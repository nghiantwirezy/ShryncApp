//
//  PublicProfileViewController.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileView.h"
#import "FollowerTableViewController.h"
#import "FollowingTableViewController.h"
#import "AppDelegate.h"
#import "UserSession.h"
#import "ContainedWebViewController.h"
#import "RevealMenuViewController.h"
#import "SettingsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "ProfileViewController.h"
#import "FeelingRecord.h"
#import "FeelingRecordLoader.h"
#import "FeelingSummarySectionHeaderView.h"
#import "FeelingSummaryCell.h"
#import "FeelingSummaryFirstRowCell.h"
#import "UserInfoCell.h"
#import "PublicFeelingRecordLoader.h"
#import "MyTherapyViewController.h"
#import "FeelingTextCell.h"
#import "ImageAttachmentCell.h"
#import "HugCell.h"
#import "NSString+HeightForFontAndWidth.h"
#import "AttachmentFullscreenViewController.h"
#import "DetailCommentsViewController.h"
#import "CommentObject.h"
#import "BaseServices.h"
#import "HowDoYouFeelViewController.h"
#import "TimeHelper.h"
#import "AvatarHelper.h"
#import "FollowerTableViewController.h"
#import "FollowingTableViewController.h"
#import "FollowObject.h"
#import "UIColor+ColorUtilities.h"

@class FeelingRecord, FeelingRecordLoader, MBProgressHUD;

@interface PublicProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UserProfileViewDelegate, FollowerTableViewControllerDelegate, FollowingTableViewControllerDelegate, UserProfileViewDelegate, UserInforDelegate,FeelingSummeryDelegate,TextCommentDelegate,HugDelegate,ImageDelegate> {
    NSMutableArray *_feelingRecords;
    NSLayoutConstraint *_headerHeightConstraint;
    NSMutableArray *_arrayListFollower;
    NSMutableArray *_arrayListFollowing;
    NSMutableArray *_arrayListFollowingMe;
    UserProfileView *_userProfileViewForCheckins, *_userProfileViewForFollower, *_userProfileViewForFollowing;
    BaseModel *_baseModel;
    CGPoint currentContentOffsetTableView;
    BOOL allowToClickHugLike;
}

@property (readonly, nonatomic) FeelingRecordLoader *feelingRecordLoader;
@property (readonly, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *followsButton;
@property (weak, nonatomic) IBOutlet UIView *contentview;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIView *checkinsView;
@property (weak, nonatomic) IBOutlet UIView *followersView;
@property (weak, nonatomic) IBOutlet UIView *followingsView;

@property (nonatomic, retain) NSDictionary *dicParamPublic;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userBiograyphy;
@property (strong, nonatomic) NSString *like;
@property (strong, nonatomic) NSString *hug;
@property (strong, nonatomic) NSArray *huggers;
@property (strong, nonatomic) NSArray *likers;
@property (strong, nonatomic) NSNumber *currentIndexPath;
@property (strong, nonatomic) NSMutableArray *arrayHugDetails;
@property (strong, nonatomic) NSMutableArray *arrayLikeDetails;
@property (strong, nonatomic) NSMutableArray *arrayCommentDetails;
@property (assign, nonatomic) CGFloat heightProfileView;

- (void)setFeelingRecords:(NSArray *)feelingRecords hasMore:(BOOL)hasMore;
- (void)addFeelingRecord:(FeelingRecord *)feelingRecord;
- (void)deleteFeelingRecord:(FeelingRecord *)feelingRecord;
- (void)toggledPublicForFeelingRecord:(FeelingRecord *)record;
- (void)setRefreshOnce:(BOOL)refreshOnce;
- (void)loadMoreDataIfNeededFromIndexPath:(NSIndexPath *)indexPath;
- (void)refresh;
- (void)refreshDone;

@end
