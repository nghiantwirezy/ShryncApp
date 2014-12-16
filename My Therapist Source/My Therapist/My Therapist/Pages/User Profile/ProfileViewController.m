//
//  ProfileViewController.m
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserSession.h"
#import "AppDelegate.h"
#import "ContainedWebViewController.h"
#import "MBProgressHUD.h"
#import "SettingsViewController.h"
#import "FeelingSummarySectionHeaderView.h"
#import "HowDoYouFeelViewController.h"
#import "FeelingSummaryCell.h"
#import "MyTherapyViewController.h"
#import "FeelingRecord.h"
#import "UIPlaceHolderTextView.h"
#import "HeaderView.h"
#import "FeelingSummaryFirstRowCell.h"
#import "UIImage+ScaleImage.h"
#import "MyFeelingsViewController.h"
#import "UIColor+ColorUtilities.h"

static NSDateFormatter *_dateFormatter;

@implementation ProfileViewController {
    BOOL _emailEdited, _passwordEdited, _avatarEdited, _emailIsValid,_userBioIsValis,_userBioEdited;
    BOOL _publicProfileEdited,_publicCheckinEdited;
    BOOL _backgroundimageEdited;
    UIImagePickerController *_imagePicker;
    UIImagePickerController *_backgroundImagePicker;
    MBProgressHUD *_hud;
    UIImageView *_hudCustomeView;
    UIImage *_profileImage;
    UIImage *_backgroundImage;
    UIBarButtonItem *_backButtonItem, *_revealMenuButtonItem;
    UIActionSheet *_imageSourceActionSheet;
    UIActionSheet *_backgroundSourceActionSheet;
    NSMutableDictionary *parameters;
    BaseModel *_baseModel;
}

#pragma mark - Load view

