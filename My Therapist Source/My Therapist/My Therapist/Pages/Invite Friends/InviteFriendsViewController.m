//
//  InviteFriendsViewController.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "AppDelegate.h"
#import "UserSession.h"
#import "ContainedWebViewController.h"
#import "RevealMenuViewController.h"
#import "MBProgressHUD.h"
#import "ProfileViewController.h"
#import "PublicProfileViewController.h"
#import "ATConnect.h"
#import "FHSTwitterEngine.h"
#import "SearchUsersFriendsViewController.h"
#import "UIColor+ColorUtilities.h"

@implementation InviteFriendsViewController {
    UIBarButtonItem *_backButtonItem, *_revealMenuButtonItem;
    NSArray *arrayTitles;
    NSArray *arrayViews;
    MBProgressHUD *_hud;
    NSMutableDictionary *dicViews;
    UIImageView *_hudCustomeView;
}

#pragma mark - InviteFriendsViewController management

- (void)viewDidLoad {
    [super viewDidLoad];
    _baseModel = [BaseModel shareBaseModel];
    _avatarCache = [[NSCache alloc] init];
    self.navigationItem.hidesBackButton = YES;
    _userFriendFoundArray = [[NSMutableArray alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME_TITLE_LABEL_INVITE_FRIENDS];
    titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_TITLE_DEFAULT);
    titleLabel.text = NSLocalizedString(TITLE_INVITE_FRIENDS, nil);
    titleLabel.textColor = [UIColor veryLightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIImage *backImage = [UIImage imageNamed:IMAGE_NAME_BACK_BUTTON];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:FRAME_BACK_BUTTON_INVITE_FRIENDS];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popMenuLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:barButton];
    
    _connectTwitterButton.layer.cornerRadius = CORNER_RADIUS_COMMON_INVITE_FRIEND;
    _connectFacebookButton.layer.cornerRadius = CORNER_RADIUS_COMMON_INVITE_FRIEND;
    _searchUsersButton.layer.cornerRadius = CORNER_RADIUS_COMMON_INVITE_FRIEND;
    _inviteTextButton.layer.cornerRadius = CORNER_RADIUS_COMMON_INVITE_FRIEND;
    _inviteEmailButton.layer.cornerRadius = CORNER_RADIUS_COMMON_INVITE_FRIEND;
    
    [_facebookInviteButton setImage:[UIImage imageNamed:IMAGE_NAME_FACEBOOK_24] forState:UIControlStateNormal];
    [_facebookInviteButton setImage:[UIImage imageNamed:IMAGE_NAME_FACEBOOK_48] forState:UIControlStateSelected];
    [_twitterInviteButton setImage:[UIImage imageNamed:IMAGE_NAME_TWITTER_24] forState:UIControlStateNormal];
    [_twitterInviteButton setImage:[UIImage imageNamed:IMAGE_NAME_TWITTER_48] forState:UIControlStateSelected];
    [_searchInviteButton setImage:[UIImage imageNamed:IMAGE_NAME_SEARCH_24] forState:UIControlStateNormal];
    [_searchInviteButton setImage:[UIImage imageNamed:IMAGE_NAME_SEARCH_48] forState:UIControlStateSelected];
    
    [_connectFacebookButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_SMALL)];
    [_connectFacebookLabel setFont:COMMON_BEBAS_FONT(SIZE_BATCH)];
    [_connectTwitterButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_SMALL)];
    [_connectTwitterLabel setFont:COMMON_BEBAS_FONT(SIZE_BATCH)];
    [_searchUsersButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_SMALL)];
    [_inviteTextButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_SMALL)];
    [_inviteEmailButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_SMALL)];
    [_connectToFacebookTitleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_SMALL)];
    [_connectToTwitterTitleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_SMALL)];
    
    _connectFacebookLabel.textColor = [UIColor veryLightGrayColor];
    _connectTwitterLabel.textColor = [UIColor veryLightGrayColor];
    
    _facebookContentView.hidden = YES;
    _searchContentView.hidden = YES;
    
    _twitterSearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchFriendsTwitterSearchBar contentsController:self];
    _twitterSearchDisplayController.delegate = self;
    _twitterSearchDisplayController.searchResultsDataSource = self;
    _twitterSearchDisplayController.searchResultsDelegate = self;
    
    _facebookSearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchFriendsFacebookSearchBar contentsController:self];
    _facebookSearchDisplayController.delegate = self;
    _facebookSearchDisplayController.searchResultsDataSource = self;
    _facebookSearchDisplayController.searchResultsDelegate = self;
    _currentTableView = _listFriendsTwitterTableView;
    [self initHud];
    
    _arrayListFriendsFacebook = [[NSMutableArray alloc]init];
    _arrayListSearchFriendsFacebook = [[NSMutableArray alloc]init];
    _arrayListFriendsTwitter = [[NSMutableArray alloc]init];
    _arrayListSearchFriendsTwitter = [[NSMutableArray alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//      self.navigationItem.leftBarButtonItem = ((AppDelegate *) [[UIApplication sharedApplication] delegate]).revealMenuButtonItem;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getFollowingMe];
    [self checkStateConnectFacebook];
    [self checkStateConnectTwitter];
}

- (void)popMenuLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)initHud {
    _hudTwitter = [[MBProgressHUD alloc] initWithView:self.twitterContentView];
    _hudTwitter.userInteractionEnabled = NO;
    _hudTwitter.labelFont = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    [self.twitterContentView addSubview:_hudTwitter];
    
    _hudFacebook = [[MBProgressHUD alloc] initWithView:self.facebookContentView];
    _hudFacebook.userInteractionEnabled = NO;
    _hudFacebook.labelFont = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    [self.facebookContentView addSubview:_hudFacebook];
}

