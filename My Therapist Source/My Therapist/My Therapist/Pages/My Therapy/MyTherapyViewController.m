//
//  MyTherapyViewController.m
//  My Therapist
//

#import "MyTherapyViewController.h"
#import "FeelingSummarySectionHeaderView.h"
#import "FeelingSummaryCell.h"
#import "FeelingRecord.h"
#import "AppDelegate.h"
#import "FeelingTextCell.h"
#import "NSString+HeightForFontAndWidth.h"
#import "UserSession.h"
#import "AttachmentFullscreenViewController.h"
#import "HeaderView.h"
#import "MyFeelingsViewController.h"
#import "MBProgressHUD.h"
#import "ContainedWebViewController.h"
#import "TextTherapiesViewController.h"
#import "AudioPlayerViewController.h"
#import "ReferralFinder.h"
#import <QuartzCore/QuartzCore.h>
#import "PublicProfileViewController.h"
#import "PublicFeelingsViewController.h"
#import "SVAnnotation.h"
#import "UIColor+ColorUtilities.h"

static NSDateFormatter *_dateFormatter;

@interface MyTherapyViewController (){
}
@end

@implementation MyTherapyViewController
{
    FeelingRecord *_feelingRecord;
    HeaderView *_headerView;
    MBProgressHUD *_hud;
    MyFeelingsViewController *_feelingsViewController;
    
    BOOL _showAllFeelings, _showMoreLink;
    
    NSArray *_customiNavigationLeftItems;
    UIView *_moreLinkContainerView, *_footerContainerView, *_mapContainerSeparatorView;
    NSUInteger _feelingRowCount;
    UIButton *_moreFeelingButton;
    NSString *_activityAndCommentString;
    MKPointAnnotation *_annotation;
    NSCache *_imageCache;
    UIImageView *_hudCustomeView;
    NSCache *_avatarCache;
}
@synthesize mapView=_mapView,subtitle=_subtitle,longitude=_longitude,latitude=_latitude;

