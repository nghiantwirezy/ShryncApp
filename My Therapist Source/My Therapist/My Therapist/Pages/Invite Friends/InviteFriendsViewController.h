//
//  InviteFriendsViewController.h
//  Copyright (c) 2014 Shrync. All rights reserved.

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BaseModel.h"
#import "ListFriendsTableViewCell.h"
#import "FHSTwitterEngine.h"
#import "MBProgressHUD.h"

@interface InviteFriendsViewController : UIViewController <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate, ListFriendsTableViewCellDelegate, FHSTwitterEngineAccessTokenDelegate> {
//    NSMutableArray *_arrayListFriends;
    BaseModel *_baseModel;
    NSCache *_avatarCache;
    UISearchDisplayController *_facebookSearchDisplayController;
    UISearchDisplayController *_twitterSearchDisplayController;
    NSMutableArray *_arrayListFollowingMe;
    NSMutableArray *_arrayTwitterIDFriends;
    UITableView *_currentTableView;
    
    MBProgressHUD *_hudTwitter;
    MBProgressHUD *_hudFacebook;
}

@property (weak, nonatomic) IBOutlet UIButton *facebookInviteButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterInviteButton;
@property (weak, nonatomic) IBOutlet UIButton *searchInviteButton;

@property (weak, nonatomic) IBOutlet UIView *twitterContentView;
@property (weak, nonatomic) IBOutlet UILabel *connectTwitterLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectTwitterButton;

@property (weak, nonatomic) IBOutlet UIView *facebookContentView;
@property (weak, nonatomic) IBOutlet UILabel *connectFacebookLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectFacebookButton;

@property (weak, nonatomic) IBOutlet UIView *searchContentView;
@property (weak, nonatomic) IBOutlet UIButton *searchUsersButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteTextButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteEmailButton;
@property (weak, nonatomic) IBOutlet UILabel *connectToFacebookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectToTwitterTitleLabel;

@property (strong, nonatomic) NSMutableArray *arrayListFriendsFacebook;
@property (strong, nonatomic) NSMutableArray *arrayListSearchFriendsFacebook;
@property (strong, nonatomic) NSMutableArray *arrayListFriendsTwitter;
@property (strong, nonatomic) NSMutableArray *arrayListSearchFriendsTwitter;
@property (weak, nonatomic) IBOutlet UITableView *listFriendsFacebookTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchFriendsFacebookSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *listFriendsTwitterTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchFriendsTwitterSearchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContentTwitterViewContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContentFacebookViewContraint;
@property (strong, nonatomic) NSMutableArray *userFriendFoundArray;

- (IBAction)facebookInviteButtonAction:(id)sender;
- (IBAction)twitterInviteButtonAction:(id)sender;
- (IBAction)searchInviteButtonAction:(id)sender;

- (IBAction)connectTwitterButtonAction:(id)sender;
- (IBAction)connectFacebookButtonAction:(id)sender;
- (IBAction)searchUsersButtonAction:(id)sender;

- (IBAction)inviteTextButtonAction:(id)sender;
- (IBAction)inviteEmailButtonAction:(id)sender;
- (IBAction)tapViewAction:(id)sender;

@end