- (void)viewDidLoad
{
    [super viewDidLoad];
    _baseModel = [BaseModel shareBaseModel];
    _heightDefaultContentContainer = _contentContainerView.frame.size.height;
    
    // Setup Bio TextView
    _biographyTextView.font = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    _biographyTextView.textColor = [UIColor veryLightGrayColor];
    _heightProfileView = USER_PROFILE_HEADER_DEFAULT_HEIGHT_WITHOUT_BOTTOM_VIEW;
    
    parameters = [NSMutableDictionary new];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    _imageSourceActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(PHOTO_SOURCE_PICKER_TITLE, nil) delegate:self cancelButtonTitle:NSLocalizedString(PHOTO_SOURCE_PICKER_CANCEL, nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(PHOTO_SOURCE_CAMERA, nil), NSLocalizedString(PHOTO_SOURCE_ALBUM, nil), nil];
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.navigationBar.translucent = NO;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.delegate = self;
    
    _backgroundSourceActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(PHOTO_SOURCE_PICKER_TITLE, nil) delegate:self cancelButtonTitle:NSLocalizedString(PHOTO_SOURCE_PICKER_CANCEL, nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(PHOTO_SOURCE_CAMERA, nil), NSLocalizedString(PHOTO_SOURCE_ALBUM, nil), nil];
    
    _backgroundImagePicker = [[UIImagePickerController alloc] init];
    _backgroundImagePicker.navigationBar.translucent = NO;
    _backgroundImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _backgroundImagePicker.delegate = self;
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    _hud.labelFont = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    
    _hudCustomeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_NAME_YES]];
    _hud.customView = _hudCustomeView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME_LABEL_TITLE_PROFILE_VIEW];
    titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_LABEL_TITLE_PROFILE_VIEW);
    titleLabel.text = NSLocalizedString(TITLE_MYPROFILE, nil);
    titleLabel.textColor = [UIColor veryLightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    self.usernameLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_LABEL_USER_NAME_PROFILE_VIEW);
    self.memberSinceLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    
    self.defaultVisibilityLabel.font = self.userBiographyTextField.font = self.emailTextField.font = self.passwordTextField.font = self.updatePhotoTextButton.titleLabel.font =self.updateBackgroundImageTextButton.titleLabel.font = self.submitButton.titleLabel.font = self.labelDefaulAllCheckin.titleLabel.font = self.labelDefaultProfilePublic.titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_LABEL_COMMON_PROFILE_VIEW);
    
    self.defaultVisibilityLabel.textColor = self.userBiographyTextField.textColor = self.emailTextField.textColor = self.passwordTextField.textColor = [UIColor lightGrayColor];
    
    self.submitButton.titleLabel.textColor = [UIColor veryLightGrayColor];
    
    self.passwordTextField.placeholder = PASSWORD_MASK;
    self.userBiographyTextField.placeholder = USER_BIOGRAPHY_MASK;
    
    self.privacyButton.titleLabel.font = self.termButton.titleLabel.font = self.aboutButton.titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_LABEL_BUTTON_COMMON_PROFILE_VIEW);
    
    UIImage *settingsImage = [UIImage imageNamed:IMAGE_NAME_REVEAL_SETTING_ICON];
    UIButton *addMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addMessageButton setFrame:FRAME_BUTTON_ADD_MESSAGE_PROFILE_VIEW];
    [addMessageButton setBackgroundImage:settingsImage forState:UIControlStateNormal];
    [addMessageButton addTarget:self action:@selector(settingGo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:addMessageButton];
    [self.navigationItem setRightBarButtonItem:barButton];
    
    UIImage *backImage = [UIImage imageNamed:IMAGE_NAME_BACK_BUTTON];
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    _revealMenuButtonItem = myAppDelegate.revealMenuButtonItem;
    
    [_avatarImageView.layer setMasksToBounds:YES];
    [_avatarImageView.layer setCornerRadius:HALF_OF(_avatarImageView.frame.size.width)];
    [_avatarImageView setImage:[UIImage imageNamed:DEFAULT_USER_IMAGE_NAME]];
    
    [self.submitButton setBackgroundImage:myAppDelegate.lightGreenImage forState:UIControlStateNormal];
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:_backButtonItem, _revealMenuButtonItem, nil];
    } else {
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:_revealMenuButtonItem, nil];
    }
    
    self.emailTextField.enabled = self.passwordTextField.enabled = NO;
    
    [self.defaultSwitch setOn: [[UserSession currentSession] userPublicCheckin]];
    [self.defaultProfileSwitch setOn: [[UserSession currentSession] userPublicProfile]];
    [self getBackgroundUserFromServer];
    [self getBiographyUserFromServer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self hideKeyboard];
    [super viewWillDisappear:animated];

}

-(void)settingGo{
    SettingsViewController *setVC = [SettingsViewController new];
    [self.navigationController pushViewController:setVC animated:YES];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem = nil;
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Control

- (void)resetNavigationLeftItems
{
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:_backButtonItem, _revealMenuButtonItem, nil];
    } else {
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:_revealMenuButtonItem, nil];
    }
}

- (void)resetEditStates
{
    _emailEdited = _passwordEdited = _avatarEdited = _userBioEdited = _userBioEdited = NO;
    _backgroundimageEdited = NO;
    _emailIsValid = YES;
    [self updateControls];
}