#pragma mark - MyTherapyViewController management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _baseModel = [BaseModel shareBaseModel];
    _avatarCache = [[NSCache alloc] init];
    [self initHeaderView];
    self.attachmentLabel.font = self.mapLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    _annotation = [[MKPointAnnotation alloc] init];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    _hud.labelFont = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    
    _hudCustomeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_NAME_NO]];
    
    self.audioTherapyLabel.font = self.audioTherapyDownloadLabel.font = self.referralLabel.font = self.textTherapyLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_COMMON_LABEL_MY_THERAPY);
    self.audioTherapySubtitleLabel.font = self.audioTherapyDownloadSubtitleLabel.font = self.referralSubtitleLabel.font = self.textTherapySubtitleLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_COMMON_LABEL_SUB_MY_THERAPY);
    
    [self.tableView registerClass:[FeelingSummaryCell class] forCellReuseIdentifier:IDENTIFIER_FEELING_SUMMARY_CELL];
    [self.tableView registerClass:[FeelingTextCell class] forCellReuseIdentifier:IDENTIFIER_FEELING_TEXT_CELL];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME_TITLE_LABEL_MY_THERAPY];
    titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_TITLE_DEFAULT);
    titleLabel.text = NSLocalizedString(TITLE_APPLICATION, nil);
    titleLabel.textColor = [UIColor veryLightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    _headerView = [[HeaderView alloc] initWithAvatar:nil title:NSLocalizedString(TITLE_HEADER_MY_THERAPY, nil) subtitle:nil];
    [self.headerContainerView addSubview:_headerView];
    
    UIImage *backImage = [UIImage imageNamed:IMAGE_NAME_BACK_BUTTON];
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *menuButtonItem = ((AppDelegate *) [[UIApplication sharedApplication] delegate]).revealMenuButtonItem;
    _customiNavigationLeftItems = [NSArray arrayWithObjects:backButtonItem, menuButtonItem, nil];
    
    _moreFeelingButton = [[UIButton alloc] initWithFrame:FRAME_BUTTON_MORE_FEELING_MY_THERAPY];
    _moreFeelingButton.titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_SMALL);
    [_moreFeelingButton setTitleColor:[UIColor darkModerateCyanColor2] forState:UIControlStateNormal];
    [_moreFeelingButton addTarget:self action:@selector(toggleShowAllRows) forControlEvents:UIControlEventTouchUpInside];
    _moreLinkContainerView = [[UIView alloc] initWithFrame:FRAME_MORE_LINK_CONTAINER_VIEW];
    [_moreLinkContainerView addSubview:_moreFeelingButton];
    
    UIView *footerSeparatorView = [[UIView alloc] initWithFrame:FRAME_FOOTER_SEPARATOR_VIEW];
    footerSeparatorView.backgroundColor = [UIColor veryLightGrayColor3];
    _footerContainerView = [[UIView alloc] initWithFrame:FRAME_FOOTER_CONTAINER_VIEW];
    [_footerContainerView addSubview:footerSeparatorView];
    
    self.deleteCheckinButton.titleLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    
    if (_feelingRecord.feelings.count > TOTAL_ROW_DEFAULT_MY_THERAPY) {
        _showMoreLink = YES;
    } else {
        _showMoreLink = NO;
    }
    
    _imageCache = [[NSCache alloc] init];
    
    self.shareFeelingLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_SHARE_FEELING_LABEL_MY_THERAPY);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDetailCheckin];
    self.scrollView.contentOffset = CGPointZero;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItems = _customiNavigationLeftItems;
    
    self.shareFeelingSwitch.on = _feelingRecord.isPublic;
    
    [self setShowAllRows:NO animated:NO];
    
    UIImage *image = _feelingRecord.attachedPicture;
    if (!image && (_feelingRecord.thumbnailPath) && [_imageCache objectForKey:_feelingRecord.thumbnailPath]) {
        image = [_imageCache objectForKey:_feelingRecord.thumbnailPath];
    }
    
    if (image || ((_feelingRecord.thumbnailPath) && ![_feelingRecord.thumbnailPath isEqualToString:@""])) {
        self.topFeelingTableViewContainerConstraint.constant = CONSTRAINT_TOP_DEFAULT_TABLE_VIEW_MY_THERAPY;
        self.heightAttachmentViewContainerConstraint.constant = CONSTRAINT_HEIGHT_ATTACHMENT_CONTAINER_MY_THERAPY;
        [self.view layoutIfNeeded];
        if (image) {
            self.attachmentImageView.image = image;
        } else {
            self.attachmentImageView.image = nil;
            NSDictionary *parameters = @{KEY_TOKEN_PARAM: [UserSession currentSession].sessionToken, KEY_FEELING: _feelingRecord.code};
            [_baseModel getThumbnailWithParameters:parameters completion:^(id responseObject, NSError *error){
                if (!error) {
                    [_imageCache setObject:responseObject forKey:_feelingRecord.thumbnailPath];
                    self.attachmentImageView.image = responseObject;
                }else {
                     NSLog(@"%@", error);
                }
            }];
        }
    } else {
        self.topFeelingTableViewContainerConstraint.constant = CONSTRAINT_TOP_DEFAULT_TABLE_VIEW_MY_THERAPY;
        self.heightAttachmentViewContainerConstraint.constant = 0;
        self.heightTotalInnerConstraint.constant = CONSTRAINT_HEIGHT_TOTAL_INNER_DEFAULT_MY_THERAPY - CONSTRAINT_HEIGHT_ATTACHMENT_CONTAINER_MY_THERAPY;
        [self.view layoutIfNeeded];
    }
    
    [self.tableView reloadData];
    
    UserSession *userSession = [UserSession currentSession];
    _userProfileView.usernameLabels.text = userSession.username;
    _userProfileView.userID = userSession.userId;
    [self setUserAvatarForImage:_userProfileView.avatarImageView];
    [self getBiographyAndBackgroundUserFromServer];
}