#pragma mark - Actions

- (IBAction)facebookInviteButtonAction:(id)sender {
    _facebookInviteButton.selected = YES;
    _twitterInviteButton.selected = NO;
    _searchInviteButton.selected = NO;
    
    _facebookContentView.hidden = NO;
    _twitterContentView.hidden = YES;
    _searchContentView.hidden = YES;
    _currentTableView = _listFriendsFacebookTableView;
}

- (IBAction)twitterInviteButtonAction:(id)sender {
    _twitterInviteButton.selected = YES;
    _facebookInviteButton.selected = NO;
    _searchInviteButton.selected = NO;
    
    _facebookContentView.hidden = YES;
    _twitterContentView.hidden = NO;
    _searchContentView.hidden = YES;
    _currentTableView = _listFriendsTwitterTableView;
}

- (IBAction)searchInviteButtonAction:(id)sender {
    _searchInviteButton.selected = YES;
    _twitterInviteButton.selected = NO;
    _facebookInviteButton.selected = NO;
    
    _facebookContentView.hidden = YES;
    _twitterContentView.hidden = YES;
    _searchContentView.hidden = NO;
}
- (IBAction)connectTwitterButtonAction:(id)sender {
    [[FHSTwitterEngine sharedEngine] isAuthorized]?[self logoutTwitter]:[self loginTwitter];
}