- (void)updateControls
{
    UserSession *userSession = [UserSession currentSession];
    
    if (userSession.isGuestSession) {
        _emailEdited = _passwordEdited = _avatarEdited = _userBioEdited = NO;
        _defaultProfileSwitch = _defaultSwitch = NO;
        _backgroundimageEdited = NO;
        _emailIsValid = YES;
        self.updateEmailButton.enabled = self.updatePasswordButton.enabled = self.updatePhotoButton.enabled = self.updatePhotoTextButton.enabled = NO;
        self.updateBackgroundImageButton.enabled = self.updateBackgroundImageTextButton.enabled = NO;
        self.defaultProfileSwitch.enabled = self.defaultSwitch.enabled = NO;
    }
    
    if (!_emailEdited) {
        self.emailTextField.text = userSession.email;
    }
    [self updateTextField:self.emailTextField forEdited:_emailEdited];
    
    if (!_emailIsValid) {
        self.emailTextField.textColor = [UIColor redColor];
    }
    self.updateEmailButton.hidden = _emailEdited;
    self.revertEmailButton.hidden = !_emailEdited;
    
    if (!_userBioEdited) {
        self.userBiographyTextField.text = (userSession.userBiography)?userSession.userBiography:@"";
    }
    [self updateTextField:self.userBiographyTextField forEdited:_userBioEdited];
    self.updateUserBiographuButton.hidden = _userBioEdited;
    self.resetUserBiographyButton.hidden = !_userBioEdited;
    
    if (!_passwordEdited) {
        self.passwordTextField.text = @"";
    }
    [self updateTextField:self.passwordTextField forEdited:_passwordEdited];
    self.updatePasswordButton.hidden = _passwordEdited;
    self.revertPasswordButton.hidden = !_passwordEdited;
    
    if (!_avatarEdited) {
        self.avatarImageView.image = (userSession.userAvatar)?(userSession.userAvatar):[UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
    }
    self.updatePhotoButton.hidden = _avatarEdited;
    self.revertPhotoButton.hidden = !_avatarEdited;
    
    if (!_backgroundimageEdited) {
        self.backgroundImageView.image = (userSession.backgroundImage)?(userSession.backgroundImage):[UIImage imageNamed:IMAGE_NAME_AUTUMN_COLOR];
    }
    self.updateBackgroundImageButton.hidden = _backgroundimageEdited;
    self.revertBackgroundImageButton.hidden = !_backgroundimageEdited;
    
    self.usernameLabel.text = userSession.username;
    self.memberSinceLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(MEMBER_SINCE_LABEL, nil),
                                  [_dateFormatter stringFromDate:userSession.createdDate]];
    self.submitButton.enabled = (_emailEdited || _passwordEdited || _avatarEdited || _userBioEdited || _backgroundimageEdited
                                 || _publicCheckinEdited || _publicProfileEdited ) && _emailIsValid;
}

+ (void)initialize
{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)tokenExpired
{
    [_hud hide:YES];
    [UserSession signOut];
    
    [myAppDelegate navigateToLandingPage];
}

#pragma mark - Actions

- (void)updateEmailButtonPressed
{
    self.emailTextField.enabled = YES;
    [self.emailTextField becomeFirstResponder];
    [self updateTextField:self.emailTextField forEdited:YES];
}

- (void)resetEmailButtonPressed
{
    _emailEdited = NO;
    _emailIsValid = YES;
    [self updateControls];
}

- (void)updatePasswordButtonPressed
{
    self.passwordTextField.enabled = YES;
    [self.passwordTextField becomeFirstResponder];
    [self updateTextField:self.passwordTextField forEdited:YES];
}

- (void)resetPasswordButtonPressed
{
    _passwordEdited = NO;
    [self updateControls];
}

- (void)imagePickerPressed
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [_imageSourceActionSheet showInView:self.view];
        [_imageSourceActionSheet setTag:AlertAvatar];
    } else {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self showImagePicker];
    }
}

- (void)imagePickerBackgroundPressed
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [_backgroundSourceActionSheet showInView:self.view];
        [_backgroundSourceActionSheet setTag:AlertBackgroundImage];
    } else {
        _backgroundImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self showBackgroundImagePicker];
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == AlertAvatar){
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
    }else if (actionSheet.tag == AlertBackgroundImage){
        switch (buttonIndex) {
            case 0:
                _backgroundImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self showBackgroundImagePicker];
                break;
            case 1:
                _backgroundImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self showBackgroundImagePicker];
                break;
            default:
                break;
        }
    }
}

