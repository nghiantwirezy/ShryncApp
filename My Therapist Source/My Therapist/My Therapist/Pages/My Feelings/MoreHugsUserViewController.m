//
//  MoreHugsUserViewController.m
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "MoreHugsUserViewController.h"
#import "FeelingRecord.h"
#import "AFHTTPRequestOperationManager.h"
#import "PublicProfileViewController.h"
#import "AppDelegate.h"
#import "UserSession.h"
#import "FollowObject.h"
#import "MBProgressHUD.h"
#import "UIColor+ColorUtilities.h"

@interface MoreHugsUserViewController()<MoreHugsUserViewCellDelegate>
@end

@implementation MoreHugsUserViewController{
    FeelingRecord *_feelingRecord;
    NSCache *_avatarCache;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initTopBar];
        _avatarCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _baseModel = [BaseModel shareBaseModel];
}

- (void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)dismissViewButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setFeelingRecordTherapy:(FeelingRecord *)feelingRecord{
    _feelingRecord = feelingRecord;
}

- (void)initTopBar {
    self.navigationItem.hidesBackButton = YES;
    UIImage *backImage = [UIImage imageNamed:IMAGE_NAME_BACK_BUTTON];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:FRAME_BACK_BUTTON_MORE_HUGS_USER];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
    _titleLabel = [[UILabel alloc] initWithFrame:FRAME_TITLE_LABEL_MORE_HUGS_USER];
    _titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_TITLE_DEFAULT);
    _titleLabel.text = NSLocalizedString(TITLE_MORE_HUGS_USER, nil);
    _titleLabel.textColor = [UIColor veryLightGrayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titleLabel;
}

#pragma mark - TableViewDelegate and Datasource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CELL_MORE_HUGS_USER;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayMoreUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreHugsUserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MORE_HUGS_USER_VIEW_CELL];
    
    if (cell == nil) {
        cell = [[MoreHugsUserViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_MORE_HUGS_USER_VIEW_CELL];
    }
    NSDictionary *dict = [_arrayMoreUsers objectAtIndex:indexPath.row];
    cell.usernameLabel.text = [dict objectForKey:KEY_NICK_NAME];
    
    [cell setDelegate:self];
    [cell.followButton setTag:indexPath.row];
    
    for (FollowObject *objs in _arrayMe) {
        if ([objs.user_id isEqualToString:[dict objectForKey:KEY_USER_ID]]) {
            [cell.followButton setTitle:NSLocalizedString(TEXT_UNFOLLOWED_PUBLIC_PROFILE_VIEW, nil) forState:UIControlStateNormal];
            cell.followButton.backgroundColor = [UIColor grayColor];
        }
        
        if ([[UserSession currentSession].username isEqualToString:[dict objectForKey:KEY_NICK_NAME]]) {
            cell.followButton.hidden = YES;
        }
    }
    
    //Get Avatar
    UIImage *avatar = [_avatarCache objectForKey:[dict objectForKey:KEY_USER_ID]];
    if (!avatar) {
        avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
        [cell.userImageView setImage:avatar];
        NSDictionary *param = @{KEY_USER_ID:[dict objectForKey:KEY_USER_ID]};
        [_baseModel getUserAvatarWithParameters:param completion:^(id responseObject, NSError *error){
            if (!error) {
                UIImage *avatar = responseObject;
                if (avatar == nil) {
                    avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                } else {
                    [_avatarCache setObject:responseObject forKey:[dict objectForKey:KEY_USER_ID]];
                }
                [cell.userImageView setImage:avatar];
            }else {
                
            }
        }];
    } else {
        [cell.userImageView setImage:avatar];
    }
    
    return cell;
}

- (void)clickedButtonActionFollow:(UIButton *)btnFollow{
    
    [MBProgressHUD showHUDAddedTo:self.hugsUserContentTableView animated:YES];
    
    NSDictionary *dict = [_arrayMoreUsers objectAtIndex:btnFollow.tag];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{KEY_TOKEN_PARAM: [UserSession currentSession].sessionToken,
                                 KEY_TOU_ID:[dict objectForKey:KEY_USER_ID]};
    [manager GET:URL_GET_FOLLOW_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success = %@",responseObject);
        
        [self updateButtonFollow:btnFollow];
        [self didUpdateFollowerSuccessful:btnFollow];
        
        [MBProgressHUD hideAllHUDsForView:self.hugsUserContentTableView animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error = %@", error);
        [MBProgressHUD hideAllHUDsForView:self.hugsUserContentTableView animated:YES];
    }];
}

- (void)updateButtonFollow:(UIButton *)btnFollow{
    if ([btnFollow.titleLabel.text isEqualToString:NSLocalizedString(TEXT_FOLLOW_PUBLIC_PROFILE_VIEW, nil)]) {
        [btnFollow setTitle:NSLocalizedString(TEXT_UNFOLLOWED_PUBLIC_PROFILE_VIEW, nil) forState:UIControlStateNormal];
        btnFollow.backgroundColor = [UIColor grayColor];
    }else{
        [btnFollow setTitle:NSLocalizedString(TEXT_FOLLOW_PUBLIC_PROFILE_VIEW, nil) forState:UIControlStateNormal];
        btnFollow.backgroundColor = [UIColor pureCyanColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [_arrayMoreUsers objectAtIndex:indexPath.row];
    PublicProfileViewController *nextViewController = [[PublicProfileViewController alloc]init];
    [nextViewController setUsername:[dict objectForKey:KEY_NICK_NAME]];
    [nextViewController setUserId:[dict objectForKey:KEY_USER_ID]];
    [nextViewController setDicParamPublic:dict];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

#pragma mark - GET Follower / Following list

-(void)compareListFollowing{
    _arrayMe =[NSMutableArray new];
    for (FollowObject *listFollowerAll in _arrayListFollowingMe) {
        for (NSDictionary *dict in _arrayMoreUsers){
            if ([listFollowerAll.user_id isEqualToString:[dict objectForKey:KEY_USER_ID]]) {
                [_arrayMe addObject:listFollowerAll];
                break;
            }
        }
    }
    if (_arrayMe.count>0) {
        [self.hugsUserContentTableView reloadData];
    }
}

#pragma mark - Check Current User Follower

- (void)didUpdateFollowerSuccessful:(UIButton *)indexPath{
    NSDictionary *dict = [_arrayMoreUsers objectAtIndex:indexPath.tag];
    FollowObject *followObjectToRemove = nil;
    for (FollowObject *followObject in _arrayListFollowingMe) {
        if ([followObject.user_id isEqualToString:[dict objectForKey:KEY_USER_ID]]) {
            followObjectToRemove = [FollowObject new];
            followObjectToRemove = followObject;
            break;
        }
    }
    if (followObjectToRemove) {
        [_arrayListFollowingMe removeObject:followObjectToRemove];
    }else{
        FollowObject *followObjectToAdd = [[FollowObject alloc] init];
        followObjectToAdd.user_id = [dict objectForKey:KEY_USER_ID];
        followObjectToAdd.nickname = [dict objectForKey:KEY_NICK_NAME];
        [_arrayListFollowingMe addObject:followObjectToAdd];
    }
    [self compareListFollowing];
}

@end
