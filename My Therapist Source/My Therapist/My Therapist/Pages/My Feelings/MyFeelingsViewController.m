//
//  MyFeelingsViewController.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "MyFeelingsViewController.h"
#import "UIColor+ColorUtilities.h"

static NSDateFormatter *_dateFormatter;

@implementation MyFeelingsViewController

#pragma mark - MyFeelingsViewController management

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _baseModel = [BaseModel shareBaseModel];
    _isHideHeaderView = NO;
    [self.view setBackgroundColor:[UIColor redColor]];
    [self initHeaderView];
    [self initTableView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME_TITLE_LABEL_MY_FEELINGS];
    titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_LABEL_TITLE_MY_FEELINGS);
    titleLabel.text = self.titleText;
    titleLabel.textColor = [UIColor veryLightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *menuButtonItem = myAppDelegate.revealMenuButtonItem;
    _customiNavigationLeftItems = [NSArray arrayWithObjects:menuButtonItem, nil];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.hidden = NO;
    
    UILabel *loadingTextLabel = [[UILabel alloc] init];
    loadingTextLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_LABEL_LOADING_TEXT_MY_FEELINGS);
    loadingTextLabel.text = NSLocalizedString(TEXT_LOADING_MY_FEELINGS, nil);
    [loadingTextLabel sizeToFit];
    CGRect loadingTextLabelFrame = loadingTextLabel.frame;
    loadingTextLabelFrame.origin = CGPointMake(0, HALF_OF(_activityIndicator.frame.size.height - loadingTextLabel.frame.size.height));
    loadingTextLabel.frame = loadingTextLabelFrame;
    
    CGRect activityIndicatorFrame = _activityIndicator.frame;
    activityIndicatorFrame.origin = CGPointMake(loadingTextLabel.frame.size.width + 3, 0);
    _activityIndicator.frame = activityIndicatorFrame;
    
    UIView *loadingCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, loadingTextLabel.frame.size.width + _activityIndicator.frame.size.width + 3, _activityIndicator.frame.size.height)];
    [loadingCenterView addSubview:loadingTextLabel];
    [loadingCenterView addSubview:_activityIndicator];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    separatorView.backgroundColor = [UIColor veryLightGrayColor2];
    
    _loadingIndicatorContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 28)];
    [_loadingIndicatorContainerView addSubview:separatorView];
    CGRect centerViewFrame = loadingCenterView.frame;
    centerViewFrame.origin = CGPointMake(HALF_OF(_loadingIndicatorContainerView.frame.size.width - centerViewFrame.size.width), HALF_OF(_loadingIndicatorContainerView.frame.size.height - centerViewFrame.size.height));
    loadingCenterView.frame = centerViewFrame;
    [_loadingIndicatorContainerView addSubview:loadingCenterView];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.userInteractionEnabled = NO;
    [self.view addSubview:_hud];
    _hud.labelFont = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    _avatarCache = [[NSCache alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItems = _customiNavigationLeftItems;
    
    UserSession *userSession = [UserSession currentSession];
    _userProfileView.avatarImageView.image = userSession.userAvatar;
    _userProfileView.usernameLabels.text = userSession.username;
    _userProfileView.userID = userSession.userId;
    [self downloadBackgroundProfileImage];
    [self getBiographyUserFromServer];
    [self refresh];
}

- (void)refreshDone
{
}

- (void)refresh
{
    _hud.labelText = NSLocalizedString(TEXT_LOADING_MY_FEELINGS, nil);
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud show:YES];
    
    _hasMore = YES;
    _isLoadingMoreRecords = NO;
    [_activityIndicator stopAnimating];
    self.feelingTableView.tableFooterView = nil;
    UserSession *userSession = [UserSession currentSession];
    [self.feelingRecordLoader loadRecordsWithCount:MAX_RECORD_TO_LOAD_MY_FEELINGS andUserId:userSession.userId before:nil  success:^(NSArray *records, BOOL hasMore) {
        [UserSession currentSession].latestFeelingRecords = records;
        
        [_hud hide:YES];
        
        [self setFeelingRecords:records hasMore:hasMore];
        
        [self refreshDone];
    } failure:^(NSInteger statusCode) {
        _hud.labelText = NSLocalizedString(TEXT_LOAD_FAILED_MY_FEELINGS, nil);
        [_hud hide:YES afterDelay:TIME_DELAY_HIDE_HUD];
        
        [self refreshDone];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setRefreshOnce:(BOOL)refreshOnce
{
    _refreshOnce = refreshOnce;
}

- (void)setFeelingRecords:(NSArray *)feelingRecords hasMore:(BOOL)hasMore
{
    if (_arrHugs == nil) {
        _arrHugs = [[NSMutableArray alloc] init];
    }
    if (_feelingRecords == nil) {
        _feelingRecords = [[NSMutableArray alloc] init];
    }
    if (_arrLikes == nil) {
        _arrLikes = [[NSMutableArray alloc] init];
    }
    
    if (_arrComments == nil) {
        _arrComments = [[NSMutableArray alloc] init];
    }
    
    [_arrHugs removeAllObjects];
    [_arrLikes removeAllObjects];
    [_arrComments removeAllObjects];
    
    for(FeelingRecord *record in feelingRecords){
        [_arrHugs addObject:record.huggerDict];
        [_arrLikes addObject:record.likerDict];
        [_arrComments addObject:record.commentDict];
    }

    [_feelingRecords removeAllObjects];
    [_feelingRecords addObjectsFromArray:feelingRecords];
    allowChangeHugLike = YES;
    _hasMore = hasMore;
    [self.feelingTableView reloadData];

}

- (void)addFeelingRecord:(FeelingRecord *)feelingRecord
{
    [_feelingRecords insertObject:feelingRecord atIndex:0];
    [self.feelingTableView reloadData];
    [self.feelingTableView scrollsToTop];
}

- (void)deleteFeelingRecord:(FeelingRecord *)feelingRecord
{
    NSInteger index = -1;
    for (int i = 0; i < _feelingRecords.count; ++i) {
        if ([((FeelingRecord *)[_feelingRecords objectAtIndex:i]).recordId caseInsensitiveCompare:feelingRecord.recordId] == NSOrderedSame) {
            index = i;
            break;
        }
    }
    
    if (index >= 0) {
        [_feelingRecords removeObjectAtIndex:index];
        [self.feelingTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = HEIGHT_TABLE_ROW_MY_FEELINGS;
    
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        height = [UserInfoCell cellHeight];
    } else if (indexPath.row == record.feelings.count + 1) {
        if (record.comment.length > 0) {
            NSString *commentString = record.comment;
            height = ceilf(commentString != nil ? ([commentString heightForFont:COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_LABEL_COMMENT_MY_FEELINGS) andWidth:WIDTH_LABEL_COMMENT_MY_FEELINGS] + 5) : 0);
        } else if (record.thumbnailPath.length > 0) {
            height = [ImageAttachmentCell cellHeight];
        } else {
            height = [HugCell cellHeight];
        }
    } else if (indexPath.row == record.feelings.count + 2) {
        if (record.comment.length > 0 && record.thumbnailPath.length > 0) {
            height = [ImageAttachmentCell cellHeight];
        } else {
            height = [HugCell cellHeight];
        }
    } else if (indexPath.row == record.feelings.count + 3) {
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

- (FeelingRecordLoader *)feelingRecordLoader
{
    if (_feelingRecordLoader == nil) {
        _feelingRecordLoader = [[FeelingRecordLoader alloc] init];
        _feelingRecordLoader.hud = _hud;
    }
    return _feelingRecordLoader;
}

- (void)loadMoreDataIfNeededFromIndexPath:(NSIndexPath *)indexPath
{
    @synchronized(self) {
        if (_feelingRecords.count - indexPath.section < 3 && !_isLoadingMoreRecords && _hasMore) {
            FeelingRecord *earliestRecord = _feelingRecords.lastObject;
            if (earliestRecord) {
                NSTimeInterval time = earliestRecord.time;
                _isLoadingMoreRecords = YES;
                
                [UIView animateWithDuration:0.2 animations:^(void) {
                    [_activityIndicator startAnimating];
                    self.feelingTableView.tableFooterView = _loadingIndicatorContainerView;
                } completion:^(BOOL finished) {
                    UserSession *userSession = [UserSession currentSession];
                    [self.feelingRecordLoader loadRecordsWithEndTime:time count:SIZE_BATCH withUserId:userSession.userId before:nil success:^(NSArray *records, BOOL hasMore)
                     {
                         @synchronized(self) {
                             NSMutableIndexSet *sectionsToUpdate = [[NSMutableIndexSet alloc] init];
                             NSMutableArray *rowsToUpdate = [[NSMutableArray alloc] init];
                             for (int i = 0; i < records.count; ++i) {
                                 NSInteger section = _feelingRecords.count + i;
                                 [sectionsToUpdate addIndex:section];
                                 
                                 FeelingRecord *record = [records objectAtIndex:i];
                                 for (int j = 0; j < record.feelings.count; ++j) {
                                     NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:section];
                                     [rowsToUpdate addObject:path];
                                 }
                             }
                             
                             [_feelingRecords addObjectsFromArray:records];
                             
                             for(FeelingRecord *record in records){
                                 [_arrHugs addObject:record.huggerDict];
                             }
                             
                             for(FeelingRecord *record in records){
                                 [_arrLikes addObject:record.likerDict];
                             }
                             
                             [self.feelingTableView beginUpdates];
                             [self.feelingTableView insertSections:sectionsToUpdate withRowAnimation:UITableViewRowAnimationFade];
                             [self.feelingTableView insertRowsAtIndexPaths:rowsToUpdate withRowAnimation:UITableViewRowAnimationFade];
                             [self.feelingTableView endUpdates];
                             
                             [UIView animateWithDuration:0.2 animations:^(void) {
                                 [_activityIndicator stopAnimating];
                                 self.feelingTableView.tableFooterView = nil;
                             }];
                             
                             _isLoadingMoreRecords = NO;
                             _hasMore = hasMore;
                         }
                     } failure:^(NSInteger code) {
                         [UIView animateWithDuration:0.2 animations:^(void) {
                             [_activityIndicator stopAnimating];
                             self.feelingTableView.tableFooterView = nil;
                         }];
                         
                         _isLoadingMoreRecords = NO;
                     }];
                }];
            }
        }
    }
}
#pragma mark - TableView Delegate & Datasource
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
            NSDictionary *parameter = @{KEY_USER_ID: record.userId};
            [_baseModel getUserAvatarWithParameters:parameter completion:^(id responseObject, NSError *error){
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
            textFrame.size.width = 280;
            textCell.textView.frame = textFrame;
            
            CGRect containerFrame = textCell.containerView.frame;
            containerFrame.size.height = textCell.textView.frame.size.height;
            textCell.containerView.frame = containerFrame;
            textCell.btnComment.frame = containerFrame;
            textCell.delegate = self;
            [textCell.btnComment setTag:indexPath.section];
            tableCell = textCell;
        } else if (record.thumbnailPath.length > 0) {
            ImageAttachmentCell *imageCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_ATTACHMENT_CELL];
            if (imageCell == nil) {
                imageCell = [[ImageAttachmentCell alloc] initWithReuseIdentifier:IDENTIFIER_ATTACHMENT_CELL];
            }
            [imageCell setFeelingRecord:record];
            [imageCell setDelegate:self];
            [imageCell.btnImage setTag:indexPath.section];
            tableCell = imageCell;
        } else {
            tableCell = [self hugCellWithIndexPath:indexPath andFeelingRecord:record andTableView:tableView];
        }
    } else if (indexPath.row == record.feelings.count + 2) {
        if ( record.comment.length > 0 && record.thumbnailPath.length > 0) {
            ImageAttachmentCell *imageCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_ATTACHMENT_CELL];
            if (imageCell == nil) {
                imageCell = [[ImageAttachmentCell alloc] initWithReuseIdentifier:IDENTIFIER_ATTACHMENT_CELL];
            }
            [imageCell setFeelingRecord:record];
            [imageCell setDelegate:self];
            [imageCell.btnImage setTag:indexPath.section];
            tableCell = imageCell;
        } else {
            tableCell = [self hugCellWithIndexPath:indexPath andFeelingRecord:record andTableView:tableView];
        }
    } else if (indexPath.row == record.feelings.count + 3) {
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
    }else{
        [hugCell.likedCountButton setTitle:[NSString stringWithFormat:@" %d ",(int)likers.count] forState:UIControlStateNormal];
    }
    //hug button
    hugCell.hugButtonClick.tag = indexPath.section;
    hugCell.huggedCountButton.tag = indexPath.section;
    NSArray *huggers = [_arrHugs objectAtIndex:indexPath.section];
    if (huggers.count == 0) {
        [hugCell.huggedCountButton setTitle:@"" forState:UIControlStateNormal];
    }else{
        [hugCell.huggedCountButton setTitle:[NSString stringWithFormat:@" %d ",(int)huggers.count] forState:UIControlStateNormal];
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

#pragma mark - Utitlies

- (NSString *)formatSummaryStringFromRecord:(FeelingRecord *)record
{
    NSString *string = nil;
    if (record.activityIndex != 0 || record.comment.length > 0) {
        NSMutableString *activityAndCommentString = [[NSMutableString alloc] init];
        if (record.activityIndex != 0) {
            [activityAndCommentString appendFormat:@"%@%@", NSLocalizedString(TEXT_I_WAS_MY_FEELINGS, nil), record.activityName];
        }
        if (record.comment.length != 0) {
            if (record.activityIndex != 0) {
                [activityAndCommentString appendString:@"\n"];
            }
            [activityAndCommentString appendFormat:@"%@", record.comment];
        }
        string = activityAndCommentString;
    }
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

- (NSString *)titleText
{
    return NSLocalizedString(TITLE_APPLICATION, nil);
}

- (void)toggledPublicForFeelingRecord:(FeelingRecord *)record
{
    for (int i = 0; i < _feelingRecords.count; ++i) {
        FeelingRecord *cRecord = [_feelingRecords objectAtIndex:i];
        if ([cRecord.recordId caseInsensitiveCompare:record.recordId] == NSOrderedSame) {
            cRecord.isPublic = record.isPublic;
            break;
        }
    }
}

- (void)setFeelingRecordTherapy:(FeelingRecord *)feelingRecord{
    _feelingRecord = feelingRecord;
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

#pragma mark - Hug Delegate

- (void)clickedButtonActionComment:(NSNumber *)indexPath{
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.intValue];
    DetailCommentsViewController *detailCommentsViewController = [DetailCommentsViewController new];
    detailCommentsViewController.username = record.username;
    detailCommentsViewController.userId = record.userId;
    detailCommentsViewController.feelingRecordCode = record.code;
    [self.navigationController pushViewController:detailCommentsViewController animated:YES];
}

- (void)didTouchCountHuggerButton:(NSIndexPath *)indexPath {
    NSArray *arrayForIndexPath = [_arrHugs objectAtIndex:indexPath.section];
    MoreHugsUserViewController *moreHugsUser = [[MoreHugsUserViewController alloc] init];
    moreHugsUser.titleLabel.text = NSLocalizedString(TITLE_HUGGER_MORE_USER, nil);
    moreHugsUser.arrayMoreUsers = arrayForIndexPath;
    moreHugsUser.arrayListFollowingMe = _arrayFollowingMe;
    [moreHugsUser compareListFollowing];
    [self.navigationController pushViewController:moreHugsUser animated:YES];
}

- (void)didTouchCountLikerButton:(NSIndexPath *)indexPath {
    NSArray *arrayForIndexPath = [_arrLikes objectAtIndex:indexPath.section];
    MoreHugsUserViewController *moreLikesUser = [[MoreHugsUserViewController alloc] init];
    moreLikesUser.titleLabel.text = NSLocalizedString(TITLE_LIKERS_MORE_USER, nil);
    moreLikesUser.arrayMoreUsers = arrayForIndexPath;
    moreLikesUser.arrayListFollowingMe = _arrayFollowingMe;
    [moreLikesUser compareListFollowing];
    [self.navigationController pushViewController:moreLikesUser animated:YES];
}

#pragma mark - Emoji Delegate

- (void)clickedButtonStatus:(NSNumber *)indexPath{
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.intValue];
    MyTherapyViewController *nextViewController = [MyTherapyViewController new];
    [nextViewController setUsername:record.username];
    [nextViewController setSubtitle:record.username];
    [nextViewController setUserId:record.userId];
    [nextViewController setFeelingRecordTherapy:record];
    [self.navigationController pushViewController:nextViewController animated:YES];
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

#pragma mark - Init View

- (void)initTableView {
    self.feelingTableView = [[UITableView alloc] init];
    self.feelingTableView.showsVerticalScrollIndicator = NO;
    self.feelingTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.feelingTableView];
    // Constaint - Top
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.feelingTableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    // Constaint - Right
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.feelingTableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    // Constaint - Left
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.feelingTableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    // Constaint - Bottom
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.feelingTableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    self.feelingTableView.dataSource = self;
    self.feelingTableView.delegate = self;
    self.feelingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self showHeaderView];
}

- (void)initHeaderView {
    _userProfileView = [[UserProfileView alloc]initWithFrame:CGRectZero];
    _userProfileView.bottomView.hidden = YES;
    _userProfileView.heightConstaintBottomView.constant = 0;
    _userProfileView.separatorView.hidden = YES;
    _userProfileView.heightDefaultProfileView = _heightProfileView = USER_PROFILE_HEADER_DEFAULT_HEIGHT_WITHOUT_BOTTOM_VIEW;
    CGRect profileViewFrame = _userProfileView.frame;
    profileViewFrame.origin.y = -_heightProfileView;
    profileViewFrame.size.height = _heightProfileView;
    _userProfileView.frame = profileViewFrame;
    _userProfileView.delegate = self;
}

- (void)showHeaderView {
    self.feelingTableView.contentInset = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
    [self.feelingTableView addSubview:_userProfileView];
    self.feelingTableView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
    _isHideHeaderView = NO;
}

- (void)hideHeaderView {
    self.feelingTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_userProfileView removeFromSuperview];
    self.feelingTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _isHideHeaderView = YES;
}

#pragma mark - Custom Methods

- (void)downloadBackgroundProfileImage {
    if (!_isHideHeaderView) {
        UserSession *userSession = [UserSession currentSession];
        UIImage *defaultBackgroundImage = [UIImage imageNamed:IMAGE_NAME_AUTUMN_COLOR];
        if ((userSession.backgroundImage)) {
            _userProfileView.profileBackgroundImageView.image = userSession.backgroundImage;
        }else {
            NSDictionary *parameters = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken, KEY_USER_ID:[UserSession currentSession].userId};
            [_baseModel downloadUserImageWithParameters:parameters andImageKey:KEY_IMAGE_COVER completion:^(id responseObject, NSError *error){
                if (!error) {
                    UIImage *userProfileBackgroundImage = responseObject;
                    _userProfileView.profileBackgroundImageView.image = (userProfileBackgroundImage)?userProfileBackgroundImage:defaultBackgroundImage;
                }else {
                    NSLog(@"Couldn't complete with error: %@",error);
                }
            }];
        }
    }
}

