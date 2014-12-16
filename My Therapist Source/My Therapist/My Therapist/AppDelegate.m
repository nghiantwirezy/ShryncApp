//
//  AppDelegate.m
//  My Therapist
//
//  Created by Yexiong Feng on 1/8/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "AppDelegate.h"
#import "UserSession.h"
#import "UIImage+ImageWithColor.h"
#import "FacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>

#import "PPRevealSideViewController.h"
#import "RevealMenuViewController.h"
#import "MainViewController.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "HowDoYouFeelViewController.h"
#import "AddCommentViewController.h"
#import "ActivitySelectionViewController.h"
#import "MyTherapyViewController.h"
#import "ImageAreaSelectionViewController.h"
#import "ContainedWebViewController.h"
#import "ProfileViewController.h"
#import "ATConnect.h"
#import "AttachmentFullscreenViewController.h"
#import "MyFeelingsViewController.h"
#import "MBProgressHUD.h"
#import "FeelingRecordLoader.h"
#import "TextTherapiesViewController.h"
#import "AudioPlayerViewController.h"
#import "ReferralFinder.h"
#import "PublicFeelingsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SettingsViewController.h"
#import "DetailMapView.h"
#import "InviteFriendsViewController.h"
#import "DetailCommentsViewController.h"

#define GET_USER_ENDPOINT @"https://secure.shrync.com/api/user/get"
#define TOKEN_PARAM @"token"

#define APPTENTIVE_KEY @"755ffd82a9d2102d601fe3fde7902ded3e7f078d6bae48e391206372ebc94268"
#define APPTENTIVE_APP_ID @"870117197"
#define PRIVACY_TITLE @"Privacy Policy"
#define PRIVACY_URL @"http://www.shrync.com/privacy.html"

#define TERM_TITLE @"Terms of Use"
#define TERM_URL @"http://www.shrync.com/terms.html"

#define ABOUT_TITLE @"About My Therapist"
#define ABOUT_URL @"http://www.shrync.com/about.html"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)showRevealMenu
{
    [self.revealSideViewController pushViewController:self.revealMenuViewController onDirection:PPRevealSideDirectionLeft animated:YES];
}

- (void)navigateToLandingPage
{
    if ([UserSession currentSession] == nil) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.navigationController setViewControllers:[NSArray arrayWithObject:self.mainViewController] animated:YES];
        [self.revealSideViewController popViewControllerAnimated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController setViewControllers:[NSArray arrayWithObject:self.publicFeelingsViewController] animated:YES];
        [self.revealSideViewController popViewControllerAnimated:YES];
    }
}

- (void)resetViewControllers
{
    [self.howDoYouFeelViewController resetButtonAction];
}

- (void)addSwipeGestureWithObjects:(NSArray *)objects{
    for (UIViewController *object in objects) {
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showRevealMenu)];
        swipeRight.numberOfTouchesRequired = 1;
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [object.view addGestureRecognizer:swipeRight];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [Flurry setDebugLogEnabled:YES];
    [Flurry startSession :@"XD98BQZFDFMS2BPM9VT8"];
    [Flurry logEvent:@"Entered app"];

//    [Crittercism enableWithAppID:@"543e505483fb794a8c000001"];
//    [Crittercism beginTransaction:@"App Start"];
//    [Crittercism setMaxOfflineCrashReports:5];

    
    [ATConnect sharedConnection].apiKey = APPTENTIVE_KEY;
    [ATConnect sharedConnection].appID = APPTENTIVE_APP_ID;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.lightGreenImage = [UIImage imageWithColor:[UIColor colorWithRed:109.0 / 255 green:162.0 / 255 blue:171.0 / 255 alpha:1]];
    self.darkGreenImage = [UIImage imageWithColor:[UIColor colorWithRed:64.0 / 255 green:126.0 / 255 blue:137.0 / 255 alpha:1]];
    self.whiteImage = [UIImage imageWithColor:[UIColor whiteColor]];
    
    self.privacyTextView = [[ContainedWebViewController alloc] init];
    [_privacyTextView setUrl:PRIVACY_URL title:NSLocalizedString(PRIVACY_TITLE, nil)];
    
    self.termTextView = [[ContainedWebViewController alloc] init];
    [_termTextView setUrl:TERM_URL title:NSLocalizedString(TERM_TITLE, nil)];
    
    self.aboutTextView = [[ContainedWebViewController alloc] init];
    [_aboutTextView setUrl:ABOUT_URL title:NSLocalizedString(ABOUT_TITLE, nil)];
    
    self.profileViewController = [[ProfileViewController alloc] init];
    self.mainViewController = [[MainViewController alloc] init];
    self.signInViewController = [[SignInViewController alloc] init];
    self.signUpViewController = [[SignUpViewController alloc] init];
    self.howDoYouFeelViewController = [[HowDoYouFeelViewController alloc] init];
    self.addCommentViewController = [[AddCommentViewController alloc] init];
    self.myFeelingsViewController = [[MyFeelingsViewController alloc] init];
    self.textTherapiesViewController = [[TextTherapiesViewController alloc] init];
    self.audioPlayerViewController = [[AudioPlayerViewController alloc] init];
    self.publicFeelingsViewController = [[PublicFeelingsViewController alloc] init];
    self.revealMenuViewController = [[RevealMenuViewController alloc] init];
    self.settingsViewController = [[SettingsViewController alloc] init];
    
    self.activitySelectionViewController = [[ActivitySelectionViewController alloc] init];
    self.inviteFriendsViewController = [[InviteFriendsViewController alloc]init];
    
    if ([UserSession currentSession] != nil) {
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.publicFeelingsViewController];
        NSLog(@"User token: %@", [UserSession currentSession].sessionToken);
    } else {
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    }
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.delegate = self;
    
    self.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:self.navigationController];
    self.revealSideViewController.panInteractionsWhenClosed = PPRevealSideInteractionNone;
    
    UIImage *revealMenuImage = [UIImage imageNamed:IMAGE_NAME_REVEAL_MENU_BUTTON];
    UIButton *revealMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, revealMenuImage.size.width, revealMenuImage.size.height)];
    [revealMenuButton setBackgroundImage:revealMenuImage forState:UIControlStateNormal];
    [revealMenuButton addTarget:self action:@selector(showRevealMenu) forControlEvents:UIControlEventTouchUpInside];
    self.revealMenuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:revealMenuButton];
    
    self.referralFinder = [[ReferralFinder alloc] init];
    
    [self addSwipeGestureWithObjects:[NSArray arrayWithObjects:
                                      _publicFeelingsViewController,
                                      _howDoYouFeelViewController,
                                      _myFeelingsViewController,
                                      _audioPlayerViewController,
                                      _textTherapiesViewController,
                                      _profileViewController,
                                      _settingsViewController,
                                      _inviteFriendsViewController, nil]];
    
    self.window.rootViewController = self.revealSideViewController;
    
    [self.window makeKeyAndVisible];
    
    [self.myFeelingsViewController setRefreshOnce:YES];
    [self.publicFeelingsViewController setRefreshOnce:YES];
    
    _howDoYouFeelTouchView = [[HowDoYouFeelTouchView alloc]initWithFrame:CGRectZero];
    [self.window addSubview:_howDoYouFeelTouchView];
    
    if ([UserSession currentSession].sessionToken.length > 0) {
        NSDictionary *param = @{TOKEN_PARAM: [UserSession currentSession].sessionToken};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:GET_USER_ENDPOINT parameters:param
             success:nil
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self tokenExpired];
             }];
    }
    