- (void)showImagePicker
{
    [self presentViewController:_imagePicker animated:YES completion:nil];
    _imagePicker.view.tag = AlertImagepickerAvatar;
}

- (void)showBackgroundImagePicker
{
    [self presentViewController:_backgroundImagePicker animated:YES completion:nil];
    _backgroundImagePicker.view.tag = AlertImagepickerBackgroundImage;
}

- (void)updatePhotoButtonPressed
{
    [self imagePickerPressed];
}

- (void)resetPhotoButtonPressed
{
    _avatarEdited = NO;
    [self updateControls];
}

- (IBAction)updateBackgroundImageButtonPressed
{
    [self imagePickerBackgroundPressed];
}
- (IBAction)resetBackgroundImageButtonPressed
{
    _backgroundimageEdited = NO;
    [self updateControls];
}

#pragma mark - Function Image

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.view.tag == AlertImagepickerAvatar) {
        _profileImage = image;
        self.avatarImageView.image = image;
        _avatarEdited = YES;
    }
    else if (picker.view.tag == AlertImagepickerBackgroundImage){
        _backgroundImage = image;
        self.backgroundImageView.image = image;
        _backgroundimageEdited = YES;
    }
    [self updateControls];
}

#pragma mark - Button Update Biography

- (IBAction)resetUserBiographyButtonPress:(id)sender {
    _userBioEdited = NO;
    _userBioIsValis = YES;
    [self updateControls];
}

- (IBAction)updateUserBiographyButtonPress:(id)sender {
    self.userBiographyTextField.enabled = YES;
    [self.userBiographyTextField becomeFirstResponder];
    [self updateTextField:self.userBiographyTextField forEdited:YES];
}

#pragma mark - Switch button

- (IBAction)defaultSwitchedAction:(id)sender {
    _publicCheckinEdited = YES;
    [self updateControls];
}

- (IBAction)defaultSwitchedProfileAction:(id)sender {
    _publicProfileEdited = YES;
    [self updateControls];
}

#pragma mark - Button Submit