- (void)initHeaderView {
    // Profile View
    _userProfileView = [[UserProfileView alloc]initWithFrame:CGRectZero];
    _userProfileView.titleLabel.shadowColor = [UIColor whiteColor];
    _userProfileView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    _userProfileView.titleLabel.textColor = [UIColor veryLightGrayColor];
    _userProfileView.titleLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_VERY_BIG);
    _userProfileView.titleLabel.text = TEXT_HEADER_TITLE_DETAIL_COMMENT;
    
    _userProfileView.usernameLabels.textColor = [UIColor darkModerateCyanColor];
    _userProfileView.usernameLabels.font = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    
    _userProfileView.bottomView.hidden = YES;
    _userProfileView.heightConstaintBottomView.constant = 0;
    _userProfileView.separatorView.hidden = YES;
    _userProfileView.heightDefaultProfileView = _heightProfileView = USER_PROFILE_HEADER_DEFAULT_HEIGHT_WITHOUT_BOTTOM_VIEW;
    CGRect profileViewFrame = _userProfileView.frame;
    profileViewFrame.origin.y = 0;
    profileViewFrame.size.height = _heightProfileView;
    _userProfileView.frame = profileViewFrame;
    _userProfileView.delegate = self;
    [_feelingSummaryInnerView addSubview:_userProfileView];
}

#pragma mark - Actions

-(void)beginEdit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteButtonPressed
{
    _hud.labelText = NSLocalizedString(TEXT_LOADING_MY_FEELINGS, nil);
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud show:YES];
    NSDictionary *parameters = @{KEY_TOKEN_PARAM: [UserSession currentSession].sessionToken, KEY_FEELING: _feelingRecord.code};
    [_baseModel deleteFeelingEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
        if (!error) {
            [_feelingsViewController deleteFeelingRecord:_feelingRecord];
            MyFeelingsViewController *myFeelingsController = myAppDelegate.myFeelingsViewController;
            [myFeelingsController deleteFeelingRecord:_feelingRecord];
            [_hud hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            _hud.labelText = NSLocalizedString(TEXT_LOAD_FAILED_MY_FEELINGS, nil);
            [_hud hide:YES afterDelay:TIME_DELAY_HUD_MY_THERAPY];
            NSLog(@"%@", error);
        }
    }];
}

- (IBAction)audioTherapyPressed:(id)sender
{
    AudioPlayerViewController *controller = myAppDelegate.audioPlayerViewController;
    controller.feelingRecord = _feelingRecord;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)audioTherapyDownloadPressed:(id)sender{
}

- (IBAction)referralPressed:(id)sender
{
    ReferralFinder *finder = myAppDelegate.referralFinder;
    [finder beginInViewController:self withHUD:_hud];
}

- (IBAction)textTherapyPressed:(id)sender
{
    TextTherapiesViewController *controller = myAppDelegate.textTherapiesViewController;
    [controller setFeelingRecord:_feelingRecord];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)shareFeelingSwitchPressed
{
    BOOL updatedPublicFlag = !(_feelingRecord.isPublic);
    NSDictionary *parameters = @{KEY_TOKEN_PARAM: [UserSession currentSession].sessionToken,
                                 KEY_CODE: _feelingRecord.code,
                                 KEY_IS_PUBLIC: [NSNumber numberWithBool:updatedPublicFlag]};
    [_baseModel postUpdateCheckinEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
        if (!error) {
            _feelingRecord.isPublic = updatedPublicFlag;
            [self.shareFeelingSwitch setOn:updatedPublicFlag animated:YES];
            [_feelingsViewController toggledPublicForFeelingRecord:_feelingRecord];
            
            MyFeelingsViewController *myFeelingsController = myAppDelegate.myFeelingsViewController;
            [myFeelingsController toggledPublicForFeelingRecord:_feelingRecord];
        }else {
            NSLog(@"%@", error);
            [self.shareFeelingSwitch setOn:_feelingRecord.isPublic animated:YES];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = _hudCustomeView;
            _hud.labelText = NSLocalizedString(TEXT_FAILED_TOTOGGLE_SHARED_MY_THERAPY, nil);
            [_hud show:YES];
            [_hud hide:YES afterDelay:TIME_DELAY_HUD_MY_THERAPY];
        }
    }];
}

- (IBAction)mapButtonAction:(id)sender {
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        DetailMapView *detailMap = [DetailMapView new];
        [detailMap setCurrenLocations:_currenLocations];
        [self.navigationController pushViewController:detailMap animated:YES];
    }
}

