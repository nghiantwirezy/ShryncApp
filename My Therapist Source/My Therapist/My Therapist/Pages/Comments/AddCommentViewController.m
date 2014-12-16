//  AddCommentViewController.m
//  My Therapist
//
//  Created by Yexiong Feng on 12/2/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "AddCommentViewController.h"
#import "FeelingSummarySectionHeaderView.h"
#import "HowDoYouFeelViewController.h"
#import "FeelingSummaryCell.h"
#import "MyTherapyViewController.h"
#import "FeelingRecord.h"
#import "UIPlaceHolderTextView.h"
#import "MBProgressHUD.h"
#import "UserSession.h"
#import "HeaderView.h"
#import "AFHTTPRequestOperationManager.h"
#import "FeelingSummaryFirstRowCell.h"
#import "UIImage+ScaleImage.h"
#import "MyFeelingsViewController.h"
#import "AppDelegate.h"

static NSDateFormatter *_dateFormatter;

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController {
    HeaderView *_headerView;
    
    NSArray *_customiNavigationLeftItems;
    NSArray *_feelings;
    UIView *_footerContainerView;
    UIButton *_moreFeelingButton;
    
    BOOL _showAllRows;
    NSUInteger _rowCount;
    
    BOOL _uploadFinished;
    
    MBProgressHUD *_hud;
    UIImageView *_hudCustomeView;
    
    UIImagePickerController *_imagePicker;
    UIImage *_selectPictureButtonImage, *_selectedPicture;
    UIActionSheet *_imageSourceActionSheet;
}

#pragma mark - AddCommentViewController Management

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Notification when application close or reopen.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunchingNotification:) name:UIApplicationDidFinishLaunchingNotification object:[UIApplication sharedApplication]];
    
    _locationManagement = [LocationManagement shareLocation];
    _locationManagement.locationManager.delegate = self;
    [_locationManagement requestTurnOnLocationServices];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // Remove Notification.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:[UIApplication sharedApplication]];
    
    [_locationManagement.locationManager stopUpdatingLocation];
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification {
    _locationManagement = [LocationManagement shareLocation];
    [_locationManagement requestTurnOnLocationServices];
}

- (void)applicationDidFinishLaunchingNotification:(NSNotification *)notification{
    [_locationManagement.locationManager stopUpdatingLocation];
}

#pragma mark - Keyboards

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height - 60, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        CGPoint commentOrigin = [self.commentViewContainer convertPoint:CGPointZero toView:self.innerContainerView];
        CGFloat offsetY = MIN(commentOrigin.y + 12, self.scrollView.contentSize.height - (self.scrollView.frame.size.height - (kbSize.height - 60)));
        self.scrollView.contentOffset = CGPointMake(0, offsetY);
        
    } completion:nil];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    } completion:nil];
}

- (void)hideKeyboard
{
    [self.commentTextView resignFirstResponder];
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [self beginFeelingUpload];
}

- (IBAction)saveButtonPressed:(id)sender
{
    _uploadFinished = NO;
    
    _feelingRecord.comment = _commentTextView.text;
    _feelingRecord.attachedPicture = _selectedPicture;
    _feelingRecord.isPublic = self.shareFeelingSwitch.on;
    
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = NSLocalizedString(CHECKIN_IN_PROGRESS, nil);
    _hud.labelFont = [UIFont fontWithName:@"BebasNeue" size:15.0];
    [_hud show:YES];
//    _locationManagement = [LocationManagement shareLocation];
//    _locationManagement.locationManager.delegate = self;
//    [_locationManagement getCurrentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    NSLog(@"found %f",newLocation.coordinate.latitude);
    [_locationManagement.locationManager stopUpdatingLocation];
    [self beginFeelingUpload];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"kCLAuthorizationStatusAuthorized");
            [_locationManagement.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"kCLAuthorizationStatusRestricted");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
            break;
    }
}

- (void)tokenExpired
{
    [_hud hide:YES];
    [UserSession signOut];
    [myAppDelegate navigateToLandingPage];
}