- (IBAction)connectFacebookButtonAction:(id)sender {
    NSLog(@"Touch button Facebook connect !");
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [self didLogoutFromFacebook];
    } else {
        [FBSession openActiveSessionWithReadPermissions:FACEBOOK_PERMISSIONS
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self sessionFaceBookStateChanged:session state:state error:error];
         }];
    }
}
- (IBAction)searchUsersButtonAction:(id)sender {
    SearchUsersFriendsViewController *nextViewController = [SearchUsersFriendsViewController new];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

- (IBAction)inviteTextButtonAction:(id)sender {
    [self showSMS];
}
- (IBAction)inviteEmailButtonAction:(id)sender {
    [self sendEmail];
}

- (IBAction)tapViewAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark MFMessageComposeViewController & MFMailComposeViewController delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom Methods

- (void)sendEmail{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Shrync Invite"];
        [mail setMessageBody:@"I'm using @ShryncApp to track and share how I feel. Try it out! http://www.shrync.com" isHTML:NO];
        [mail setToRecipients:@[@"testingEmail@example.com"]];
        [self presentViewController:mail animated:YES completion:nil];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

- (void)showSMS{
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = nil;
    NSString *message = [NSString stringWithFormat:@"I'm using @ShryncApp to track and share how I feel. Try it out! http://www.shrync.com"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)setAvatarForImage:(UIImageView *)imageView withUserID:(NSString *)userID {
    UserSession *userSession = [UserSession currentSession];
    BOOL isNeedRequestAvatar = YES;
    if ([userID isEqualToString:userSession.userId] && (userSession.userAvatar)) {
        imageView.image = userSession.userAvatar;
        isNeedRequestAvatar = NO;
    }
    if (isNeedRequestAvatar) {
        UIImage *avatar = [_avatarCache objectForKey:userID];
        NSDictionary *parameters = @{KEY_USER_ID:userID};
        if (!avatar) {
            [_baseModel getUserAvatarWithParameters:parameters completion:^(id responseObject, NSError *error){
                if (!error) {
                    UIImage *avatar = responseObject;
                    if (avatar == nil) {
                        avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                    } else {
                        [_avatarCache setObject:avatar forKey:userID];
                    }
                    imageView.image = avatar;
                }else {
                    UIImage *avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                    imageView.image = avatar;
                }
            }];
        }else {
            imageView.image = avatar;
        }
    }
}

- (NSMutableArray *)removeCurrentUserLoginFromArray:(NSMutableArray *)arrayUser {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (FollowObject *followObject in arrayUser) {
        if (![followObject.user_id isEqualToString:[UserSession currentSession].userId]) {
            [resultArray addObject:followObject];
        }
    }
    return resultArray;
}

#pragma mark - Facebook management

- (void)checkStateConnectFacebook {
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [self didLoginFromFacebook];
    } else {
        [self didLogoutFromFacebook];
    }
}

- (void)sessionFaceBookStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    if (!error && state == FBSessionStateOpen){
        // If the session was opened successfully
        _connectToFacebookTitleLabel.text = TEXT_DISCONNECT_TO_FACEBOOK;
        [self didLoginFromFacebook];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        [self didLogoutFromFacebook];
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
        [self didLogoutFromFacebook];
    }
}

- (void)didLoginFromFacebook {
    NSLog(@"Session Facebook opened");
    [UIView animateWithDuration:TIME_EXPAND_COLLAPSE_VIEW_INVITE_FRIENDS animations:^{
        _connectToFacebookTitleLabel.text = TEXT_DISCONNECT_TO_FACEBOOK;
        _heightContentFacebookViewContraint.constant = CONSTRAINT_HEIGHT_COLLAPSE_CONTENT_SOCIAL_NETWORK_INVITE_FRIENDS;
        [self.view layoutIfNeeded];
        _listFriendsFacebookTableView.hidden = NO;
    }];
    
    UserSession *userSession = [UserSession currentSession];
    [FBRequestConnection startForMeWithCompletionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error)
     {
         BOOL needUpdateFacebookInfo = NO;
         NSString *facebookID = [result objectForKey:KEY_ID];
         NSString *facebookToken = [FBSession activeSession].accessTokenData.accessToken;
         
         NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
         NSString *token = userSession.sessionToken;
         [parameters setObject:token forKey:KEY_TOKEN_PARAM];
         
         if (![userSession.facebookID isEqualToString:facebookID] || ![userSession.facebookToken isEqualToString:facebookToken]) {
             [parameters setObject:facebookID forKey:KEY_FACEBOOK_ID];
             [parameters setObject:facebookToken forKey:KEY_FACEBOOK_TOKEN];
             [UserSession updateFacebookInfoWithFaceBookID:facebookID facebookToken:facebookToken];
             needUpdateFacebookInfo = YES;
         }
         if (needUpdateFacebookInfo) {
             [_baseModel postUserUpdateEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
                 if (!error) {
                     NSLog(@"Success = %@",responseObject);
                 }else {
                     NSLog(@"Error = %@", error);
                 }
             }];
         }
     }];
    
    [_userFriendFoundArray removeAllObjects];
    [[FBRequest requestForGraphPath:URL_FACEBOOK_GRAPH_FRIENDS_INSTALLED]
     startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary *result,
       NSError *error) {
         
         //if result, no errors
         if (!error && result) {
             NSLog(@"%@",result);
             //result dictionary in key "data"
             NSArray *allFriendsList = [result objectForKey:KEY_DATA];
             if ([allFriendsList count] > 0) {
                 // Loop
                 for (NSDictionary *aFriendData in allFriendsList) {
                     // Friend installed app?
                     if ([aFriendData objectForKey:KEY_INSTALLED]) {
                         [_userFriendFoundArray addObject: [aFriendData objectForKey:KEY_ID]];
                     }
                 }
             }
             if (_userFriendFoundArray.count > 0) {
                 [self getListFriendsFacebookWithUsersFriendID:_userFriendFoundArray];
             }
         }else {
             NSLog(@"%@",error);
         }
     }];
}

