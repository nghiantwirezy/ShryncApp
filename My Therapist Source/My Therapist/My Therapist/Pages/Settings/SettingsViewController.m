//
//  SettingsViewController.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "UserSession.h"
#import "ContainedWebViewController.h"
#import "RevealMenuViewController.h"
#import "MBProgressHUD.h"
#import "ProfileViewController.h"
#import "PublicProfileViewController.h"
#import "ATConnect.h"
#import "FHSTwitterEngine.h"
#import "PPRevealSideViewController.h"
#import "InviteFriendsViewController.h"
#import "UIColor+ColorUtilities.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController{
    UIBarButtonItem *_backButtonItem;
    NSArray *arrayTitles;
    NSArray *arrayViews;
    MBProgressHUD *_hud;
    NSMutableDictionary *dicViews;
    UIImageView *_hudCustomeView;
    BaseModel *_baseModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    _baseModel = [BaseModel shareBaseModel];
    ATConnect *connection = [ATConnect sharedConnection];
    connection.apiKey = KEY_APPTENTIVE;
    
    UIImage *backImage = [UIImage imageNamed:IMAGE_NAME_BACK_BUTTON];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 28, 28)];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack1) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:barButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME_TITLE_SETTINGS];
    titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_TITLE_SETTINGS);
    titleLabel.text = NSLocalizedString(TITLE_SETTINGS, nil);
    titleLabel.textColor = [UIColor veryLightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    [_tableviewContent setBackgroundColor:_contentContainerView.backgroundColor];
    arrayTitles = [NSArray arrayWithObjects:TITLE_PROFILE_SETTINGS,TITLE_FRIENDS_SETTINGS,TITLE_SHARE_SETTINGS,TITLE_SUPPORT_AND_FEEDBACK_SETTINGS,TITLE_RATE_SETTINGS,TITLE_APP_INFORMATION_SETTINGS, nil];
    arrayViews = [NSArray arrayWithObjects:self.subviewProfile,self.subviewFriends,self.subviewShare,self.subviewSpFeedback,self.subviewRate, self.subviewInformation,nil];
    dicViews = [NSMutableDictionary dictionaryWithObjects:arrayViews forKeys:arrayTitles];
    //set font
    [_editProfileButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_signoutButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_checkinPublicLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_profilePublicLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_shryncShareButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_facebookShareLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_facebookConnectLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_SMALL)];
    [_shareTwitterButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_shareFacebookButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_twitterShareLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_twitterConnectLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_SMALL)];
    [_rateButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_feedbackButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_supportButtonAction.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_rateButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    //about
    [_privacyButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_termsofuseButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_aboutButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_versionAppButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_deleteAccountButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_BIG)];
    //help
    [_helpCheckinsPublicLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_LABEL_SMALL)];
    [_helpConnectFbLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_LABEL_SMALL)];
    [_helpConnectTwLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_LABEL_SMALL)];
    [_helpEditProfile setFont:COMMON_BEBAS_FONT(SIZE_FONT_LABEL_SMALL)];
    [_helpProfilePublicLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_LABEL_SMALL)];
    [_helpShareShryncLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_LABEL_SMALL)];
    [_versionLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_helpRateLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_LABEL_SMALL)];
    //friends
    [_findFriendsButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *label = [NSString stringWithFormat:@"%@ (%@)",version,build];
    _versionLabel.text = label;
    
    [_versionLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_versionAppButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    _hud.labelFont = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    
    _hudCustomeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no.png"]];
    _hud.customView = _hudCustomeView;
    
    //connect fb
    [self updateStatusFacebook];
    
    [self checkStateConnectFacebook];
    [self checkStateConnectTwitter];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSLog(@"[UserSession currentSession] userPublicCheckin] = %d",[[UserSession currentSession] userPublicCheckin]);
//    [[UserSession currentSession] saveSession];
    [self.switchCheckinPublicButton setOn: [[UserSession currentSession] userPublicCheckin] animated:YES];
    [self.switchProfilePublicButton setOn: [[UserSession currentSession] userPublicProfile] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkStateConnectTwitter];
    [self checkStateConnectFacebook];
}

- (void)checkStateConnectTwitter {
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:TWITTER_CONSUMER_KEY andSecret:TWITTER_CONSUMER_SECRET];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    if ([[FHSTwitterEngine sharedEngine] isAuthorized]) {
        [_twitterConnectLabel setText:NSLocalizedString(TEXT_CONNECTED_SETTINGS, nil)];
        [_shareTwitterButton setTitle:NSLocalizedString(TEXT_UNLINK_CONNECT_SETTINGS, nil) forState:UIControlStateNormal];
    }else{
        [_twitterConnectLabel setText:NSLocalizedString(TEXT_NOT_CONNECTED_SETTINGS, nil)];
        [_shareTwitterButton setTitle:NSLocalizedString(TEXT_LINK_CONNECT_SETTINGS, nil) forState:UIControlStateNormal];
    }
}
- (void)checkStateConnectFacebook {
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [_facebookConnectLabel setText:NSLocalizedString(TEXT_CONNECTED_SETTINGS, nil)];
        [_shareFacebookButton setTitle:NSLocalizedString(TEXT_UNLINK_CONNECT_SETTINGS, nil) forState:UIControlStateNormal];
    } else {
        [_facebookConnectLabel setText:NSLocalizedString(TEXT_NOT_CONNECTED_SETTINGS,nil)];
        [_shareFacebookButton setTitle:NSLocalizedString(TEXT_LINK_CONNECT_SETTINGS, nil) forState:UIControlStateNormal];
    }
}