- (void)beginFeelingUpload
{
    @synchronized(self) {
        if (_uploadFinished) {
            return;
        }
        
        if (currentLocation) {
            _feelingRecord.location = currentLocation.coordinate;
        }
        NSLog(@"lat = %f",currentLocation.coordinate.latitude);
        NSLog(@"Begin upload");
        
        NSURL *filePath = nil;
        if (_feelingRecord.attachedPicture) {
            UIImage *attachedImage = _feelingRecord.attachedPicture;
            CGFloat longEdge = MAX(attachedImage.size.width, attachedImage.size.height);
            if (longEdge > LONGEST_EDGE) {
                CGFloat scaleFactor = LONGEST_EDGE / longEdge;
                CGFloat scaledWidth = (int)(attachedImage.size.width * scaleFactor);
                CGFloat scaledHeight = (int)(attachedImage.size.height * scaleFactor);
                attachedImage = [UIImage imageWithImage:attachedImage scaledToSize:CGSizeMake(scaledWidth, scaledHeight)];
                
                NSLog(@"Resized");
            }
            
            NSData *photoData = UIImageJPEGRepresentation(attachedImage, 0.9);
            NSString *localFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:ATTACHED_IMAGE_NAME];
            [photoData writeToFile:localFilePath atomically:YES];
            filePath = [NSURL fileURLWithPath:localFilePath];
        }
        
        NSDictionary *dictionary = [_feelingRecord toJSONDictionary];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[UserSession currentSession].sessionToken forKey:TOKEN_REQUEST_KEY];
        [parameters setObject:jsonString forKey:FEELING_REQUEST_KEY];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:CHECKIN_ENDPOINT parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (filePath) {
                [formData appendPartWithFileURL:filePath name:IMAGE_REQUEST_KEY error:nil];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Done upload %@",responseObject);
            
            _uploadFinished = YES;
            [_hud hide:YES];
            
            if (filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath.path]) {
                [[NSFileManager defaultManager] removeItemAtPath:filePath.path error:NULL];
            }
            
            _feelingRecord.code = [responseObject objectForKey:FEELING_CODE_KEY];
            
            NSMutableArray *feelingRecords = [[NSMutableArray alloc] init];
            [feelingRecords addObject:_feelingRecord];
            [feelingRecords addObjectsFromArray:[UserSession currentSession].latestFeelingRecords];
            [UserSession currentSession].latestFeelingRecords = feelingRecords;
            
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UserSession *userSession = [UserSession currentSession];
            MyTherapyViewController *nextViewController = [MyTherapyViewController new];
            [nextViewController setUserId:userSession.userId];
            [nextViewController setUsername:userSession.username];
            [nextViewController setFeelingRecordTherapy:_feelingRecord];
        
            delegate.howDoYouFeelViewController.needResetFeeling = YES;
            [self setSelectedPicture:nil];
            self.commentTextView.text = nil;
            [self setActivityIndex:0];
            
            [self.navigationController setViewControllers:[NSArray arrayWithObjects:delegate.howDoYouFeelViewController, nextViewController, nil] animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _uploadFinished = YES;
            
            _hudCustomeView.image = [UIImage imageNamed:@"no.png"];
            _hud.mode = MBProgressHUDModeCustomView;
            
            if (filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath.path]) {
                [[NSFileManager defaultManager] removeItemAtPath:filePath.path error:NULL];
            }
            
            if (operation.response.statusCode == TOKEN_NOT_FOUND_CODE) {
                _hud.labelText = NSLocalizedString(ERROR_WRONG_TOKEN, nil);
                [self performSelector:@selector(tokenExpired) withObject:nil afterDelay:2.0];
            } else {
                _hud.labelText = NSLocalizedString(ERROR_GENERAL, nil);
                [_hud hide:YES afterDelay:2.0];
            }
        }];
    }
}

- (void)setActivityIndex:(NSUInteger)index
{
    _feelingRecord.activityIndex = index;
    
    if (index == 0) {
        _activitySelectionLabel.text = NSLocalizedString(ACTIVITY_DEFAULT_LABEL, nil);
    } else {
        _activitySelectionLabel.text = _feelingRecord.activityName;
    }
}

- (IBAction)activitySelectionButtonPressed:(id)sender
{
    UIViewController *controller = myAppDelegate.activitySelectionViewController;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)setShowAllRows:(BOOL)showAllRows animated:(BOOL)animated
{
    if (showAllRows) {
        _rowCount = _feelings.count;
        _moreFeelingButton.hidden = YES;
        //[_moreFeelingButton setTitle:@"LESS" forState:UIControlStateNormal];
    } else {
        _rowCount = MIN(_feelings.count, DEFAULT_ROW_COUNT);
        [_moreFeelingButton setTitle:[NSString stringWithFormat:@"AND %lu MORE", _feelings.count - DEFAULT_ROW_COUNT] forState:UIControlStateNormal];
    }
    
    CGFloat tableViewHeight = 44 + 21 + _rowCount * 42;
    self.tableViewHeightConstraint.constant = tableViewHeight;
    [self.tableView setNeedsUpdateConstraints];
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.scrollView layoutIfNeeded];
            
            NSMutableArray *rowsToUpdate = [[NSMutableArray alloc] init];
            for (int i = DEFAULT_ROW_COUNT; i < _feelings.count; ++i) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                [rowsToUpdate addObject:path];
            }
            
            [self.tableView beginUpdates];
            if (showAllRows) {
                [self.tableView insertRowsAtIndexPaths:rowsToUpdate withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self.tableView deleteRowsAtIndexPaths:rowsToUpdate withRowAnimation:UITableViewRowAnimationFade];
            }
            [self.tableView endUpdates];
        }];
    } else {
        [self.scrollView layoutIfNeeded];
    }
    
    _showAllRows = showAllRows;
}