- (void)getBiographyUserFromServer {
    if (!_isHideHeaderView) {
        UserSession *userSession = [UserSession currentSession];
        if (userSession.userBiography && ![userSession.userBiography isEqualToString:@""]) {
            [_userProfileView setValueBiographyTextViewWithString:userSession.userBiography];
        }else {
            NSDictionary *parameters = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken, KEY_USER_ID:[UserSession currentSession].userId};
            [_baseModel getUserEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
                if (!error) {
                    NSDictionary *userDataDict = (NSDictionary *)[responseObject objectForKey:KEY_USER];
                    NSString *biograyphy = [userDataDict objectForKey:KEY_BIOGRAPHY];
                    [_userProfileView setValueBiographyTextViewWithString:biograyphy];
                }else {
                    NSLog(@"Couldn't complete with error: %@",error);
                }
            }];
            
        }
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _feelingTableView) {
        if (!_isHideHeaderView) {
            CGFloat yOffset  = scrollView.contentOffset.y;
            if (yOffset < -_heightProfileView) {
                CGRect fixedFrame = _userProfileView.frame;
                fixedFrame.origin.y = yOffset;
                fixedFrame.size.height =  -yOffset;
                _userProfileView.frame = fixedFrame;
                _feelingTableView.scrollIndicatorInsets = UIEdgeInsetsMake(-yOffset, 0, 0, 0);
            }else{
                CGRect fixedFrame = _userProfileView.frame;
                fixedFrame.origin.y = yOffset;
                _userProfileView.frame = fixedFrame;
                _feelingTableView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
            }
        }
    }
}

#pragma mark - UserProfile Delegate

- (void)updateScrollIndicatorInset:(UIEdgeInsets)edgeInsets userProfileView:(UserProfileView *)userProfileView{
    _heightProfileView = _userProfileView.heightProfileView;
    self.feelingTableView.scrollIndicatorInsets = edgeInsets;
}

- (void)updateTableContentInset:(UIEdgeInsets)edgeInsets userProfileView:(UserProfileView *)userProfileView{
    self.feelingTableView.contentInset = edgeInsets;
    [self.feelingTableView setContentOffset:CGPointMake(0, self.feelingTableView.contentOffset.y) animated:YES];
}

- (void)textViewDidScroll:(UIScrollView *)scrollView userProfileView:(UserProfileView *)userProfileView {
    CGFloat xOffset  = scrollView.contentOffset.x;
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGRect rect = CGRectMake(xOffset, yOffset, userProfileView.biographyTextView.frame.size.width, userProfileView.biographyTextView.frame.size.height);
    if (userProfileView != _userProfileView) {
        [_userProfileView.biographyTextView scrollRectToVisible:rect animated:NO];
    }
}

@end