- (void)getListFriendsFacebookWithUsersFriendID:(NSArray *)usersFriendID {
    [_hudFacebook show:YES];
    UserSession *userSesstion = [UserSession currentSession];
    NSDictionary *parameters = @{KEY_TOKEN_PARAM:userSesstion.sessionToken, KEY_ID_SOCIAL:usersFriendID, KEY_TYPE: FACEBOOK_TYPE};
    [_baseModel getSocialFriendWithParameters:parameters completion:^(id responseObject, NSError *error){
        if (!error) {
            NSLog(@"%@",responseObject);
            _arrayListFriendsFacebook = [self removeCurrentUserLoginFromArray:[NSMutableArray arrayWithArray:[FollowObject followObjectsWith:responseObject]]];
            _arrayListSearchFriendsFacebook = [_arrayListFriendsFacebook mutableCopy];
            [self.listFriendsFacebookTableView reloadData];
            [_hudFacebook hide:YES];
        }else {
            NSLog(@"Error: %@", error);
            [_hudFacebook hide:YES];
        }
    }];
}

- (void)didLogoutFromFacebook {
    NSLog(@"Session Facebook closed");
    [_arrayListFriendsFacebook removeAllObjects];
    [_arrayListSearchFriendsFacebook removeAllObjects];
    _connectToFacebookTitleLabel.text = TEXT_CONNECT_TO_FACEBOOK;
    [FBSession.activeSession closeAndClearTokenInformation];
    [UIView animateWithDuration:TIME_EXPAND_COLLAPSE_VIEW_INVITE_FRIENDS animations:^{
        _heightContentFacebookViewContraint.constant = CONSTRAINT_HEIGHT_EXPAND_CONTENT_SOCIAL_NETWORK_INVITE_FRIENDS;
        [self.view layoutIfNeeded];
        _listFriendsFacebookTableView.hidden = YES;
    }];
}

#pragma mark - Twitter management

- (void)loginTwitter {
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        if (success) {
            [self didConnectFromTwitter];
        }

    }];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (void)logoutTwitter {
    [[FHSTwitterEngine sharedEngine]clearAccessToken];
    [self didDisconnectToTwitter];
}

- (void)checkStateConnectTwitter {
    //connect tw
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:TWITTER_CONSUMER_KEY andSecret:TWITTER_CONSUMER_SECRET];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    if ([[FHSTwitterEngine sharedEngine] isAuthorized]) {
        [self didConnectFromTwitter];
    }else{
        [self didDisconnectToTwitter];
    }
}

