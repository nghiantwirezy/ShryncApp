
//  PublicFeelingsViewController.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "PublicFeelingsViewController.h"
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
#import "MBProgressHUD.h"
#import "TimeHelper.h"
#import "AvatarHelper.h"
#import "MoreHugsUserViewController.h"
#import "FollowObject.h"

@interface PublicFeelingsViewController ()<HugDelegate,UserInforDelegate,FeelingSummeryDelegate,TextCommentDelegate,ImageDelegate>{
}
@end

@implementation PublicFeelingsViewController {
    PublicFeelingRecordLoader *_publicFeelingRecordLoader;
    NSCache *_avatarCache;
    ODRefreshControl *_refreshControl;
    FeelingRecord *_feelingRecord;
    MBProgressHUD *_hudPublicFeeling;
}

- (FeelingRecordLoader *)feelingRecordLoader
{
    if (_publicFeelingRecordLoader == nil) {
        _publicFeelingRecordLoader = [[PublicFeelingRecordLoader alloc] init];
        _publicFeelingRecordLoader.hud = self.hud;
    }
    return _publicFeelingRecordLoader;
}

- (NSString *)titleText
{
    return NSLocalizedString(TITLE_PUBLIC_FEELINGS, nil);
}

- (void)refreshDone
{
    [super refreshDone];
    [_refreshControl endRefreshing];
}

- (void)toggledPublicForFeelingRecord:(FeelingRecord *)record
{
    if (!record.isPublic) {
        [self deleteFeelingRecord:record];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hideHeaderView];
    self.feelingTableView.backgroundColor = [UIColor veryLightGrayColor5];
    
    _publicFeelingRecordLoader = [[PublicFeelingRecordLoader alloc] init];
    _avatarCache = [[NSCache alloc] init];
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.feelingTableView];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    _hudPublicFeeling = [[MBProgressHUD alloc] initWithView:self.view];
    _hudPublicFeeling.userInteractionEnabled = NO;
    [self.view addSubview:_hudPublicFeeling];
    _hudPublicFeeling.labelFont = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
}

- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItems = _customiNavigationLeftItems;
    [self.feelingTableView reloadData];
    [self refresh];
    [self reloadFollowingMe];
}

- (void)refresh
{
    _hudPublicFeeling.labelText = NSLocalizedString(TEXT_LOADING_PUBLIC_PROFILE_VIEW, nil);
    _hudPublicFeeling.mode = MBProgressHUDModeIndeterminate;
    [_hudPublicFeeling show:YES];
    
    self.feelingTableView.tableFooterView = nil;
    UserSession *userSession = [UserSession currentSession];
    allowChangeHugLike = NO;
    [self.feelingRecordLoader loadRecordsWithCount:NUMBER_MAX_DATA_DOWNLOAD andUserId:userSession.userId before:nil  success:^(NSArray *records, BOOL hasMore) {
        [UserSession currentSession].latestFeelingRecords = records;
        [_hudPublicFeeling hide:YES];
        [self setFeelingRecords:records hasMore:hasMore];
        [self refreshDone];
    } failure:^(NSInteger statusCode) {
        _hudPublicFeeling.labelText = NSLocalizedString(TEXT_LOAD_FAILED_PUBLIC_PROFILE_VIEW, nil);
        [_hudPublicFeeling hide:YES afterDelay:TIME_DELAY_HUG_PUBLIC_FEELINGS];
        [self refreshDone];
    }];
}

- (void)setFeelingRecordTherapy:(FeelingRecord *)feelingRecord{
    _feelingRecord = feelingRecord;
}