- (void)submitButtonPressed
{
    UserSession *userSession = [UserSession currentSession];
    NSString *token = userSession.sessionToken;
    [parameters setObject:token forKey:TOKEN_REQUEST_KEY];
    
    NSString *email = nil;
    if (![self.emailTextField.text isEqualToString:userSession.email]) {
        email = self.emailTextField.text;
        [parameters setObject:email forKey:EMAIL_REQUEST_KEY];
    }
    
    if (_passwordEdited) {
        [parameters setObject:self.passwordTextField.text forKey:PASSWORD_REQUEST_KEY];
    }
    
    NSString *biography = nil;
    if (![self.userBiographyTextField.text isEqualToString:userSession.userBiography]) {
        biography = self.userBiographyTextField.text;
        [parameters setObject:biography forKey:USER_BIOGRAPHY_REQUEST_KEY];
    }
    
    NSURL *avatarTempFileURL = nil;
    if (_avatarEdited) {
        CGFloat longEdge = MAX(_profileImage.size.width, _profileImage.size.height);
        if (longEdge > LONGEST_EDGE) {
            CGFloat scaleFactor = LONGEST_EDGE / longEdge;
            CGFloat scaledWidth = (int)(_profileImage.size.width * scaleFactor);
            CGFloat scaledHeight = (int)(_profileImage.size.height * scaleFactor);
            _profileImage = [UIImage imageWithImage:_profileImage scaledToSize:CGSizeMake(scaledWidth, scaledHeight)];
            NSLog(@"Resized avatar");
        }
        
        NSData *photoData = UIImageJPEGRepresentation(_profileImage, 0.5);
        NSString *localFilePath = [NSTemporaryDirectory() stringByAppendingString:USER_AVATAR_FILE_NAME];
        [photoData writeToFile:localFilePath atomically:YES];
        avatarTempFileURL = [NSURL fileURLWithPath:localFilePath];
    }
    
    NSURL *bimageTempFileURL = nil;
    if (_backgroundimageEdited) {
        CGFloat longEdge = MAX(_backgroundImage.size.width, _backgroundImage.size.height);
        if (longEdge > LONGEST_EDGE) {
            CGFloat scaleFactor = LONGEST_EDGE / longEdge;
            CGFloat scaledWidth = (int)(_backgroundImage.size.width * scaleFactor);
            CGFloat scaledHeight = (int)(_backgroundImage.size.height * scaleFactor);
            _backgroundImage = [UIImage imageWithImage:_backgroundImage scaledToSize:CGSizeMake(scaledWidth, scaledHeight)];
            NSLog(@"Resized cover");
        }
        
        NSData *bimageData = UIImageJPEGRepresentation(_backgroundImage, 0.5);
        NSString *localFilePath2 = [NSTemporaryDirectory() stringByAppendingString:BACKGROUND_IMAGE_FILE_NAME];
        [bimageData writeToFile:localFilePath2 atomically:YES];
        bimageTempFileURL = [NSURL fileURLWithPath:localFilePath2];
    }
    if (_publicCheckinEdited) {
        [parameters setObject:[NSNumber numberWithBool:_defaultSwitch.isOn] forKey:PUBLIC_CHECKIN_REQUEST_KEY];
    }
    if (_publicProfileEdited) {
        [parameters setObject:[NSNumber numberWithBool:_defaultProfileSwitch.isOn] forKey:PUBLIC_PROFILE_REQUEST_KEY];
    }
    
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = NSLocalizedString(UPDATE_IN_PROGRESS, nil);
    [_hud show:YES];
    [_baseModel postUserUpdateEndPointWithParameters:parameters andURLAvatarTemp:avatarTempFileURL andURLBimageTemp:bimageTempFileURL completion:^(id responseObject, NSError *error, AFHTTPRequestOperation *operation){
        if (!error) {
            NSLog(@"pr = %@",responseObject);
            if (avatarTempFileURL != nil) {
                NSString *localFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:USER_AVATAR_FILE_NAME];
                NSURL *avatarFileURL = [NSURL fileURLWithPath:localFilePath];
                
                NSError *copyError = nil;
                [[NSFileManager defaultManager] replaceItemAtURL:avatarFileURL withItemAtURL:avatarTempFileURL backupItemName:nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:&avatarFileURL error:&copyError];
                
                if (copyError != nil) {
                    NSLog(@"Copy error: %@", copyError);
                }
            }
            
            if (bimageTempFileURL != nil) {
                NSString *localFilePath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:BACKGROUND_IMAGE_FILE_NAME];
                NSURL *bimageFileURL = [NSURL fileURLWithPath:localFilePath2];
                
                NSError *copyError = nil;
                [[NSFileManager defaultManager] replaceItemAtURL:bimageFileURL withItemAtURL:bimageTempFileURL backupItemName:nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:&bimageFileURL error:&copyError];
                
                if (copyError != nil) {
                    NSLog(@"Copy error: %@", copyError);
                }
                
            }
            [UserSession updatedWithEmail:((_emailEdited)?email:@"")
                                   avatar:((_avatarEdited)?_profileImage:nil)
                                biography:((_userBioEdited)?biography:@"")
                          backgroundImage:((_backgroundimageEdited)?_backgroundImage:nil)
                        userPublicProfile:([[[responseObject objectForKey:USER_REQUEST_KEY ] objectForKey:PUBLIC_PROFILE_REQUEST_KEY]boolValue])
                        userPublicCheckin:([[[responseObject objectForKey:USER_REQUEST_KEY ] objectForKey:PUBLIC_CHECKIN_REQUEST_KEY]boolValue])];
            
            if (_backgroundimageEdited) {
                [self getBackgroundUserFromServer];
            }
            
            if (_userBioEdited) {
                [self getBiographyUserFromServer];
            }
            
            _emailEdited = _passwordEdited = _avatarEdited = _userBioEdited = NO;
            _publicCheckinEdited = _publicProfileEdited = NO;
            _backgroundimageEdited = NO;
            [self updateControls];
            
            _hud.labelText = NSLocalizedString(UPDATE_SUCCEEDED, nil);
            _hudCustomeView.image = [UIImage imageNamed:IMAGE_NAME_YES];
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud hide:YES afterDelay:2.0];
        }else {
            NSLog(@"Error: %@", error);
            _hudCustomeView.image = [UIImage imageNamed:IMAGE_NAME_NO];
            _hud.mode = MBProgressHUDModeCustomView;
            
            if (operation.response.statusCode == WRONG_TOKEN_CODE) {
                _hud.labelText = NSLocalizedString(ERROR_WRONG_TOKEN, nil);
                [self performSelector:@selector(tokenExpired) withObject:nil afterDelay:2.0];
            } else {
                _hud.labelText = NSLocalizedString(ERROR_GENERAL, nil);
                [_hud hide:YES afterDelay:2.0];
            }
        }
    }];
}

