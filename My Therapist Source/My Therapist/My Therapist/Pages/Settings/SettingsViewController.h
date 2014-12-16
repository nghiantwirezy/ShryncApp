//
//  SettingsViewController.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RevealMenuViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookManager.h"
#import "FHSTwitterEngine.h"

@interface SettingsViewController : UIViewController<UINavigationBarDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,FHSTwitterEngineAccessTokenDelegate>

@property (nonatomic, assign) BOOL isStreaming;
@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (nonatomic, strong) FacebookManager *facebookManager;
@property (weak, nonatomic) IBOutlet UITableView *tableviewContent;
@property (weak, nonatomic) IBOutlet UIButton *deleteAccountButton;
//profile
@property (weak, nonatomic) IBOutlet UIView *subviewProfile;
@property (weak, nonatomic) IBOutlet UISwitch *switchProfilePublicButton;
@property (weak, nonatomic) IBOutlet UISwitch *switchCheckinPublicButton;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *signoutButton;
@property (weak, nonatomic) IBOutlet UILabel *checkinPublicLabel;
@property (weak, nonatomic) IBOutlet UILabel *profilePublicLabel;
//share
@property (weak, nonatomic) IBOutlet UIView *subviewShare;
@property (weak, nonatomic) IBOutlet UIButton *shareTwitterButton;
@property (weak, nonatomic) IBOutlet UIButton *shareFacebookButton;
@property (weak, nonatomic) IBOutlet UIButton *shryncShareButton;
@property (weak, nonatomic) IBOutlet UILabel *facebookShareLabel;
@property (weak, nonatomic) IBOutlet UILabel *facebookConnectLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterShareLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterConnectLabel;
//friends
@property (weak, nonatomic) IBOutlet UIView *subviewFriends;
@property (weak, nonatomic) IBOutlet UIButton *findFriendsButton;
//feedback support
@property (weak, nonatomic) IBOutlet UIView *subviewSpFeedback;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *supportButtonAction;
//subview rate
@property (weak, nonatomic) IBOutlet UIView *subviewRate;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
//info
@property (weak, nonatomic) IBOutlet UIView *subviewInformation;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *versionAppButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;
@property (weak, nonatomic) IBOutlet UIButton *termsofuseButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
//help label
@property (weak, nonatomic) IBOutlet UILabel *helpShareShryncLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpConnectFbLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpConnectTwLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpEditProfile;
@property (weak, nonatomic) IBOutlet UILabel *helpCheckinsPublicLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpProfilePublicLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpRateLabel;

- (IBAction)deleteAccountButtonAction:(id)sender;
- (IBAction)EditProfileButtonAction:(id)sender;
- (IBAction)signoutButtonAction:(id)sender;
- (IBAction)switchProfilePublicButtonAction:(id)sender;
- (IBAction)switchCheckinPublicButtonAction:(id)sender;
- (IBAction)shareTwitterButtonAction:(id)sender;
- (IBAction)shareFacebookButtonAction:(id)sender;
- (IBAction)shryncShareButtonAction:(id)sender;
- (IBAction)findFriendsButtonAction:(id)sender;
- (IBAction)feedbackButtonAction:(id)sender;
- (IBAction)supportButtonAction:(id)sender;
- (IBAction)rateButtonAction:(id)sender;
- (IBAction)privacyButtonAction:(id)sender;
- (IBAction)termsofuseButtonAction:(id)sender;
- (IBAction)aboutButtonAction:(id)sender;
- (void)resetEditStates;

@end
