
//
//  DetailCommentsViewController.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "UserSession.h"
#import "ContainedWebViewController.h"
#import "RevealMenuViewController.h"
#import "SettingsViewController.h"
#import "AFHTTPRequestOperationManager.h"
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
#import "CommentObject.h"
#import "MessageViewCell.h"
#import "HugDetailViewCell.h"
#import "LikeDetailViewCell.h"
#import "ImageAttachmentCell.h"
#import "MBProgressHUD.h"
#import "PublicProfileViewController.h"
#import "MoreHugsUserViewController.h"
#import "SeparatorViewCell.h"
#import "AvatarHelper.h"
#import "TimeHelper.h"
#import "FollowObject.h"
#import "UserProfileView.h"

@class FeelingRecord, FeelingRecordLoader, MBProgressHUD, MessageViewCell, CommentObject, MoreHugsUserViewController;

@interface DetailCommentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate, ImageDelegate,MessageViewCellDelegate,ViewHugByDelegate,ViewLikeByDelegate,HugDelegate, UserProfileViewDelegate,UIGestureRecognizerDelegate>{
    UILabel *placeHolder;
    NSMutableArray *_arrayComment;
    NSMutableArray *_arrayFollowingMe;
    NSLayoutConstraint *_headerHeightConstraint;
    MessageViewCell *messageViewCell;
    BOOL huggedByMe;
    BOOL likedByMe;
    float fcurrentNumberLiker;
    float fCurrentNumberHuggers;
    int indexHugger;
    BaseModel *_baseModel;

    UIImageView *_hudCustomeView;
    NSArray *_customiNavigationLeftItems;
    NSCache *_avatarCache;
    
    PublicFeelingRecordLoader *_publicFeelingRecordLoader;
    FeelingRecordLoader *_feelingRecordLoader;
    FeelingRecord *_feelingRecord;
    BOOL _refreshOnce;
    UserProfileView *_userProfileView;
    FeelingSummarySectionHeaderView *_feelingSummarySection;
    BOOL allowChangeHugLike;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (weak, nonatomic) IBOutlet UIView *composeChatView;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomChatViewConstraint;


@property (readonly, nonatomic) CommentObject *commentObject;
@property (readonly, nonatomic) FeelingRecordLoader *feelingRecordLoader;
@property (readonly, nonatomic) MBProgressHUD *hud;
@property (nonatomic, retain) NSDictionary *dicParamPublic;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *like;
@property (strong, nonatomic) NSString *hug;
@property (strong, nonatomic) NSArray *huggers;
@property (strong, nonatomic) NSArray *likers;
@property (strong, nonatomic) NSNumber *currentIndexPath;
@property (strong, nonatomic) NSMutableArray *arrayHugDetails;
@property (strong, nonatomic) NSMutableArray *arrayLikeDetails;
@property (strong, nonatomic) NSMutableArray *arrayCommentDetails;
@property (strong, nonatomic) NSString *feelingRecordCode;
@property (assign, nonatomic) CGFloat heightProfileView;

- (void)setFeelingRecordTherapy:(FeelingRecord *)feelingRecord;
- (IBAction)sendMessageButtonAction:(id)sender;
- (CGFloat) shiftHeightByKeyboard;
- (void) keyboardStateChanged: (BOOL) state;
- (void)addplaceholder;
+ (void)subscribeController: (UIViewController *) controller forKeyboardAppears: (SEL) appears disapears: (SEL) disapears;
+ (void)unsubscribeControllerFromNotifications: (UIViewController *) controller;

@end