#pragma mark - TableView datasource & delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.section];
    if ([[UserSession currentSession].userId caseInsensitiveCompare:record.userId] == NSOrderedSame && indexPath.row > 0 && indexPath.row <= record.feelings.count) {
        [super tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = HEIGHT_CELL_DEFAULT_PUBLIC_FEELINGS;
    
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        height = [UserInfoCell cellHeight];
    }
    else if (indexPath.row == record.feelings.count + 1) {
        if (record.comment.length > 0) {
            NSString *commentString = record.comment;
            height = ceilf(commentString != nil ? ([commentString heightForFont:COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_COMMENT_CELL_PUBLIC_FEELINGS) andWidth:WIDTH_COMMENT_CELL_PUBLIC_FEELINGS] + SPACE_COMMENT_CELL_PUBLIC_FEELINGS) : 0);
        }
        else if (record.thumbnailPath.length > 0) {
            height = [ImageAttachmentCell cellHeight];
        }
        else {
            height = [HugCell cellHeight];
        }
    }
    else if (indexPath.row == record.feelings.count + 2) {
        if (record.comment.length > 0 && record.thumbnailPath.length > 0) {
            height = [ImageAttachmentCell cellHeight];
        }
        else if(record.huggers.count!= 0) {
            height = [HugCell cellHeight];
        }
    }
    else {
        height = [HugCell cellHeight];
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _feelingRecords.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FeelingRecord *record = [_feelingRecords objectAtIndex:section];
    
    NSUInteger count = record.feelings.count + 2;
    if (record.comment.length > 0) {
        count += 1;
    }
    if (record.thumbnailPath.length > 0) {
        count += 1;
    }
    return count;
}

#pragma mark - Flag#1

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self loadMoreDataIfNeededFromIndexPath:indexPath];
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.section];
    UITableViewCell *tableCell = nil;
    if (indexPath.row == 0) {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_USER_INFO_CELL];
        if (cell == nil) {
            cell = [[UserInfoCell alloc] initWithReuseIdentifier:IDENTIFIER_USER_INFO_CELL];
        }
        cell.delegate = self;
        [cell.btnClick setTag:indexPath.section];
        [cell setFeelingRecord:record];
        UIImage *avatar = [_avatarCache objectForKey:record.userId];
        if (!avatar) {
            NSDictionary *param = @{KEY_USER_ID: record.userId};
            [_baseModel getUserAvatarWithParameters:param completion:^(id responseObject, NSError *error){
                if (!error) {
                    UIImage *avatar = responseObject;
                    if (avatar == nil) {
                        avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                    } else {
                        [_avatarCache setObject:responseObject forKey:record.userId];
                    }
                    [cell setAvatar:avatar forUserId:record.userId];
                }else {
                    UIImage *avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                    [cell setAvatar:avatar forUserId:record.userId];
                }
            }];
        } else {
            [cell setAvatar:avatar forUserId:record.userId];
        }
        
        tableCell = cell;
    } else if (indexPath.row <= record.feelings.count) {
        FeelingSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FEELING_CELL];
        if (cell == nil) {
            cell = [[FeelingSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_FEELING_CELL];
        }
        [cell setFeeling:[record.feelings objectAtIndex:indexPath.row - 1]];
        [cell setDelegate:self];
        [cell.btnStatus setTag:indexPath.section];
        tableCell = cell;
    } else if (indexPath.row == record.feelings.count + 1) {
        if (record.comment.length > 0) {
            FeelingTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_COMMENT_CELL];
            if (textCell == nil) {
                textCell = [[FeelingTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_COMMENT_CELL ];
            }
            NSString *commentString = record.comment;
            textCell.textView.text = commentString;
            [textCell.textView sizeToFit];
            
            CGRect textFrame = textCell.textView.frame;
            textFrame.size.width = WIDTH_COMMENT_CELL_PUBLIC_FEELINGS;
            textCell.textView.frame = textFrame;
            
            CGRect containerFrame = textCell.containerView.frame;
            containerFrame.size.height = textCell.textView.frame.size.height;
            textCell.containerView.frame = containerFrame;
            textCell.btnComment.frame = containerFrame;
            textCell.delegate = self;
            [textCell.btnComment setTag:indexPath.section];
            tableCell = textCell;
        }
        else if (record.thumbnailPath.length > 0) {
            ImageAttachmentCell *imageCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_ATTACHMENT_CELL];
            if (imageCell == nil) {
                imageCell = [[ImageAttachmentCell alloc] initWithReuseIdentifier:IDENTIFIER_ATTACHMENT_CELL];
            }
            [imageCell setFeelingRecord:record];
            [imageCell setDelegate:self];
            [imageCell.btnImage setTag:indexPath.section];
            tableCell = imageCell;
        }
        else {
            tableCell = [self hugCellWithIndexPath:indexPath andFeelingRecord:record andTableView:tableView];
        }
    }
    else if (indexPath.row == record.feelings.count + 2) {
        if (record.comment.length > 0 && record.thumbnailPath.length > 0) {
            ImageAttachmentCell *imageCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_ATTACHMENT_CELL];
            if (imageCell == nil) {
                imageCell = [[ImageAttachmentCell alloc] initWithReuseIdentifier:IDENTIFIER_ATTACHMENT_CELL];
            }
            [imageCell setFeelingRecord:record];
            [imageCell setDelegate:self];
            [imageCell.btnImage setTag:indexPath.section];
            tableCell = imageCell;
        }
        else {
            tableCell = [self hugCellWithIndexPath:indexPath andFeelingRecord:record andTableView:tableView];
        }
    }
    else {
        tableCell = [self hugCellWithIndexPath:indexPath andFeelingRecord:record andTableView:tableView];
    }
    return tableCell;
}

