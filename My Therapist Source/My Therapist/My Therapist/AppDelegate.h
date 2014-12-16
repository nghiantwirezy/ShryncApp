//
//  AppDelegate.h
//  My Therapist
//
//  Created by Yexiong Feng on 1/8/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrittercismDelegate.h"
#import "Crittercism.h"
#import "HowDoYouFeelTouchView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Flurry.h"

@class SignInViewController, PPRevealSideViewController, MyTherapyViewController, ImageAreaSelectionViewController, HowDoYouFeelViewController, ContainedWebViewController, ProfileViewController, AttachmentFullscreenViewController, MyFeelingsViewController, TextTherapiesViewController, AudioPlayerViewController, ReferralFinder, PublicFeelingsViewController,SettingsViewController,DetailMapView,CommentDetailViewController,InviteFriendsViewController,DetailCommentsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CrittercismDelegate, UINavigationControllerDelegate>{
    HowDoYouFeelTouchView *_howDoYouFeelTouchView;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) UIImage *lightGreenImage, *darkGreenImage, *whiteImage;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIBarButtonItem *revealMenuButtonItem;
@property (strong, nonatomic) UIViewController *revealMenuViewController, *mainViewController, *signUpViewController, *addCommentViewController, *activitySelectionViewController;

@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
@property (strong, nonatomic) SignInViewController *signInViewController;

@property (strong, nonatomic) PublicFeelingsViewController *publicFeelingsViewController;
@property (strong, nonatomic) HowDoYouFeelViewController *howDoYouFeelViewController;
@property (strong, nonatomic) MyFeelingsViewController *myFeelingsViewController;
@property (strong, nonatomic) AudioPlayerViewController *audioPlayerViewController;
@property (strong, nonatomic) TextTherapiesViewController *textTherapiesViewController;
@property (strong, nonatomic) ReferralFinder *referralFinder;
@property (strong, nonatomic) ProfileViewController *profileViewController;
@property (strong, nonatomic) InviteFriendsViewController *inviteFriendsViewController;
@property (strong, nonatomic) SettingsViewController *settingsViewController;
@property (strong, nonatomic) ContainedWebViewController *privacyTextView, *termTextView, *aboutTextView;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)showRevealMenu;
- (void)navigateToLandingPage;
- (void)resetViewControllers;
// Facebook
- (void)sessionFaceBookStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end
