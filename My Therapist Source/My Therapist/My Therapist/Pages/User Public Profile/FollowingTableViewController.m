//
//  FollowingTableViewController.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "FollowingTableViewController.h"
#import "FollowingTableViewCell.h"
#import "PublicProfileViewController.h"
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

#define FOLLOWER_ENDPOINT @"https://secure.shrync.com/api/user/getfollowers"
#define FOLLOWING_ENDPOINT @"https://secure.shrync.com/api/user/getfollowing"
#define TOKEN_PARAM @"token"
#define USERS_ID_PARAM @"userid"
#define USER_ID_PARAM @"userid"
#define NICK_NAME_USER @"nickname"
#define NICKNAME_PARAM @"nickname"
#define FOLLOW @" Follow "
#define UNFOLLOW @"Unfollow"
#define TABLE_IDENTIFIER_ID_ID @"TABLE_IDENTIFIER_ID"
#define CELL_HEIGHT 35

@interface FollowingTableViewController ()<FollowingTableViewCellDelegate>

@end

@implementation FollowingTableViewController{
    FollowingTableViewCell *cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return _arrayFollowing.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = TABLE_IDENTIFIER_ID_ID;
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[FollowingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    FollowObject *dict = [_arrayFollowing objectAtIndex:indexPath.row];
    cell.labelUserFollowing.text = dict.nickname;
    [AvatarHelper setAvatarForImageView:cell.imageUserFollowing withKey:dict.user_id];
    [cell setDelegate:self];
    [cell.followingCellButton setTag:indexPath.row];
    
    for (FollowObject *followObj in _arrayOfMe) {
        if ([followObj.user_id isEqualToString:dict.user_id]) {
            [cell.followingCellButton setTitle:NSLocalizedString(UNFOLLOW, nil) forState:UIControlStateNormal];
            cell.followingCellButton.backgroundColor = [UIColor grayColor];
        }
        if ([[UserSession currentSession].userId isEqualToString:dict.user_id]) {
            cell.followingCellButton.hidden = YES;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowObject *dict = [_arrayFollowing objectAtIndex:indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectFollowingUser:)]) {
        [_delegate didSelectFollowingUser:dict];
    }
}

- (void)updateButtonFollowing:(UIButton *)btnFollowing{
    if ([btnFollowing.titleLabel.text isEqualToString:NSLocalizedString(FOLLOW, nil)]) {
        [btnFollowing setTitle:NSLocalizedString(UNFOLLOW, nil) forState:UIControlStateNormal];
        btnFollowing.backgroundColor = [UIColor grayColor];
    }else {
        [btnFollowing setTitle:NSLocalizedString(FOLLOW, nil) forState:UIControlStateNormal];
        btnFollowing.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:176 / 255.0 blue:255 / 255.0 alpha:1];
    }
}

#pragma mark - Delegate Button

- (void)clickedButtonActionFollowing:(UIButton *)btnFollowing{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FollowObject *dict = [_arrayFollowing objectAtIndex:btnFollowing.tag];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{TOKEN_PARAM_POST: [UserSession currentSession].sessionToken,
                                 USERS_ID_PARAM_POST:dict.user_id};
    [manager GET:FOLLOW_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success = %@",responseObject);
        
        [self updateButtonFollowing:btnFollowing];
        [self didUpdateFollowerSuccessful:btnFollowing];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error = %@", error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - Compare Following List

-(void)compareListFollowingTwo{
    _arrayOfMe =[NSMutableArray new];
    for (FollowObject *listFollowerAll in _arrayFollowing) {
        for (FollowObject *listFollowMe in _arrayFollowingMeMe){
            if ([listFollowerAll.nickname isEqualToString:listFollowMe.nickname]) {
                [_arrayOfMe addObject:listFollowMe];
            }
        }
    }
    if (_arrayOfMe.count>0) {
        [self.tableView reloadData];
    }
}

#pragma mark - Check Current User Following

- (void)didUpdateFollowerSuccessful:(UIButton *)indexPath{
    FollowObject *folowObject = [_arrayFollowing objectAtIndex:indexPath.tag];
    FollowObject *fbj2 = nil;
    for (FollowObject *flObj in _arrayFollowingMeMe) {
        if ([flObj.user_id isEqualToString:folowObject.user_id]) {
            fbj2 = [FollowObject new];
            fbj2 = flObj;
        }
    }
    if (fbj2) {
        [_arrayFollowingMeMe removeObject:fbj2];
    }else
        [_arrayFollowingMeMe addObject:folowObject];
    
    [self compareListFollowingTwo];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_delegate didScrollFollowing:scrollView];
}

@end