- (void)didConnectFromTwitter {
    [self getListFriendsTwitterFromServer];
    [UIView animateWithDuration:TIME_EXPAND_COLLAPSE_VIEW_INVITE_FRIENDS animations:^{
        _connectToTwitterTitleLabel.text = TEXT_DISCONNECT_TO_TWITTER;
        _heightContentTwitterViewContraint.constant = CONSTRAINT_HEIGHT_COLLAPSE_CONTENT_SOCIAL_NETWORK_INVITE_FRIENDS;
        [self.view layoutIfNeeded];
        _listFriendsTwitterTableView.hidden = NO;
    }];
    NSString *twitterID = [FHSTwitterEngine sharedEngine].authenticatedID;
    NSString *twitterToken = [FHSTwitterEngine sharedEngine].accessToken.secret;
    
    UserSession *userSession = [UserSession currentSession];
    BOOL needUpdateFacebookInfo = NO;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *token = userSession.sessionToken;
    [parameters setObject:token forKey:KEY_TOKEN_PARAM];
    if (![userSession.twitterID isEqualToString:twitterID] || ![userSession.twitterToken isEqualToString:twitterToken]) {
        [parameters setObject:twitterID forKey:KEY_TWITTER_ID];
        [parameters setObject:twitterToken forKey:KEY_TWITTER_TOKEN];
        [UserSession updateTwitterInfoWithTwitterID:twitterID twitterToken:twitterToken];
        needUpdateFacebookInfo = YES;
    }
    if (needUpdateFacebookInfo) {
        [_baseModel postUserUpdateEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
            if (!error) {
                NSLog(@"Success = %@",responseObject);
            }else {
                NSLog(@"Error = %@", error);
            }
        }];
    }
}

- (void)didDisconnectToTwitter {
    [_arrayListFriendsTwitter removeAllObjects];
    [_arrayListSearchFriendsTwitter removeAllObjects];
    [UIView animateWithDuration:TIME_EXPAND_COLLAPSE_VIEW_INVITE_FRIENDS animations:^{
        _connectToTwitterTitleLabel.text = TEXT_CONNECT_TO_TWITTER;
        _heightContentTwitterViewContraint.constant = CONSTRAINT_HEIGHT_EXPAND_CONTENT_SOCIAL_NETWORK_INVITE_FRIENDS;
        [self.view layoutIfNeeded];
        _listFriendsTwitterTableView.hidden = YES;
    }];
}

- (void)getListFriendsTwitterFromServer {
    [_hudTwitter show:YES];
    _arrayTwitterIDFriends = [[NSMutableArray alloc] init];
    NSDictionary *listFriendTwitterDict = [[FHSTwitterEngine sharedEngine] getFriendsIDs];
    NSLog(@"%@",listFriendTwitterDict);
    _arrayTwitterIDFriends = [listFriendTwitterDict objectForKey:KEY_IDS];
    
    UserSession *userSesstion = [UserSession currentSession];
    NSDictionary *parameters = @{KEY_TOKEN_PARAM:userSesstion.sessionToken, KEY_ID_SOCIAL:_arrayTwitterIDFriends, KEY_TYPE: TWITTER_TYPE};
    [_baseModel getSocialFriendWithParameters:parameters completion:^(id responseObject, NSError *error){
        if (!error) {
            NSLog(@"%@",responseObject);
            _arrayListFriendsTwitter = [self removeCurrentUserLoginFromArray:[NSMutableArray arrayWithArray:[FollowObject followObjectsWith:responseObject]]];
            _arrayListSearchFriendsTwitter = [_arrayListFriendsTwitter mutableCopy];
            [self.listFriendsTwitterTableView reloadData];
            [_hudTwitter hide:YES];
        }else {
            NSLog(@"Error: %@", error);
            [_hudTwitter hide:YES];
        }
    }];
}

#pragma mark - Alert
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