- (IBAction)attachmentFullscreenButtonPressed
{
    AttachmentFullscreenViewController *controller = [AttachmentFullscreenViewController new];
    [controller setAttachFeelingCode:_feelingRecord.code];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Custom Methods

- (void)getDetailCheckin
{
    NSDictionary *paramCheckinDetail = @{KEY_FEELING:_feelingRecord.code,KEY_TOKEN_PARAM:[[UserSession currentSession] sessionToken]};
    NSLog(@"param = %@",paramCheckinDetail);
    [_baseModel getFeelingDetailWithParameters:paramCheckinDetail completion:^(id responseObject, NSError *error){
        if (!error) {
            NSDictionary *dic = (NSDictionary *)(responseObject);
            NSDictionary *dicDetail = [dic objectForKey:KEY_FEELING];
            //get lat and lon
            CLLocationCoordinate2D location;
            location.latitude = [[dicDetail valueForKey:KEY_LATITUDE] floatValue];
            location.longitude = [[dicDetail valueForKey:KEY_LONGITUDE] floatValue];
            NSLog(@"%s",__PRETTY_FUNCTION__);
            NSLog(@"lat = %f",location.latitude);
            NSLog(@"long %f",location.longitude);
            _currenLocations = location;
            
            [self setLocationsMyTherapy:location];
        }else {
            NSLog(@"Error: %@",error);
        }
    }];
    
}

- (void)setFeelingRecordTherapy:(FeelingRecord *)feelingRecord{
    _feelingRecord = feelingRecord;
}

- (void)setShowAllRows:(BOOL)showAllRows animated:(BOOL)animated
{
    if (showAllRows) {
        _feelingRowCount = _feelingRecord.feelings.count;
    } else {
        _feelingRowCount = MIN(_feelingRecord.feelings.count, TOTAL_ROW_DEFAULT_MY_THERAPY);
        [_moreFeelingButton setTitle:[NSString stringWithFormat:@"AND %d MORE", (int)(_feelingRecord.feelings.count - TOTAL_ROW_DEFAULT_MY_THERAPY)] forState:UIControlStateNormal];
    }
    
    _showMoreLink = _showMoreLink && _feelingRowCount < _feelingRecord.feelings.count;
    
    CGFloat tableViewHeight = HEIGHT_HEADER_TABLE_VIEW_MY_THERAPY + (_feelingRowCount * HEIGHT_FEELING_CELL_TABLE_VIEW_MY_THERAPY) + (_showMoreLink ? HEIGHT_SHOW_MORE_LINK_CELL_TABLE_VIEW_MY_THERAPY : 0) + HEIGHT_FOOTER_TABLE_VIEW_MY_THERAPY;
    self.heightFeelingTableViewContainerConstraint.constant = tableViewHeight;
    [self.tableView setNeedsUpdateConstraints];
    
    if (animated) {
        [UIView animateWithDuration:TIME_UPDATE_TABLE_VIEW_MY_THERAPY animations:^{
            [self.scrollView layoutIfNeeded];
            
            NSMutableArray *moreFeelingRowPaths = [[NSMutableArray alloc] init];
            for (int i = TOTAL_ROW_DEFAULT_MY_THERAPY; i < _feelingRecord.feelings.count; ++i) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                [moreFeelingRowPaths addObject:path];
            }
            
            NSArray *moreLinkRowPath = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:TOTAL_ROW_DEFAULT_MY_THERAPY inSection:0], nil];
            
            [self.tableView beginUpdates];
            if (showAllRows) {
                _showMoreLink = NO;
                [self.tableView deleteRowsAtIndexPaths:moreLinkRowPath withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:moreFeelingRowPaths withRowAnimation:UITableViewRowAnimationFade];
            }
            [self.tableView endUpdates];
        }];
    } else {
        [self.scrollView layoutIfNeeded];
    }
    
    _showAllFeelings = showAllRows;
}

- (void)toggleShowAllRows
{
    [self setShowAllRows:!_showAllFeelings animated:YES];
}

- (void)setUserAvatarForImage:(UIImageView *)imageView {
    imageView.image = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
    UserSession *userSession = [UserSession currentSession];
    BOOL isNeedRequestAvatar = YES;
    if (userSession.userAvatar) {
        imageView.image = userSession.userAvatar;
        isNeedRequestAvatar = NO;
    }
    if (isNeedRequestAvatar) {
        UIImage *avatar = [_avatarCache objectForKey:userSession.userId];
        NSDictionary *parameters = @{KEY_USER_ID:userSession.userId};
        if (!avatar) {
            [_baseModel getUserAvatarWithParameters:parameters completion:^(id responseObject, NSError *error){
                if (!error) {
                    UIImage *avatar = responseObject;
                    if (avatar == nil) {
                        avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                    } else {
                        [_avatarCache setObject:responseObject forKey:userSession.userId];
                    }
                    imageView.image = avatar;
                }else {
                    UIImage *avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                    imageView.image = avatar;
                }
            }];
        }
    }
}

