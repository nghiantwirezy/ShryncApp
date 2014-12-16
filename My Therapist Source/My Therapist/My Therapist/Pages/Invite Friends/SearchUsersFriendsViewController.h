//
//  SearchUsersFriendsViewController.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ListFriendsTableViewCell.h"
#import "PublicProfileViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "MoreHugsUserViewCell.h"
#import "UserSession.h"
#import "FeelingRecord.h"
#import "FollowObject.h"
#import "AvatarHelper.h"
#import "MBProgressHUD.h"
#import "UIColor+ColorUtilities.h"

@interface SearchUsersFriendsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate, ListFriendsTableViewCellDelegate> {
    BaseModel *_baseModel;
    MBProgressHUD *_hud;
    NSCache *_avatarCache;
}

@property (weak, nonatomic) IBOutlet UITableView *searchFriendsContentTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchFriendsBar;

@property (strong, nonatomic) NSMutableArray *arrayListFriends;
@property (strong, nonatomic) NSMutableArray *arrayListSearchFriends;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;

@end