#pragma mark - Button Info

- (IBAction)privacyButtonAction
{
    ContainedWebViewController *viewController = myAppDelegate.privacyTextView;
    [viewController presentFromController:self];
}

- (IBAction)termButtonAction
{
    ContainedWebViewController *viewController = myAppDelegate.termTextView;
    [viewController presentFromController:self];
}

- (IBAction)aboutButtonAction
{
    ContainedWebViewController *viewController = myAppDelegate.aboutTextView;
    [viewController presentFromController:self];
}

#pragma mark - UITextField Delgate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _topSpaceProfileViewConstaint.constant = 0;
        _heightProfileViewConstaint.constant = _heightProfileView;
        [_avatarContainerView layoutIfNeeded];
        _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
    } completion:nil];
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *endString = [NSMutableString stringWithString:textField.text];
    [endString replaceCharactersInRange:range withString:string];
    
    if (textField == self.emailTextField) {
        BOOL isEmailValid = [self NSStringIsValidEmail:endString];
        if (!isEmailValid) {
            self.emailTextField.textColor = [UIColor redColor];
        } else {
            self.emailTextField.textColor = [UIColor lightGrayColor];
        }
        _emailIsValid = isEmailValid;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UserSession *userSession = [UserSession currentSession];
    
    if (textField == self.emailTextField) {
        _emailEdited = ![textField.text isEqualToString:userSession.email];
    } else if (textField == self.passwordTextField) {
        _passwordEdited = textField.text.length > 0;
    }else if (textField == self.userBiographyTextField) {
        _userBioEdited = ![textField.text isEqualToString:userSession.userBiography];
    }
    
    textField.enabled = NO;
    [self updateControls];
}

- (void)updateTextField:(UITextField *)textField forEdited:(BOOL)edited
{
    if (edited) {
        textField.textColor = [UIColor veryDarkGrayColor5];
    } else {
        textField.textColor = [UIColor veryLightGrayColor];
    }
}

- (void)hideKeyboard
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.userBiographyTextField resignFirstResponder];
}

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

- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        if (self.scrollView.contentOffset.y < 100) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 100 - _heightProfileView);
        }
        
    } completion:nil];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    } completion:nil];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollView ) {
        CGFloat yOffset  = scrollView.contentOffset.y;
        if (yOffset < 0) {
            _topSpaceProfileViewConstaint.constant = 0;
            if (-yOffset < 0) {
                _heightProfileViewConstaint.constant = _heightProfileView;
            }else {
                _heightProfileViewConstaint.constant = -yOffset + _heightProfileView;
            }
            [_avatarContainerView layoutIfNeeded];
            _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(-yOffset, 0, 0, 0);
        }else{
            if (-yOffset < 0) {
                _topSpaceProfileViewConstaint.constant = 0;
                _heightProfileViewConstaint.constant = _heightProfileView;
            }else {
                _topSpaceProfileViewConstaint.constant = -yOffset;
            }
            [_avatarContainerView layoutIfNeeded];
            _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
        }
    }
}