- (void)getBiographyAndBackgroundUserFromServer {
    UserSession *userSession = [UserSession currentSession];
    BOOL needRequestBiography = YES;
    BOOL needRequestBackground = YES;
    
    // Biography
    if ((userSession.userBiography != (id)[NSNull null]) && (userSession.userBiography.length > 0)) {
        [_userProfileView setValueBiographyTextViewWithString:userSession.userBiography];
        needRequestBiography = NO;
    }
    
    // Background
    if ((userSession.backgroundImage)) {
        _userProfileView.profileBackgroundImageView.image = userSession.backgroundImage;
        needRequestBackground = NO;
    }else {
        needRequestBackground = YES;
    }
    
    if (needRequestBiography || needRequestBackground)  {
        NSDictionary *parameters = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken, KEY_USER_ID:userSession.userId};
        [_baseModel getUserEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
            if (!error) {
                NSDictionary *userDataDict = (NSDictionary *)[responseObject objectForKey:KEY_USER];
                if (needRequestBiography) {
                    NSString *biograyphy = [userDataDict objectForKey:KEY_BIOGRAPHY];
                    [_userProfileView setValueBiographyTextViewWithString:biograyphy];
                }
                if (needRequestBackground) {
                    NSString *urlPathNameBackground = [userDataDict objectForKey:KEY_IMAGE_COVER];
                    [self downloadBackgroundProfileImageWithURLPathName:urlPathNameBackground];
                }
            }else {
                NSLog(@"Couldn't complete with error: %@",error);
            }
        }];
    }
}

- (void)downloadBackgroundProfileImageWithURLPathName:(NSString *)urlPathName {
    [_baseModel downloadUserImageWithImageKey:KEY_IMAGE_COVER andURLPathName:urlPathName completion:^(id responseObject, NSError *error){
        if (!error) {
            UIImage *userProfileBackgroundImage = responseObject;
            if(userProfileBackgroundImage){
                UserSession *userSession = [UserSession currentSession];
                _userProfileView.profileBackgroundImageView.image = userSession.backgroundImage = userProfileBackgroundImage;
            }else {
                UIImage *defaultBackgroundImage = [UIImage imageNamed:IMAGE_NAME_AUTUMN_COLOR];
                _userProfileView.profileBackgroundImageView.image = defaultBackgroundImage;
            }
        }else {
            NSLog(@"Couldn't complete with error: %@",error);
        }
    }];
}

#pragma mark - MapView management

- (void)setLocationsMyTherapy:(CLLocationCoordinate2D )locations{
    if (locations.latitude == -180 && locations.longitude == -180) {
        _mapViews.hidden = YES;
        _mapButtonView.hidden = YES;
        _mapPlaceholderLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_SHARE_FEELING_LABEL_MY_THERAPY);
        _mapPlaceholderLabel.textColor = [UIColor whiteColor];
        _mapPlaceholderLabel.text = NSLocalizedString(TEXT_LOCATION_UNAVAILABLE_MY_THERAPY, nil);
    }else{
        if (_mapViews) {
            [_mapViews removeFromSuperview];
            _mapViews = nil;
        }
        _mapViews = [[MKMapView alloc] initWithFrame:self.mapButtonView.frame];
        [_mapContainerView insertSubview:_mapViews belowSubview:_mapButtonView];
        _mapViews.delegate = self;

        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(locations.latitude, locations.longitude);
        
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.027, 0.027));
        region.span.latitudeDelta = 6;
        region.span.longitudeDelta = 1;
        [_mapViews setRegion:region animated:YES];
        
        SVAnnotation *annotation = [[SVAnnotation alloc] initWithCoordinate:coordinate];
        [_mapViews addAnnotation:annotation];
    }

}