- (void)toggleShowAllRows
{
    [self setShowAllRows:!_showAllRows animated:YES];
}

- (IBAction)mapPublicSwitchAction:(id)sender {
}

- (void)setFeelings:(NSArray *)feelings
{
    _feelings = feelings;
    if (_feelings.count > DEFAULT_ROW_COUNT) {
        _moreFeelingButton.hidden = NO;
    } else {
        _moreFeelingButton.hidden = YES;
    }
    [self setShowAllRows:NO animated:NO];
    
    _feelingRecord = [[FeelingRecord alloc] init];
    _feelingRecord.feelings = feelings;
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    _feelingRecord.time = timeInterval;
    
    [self.tableView scrollsToTop];
}

- (CGFloat)fittedHeightForSelectedImage:(UIImage *)selectedImage
{
    CGFloat width = self.selectPictureButton.frame.size.width;
    CGFloat height = width / selectedImage.size.width * selectedImage.size.height;
    
    return height;
}

- (void)setSelectedPicture:(UIImage *)selectedPicture
{
    _selectedPicture = selectedPicture;
    if (_selectedPicture) {
        self.selectedPictureViewHeightConstraint.constant = [self fittedHeightForSelectedImage:_selectedPicture];
        [self.selectedPictureContainerView setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.1 animations:^(void) {
            self.selectPictureButton.alpha = 0;
            [self.scrollView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^(void) {
                [self.selectPictureButton setImage:_selectedPicture forState:UIControlStateNormal];
                self.selectPictureButton.alpha = self.deletePictureButton.alpha = 1.0;
            }];
        }];
    } else {
        self.selectedPictureViewHeightConstraint.constant = [self fittedHeightForSelectedImage:_selectPictureButtonImage];
        [self.selectedPictureContainerView setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.1 animations:^(void) {
            self.selectPictureButton.alpha = 0;
            [self.scrollView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^(void) {
                [self.selectPictureButton setImage:_selectPictureButtonImage forState:UIControlStateNormal];
                self.selectPictureButton.alpha = 1.0;
                self.deletePictureButton.alpha = 0;
            }];
        }];
    }
}

- (void)imagePickerPressed
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [_imageSourceActionSheet showInView:self.view];
    } else {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self showImagePicker];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self showImagePicker];
            break;
            
        case 1:
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self showImagePicker];
            break;
            
        default:
            break;
    }
}

- (void)showImagePicker
{
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self setSelectedPicture:image];
}

- (IBAction)selectPictureButtonPressed
{
    [self imagePickerPressed];
}

- (IBAction)deletePictureButtonPressed
{
    [self setSelectedPicture:nil];
}

- (IBAction)shareFeelingSwitchAction:(id)sender {

}

- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)aRange replacementText:(NSString*)aText
{
    NSString* newText = [aTextView.text stringByReplacingCharactersInRange:aRange withString:aText];
    return newText.length <= COMMENT_CHARACTER_LIMIT;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.commentLengthLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length, COMMENT_CHARACTER_LIMIT];
    self.commentLengthLabel.hidden = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.commentLengthLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.commentLengthLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length, COMMENT_CHARACTER_LIMIT];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FeelingSummarySectionHeaderView *headerView = [[FeelingSummarySectionHeaderView alloc] initForSingleRecord:YES];
    
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    [headerView setHeaderString:[NSString stringWithFormat:@"ON %@  I FELT:", [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_feelingRecord.time]]]];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _footerContainerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 21;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeelingSummaryCell *cell = nil;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:FEELING_SUMMARY_FIRST_ROW_CELL_REUSE_ID];
        if (cell == nil) {
            cell = [[FeelingSummaryFirstRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FEELING_SUMMARY_FIRST_ROW_CELL_REUSE_ID];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:FEELING_SUMMARY_CELL_REUSE_ID];
        if (cell == nil) {
            cell = [[FeelingSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FEELING_SUMMARY_CELL_REUSE_ID];
        }
    }
    
    [cell setFeeling:[_feelings objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 49 : 42;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    _hud.labelFont = [UIFont fontWithName:@"BebasNeue" size:13.0];
    
    _selectPictureButtonImage = [UIImage imageNamed:@"select picture.png"];
    
    _imageSourceActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(PHOTO_SOURCE_PICKER_TITLE, nil) delegate:self cancelButtonTitle:NSLocalizedString(PHOTO_SOURCE_PICKER_CANCEL, nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(PHOTO_SOURCE_CAMERA, nil), NSLocalizedString(PHOTO_SOURCE_ALBUM, nil), nil];
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.navigationBar.translucent = NO;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.delegate = self;
    
    [self.selectPictureButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    _hudCustomeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yes.png"]];
    _hud.customView = _hudCustomeView;
    
    [self.tableView registerClass:[FeelingSummaryCell class] forCellReuseIdentifier:FEELING_SUMMARY_CELL_REUSE_ID];
    

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:21.0f];
    titleLabel.text = NSLocalizedString(TITLE_ADD_COMMENT, nil);
    titleLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    _headerView = [[HeaderView alloc] initWithAvatar:nil title:NSLocalizedString(HEADER_TITLE, nil) subtitle:nil];
    [self.headerContainerView addSubview:_headerView];
    
    self.shareFeelingLabel.font = [UIFont fontWithName:@"BebasNeue" size:17.0];
    self.mapPublicLabel.font = [UIFont fontWithName:@"BebasNeue" size:17.0];
    
    self.activityLabel.font = [UIFont fontWithName:@"BebasNeue" size:17.0];
    self.activityOptionalLabel.font = [UIFont fontWithName:@"BebasNeue" size:11.0];
    self.activitySelectionLabel.font = [UIFont fontWithName:@"BebasNeue" size:15.0];
    self.activitySelectionLabel.text = NSLocalizedString(ACTIVITY_DEFAULT_LABEL, nil);
    
    self.commentLabel.font = [UIFont fontWithName:@"BebasNeue" size:17.0];
    self.commentOptionalLabel.font = [UIFont fontWithName:@"BebasNeue" size:11.0];
    self.commentLengthLabel.font = [UIFont fontWithName:@"BebasNeue" size:11.0];
    
    self.commentTextView.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
    self.commentTextView.placeholder = NSLocalizedString(COMMENT_PLACE_HOLDER, nil);
    self.commentTextView.placeholderColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
    
    self.attachPictureLabel.font = [UIFont fontWithName:@"BebasNeue" size:17.0];
    self.attachPictureOptionalLabel.font = [UIFont fontWithName:@"BebasNeue" size:11.0];
    
    UIImage *backImage = [UIImage imageNamed:@"back button.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *menuButtonItem = ((AppDelegate *) [[UIApplication sharedApplication] delegate]).revealMenuButtonItem;
    _customiNavigationLeftItems = [NSArray arrayWithObjects:backButtonItem, menuButtonItem, nil];
    
    self.saveButtonLabel.font = self.cancelButtonLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
    
    UIView *footerSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 1)];
    footerSeparatorView.backgroundColor = [UIColor colorWithRed:222.0 / 255 green:222.0 / 255 blue:222.0 / 255 alpha:1];
    _moreFeelingButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 120, 20)];
    _moreFeelingButton.titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:13.0f];
    [_moreFeelingButton setTitleColor:[UIColor colorWithRed:80 / 255.0 green:144 / 255.0 blue:155 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_moreFeelingButton addTarget:self action:@selector(toggleShowAllRows) forControlEvents:UIControlEventTouchUpInside];
    _footerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 21)];
    [_footerContainerView addSubview:_moreFeelingButton];
    [_footerContainerView addSubview:footerSeparatorView];
    
    if (_feelings.count > DEFAULT_ROW_COUNT) {
        _moreFeelingButton.hidden = NO;
    } else {
        _moreFeelingButton.hidden = YES;
    }
    [self setShowAllRows:NO animated:NO];
    
    [self setSelectedPicture:nil];
    
    UITapGestureRecognizer *gestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    UITapGestureRecognizer *gestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:gestureRecognizer1];
    [self.headerContainerView addGestureRecognizer:gestureRecognizer2];
    gestureRecognizer1.cancelsTouchesInView = gestureRecognizer2.cancelsTouchesInView = NO;  // this prevents the gesture recognizers to 'block' touches
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItems = _customiNavigationLeftItems;
    [self.tableView reloadData];
    UserSession *userSession = [UserSession currentSession];
    [_headerView setAvatar:userSession.userAvatar];
    [_headerView setSubtitle:userSession.username];
    self.commentLengthLabel.hidden = YES;
    [self.shareFeelingSwitch setOn: [[UserSession currentSession] userPublicCheckin] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self hideKeyboard];
    [super viewWillDisappear:animated];
}

@end
