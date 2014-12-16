//
//  SearchUsersFriendsViewController.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "SearchUsersFriendsViewController.h"

@implementation SearchUsersFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _arrayListFriends = [[NSMutableArray alloc] init];
        _arrayListSearchFriends = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _baseModel = [BaseModel shareBaseModel];
    self.navigationItem.hidesBackButton = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME_TITLE_LABEL_SEARCH_USERS_FRIENDS];
    titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_TITLE_DEFAULT);
    titleLabel.text = NSLocalizedString(TITLE_SEARCH_USERS_FRIENDS, nil);
    titleLabel.textColor = [UIColor veryLightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIImage *backImage = [UIImage imageNamed:IMAGE_NAME_BACK_BUTTON];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:FRAME_BACK_BUTTON_SEARCH_USERS_FRIENDS];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popInvit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:barButton];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.userInteractionEnabled = NO;
    _hud.labelFont = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    [self.view addSubview:_hud];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self reloadFriends];
    _arrayListSearchFriends = [NSMutableArray arrayWithArray:_arrayListFriends];
}

- (void)popInvit
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView delegate & datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CELL_TABLE_VIEW_SEARCH_USERS_FRIENDS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayListSearchFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL];
    if (cell == nil) {
        cell = [[ListFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_LIST_FRIENDS_TABLE_VIEW_CELL];
    }
    
    FollowObject *followObject = [_arrayListSearchFriends objectAtIndex:indexPath.row];
    cell.labelUsername.text = followObject.nickname;
    [self setAvatarForImage:cell.imageUserFriends withUserID:followObject.user_id];
    for (FollowObject *followObj in _arrayListSearchFriends) {
        if ([followObj.user_id isEqualToString:followObject.user_id]) {
            [cell.buttonFollow setTitle:NSLocalizedString(TEXT_UNFOLLOWED_PUBLIC_PROFILE_VIEW, nil) forState:UIControlStateNormal];
            cell.buttonFollow.backgroundColor = [UIColor grayColor];
        }
    }
    
    [cell setDelegate:self];
    [cell.buttonFollow setTag:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSession *userSession = [UserSession currentSession];
    FollowObject *followObject = [_arrayListSearchFriends objectAtIndex:indexPath.row];
    NSDictionary *parameters = @{KEY_TOKEN_PARAM:userSession.sessionToken, KEY_END_PARAM:@0,KEY_COUNT:@NUMBER_MAX_DATA_DOWNLOAD, KEY_USER_ID:followObject.user_id};
    
    PublicProfileViewController *publicProfileViewControllerForUser = [[PublicProfileViewController alloc]init];
    [publicProfileViewControllerForUser setUsername:followObject.nickname];
    [publicProfileViewControllerForUser setUserId:followObject.user_id];
    [publicProfileViewControllerForUser setDicParamPublic:parameters];
    [self.navigationController pushViewController:publicProfileViewControllerForUser animated:YES];
}

#pragma mark - Search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _arrayListSearchFriends = [_arrayListFriends mutableCopy];
    [self.searchFriendsContentTable reloadData];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString.length==0) {
        _arrayListSearchFriends = [_arrayListFriends mutableCopy];
        [self.searchFriendsContentTable reloadData];
    }else{
        [self.arrayListSearchFriends removeAllObjects];
        for (FollowObject *obj in _arrayListFriends) {
            if ([obj.nickname hasPrefix:searchString]) {
                [self.arrayListSearchFriends addObject:obj];
            }
        }
        [self.searchFriendsContentTable reloadData];
    }
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return YES;
}

#pragma mark - ListFriendsTableViewCell delegate

- (void)clickedButtonActionFollow:(UIButton *)btnFollow{
    [_hud show:YES];
    FollowObject *dict = [_arrayListFriends objectAtIndex:btnFollow.tag];
    NSDictionary *parameters = @{KEY_TOKEN_PARAM: [UserSession currentSession].sessionToken,
                                 KEY_TOU_ID:dict.user_id};
    [_baseModel getFollowEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
        if (!error) {
            NSLog(@"Success = %@", responseObject);
            [self updateButtonFollow:btnFollow];
            [self reloadFriends];
            [_hud hide:YES];
        }else {
            NSLog(@"Error = %@", error);
            [_hud hide:YES];
        }
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

#pragma mark - update List Friends With Token

- (void)reloadFriends{
    NSDictionary * parameterss = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken,
                                   KEY_USER_ID:[UserSession currentSession].userId};
    [_hud show:YES];
    [_baseModel getUserFriendWithParameters:parameterss completion:^(id responseObject, NSError *error){
        if (!error) {
            _arrayListFriends = [NSMutableArray arrayWithArray:[FollowObject followObjectsWith:responseObject]];
            _arrayListSearchFriends = [_arrayListFriends mutableCopy];
            [self.searchFriendsContentTable reloadData];
            [_hud hide:YES];
        }else {
            NSLog(@"error = %@",error);
            [_hud hide:YES];
        }
    }];
}

#pragma mark - Custom Methods

- (void)setAvatarForImage:(UIImageView *)imageView withUserID:(NSString *)userID {
    imageView.image = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
    UserSession *userSession = [UserSession currentSession];
    BOOL isNeedRequestAvatar = YES;
    if ([userID isEqualToString:userSession.userId] && (userSession.userAvatar)) {
        imageView.image = userSession.userAvatar;
        isNeedRequestAvatar = NO;
    }
    if (isNeedRequestAvatar) {
        UIImage *avatar = [_avatarCache objectForKey:userID];
        NSDictionary *parameters = @{KEY_USER_ID:userID};
        if (!avatar) {
            [_baseModel getUserAvatarWithParameters:parameters completion:^(id responseObject, NSError *error){
                if (!error) {
                    UIImage *avatar = responseObject;
                    if (avatar == nil) {
                        avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                    } else {
                        [_avatarCache setObject:responseObject forKey:userID];
                    }
                    imageView.image = avatar;
                }else {
                    UIImage *avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                    imageView.image = avatar;
                }
            }];
        }
    }
}

@end