#pragma mark - TableView delegate & datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CELL_TABLE_VIEW_SEARCH_USERS_FRIENDS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if (tableView == _listFriendsFacebookTableView) {
        result = _arrayListSearchFriendsFacebook.count;
    }else if (tableView == _listFriendsTwitterTableView) {
        result = _arrayListSearchFriendsTwitter.count;
    }else if (_currentTableView == _listFriendsFacebookTableView) {
        result = _arrayListSearchFriendsFacebook.count;
    }else if (_currentTableView == _listFriendsTwitterTableView) {
        result = _arrayListSearchFriendsTwitter.count;
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrayListSearchFriends;
    NSString *cellIdentifierForTableView = @"";
    if (tableView == _listFriendsFacebookTableView) {
        arrayListSearchFriends = [NSArray arrayWithArray:_arrayListSearchFriendsFacebook];
        cellIdentifierForTableView = IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL_FOR_FACEBOOK_TABLE_VIEW;
    }else if (tableView == _listFriendsTwitterTableView) {
        arrayListSearchFriends = [NSArray arrayWithArray:_arrayListSearchFriendsTwitter];
        cellIdentifierForTableView = IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL_FOR_TWITTER_TABLE_VIEW;
    }else if (_currentTableView == _listFriendsFacebookTableView) {
        arrayListSearchFriends = [NSArray arrayWithArray:_arrayListSearchFriendsFacebook];
        cellIdentifierForTableView = IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL_FOR_FACEBOOK_TABLE_VIEW;
    }else if (_currentTableView == _listFriendsTwitterTableView) {
        arrayListSearchFriends = [NSArray arrayWithArray:_arrayListSearchFriendsTwitter];
        cellIdentifierForTableView = IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL_FOR_TWITTER_TABLE_VIEW;
    }
    
    ListFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL];
    if (cell == nil) {
        cell = [[ListFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL];
    }
    
    [cell.buttonFollow setTitle:NSLocalizedString(TEXT_FOLLOW_PUBLIC_PROFILE_VIEW, nil) forState:UIControlStateNormal];
    cell.buttonFollow.backgroundColor = [UIColor pureCyanColor];
    
    FollowObject *followObject = [arrayListSearchFriends objectAtIndex:indexPath.row];
    cell.labelUsername.text = followObject.nickname;
    [self setAvatarForImage:cell.imageUserFriends withUserID:followObject.user_id];
    for (FollowObject *followObj in _arrayListFollowingMe) {
        if ([followObj.user_id isEqualToString:followObject.user_id]) {
            [cell.buttonFollow setTitle:NSLocalizedString(TEXT_UNFOLLOWED_PUBLIC_PROFILE_VIEW, nil) forState:UIControlStateNormal];
            cell.buttonFollow.backgroundColor = [UIColor grayColor];
        }
    }
    
    [cell setDelegate:self];
    cell.cellIdentifierForTableView = cellIdentifierForTableView;
    [cell.buttonFollow setTag:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSession *userSession = [UserSession currentSession];
    
    NSArray *arrayListSearchFriends;
    if (tableView == _listFriendsFacebookTableView) {
        arrayListSearchFriends = [NSArray arrayWithArray:_arrayListSearchFriendsFacebook];
    }
    if(tableView == _listFriendsTwitterTableView) {
        arrayListSearchFriends = [NSArray arrayWithArray:_arrayListSearchFriendsTwitter];
    }
    FollowObject *followObject = [arrayListSearchFriends objectAtIndex:indexPath.row];
    NSDictionary *parameters = @{KEY_TOKEN_PARAM:userSession.sessionToken, KEY_END_PARAM:@0,KEY_COUNT:@NUMBER_MAX_DATA_DOWNLOAD, KEY_USER_ID:followObject.user_id};
    
    PublicProfileViewController *publicProfileViewControllerForUser = [[PublicProfileViewController alloc]init];
    [publicProfileViewControllerForUser setUsername:followObject.nickname];
    [publicProfileViewControllerForUser setUserId:followObject.user_id];
    [publicProfileViewControllerForUser setDicParamPublic:parameters];
    [self.navigationController pushViewController:publicProfileViewControllerForUser animated:YES];
}

#pragma mark - Search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    if (searchBar == _searchFriendsFacebookSearchBar) {
        _arrayListSearchFriendsFacebook = [_arrayListFriendsFacebook mutableCopy];
        [_listFriendsFacebookTableView reloadData];
    }
    if (searchBar == _searchFriendsTwitterSearchBar) {
        _arrayListSearchFriendsTwitter = [_arrayListFriendsTwitter mutableCopy];
        [_listFriendsTwitterTableView reloadData];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (controller == _facebookSearchDisplayController) {
        if (searchString.length == 0) {
            _arrayListSearchFriendsFacebook = [_arrayListFriendsFacebook mutableCopy];
            [_listFriendsFacebookTableView reloadData];
        }else{
            [_arrayListSearchFriendsFacebook removeAllObjects];
            for (FollowObject *obj in _arrayListFriendsFacebook) {
                if ([obj.nickname hasPrefix:searchString]) {
                    [_arrayListSearchFriendsFacebook addObject:obj];
                }
            }
            [_listFriendsFacebookTableView reloadData];
        }
    }
    
    if (controller == _twitterSearchDisplayController) {
        if (searchString.length == 0) {
            _arrayListSearchFriendsTwitter = [_arrayListFriendsTwitter mutableCopy];
            [_listFriendsTwitterTableView reloadData];
        }else{
            [_arrayListSearchFriendsTwitter removeAllObjects];
            for (FollowObject *obj in _arrayListFriendsTwitter) {
                if ([obj.nickname hasPrefix:searchString]) {
                    [_arrayListSearchFriendsTwitter addObject:obj];
                }
            }
            [_listFriendsTwitterTableView reloadData];
        }
    }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return YES;
}