//    //ios 7
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        [FBSession openActiveSessionWithReadPermissions:FACEBOOK_PERMISSIONS
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self sessionFaceBookStateChanged:session state:state error:error];
                                      }];
    }
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    //    [UIApplication sharedApplication].applicationIconBadgeNumber ++;
    
    NSString * string = [NSString stringWithFormat:@"%@",deviceToken];
    string=[string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string=[string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    string=[string stringByReplacingOccurrencesOfString:@">" withString:@""];
//    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"DEVICE_TOKEN"];
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"DEVICE_TOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"DEVICE_TOKEN %@",string);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"DEVICE_TOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showExpiredMessage
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SignInViewController *signInViewController = delegate.signInViewController;
    MBProgressHUD *hud = signInViewController.hud;
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no.png"]];
    hud.labelText = @"Please login again!";
    [hud show:YES];
    [hud hide:YES afterDelay:2.0];
}

- (void)tokenExpired
{
    [UserSession signOut];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate navigateToLandingPage];
    
    [self performSelector:@selector(showExpiredMessage) withObject:nil afterDelay:2];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [Flurry pauseBackgroundSession];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    [Crittercism endTransaction:@"App Continue"];
//    [Crittercism endTransaction:@"App Start"];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
//    [Crittercism endTransaction:@"App Continue"];
//    [Crittercism endTransaction:@"App Start"];

    [self saveContext];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Pass on
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:nil];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"userInfo %@",userInfo);
    for (id key in userInfo)
    {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    int badgeReceived = [[aps objectForKey:@"badge"] intValue];
    NSString *message = [aps objectForKey:@"alert"];
    
    // Check if in background
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSLog(@"%d",(int)application.applicationIconBadgeNumber);
        application.applicationIconBadgeNumber = 0;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shrync feeling..."
                                                        message:[NSString stringWithFormat:@"%@", message]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        int value = (int)[UIApplication sharedApplication].applicationIconBadgeNumber;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:value + badgeReceived];
    }
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"My_Therapist" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"My_Therapist.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [Crittercism beginTransaction:@"App Continue"];
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:self.session];
    
    // You can add your app-specific url handling code here if needed
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark- CrittercismSDK delegate

- (void)crittercismDidCrashOnLastLoad{
    [Crittercism logError:[NSError errorWithDomain:@"BHTech Mobile" code:501 userInfo:@{NSLocalizedDescriptionKey:@"App crash"}]];
}

#pragma mark - UINavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *viewsNeedHidePlusButton = @[self.signInViewController, self.signUpViewController, self.mainViewController, self.howDoYouFeelViewController, self.addCommentViewController,];
    
    BOOL needHidePlusButton = NO;
    for (UIViewController *viewNeedHidePlusButton in viewsNeedHidePlusButton) {
        if ([viewNeedHidePlusButton isEqual:viewController]) {
            needHidePlusButton = YES;
            break;
        }
    }
    _howDoYouFeelTouchView.hidden = needHidePlusButton;
}

#pragma mark - Facebook management
// Facebook management
- (void)sessionFaceBookStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    if (!error && state == FBSessionStateOpen){
        // If the session was opened successfully
        NSLog(@"Session Facebook opened");
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session Facebook closed");
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
            [AppDelegate showSingleAlert:alertView];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil];
                [AppDelegate showSingleAlert:alertView];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil];
                [AppDelegate showSingleAlert:alertView];            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
    }
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

@end