- (MBProgressHUD *)hud
{
    return _hud;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)popBack1{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Login/Logout Facebook

- (void)updateStatusFacebook{
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] session].isOpen) {
        [_facebookConnectLabel setText:NSLocalizedString(TEXT_CONNECTED_SETTINGS, nil)];
        [_shareFacebookButton setTitle:NSLocalizedString(TEXT_UNLINK_CONNECT_SETTINGS, nil) forState:UIControlStateNormal];
    }else{
        [_facebookConnectLabel setText:NSLocalizedString(TEXT_NOT_CONNECTED_SETTINGS,nil)];
        [_shareFacebookButton setTitle:NSLocalizedString(TEXT_LINK_CONNECT_SETTINGS, nil) forState:UIControlStateNormal];
    }
}

#pragma mark - Delete Button

- (IBAction)deleteAccountButtonAction:(id)sender {
    UserSession *userSession = [UserSession currentSession];
    if ([userSession isGuestSession]) {
        _deleteAccountButton.enabled = NO;
        _deleteAccountButton.backgroundColor = [UIColor grayColor];
        UIAlertView *messageAlerta = [[UIAlertView alloc] initWithTitle:@"Delete Account Message!"
                                                                message:@"You are login guest account !!!"
                                                               delegate:self
                                                      cancelButtonTitle: nil
                                                      otherButtonTitles: @"Cancel", nil];
        [messageAlerta show];
    }else if([UserSession currentSession]){
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Delete Account Message!"
                                                               message:@"Deleting your account will: \
                                     - Delete all of your Account and Profile information from Shrync \
                                     - Delete all Public and Private Check-ins \
                                     Would you like to proceed with deleting? "
                                                              delegate:self
                                                     cancelButtonTitle:@"No"
                                                     otherButtonTitles:@"Yes",nil];
        [messageAlert setTag:TAG_ALERT_DELETE_ACCOUNT_SETTNGS];
        [messageAlert show];
    }
}

#pragma mark - Edit Profile

- (IBAction)EditProfileButtonAction:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ProfileViewController *controller = delegate.profileViewController;
    //    [controller resetEditStates];
    
    [delegate.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:YES];
    [controller resetNavigationLeftItems];
    
    [delegate.revealSideViewController popViewControllerAnimated:YES];
}

- (IBAction)signoutButtonAction:(id)sender {
    UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Shrync Sign Out!"
                                                           message:@"Are you sure you want to sign out? "
                                                          delegate:self
                                                 cancelButtonTitle:@"No"
                                                 otherButtonTitles:@"Yes",nil];
    [messageAlert setTag:TAG_ALERT_SIGN_OUT_SETTNGS];
    [messageAlert show];
}

- (IBAction)switchProfilePublicButtonAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:_contentContainerView animated:YES];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    UserSession *userSession = [UserSession currentSession];
    NSString *token = userSession.sessionToken;
    [parameters setObject:token forKey:KEY_TOKEN_PARAM];
    [parameters setObject:[NSNumber numberWithBool:_switchProfilePublicButton.isOn] forKey:KEY_PROFILE_PUBLIC];
    
    [_baseModel postUserUpdateEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
        if (!error) {
            NSLog(@"Success = %@",responseObject);
            
            [[UserSession currentSession] setUserPublicProfile:[[[responseObject objectForKey:@"user" ] objectForKey:@"profile_public"]boolValue]];
            [[UserSession currentSession] saveSession];
            [MBProgressHUD hideAllHUDsForView:_contentContainerView animated:YES];
        }else {
            NSLog(@"Error = %@", error);
            [MBProgressHUD hideAllHUDsForView:_contentContainerView animated:YES];
        }
    }];
}

- (IBAction)switchCheckinPublicButtonAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:_contentContainerView animated:YES];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    UserSession *userSession = [UserSession currentSession];
    NSString *token = userSession.sessionToken;
    [parameters setObject:token forKey:KEY_TOKEN_PARAM];
    [parameters setObject:[NSNumber numberWithBool:_switchCheckinPublicButton.isOn] forKey:KEY_CHECKIN_PUBLIC];
    [_baseModel postUserUpdateEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
        if (!error) {
            NSLog(@"Success = %@",responseObject);
            [[UserSession currentSession] setUserPublicCheckin:[[[responseObject objectForKey:@"user" ] objectForKey:@"checkin_public"]boolValue]];
            [[UserSession currentSession] saveSession];
            [MBProgressHUD hideAllHUDsForView:_contentContainerView animated:YES];
        }else {
            NSLog(@"Error = %@", error);
            [MBProgressHUD hideAllHUDsForView:_contentContainerView animated:YES];
        }
    }];
}

#pragma mark - Feedback/Support Button

- (IBAction)feedbackButtonAction:(id)sender {
    ATConnect *connection = [ATConnect sharedConnection];
    [connection presentMessageCenterFromViewController:self];
}

- (IBAction)supportButtonAction:(id)sender {
    ATConnect *connection = [ATConnect sharedConnection];
    [connection presentMessageCenterFromViewController:self];
}

#pragma mark - Information Button

- (IBAction)rateButtonAction:(id)sender {
    [[ATConnect sharedConnection] engage:@"completed_level" fromViewController:self];
}

- (IBAction)privacyButtonAction:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ContainedWebViewController *viewController = delegate.privacyTextView;
    [viewController presentFromController:self];
}

- (IBAction)termsofuseButtonAction:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ContainedWebViewController *viewController = delegate.termTextView;
    [viewController presentFromController:self];
}

- (IBAction)aboutButtonAction:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ContainedWebViewController *viewController = delegate.aboutTextView;
    [viewController presentFromController:self];
}

#pragma mark - Find Friends

- (IBAction)findFriendsButtonAction:(id)sender {
        InviteFriendsViewController *inviteFriendsViewController = [[InviteFriendsViewController alloc]init];
        [self.navigationController pushViewController:inviteFriendsViewController animated:YES];
}

#pragma mark - Share Button

- (IBAction)shryncShareButtonAction:(id)sender{
    NSString *texttoshare = @" I'm using @ShryncApp to track and share how I feel. Try it out! http://www.shrync.com "; //this is your text string to share
    UIImage *imagetoshare = [UIImage imageNamed:@"logo@2x.png"]; //this is your image to share
    NSArray *activityItems = @[texttoshare, imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

- (IBAction)shareTwitterButtonAction:(id)sender {
    [[FHSTwitterEngine sharedEngine] isAuthorized]?[self logoutTwitter]:[self loginTwitter];
}

- (IBAction)shareFacebookButtonAction:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            appDelegate.session = [[FBSession alloc] init];
        }
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            [self updateStatusFacebook];
        }];
    }
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Logout Message!"
                                                               message:@"Are you sign out Facebook account? "
                                                              delegate:self
                                                     cancelButtonTitle:@"No"
                                                     otherButtonTitles:@"Yes",nil];
        [messageAlert setTag:TAG_ALERT_SIGN_OUT_FACEBOOK_SETTNGS];
        [messageAlert show];
    } else {
        [FBSession openActiveSessionWithReadPermissions:FACEBOOK_PERMISSIONS
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self sessionFaceBookStateChanged:session state:state error:error];
         }];
    }
}

- (void)sessionFaceBookStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    if (!error && state == FBSessionStateOpen){
        // If the session was opened successfully
        [self checkStateConnectFacebook];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil];
            [self.class showSingleAlert:alertView];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil];
                [self.class showSingleAlert:alertView];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil];
                [self.class showSingleAlert:alertView];            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    [self checkStateConnectFacebook];
}