- (void)updateMapZoomLocation:(CLLocation *)newLocation
{
    MKCoordinateRegion region;
    region.center.latitude = newLocation.coordinate.latitude;
    region.center.longitude = newLocation.coordinate.longitude;
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;
    [_mapViews setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    if(annotation != _mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                         initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    }
    else {
        [_mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], LATITUDINAL_METERS_MY_THERAPY, LONGITUDINAL_METERS_MY_THERAPY);
    [mv setRegion:region animated:YES];
    [mv selectAnnotation:mp animated:YES];
}

#pragma mark - TableView delegates & datasources

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
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
    return HEIGHT_HEADER_TABLE_VIEW_MY_THERAPY;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _footerContainerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_FOOTER_TABLE_VIEW_MY_THERAPY;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_SECTION_TABLE_VIEW_MY_THERAPY;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = _feelingRowCount + (_showMoreLink ? 1 : 0);
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row < _feelingRowCount) {
        FeelingSummaryCell *feelingCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FEELING_SUMMARY_CELL];
        if (feelingCell == nil) {
            feelingCell = [[FeelingSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_FEELING_SUMMARY_CELL];
        }
        [feelingCell setFeeling:[_feelingRecord.feelings objectAtIndex:indexPath.row]];
        
        cell = feelingCell;
    } else {
        if (_showMoreLink && indexPath.row == TOTAL_ROW_DEFAULT_MY_THERAPY) {
            UITableViewCell *moreLinkCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MORE_LINK_CELL];
            if (moreLinkCell == nil) {
                moreLinkCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_MORE_LINK_CELL];
            }
            [moreLinkCell.contentView addSubview:_moreLinkContainerView];
            cell = moreLinkCell;
        } else {
            FeelingTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FEELING_TEXT_CELL];
            if (textCell == nil) {
                textCell = [[FeelingTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_FEELING_TEXT_CELL];
            }
            
            textCell.textView.text = _activityAndCommentString;
            [textCell.textView sizeToFit];
            
            CGRect textFrame = textCell.textView.frame;
            textFrame.size.width = WIDTH_TEXT_CELL_TABLE_VIEW_MY_THERAPY;
            textCell.textView.frame = textFrame;
            
            CGRect containerFrame = textCell.containerView.frame;
            containerFrame.size.height = textCell.textView.frame.size.height;
            textCell.containerView.frame = containerFrame;
            
            cell = textCell;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row < _feelingRowCount) {
        height = HEIGHT_FEELING_CELL_TABLE_VIEW_MY_THERAPY;
    } else if (_showMoreLink && indexPath.row == TOTAL_ROW_DEFAULT_MY_THERAPY) {
        height = HEIGHT_SHOW_MORE_LINK_CELL_TABLE_VIEW_MY_THERAPY;
    } else {
        height = HEIGHT_FOOTER_TABLE_VIEW_MY_THERAPY;
    }
    return height;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        CGFloat yOffset  = scrollView.contentOffset.y;
        if (yOffset < 0) {
            CGRect fixedFrame = _userProfileView.frame;
            fixedFrame.size.height =  -yOffset + _heightProfileView;
            fixedFrame.origin.y = yOffset;
            _userProfileView.frame = fixedFrame;
            
            _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_userProfileView.frame.size.height, 0, 0, 0);
        }else {
            CGRect fixedFrame = _userProfileView.frame;
            fixedFrame.origin.y = yOffset;
            _userProfileView.frame = fixedFrame;
            _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_userProfileView.frame.size.height, 0, 0, 0);
        }
    }
}

#pragma mark - Profile View delegate

- (void)updateScrollIndicatorInset:(UIEdgeInsets)edgeInsets userProfileView:(UserProfileView *)userProfileView {
    if (userProfileView == _userProfileView) {
        _heightProfileView = _userProfileView.heightProfileView;
        _scrollView.scrollIndicatorInsets = edgeInsets;
        [UIView animateWithDuration:TIME_TO_CHANGE_CONSTRAINT animations:^{
            _topFeelingTableViewContainerConstraint.constant = _heightProfileView;
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished){
            _heightTotalInnerConstraint.constant = _heightProfileView + _heightFeelingTableViewContainerConstraint.constant + _heightMapsViewContainerConstraint.constant + _heightAttachmentViewContainerConstraint.constant + _heightShareSwithViewContainerConstraint.constant + _heightDeleteCheckinViewContainerConstraint.constant + _heightShortcutContainerConstraint.constant;
            [self.view layoutIfNeeded];
        }];
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentOffset.y) animated:YES];
    }
}

@end
