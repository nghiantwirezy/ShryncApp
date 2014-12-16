//
//  MyFeelingsViewController.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileView.h"
#import "HeaderView.h"
#import "FeelingRecordLoader.h"
#import "FeelingSummarySectionHeaderView.h"
#import "FeelingSummaryFirstRowCell.h"
#import "MBProgressHUD.h"
#import "FeelingRecord.h"
#import "UserInfoCell.h"
#import "FeelingSummaryCell.h"
#import "PublicFeelingRecordLoader.h"
#import "NSDictionary+GetNull.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+HeightForFontAndWidth.h"
#import "FeelingTextCell.h"
#import "HugCell.h"
#import "ODRefreshControl.h"
#import "ImageAttachmentCell.h"
#import "UserSession.h"
#import "PublicProfileViewController.h"
#import "AppDelegate.h"
#import "MyTherapyViewController.h"
#import "AttachmentFullscreenViewController.h"
#import "DetailCommentsViewController.h"
#import "CommentObject.h"
#import "BaseServices.h"

@class FeelingRecord, FeelingRecordLoader, MBProgressHUD;

@interface MyFeelingsViewController :UIViewController <UITableViewDataSource, UITableViewDelegate, FeelingSummeryDelegate,UserInforDelegate,TextCommentDelegate,ImageDelegate,HugDelegate, UserProfileViewDelegate> {
    NSMutableArray *_feelingRecords;
    NSLayoutConstraint *_headerHeightConstraint;
    
    NSMutableArray *_arrHugs;
    NSMutableArray *_arrLikes;
    NSMutableArray *_arrComments;
    
    NSMutableArray *_arrayFollowingMe;
    
    BOOL _refreshOnce;
    BOOL _hasMore, _isLoadingMoreRecords;
    
    NSArray *_customiNavigationLeftItems;
    UIView *_loadingIndicatorContainerView;
    UIActivityIndicatorView *_activityIndicator;
    NSCache *_avatarCache;
    
    HeaderView *_headerView;
    FeelingRecordLoader *_feelingRecordLoader;
    PublicFeelingRecordLoader *_publicFeelingRecordLoader;
    ODRefreshControl *_refreshControl;
    FeelingRecord *_feelingRecord;
    UIImageView *_headerBackgroundImageView;
    UserProfileView *_userProfileView;
    BaseModel *_baseModel;
    CGPoint currentContentOffsetTableView;
    BOOL allowChangeHugLike;
}

@property (nonatomic, retain) NSDictionary *dicParamPublic;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) IBOutlet UIView *headerContainerView;
@property (strong, nonatomic) IBOutlet UITableView *feelingTableView;

@property (readonly, nonatomic) NSString *titleText;
@property (readonly, nonatomic) FeelingRecordLoader *feelingRecordLoader;

@property (strong, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) BOOL isHideHeaderView;
@property (assign, nonatomic) CGFloat heightProfileView;

- (void)setFeelingRecords:(NSArray *)feelingRecords hasMore:(BOOL)hasMore;
- (void)addFeelingRecord:(FeelingRecord *)feelingRecord;
- (void)deleteFeelingRecord:(FeelingRecord *)feelingRecord;
- (void)toggledPublicForFeelingRecord:(FeelingRecord *)record;

- (void)setRefreshOnce:(BOOL)refreshOnce;

- (void)loadMoreDataIfNeededFromIndexPath:(NSIndexPath *)indexPath;

- (void)refresh;
- (void)refreshDone;

- (void)showHeaderView;
- (void)hideHeaderView;

@end