#pragma mark - Alert View
__strong static UIAlertView *singleAlert;
// Show an alert message
+ (void)showSingleAlert:(UIAlertView *)alertView {
    if (singleAlert.visible) {
        [singleAlert dismissWithClickedButtonIndex:0 animated:NO];
        singleAlert = nil;
    }
    singleAlert = alertView;
    [singleAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case TAG_ALERT_DELETE_ACCOUNT_SETTNGS:{
            if (buttonIndex == 1)
            {
                NSLog(@"You have clicked YES");
                _hud.labelText = NSLocalizedString(TEXT_DELETING_SETTINGS, nil);
                _hud.mode = MBProgressHUDModeIndeterminate;
                [_hud show:YES];
                NSDictionary *parameters = @{KEY_USER_ID: [[UserSession currentSession] userId], KEY_TOKEN_PARAM: [[UserSession currentSession] sessionToken]};
                NSLog(@"parameters = %@",parameters);
                [_baseModel deleteAccountEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
                    if (!error) {
                        NSLog(@"respone = %@",responseObject);
                        _hud.labelText = [responseObject valueForKey:KEY_MASSAGE];
                        [_hud hide:YES afterDelay:4.0];
                        [UserSession signOut];
                        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [delegate navigateToLandingPage];
                    }else {
                        NSLog(@"error = %@",error);
                    }
                }];
            }
            else if(buttonIndex == 0)
            {
                NSLog(@"You have clicked NO");
            }
        }
            break;
            
        case TAG_ALERT_SIGN_OUT_SETTNGS:{
            if (buttonIndex == 1)
            {
                [UserSession signOut];
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate navigateToLandingPage];
            }else if (buttonIndex == 0){
                NSLog(@"You have clicked NO");
            }
        }
            break;
        case TAG_ALERT_SIGN_OUT_FACEBOOK_SETTNGS:{
            if (buttonIndex == 1)
            {
                [FBSession.activeSession closeAndClearTokenInformation];
                [self checkStateConnectFacebook];
            }else if (buttonIndex == 0){
                NSLog(@"You have clicked NO");
            }
        }
            break;
        case TAG_ALERT_SIGN_OUT_TWITTER_SETTNGS:{
            if (buttonIndex == 1)
            {
                [[FHSTwitterEngine sharedEngine]clearAccessToken];
                [_tableviewContent reloadData];
                [self checkStateConnectTwitter];
            }else if (buttonIndex == 0){
                NSLog(@"You have clicked NO");
            }
        }
        default:
            break;
    }
    
}

- (void)resetEditStates{
    [self.switchCheckinPublicButton setOn: [[UserSession currentSession] userPublicCheckin] animated:YES];
    [self.switchProfilePublicButton setOn: [[UserSession currentSession] userPublicProfile] animated:YES];
}

- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

#pragma mark - Login/Logout Twitter

- (void)loginTwitter{
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
        NSLog(@"log 2 = %d",[[FHSTwitterEngine sharedEngine] isAuthorized]);
        
        [_tableviewContent reloadData];
        [_twitterConnectLabel setText:NSLocalizedString(TEXT_CONNECTED_SETTINGS, nil)];
        [_shareTwitterButton setTitle:NSLocalizedString(TEXT_UNLINK_CONNECT_SETTINGS, nil) forState:UIControlStateNormal];
    }];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (void)logoutTwitter{
    UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Logout Message!"
                                                           message:@"Are you sign out Twitter account? "
                                                          delegate:self
                                                 cancelButtonTitle:@"No"
                                                 otherButtonTitles:@"Yes",nil];
    [messageAlert setTag:TAG_ALERT_SIGN_OUT_TWITTER_SETTNGS];
    [messageAlert show];
}

#pragma mark - Table view Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrayTitles count]; //one male and other female
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:self.contentContainerView.backgroundColor];
    UILabel *labelTitleSection = [[UILabel alloc]initWithFrame:headerView.frame];
    [labelTitleSection setText:[arrayTitles objectAtIndex:section]];
    [labelTitleSection setFont:COMMON_BEBAS_FONT(SIZE_FONT_LABEL_TITLE_MY_FEELINGS)];
    [labelTitleSection setTextColor:[UIColor blackColor]];
    [labelTitleSection  setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:labelTitleSection];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIView *viewContent = (UIView *)[dicViews objectForKey:[arrayTitles objectAtIndex:indexPath.section]];
    return CGRectGetHeight(viewContent.frame);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UIView *viewContent = (UIView *)[dicViews objectForKey:[arrayTitles objectAtIndex:indexPath.section]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:viewContent];
    return cell;
}
@end
