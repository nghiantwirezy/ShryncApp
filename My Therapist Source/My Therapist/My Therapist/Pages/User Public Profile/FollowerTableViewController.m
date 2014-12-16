//
//  FollowerTableViewController.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "FollowerTableViewController.h"
#import "FollowerTableViewCell.h"
#import "PublicProfileViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "MoreHugsUserViewCell.h"
#import "UserSession.h"
#import "FeelingRecord.h"
#import "FollowObject.h"
#import "AvatarHelper.h"
#import "MBProgressHUD.h"

#define FOLLOW_ENDPOINT @"https://secure.shrync.com/api/user/follow"
#define TOKEN_PARAM_POST @"token"
#define USERS_ID_PARAM_POST @"touid"
#define NICKNAME_PARAM @"nickname"
#define NICKNAME_PARAM_ALL @"nickname"

#define FOLLOWER_ENDPOINT @"https://secure.shrync.com/api/user/getfollowers"
#define FOLLOWING_ENDPOINT @"https://secure.shrync.com/api/user/getfollowing"
#define TOKEN_PARAM @"token"
#define USERS_ID_PARAM @"userid"
#define USER_ID_PARAM @"userid"
#define NICK_NAME_USER @"nickname"
#define FOLLOW @" Follow "
#define UNFOLLOW @"Unfollow"
#define TABLE_IDENTIFIER_ID_ID @"TABLE_IDENTIFIER_ID"
#define CELL_HEIGHT 35

@interface FollowerTableViewController ()<FollowerTableViewCellDelegate>

@end

@implementation FollowerTableViewController{
    FollowerTableViewCell *cell;
    MBProgressHUD *_hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableViewDelegate and Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayFollower.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = TABLE_IDENTIFIER_ID_ID;
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[FollowerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    FollowObject *dict = [_arrayFollower objectAtIndex:indexPath.row];
    cell.labelUserFollower.text = dict.nickname;
    [AvatarHelper setAvatarForImageView:cell.imageUserFollower withKey:dict.user_id];
    [cell setDelegate:self];
    [cell.followerUserButton setTag:indexPath.row];

    for (FollowObject *followObj in _arrayMe) {
        if ([followObj.user_id isEqualToString:dict.user_id]) {
            [cell.followerUserButton setTitle:NSLocalizedString(UNFOLLOW, nil) forState:UIControlStateNormal];
            cell.followerUserButton.backgroundColor = [UIColor grayColor];
            break;
        }
        
        if ([[UserSession currentSession].userId isEqualToString:dict.user_id]) {
            cell.followerUserButton.hidden = YES;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowObject *dict = [_arrayFollower objectAtIndex:indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectFollowerUser:)]) {
        [_delegate didSelectFollowerUser:dict];
    }
}

#pragma mark - Delegate Button

- (void)clickedButtonActionFollower:(UIButton *)btnFollower{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FollowObject *dict = [_arrayFollower objectAtIndex:btnFollower.tag];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{TOKEN_PARAM_POST: [UserSession currentSession].sessionToken,
                                 USERS_ID_PARAM_POST:dict.user_id};
    [manager GET:FOLLOW_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success = %@", responseObject);
        
        [self updateButtonFollow:btnFollower];
        [self didUpdateFollowerSuccessful:btnFollower];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error = %@", error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)updateButtonFollow:(UIButton *)btnFollower{
    if ([btnFollower.titleLabel.text isEqualToString:NSLocalizedString(FOLLOW, nil)]) {
        [btnFollower setTitle:NSLocalizedString(UNFOLLOW, nil) forState:UIControlStateNormal];
        btnFollower.backgroundColor = [UIColor grayColor];
    }else{
        [btnFollower setTitle:NSLocalizedString(FOLLOW, nil) forState:UIControlStateNormal];
        btnFollower.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:176 / 255.0 blue:255 / 255.0 alpha:1];
    }
}

#pragma mark - Compare Follower List

-(void)compareListFollowing{
    _arrayMe =[NSMutableArray new];
    for (FollowObject *listFollowerAll in _arrayFollower) {
        for (FollowObject *listFollowMe in _arrayFollowingMe){
            if ([listFollowerAll.nickname isEqualToString:listFollowMe.nickname]) {
                [_arrayMe addObject:listFollowMe];
            }
        }
    }
    if (_arrayMe.count>0) {
        [self.tableView reloadData];
    }
}

#pragma mark - Check Current User Follower

- (void)didUpdateFollowerSuccessful:(UIButton *)indexPath{
    FollowObject *folowObject = [_arrayFollower objectAtIndex:indexPath.tag];
    FollowObject *fbj2 = nil;
    for (FollowObject *flObj in _arrayFollowingMe) {
        if ([flObj.user_id isEqualToString:folowObject.user_id]) {
            fbj2 = [FollowObject new];
            fbj2 = flObj;
        }
    }
    if (fbj2) {
        [_arrayFollowingMe removeObject:fbj2];
    }else
        [_arrayFollowingMe addObject:folowObject];
    
    [self compareListFollowing];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_delegate didScrollFollower:scrollView];
}

@end