#pragma mark - Services

- (void)getBackgroundUserFromServer {
    UserSession *userSession = [UserSession currentSession];
    UIImage *defaultBackgroundImage = [UIImage imageNamed:IMAGE_NAME_AUTUMN_COLOR];
    if ((userSession.backgroundImage)) {
        _backgroundImageView.image  = userSession.backgroundImage;
    }else {
        NSDictionary *parametersBackground = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken, KEY_USER_ID:[UserSession currentSession].userId};
        [_baseModel downloadUserImageWithParameters:parametersBackground andImageKey:KEY_IMAGE_COVER completion:^(id responseObject, NSError *error){
            if (!error) {
                UIImage *userProfileBackgroundImage = responseObject;
                _backgroundImageView.image = (userProfileBackgroundImage)?userProfileBackgroundImage:defaultBackgroundImage;
                userSession.backgroundImage = userProfileBackgroundImage;
            }else {
                NSLog(@"Couldn't complete with error: %@",error);
            }
        }];
    }
}

- (void)getBiographyUserFromServer {
    UserSession *userSession = [UserSession currentSession];
    if (userSession.userBiography) {
        [self setValueBiographyTextViewWithString:userSession.userBiography];
    }else {
        NSDictionary *parametersBio = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken, KEY_USER_ID:[UserSession currentSession].userId};
        [_baseModel getUserEndPointWithParameters:parametersBio completion:^(id responseObject, NSError *error){
            if (!error) {
                NSDictionary *userDataDict = (NSDictionary *)[responseObject objectForKey:KEY_USER];
                NSString *biograyphy = [userDataDict objectForKey:KEY_BIOGRAPHY];
                [self setValueBiographyTextViewWithString:biograyphy];
            }else {
                NSLog(@"Couldn't complete with error: %@",error);
            }
        }];
        
    }
}

#pragma mark - Customs Method

- (void)setValueBiographyTextViewWithString:(NSString *)biography {
    if ((biography != (id)[NSNull null]) && (biography.length > 0)) {
        biography = [biography stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (biography.length > 0) {
            _biographyTextView.text = biography;
            CGSize textViewSize = [_biographyTextView sizeThatFits:CGSizeMake(_biographyTextView.frame.size.width, FLT_MAX)];
            _biographyTextView.scrollEnabled = (textViewSize.height >= HEIGHT_MAX_BIOGRAPHY_TEXT_VIEW)?YES:NO;
            [self changeBiographyTextViewHeight:textViewSize.height];
        }
    }else {
        [self changeBiographyTextViewHeight:0.0];
    }
}

- (void)changeBiographyTextViewHeight:(CGFloat)height {
    height = (height > HEIGHT_MAX_BIOGRAPHY_TEXT_VIEW)?HEIGHT_MAX_BIOGRAPHY_TEXT_VIEW:height;
    _heightBiographyConstaint.constant = (height >= 0)?height:0;
    [UIView animateWithDuration:TIME_TO_EXPAND_PROFILE_VIEW animations:^{
        _heightProfileView = (height > 0)?(USER_PROFILE_HEADER_DEFAULT_HEIGHT_WITHOUT_BOTTOM_VIEW + height):USER_PROFILE_HEADER_DEFAULT_HEIGHT_WITHOUT_BOTTOM_VIEW;
        _heightProfileViewConstaint.constant = _heightProfileView;
        _heightContentContainerConstaint.constant = _heightDefaultContentContainer + height;
        [self.avatarContainerView layoutIfNeeded];
        [self.contentContainerView layoutIfNeeded];
    }completion:^(BOOL finished){
        _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
    }];
}

@end