//Hug Cell

- (HugCell *)hugCellWithIndexPath :(NSIndexPath *)indexPath andFeelingRecord:(FeelingRecord *)record andTableView:(UITableView *)tableView{
    HugCell *hugCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_HUG_CELL];
    if (hugCell == nil) {
        hugCell = [[HugCell alloc] initWithReuseIdentifier:IDENTIFIER_HUG_CELL];
    }
    hugCell.tableView = tableView;
    
    if ([[UserSession currentSession].userId isEqualToString:record.userId]) {
        hugCell.likeButtonClick.enabled = NO;
        hugCell.hugButtonClick.enabled = NO;
    }
    else{
        hugCell.likeButtonClick.enabled = YES;
        hugCell.hugButtonClick.enabled = YES;
    }
    [hugCell setHugFeelingRecord:record];
    [hugCell setLikeFeelingRecord:record];
    [hugCell setDelegate:self];
    
    
    [hugCell.hugButton setImage:[UIImage imageNamed:IMAGE_NAME_HEART_64] forState:UIControlStateNormal];
    hugCell.hugTextLabel.textColor = [UIColor grayColor];
    [hugCell.huggedCountButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    for (NSDictionary *dicHugger in [_arrHugs objectAtIndex:indexPath.section]) {
        if ([[dicHugger valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]){
            [hugCell.hugButton setImage:[UIImage imageNamed:IMAGE_NAME_HEART_64_SELECTED] forState:UIControlStateNormal];
            hugCell.hugTextLabel.textColor = [UIColor darkModerateCyanColor];
            [hugCell.huggedCountButton setTitleColor:[UIColor darkModerateCyanColor] forState:UIControlStateNormal];
            break;
        }
    }
    
    [hugCell.likeButton setImage:[UIImage imageNamed:IMAGE_NAME_THUMB_UP] forState:UIControlStateNormal];
    hugCell.likeTextLabel.textColor = [UIColor grayColor];
    [hugCell.likedCountButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    for (NSDictionary *dicLiker in [_arrLikes objectAtIndex:indexPath.section]) {
        if ([[dicLiker valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]) {
            [hugCell.likeButton setImage:[UIImage imageNamed:IMAGE_NAME_THUMB_UP_SELECTED] forState:UIControlStateNormal];
            hugCell.likeTextLabel.textColor = [UIColor darkModerateCyanColor];
            [hugCell.likedCountButton setTitleColor:[UIColor darkModerateCyanColor] forState:UIControlStateNormal];
            break;
        }
    }
    
    [hugCell.commentButton setImage:[UIImage imageNamed:IMAGE_NAME_COMMENT_32_NORMAL] forState:UIControlStateNormal];
    hugCell.commentTextLabel.textColor = [UIColor grayColor];
    hugCell.totalCommentLabel.textColor = [UIColor grayColor];
    for (NSDictionary *dicComment in [_arrComments objectAtIndex:indexPath.section]) {
        if ([[dicComment valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]) {
            hugCell.totalCommentLabel.text = @"";
            [hugCell.commentButton setImage:[UIImage imageNamed:IMAGE_NAME_COMMENT_32] forState:UIControlStateNormal];
            hugCell.commentTextLabel.textColor = [UIColor darkModerateCyanColor];
            hugCell.totalCommentLabel.textColor = [UIColor darkModerateCyanColor];
            break;
        }
    }
    
    //like button
    hugCell.likeButtonClick.tag = indexPath.section;
    hugCell.likedCountButton.tag = indexPath.section;
    NSArray *likers = [_arrLikes objectAtIndex:indexPath.section];
    if (likers.count == 0 ) {
        [hugCell.likedCountButton setTitle:@"" forState:UIControlStateNormal];
        hugCell.likedCountButton.enabled = NO;
    }else{
        [hugCell.likedCountButton setTitle:[NSString stringWithFormat:@" %d ",(int)likers.count] forState:UIControlStateNormal];
        hugCell.likedCountButton.enabled = YES;
    }
    //hug button
    hugCell.hugButtonClick.tag = indexPath.section;
    hugCell.huggedCountButton.tag = indexPath.section;
    NSArray *huggers = [_arrHugs objectAtIndex:indexPath.section];
    if (huggers.count == 0) {
        [hugCell.huggedCountButton setTitle:@"" forState:UIControlStateNormal];
        hugCell.huggedCountButton.enabled = NO;
    }else{
        [hugCell.huggedCountButton setTitle:[NSString stringWithFormat:@" %d ",(int)huggers.count] forState:UIControlStateNormal];
        hugCell.huggedCountButton.enabled = YES;
    }
    //comment button
    [hugCell.commentButtonClick setTag:indexPath.section];
    NSArray *comments = [_arrComments objectAtIndex:indexPath.section];
    if (comments.count == 0) {
        hugCell.totalCommentLabel.text = @"";
    }else {
        hugCell.totalCommentLabel.text = [NSString stringWithFormat:@" %d ",(int)comments.count];
    }
    return hugCell;
}

#pragma mark - Check Current User Hug

- (NSArray *)arrayUserHugWithCurrentUser :(NSArray *)arrayHuggers{
    NSMutableArray *arrHuggers = [NSMutableArray new];
    if ([self checkIncludeCurrentUserInArrayHugs:arrayHuggers ]) {
        for (NSDictionary *dicHugger in arrayHuggers) {
            if (![[dicHugger valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]) {
                [arrHuggers addObject:dicHugger];
            }
        }
    }else{
        NSDictionary *param = @{KEY_USER_ID:[UserSession currentSession].userId ,
                                KEY_NICK_NAME:[UserSession currentSession].username};
        arrHuggers = [NSMutableArray arrayWithArray:arrayHuggers];
        [arrHuggers addObject:param];
    }
    arrayHuggers = [NSArray arrayWithArray:arrHuggers];
    return arrHuggers;
}

- (BOOL)checkIncludeCurrentUserInArrayHugs :(NSArray *)arrayHuggers{
    for (NSDictionary *dicHugger in arrayHuggers) {
        if ([[dicHugger valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Check Current User Like

- (NSArray *)arrayUserLikeWithCurrentUser :(NSArray *)arrayLikerrs{
    NSMutableArray *arrLikers = [NSMutableArray new];
    if ([self checkIncludeCurrentUserInArrayLikes:arrayLikerrs ]) {
        for (NSDictionary *dicLiker in arrayLikerrs) {
            if (![[dicLiker valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]) {
                [arrLikers addObject:dicLiker];
            }
        }
    }else{
        NSDictionary *param = @{KEY_USER_ID:[UserSession currentSession].userId ,
                                KEY_NICK_NAME:[UserSession currentSession].username};
        arrLikers = [NSMutableArray arrayWithArray:arrayLikerrs];
        [arrLikers addObject:param];
    }
    arrayLikerrs = [NSArray arrayWithArray:arrLikers];
    return arrLikers;
}

- (BOOL)checkIncludeCurrentUserInArrayLikes :(NSArray *)arrayLikerrs{
    for (NSDictionary *dicLiker in arrayLikerrs) {
        if ([[dicLiker valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Utitlies

- (NSString *)formatSummaryStringFromRecord:(FeelingRecord *)record
{
    NSString *string = nil;
    NSMutableString *activityAndCommentString = [[NSMutableString alloc] init];
    if (record.comment.length != 0) {
        [activityAndCommentString appendFormat:@"%@", record.comment];
    }
    string = activityAndCommentString;
    return string;
}

- (NSMutableDictionary *)buildParamsDictWithToken:(NSString *)token endTime:(NSTimeInterval)endTime count:(NSUInteger)count andUserId:(NSString *)userId
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:token forKey:KEY_TOKEN_PARAM];
    [dict setObject:[NSNumber numberWithDouble:endTime] forKey:KEY_END_PARAM];
    [dict setObject:[NSNumber numberWithInteger:(count + 1)] forKey:KEY_COUNT];
    [dict setObject:userId forKey:KEY_USER_ID];
    return dict;
}

#pragma mark - UserInfor Delegate

- (void)clickedAvatarAtIndexPath:(NSNumber *)indexPath{
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.intValue];
    UserSession *userSession = [UserSession currentSession];
    
    if (userSession == nil || userSession.isGuestSession) {
        return;
    }
    
    NSDictionary *parameters = [self buildParamsDictWithToken:userSession.sessionToken endTime:record.time count:NUMBER_MAX_DATA_DOWNLOAD andUserId:record.userId];
    
    PublicProfileViewController *pubProfile = [PublicProfileViewController new];
    [pubProfile setUserId:record.userId];
    [pubProfile setUsername:record.username];
    [pubProfile setDicParamPublic:parameters];
    pubProfile.currentIndexPath = indexPath;
    [self.navigationController pushViewController:pubProfile animated:YES];
}

#pragma mark - FeelingSummery Delegate

- (void)clickedButtonStatus:(NSNumber *)indexPath{
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.intValue];
    DetailCommentsViewController *detailCommentsViewController = [DetailCommentsViewController new];
    detailCommentsViewController.username = record.username;
    detailCommentsViewController.userId = record.userId;
    detailCommentsViewController.feelingRecordCode = record.code;
    [self.navigationController pushViewController:detailCommentsViewController animated:YES];
}

#pragma mark - TextComment Delegate

- (void)clickedButtonComment:(NSNumber *)indexPath{
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.intValue];
    DetailCommentsViewController *detailCommentsViewController = [DetailCommentsViewController new];
    detailCommentsViewController.username = record.username;
    detailCommentsViewController.userId = record.userId;
    detailCommentsViewController.feelingRecordCode = record.code;
    [self.navigationController pushViewController:detailCommentsViewController animated:YES];
}

#pragma mark - Image Delegate

- (void)clickedButtonImage:(NSIndexPath *)indexPath{
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.section];
    AttachmentFullscreenViewController *controllerr = [AttachmentFullscreenViewController new];
    [controllerr setAttachFeelingCode:record.code];
    [self.navigationController pushViewController:controllerr animated:YES];
}

#pragma mark - Hug Delegate

- (void)clickedButtonActionComment:(NSNumber *)indexPath{
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.intValue];
    DetailCommentsViewController *detailCommentsViewController = [DetailCommentsViewController new];
    detailCommentsViewController.username = record.username;
    detailCommentsViewController.userId = record.userId;
    detailCommentsViewController.feelingRecordCode = record.code;
    [self.navigationController pushViewController:detailCommentsViewController animated:YES];
}

- (void)didUpdateNumberHuggerSuccessful:(NSNumber *)section {
    NSArray *arrayForIndexPath = [_arrHugs objectAtIndex:section.integerValue];
    [_arrHugs replaceObjectAtIndex:section.integerValue withObject:[self arrayUserHugWithCurrentUser:arrayForIndexPath]];
    NSInteger numberOfRows = [self.feelingTableView numberOfRowsInSection:[section integerValue]];
    NSIndexPath *indexPathToReload = [NSIndexPath indexPathForRow:(numberOfRows - 1) inSection:[section integerValue]];
    [self.feelingTableView reloadRowsAtIndexPaths:@[indexPathToReload] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didUpdateNumberLikerSuccessful:(NSNumber *)section {
    NSArray *arrayForIndexPath = [_arrLikes objectAtIndex:section.integerValue];
    [_arrLikes replaceObjectAtIndex:section.integerValue withObject:[self arrayUserLikeWithCurrentUser:arrayForIndexPath]];
    NSInteger numberOfRows = [self.feelingTableView numberOfRowsInSection:[section integerValue]];
    NSIndexPath *indexPathToReload = [NSIndexPath indexPathForRow:(numberOfRows - 1) inSection:[section integerValue]];
    [self.feelingTableView reloadRowsAtIndexPaths:@[indexPathToReload] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didUpdateNumberHuggerFail {
    
}

- (void)didUpdateNumberLikerFail{
    
}

- (void)didTouchCountHuggerButton:(NSIndexPath *)indexPath{
    NSArray *arrayForIndexPath = [_arrHugs objectAtIndex:indexPath.section];
    MoreHugsUserViewController *moreHugsUser = [[MoreHugsUserViewController alloc] init];
    moreHugsUser.titleLabel.text = NSLocalizedString(TITLE_HUGGER_MORE_USER, nil);
    moreHugsUser.arrayMoreUsers = arrayForIndexPath;
    moreHugsUser.arrayListFollowingMe = _arrayFollowingMe;
    [moreHugsUser compareListFollowing];
    [self.navigationController pushViewController:moreHugsUser animated:YES];
}

- (void)didTouchCountLikerButton:(NSIndexPath *)indexPath{
    NSArray *arrayForIndexPath = [_arrLikes objectAtIndex:indexPath.section];
    MoreHugsUserViewController *moreLikesUser = [[MoreHugsUserViewController alloc] init];
    moreLikesUser.titleLabel.text = NSLocalizedString(TITLE_LIKERS_MORE_USER, nil);
    moreLikesUser.arrayMoreUsers = arrayForIndexPath;
    moreLikesUser.arrayListFollowingMe = _arrayFollowingMe;
    [moreLikesUser compareListFollowing];
    [self.navigationController pushViewController:moreLikesUser animated:YES];
}

- (BOOL)willTouchHugButton:(NSNumber *)section {
    return allowChangeHugLike;
}

- (BOOL)willTouchLikeButton:(NSNumber *)section {
    return allowChangeHugLike;
}

#pragma mark - Update List Following With Token Me

- (void)reloadFollowingMe{
    NSDictionary * parameterss = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken,
                                   KEY_USER_ID:[UserSession currentSession].userId};
    [_baseModel getFollowingEndPointWithParameters:parameterss completion:^(id responseObject, NSError *error){
        if (!error) {
            _arrayFollowingMe = [NSMutableArray arrayWithArray:[FollowObject followObjectsWith:responseObject]];
        }else {
            NSLog(@"error = %@",error);
        }
    }];
}

@end