#pragma mark - ListFriendsTableViewCell delegate

- (void)clickedButtonFollow:(ListFriendsTableViewCell *)listFriendsTableViewCell buttonFollow:(UIButton *)btnFollow {
    FollowObject *dict;
    BOOL isUpdateForFacebookTable = YES;
    if ([listFriendsTableViewCell.cellIdentifierForTableView isEqualToString:IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL_FOR_FACEBOOK_TABLE_VIEW] && _hudFacebook.isHidden) {
        dict = [_arrayListFriendsFacebook objectAtIndex:btnFollow.tag];
        [_hudFacebook show:YES];
        isUpdateForFacebookTable = YES;
    }else if ([listFriendsTableViewCell.cellIdentifierForTableView isEqualToString:IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL_FOR_TWITTER_TABLE_VIEW] && _hudTwitter.isHidden) {
        dict = [_arrayListFriendsTwitter objectAtIndex:btnFollow.tag];
        [_hudTwitter show:YES];
        isUpdateForFacebookTable = NO;
    }
    if (dict) {
        NSDictionary *parameters = @{KEY_TOKEN_PARAM: [UserSession currentSession].sessionToken,
                                     KEY_TOU_ID:dict.user_id};
        [_baseModel getFollowEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
            if (!error) {
                NSLog(@"Success = %@", responseObject);
                [self updateButtonFollow:btnFollow];
                [self getFollowingMe];
                (isUpdateForFacebookTable)?[_hudFacebook hide:YES]:[_hudTwitter hide:YES];
            }else {
                NSLog(@"Error = %@", error);
                (isUpdateForFacebookTable)?[_hudFacebook hide:YES]:[_hudTwitter hide:YES];
            }
        }];
    }
}

- (void)updateButtonFollow:(UIButton *)btnFollow{
    if ([btnFollow.titleLabel.text isEqualToString:NSLocalizedString(TEXT_FOLLOW_PUBLIC_PROFILE_VIEW, nil)]) {
        [btnFollow setTitle:NSLocalizedString(TEXT_UNFOLLOWED_PUBLIC_PROFILE_VIEW, nil) forState:UIControlStateNormal];
        btnFollow.backgroundColor = [UIColor grayColor];
    }else{
        [btnFollow setTitle:NSLocalizedString(TEXT_FOLLOW_PUBLIC_PROFILE_VIEW, nil) forState:UIControlStateNormal];
        btnFollow.backgroundColor = [UIColor pureCyanColor];
    }
}

- (void)getFollowingMe {
    NSDictionary * parameters = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken,
                                   KEY_USER_ID:[UserSession currentSession].userId};
    [_baseModel getFollowingEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
        if (!error) {
            _arrayListFollowingMe = [NSMutableArray arrayWithArray:[FollowObject followObjectsWith:responseObject]];
            [self.listFriendsFacebookTableView reloadData];
            [self.listFriendsTwitterTableView reloadData];
        }else {
            NSLog(@"error = %@",error);
        }
    }];
}

@end
