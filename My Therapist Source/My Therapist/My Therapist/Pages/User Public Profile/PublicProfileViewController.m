//
//  PublicProfileViewController.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "PublicProfileViewController.h"
#import "MoreHugsUserViewController.h"

static NSDateFormatter *_dateFormatter;

@implementation PublicProfileViewController{
    UIBarButtonItem *_settingButtonItem;
    NSCache *_avatarCache;
    UIView *_loadingIndicatorContainerView;
    UIActivityIndicatorView *_activityIndicator;
    NSArray *_customiNavigationLeftItems;
    FeelingRecord *_feelingRecord;
    PublicFeelingRecordLoader *_publicFeelingRecordLoader;
    FeelingRecordLoader *_feelingRecordLoader;
    BOOL _refreshOnce;
    BOOL _hasMore, _isLoadingMoreRecords;
    FollowerTableViewController *followerTableViewController ;
    FollowingTableViewController *followingTableViewController ;
}

#pragma mark - PublicProfileViewController management

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setUserProfileName];
    [self setUserProfileAvatar];
    [self reloadFollowingMe];
    [self getBiographyAndBackgroundUserFromServer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _baseModel = [BaseModel shareBaseModel];
    [self initProfileView];
    [self initTopBar];
    [self initLoadingView];
    
    // Table View
    _contentTableView.showsVerticalScrollIndicator = YES;
    _contentTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.hidden = NO;
    _arrayListFollower = [NSMutableArray new];
    _arrayListFollowing = [NSMutableArray new];
    _arrayListFollowingMe = [NSMutableArray new];
    
    //table follower
    followerTableViewController = [[FollowerTableViewController alloc]init];
    followerTableViewController.tableView.frame = _contentTableView.frame;
    followerTableViewController.delegate = self;
    [self.contentview insertSubview:followerTableViewController.tableView aboveSubview:_contentTableView];
    followerTableViewController.tableView.hidden = YES;
    
    //table following
    followingTableViewController = [[FollowingTableViewController alloc]init];
    followingTableViewController.tableView.frame = _contentTableView.frame;
    followingTableViewController.delegate = self;
    [self.contentview insertSubview:followingTableViewController.tableView aboveSubview:_contentTableView];
    followingTableViewController.tableView.hidden = YES;
    
    _checkinsView.hidden = NO;
    _followersView.hidden = YES;
    _followingsView.hidden = YES;
    
    // Setting backgound Profile
    self.contentTableView.contentInset = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
    followerTableViewController.tableView.contentInset = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
    followingTableViewController.tableView.contentInset = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
    
    [self.contentTableView addSubview:_userProfileViewForCheckins];
    [followerTableViewController.tableView addSubview:_userProfileViewForFollower];
    [followingTableViewController.tableView addSubview:_userProfileViewForFollowing];
    
    self.contentTableView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
    followerTableViewController.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
    followingTableViewController.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initTopBar {
    // Back Button
    self.navigationItem.hidesBackButton = YES;
    UIImage *backImage = [UIImage imageNamed:IMAGE_NAME_BACK_BUTTON];
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setFrame:FRAME_BACK_BUTTON_PUBLIC_PROFILE_VIEW];
    [_backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_backButton];
    UIBarButtonItem *barButtonItemTest = [[UIBarButtonItem alloc] init];
    barButtonItemTest.image = backImage;
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    // Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME_TITLE_LABEL_PUBLIC_PROFILE_VIEW];
    titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(FONT_SIZE_TITLE_PUBLIC_PROFILE_VIEW);
    titleLabel.text = NSLocalizedString(TITLE_PUBLIC_PROFILE_VIEW, nil);
    titleLabel.textColor = [UIColor veryLightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    // Follows
    UIImage *settingsImage = [UIImage imageNamed:IMAGE_NAME_FOLLOW];
    _followsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followsButton setFrame:FRAME_FOLLOWS_BUTTON_PUBLIC_PROFILE_VIEW];
    [_followsButton setBackgroundImage:settingsImage forState:UIControlStateNormal];
    [_followsButton addTarget:self action:@selector(followPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonFollows = [[UIBarButtonItem alloc]initWithCustomView:_followsButton];
    self.navigationItem.rightBarButtonItem = barButtonFollows;
    _followsButton.hidden = ([[UserSession currentSession].userId isEqualToString:_userId])?YES:NO;
}

- (void)initLoadingView {
    UILabel *loadingTextLabel = [[UILabel alloc] init];
    loadingTextLabel.font = COMMON_BEBAS_FONT(FONT_SIZE_LOADING_TEXT_LABEL_PUBLIC_PROFILE_VIEW);
    loadingTextLabel.text = NSLocalizedString(TEXT_LOADING_PUBLIC_PROFILE_VIEW, nil);
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
}

#pragma mark - Actions

- (void)backButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Button follow top left

-(void)followPress{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{KEY_TOKEN_PARAM: [UserSession currentSession].sessionToken,
                                 KEY_TOU_ID: _userId};
    [_baseModel getFollowEndPointWithParameters:parameters completion:^(id responseObject,NSError *error){
        if (!error) {
            NSLog(@"Success = %@",responseObject);
            if ([[responseObject objectForKey:KEY_STATUS]isEqualToString:TEXT_FOLLOWED_PUBLIC_PROFILE_VIEW] || [[responseObject objectForKey:KEY_STATUS]isEqualToString:TEXT_FRIEND_PUBLIC_PROFILE_VIEW]) {
                [_followsButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_UNFOLLOW] forState:UIControlStateNormal];
            }else if ([[responseObject objectForKey:KEY_STATUS]isEqualToString:TEXT_UNFOLLOWED_PUBLIC_PROFILE_VIEW]){
                [_followsButton setBackgroundImage:[UIImage imageNamed:TEXT_FOLLOW_PUBLIC_PROFILE_VIEW] forState:UIControlStateNormal];
            }
            [self reloadFollower];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }else {
            NSLog(@"Error = %@", error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
    
}

#pragma mark - Refresh function

- (void)setRefreshOnce:(BOOL)refreshOnce
{
    _refreshOnce = refreshOnce;
}

- (void)setFeelingRecords:(NSArray *)feelingRecords hasMore:(BOOL)hasMore
{
    if (_feelingRecords == nil) {
        _feelingRecords = [[NSMutableArray alloc] init];
    }
    if (_arrayHugDetails == nil) {
        _arrayHugDetails = [[NSMutableArray alloc] init];
    }
    if (_arrayLikeDetails == nil) {
        _arrayLikeDetails = [[NSMutableArray alloc] init];
    }
    if (_arrayCommentDetails == nil) {
        _arrayCommentDetails = [[NSMutableArray alloc] init];
    }
    [_arrayHugDetails removeAllObjects];
    [_arrayLikeDetails removeAllObjects];
    [_arrayCommentDetails removeAllObjects];
    
    for(FeelingRecord *record in feelingRecords){
        [_arrayHugDetails addObject:record.huggerDict];
        [_arrayLikeDetails addObject:record.likerDict];
        [_arrayCommentDetails addObject:record.commentDict];
    }
    
    [_feelingRecords removeAllObjects];
    [_feelingRecords addObjectsFromArray:feelingRecords];
    _hasMore = hasMore;
    
    [self.contentTableView reloadData];
}

- (void)loadMoreDataIfNeededFromIndexPath:(NSIndexPath *)indexPath
{
    NSString *userId = [_dicParamPublic objectForKey:KEY_USER_ID];
    
    @synchronized(self) {
        
        if (_feelingRecords.count - indexPath.section < 3 && !_isLoadingMoreRecords && _hasMore) {
            FeelingRecord *earliestRecord = _feelingRecords.lastObject;
            if (earliestRecord) {
                NSTimeInterval time = earliestRecord.time;
                _isLoadingMoreRecords = YES;
                
                [UIView animateWithDuration:0.2 animations:^(void) {
                    [_activityIndicator startAnimating];
                    self.contentTableView.tableFooterView = _loadingIndicatorContainerView;
                } completion:^(BOOL finished) {
                    [self.feelingRecordLoader loadRecordsWithEndTime:time count:SIZE_BATCH withUserId:userId before:nil success:^(NSArray *records, BOOL hasMore) {
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
                            
                            [self.contentTableView beginUpdates];
                            [self.contentTableView insertSections:sectionsToUpdate withRowAnimation:UITableViewRowAnimationFade];
                            [self.contentTableView insertRowsAtIndexPaths:rowsToUpdate withRowAnimation:UITableViewRowAnimationFade];
                            [self.contentTableView endUpdates];
                            
                            [UIView animateWithDuration:0.2 animations:^(void) {
                                [_activityIndicator stopAnimating];
                                self.contentTableView.tableFooterView = nil;
                            }];
                            
                            _isLoadingMoreRecords = NO;
                            _hasMore = hasMore;
                        }
                    } failure:^(NSInteger code) {
                        [UIView animateWithDuration:0.2 animations:^(void) {
                            [_activityIndicator stopAnimating];
                            self.contentTableView.tableFooterView = nil;
                        }];
                        
                        _isLoadingMoreRecords = NO;
                    }];
                }];
            }
        }
    }
}

- (void)refreshDone
{
    allowToClickHugLike = YES;
}

- (void)refresh
{
    _hasMore = YES;
    _isLoadingMoreRecords = NO;
    [_activityIndicator stopAnimating];
    self.contentTableView.tableFooterView = nil;
    NSString *userId = [_dicParamPublic objectForKey:KEY_USER_ID];
    MBProgressHUD *hubCheckins = [MBProgressHUD showHUDAddedTo:_checkinsView animated:YES];
    hubCheckins.userInteractionEnabled = NO;
    allowToClickHugLike = NO;
    [self.feelingRecordLoader loadRecordsWithCount:NUMBER_MAX_DATA_DOWNLOAD andUserId:userId before:nil success:^(NSArray *records, BOOL hasMore) {
        [UserSession currentSession].latestFeelingRecords = records;
        
        [self setFeelingRecords:records hasMore:hasMore];
        
        [self refreshDone];
        [MBProgressHUD hideHUDForView:_checkinsView animated:YES];
    } failure:^(NSInteger statusCode) {
        [self refreshDone];
    }];
}

#pragma mark - Summary Delegate

- (void)addFeelingRecord:(FeelingRecord *)feelingRecord
{
    [_feelingRecords insertObject:feelingRecord atIndex:0];
    [self.contentTableView reloadData];
    [self.contentTableView scrollsToTop];
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
        [self.contentTableView reloadData];
    }
}

- (FeelingRecordLoader *)feelingRecordLoader
{
    if (_feelingRecordLoader == nil) {
        _feelingRecordLoader = [[FeelingRecordLoader alloc] init];
        _feelingRecordLoader.hud = _hud;
    }
    return _feelingRecordLoader;
}


- (NSString *)formatSummaryStringFromRecord:(FeelingRecord *)record
{
    NSString *string = nil;
    if (record.activityIndex != 0 || record.comment.length > 0) {
        NSMutableString *activityAndCommentString = [[NSMutableString alloc] init];
        if (record.activityIndex != 0) {
            [activityAndCommentString appendFormat:@"%@%@", NSLocalizedString(TEXT_I_WAS_PUBLIC_PROFILE_VIEW, nil), record.activityName];
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

#pragma mark - TableView Delagate & Datasource


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
    CGFloat height = 42;
    
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        height = [UserInfoCell cellHeight];
    } else if (indexPath.row == record.feelings.count + 1) {
        if (record.comment.length > 0) {
            NSString *commentString = record.comment;
            height = ceilf(commentString != nil ? ([commentString heightForFont:COMMON_LEAGUE_GOTHIC_FONT(FONT_SIZE_USER_INFO_CELL_PUBLIC_PROFILE_VIEW) andWidth:280] + 5) : 0);
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
    [self setCheckinsLabel];
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
            NSDictionary *parameters = @{KEY_USER_ID: record.userId};
            [_baseModel getUserAvatarWithParameters:parameters completion:^(id responseObject, NSError *error){
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
        if (record.comment.length > 0 && record.thumbnailPath.length > 0) {
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
    
    //like button
    hugCell.likeButtonClick.tag = indexPath.section;
    hugCell.likedCountButton.tag = indexPath.section;
    NSArray *likers = [_arrayLikeDetails objectAtIndex:indexPath.section];
    if (likers.count == 0 ) {
        [hugCell.likedCountButton setTitle:@"" forState:UIControlStateNormal];
    }else{
        [hugCell.likedCountButton setTitle:[NSString stringWithFormat:@" %d ",(int)likers.count] forState:UIControlStateNormal];
    }
    
    [hugCell.likeButton setImage:[UIImage imageNamed:IMAGE_NAME_THUMB_UP] forState:UIControlStateNormal];
    hugCell.likeTextLabel.textColor = [UIColor grayColor];
    [hugCell.likedCountButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    for (NSDictionary *dicLiker in [_arrayLikeDetails objectAtIndex:indexPath.section]) { //
        if ([[dicLiker valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]) {
            [hugCell.likeButton setImage:[UIImage imageNamed:IMAGE_NAME_THUMB_UP_SELECTED] forState:UIControlStateNormal];
            hugCell.likeTextLabel.textColor = [UIColor darkModerateCyanColor];
            [hugCell.likedCountButton setTitleColor:[UIColor darkModerateCyanColor] forState:UIControlStateNormal];
            break;
        }
    }
    //hug button
    hugCell.hugButtonClick.tag = indexPath.section;
    hugCell.huggedCountButton.tag = indexPath.section;
    NSArray *huggers = [_arrayHugDetails objectAtIndex:indexPath.section];
    if (huggers.count == 0) {
        [hugCell.huggedCountButton setTitle:@"" forState:UIControlStateNormal];
    }else{
        [hugCell.huggedCountButton setTitle:[NSString stringWithFormat:@" %d ",(int)huggers.count] forState:UIControlStateNormal];
    }
    
    [hugCell.hugButton setImage:[UIImage imageNamed:IMAGE_NAME_HEART_64] forState:UIControlStateNormal];
    hugCell.hugTextLabel.textColor = [UIColor grayColor];
    [hugCell.huggedCountButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    for (NSDictionary *dicHugger in [_arrayHugDetails objectAtIndex:indexPath.section]) { //
        if ([[dicHugger valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]){
            [hugCell.hugButton setImage:[UIImage imageNamed:IMAGE_NAME_HEART_64_SELECTED] forState:UIControlStateNormal];
            hugCell.hugTextLabel.textColor = [UIColor darkModerateCyanColor];
            [hugCell.huggedCountButton setTitleColor:[UIColor darkModerateCyanColor] forState:UIControlStateNormal];
            break;
        }
    }
    
    // Comment button
    hugCell.commentButtonClick.tag = indexPath.section;
    NSArray *comments = [_arrayCommentDetails objectAtIndex:indexPath.section];
    if (comments.count == 0) {
        hugCell.totalCommentLabel.text = @"";
    }else {
        hugCell.totalCommentLabel.text = [NSString stringWithFormat:@" %d ",(int)comments.count];
    }
    [hugCell.commentButton setImage:[UIImage imageNamed:IMAGE_NAME_COMMENT_32_NORMAL] forState:UIControlStateNormal];
    hugCell.commentTextLabel.textColor = [UIColor grayColor];
    hugCell.totalCommentLabel.textColor = [UIColor grayColor];
    for (NSDictionary *dicComment in [_arrayCommentDetails objectAtIndex:indexPath.section]) {
        if ([[dicComment valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]){
            [hugCell.commentButton setImage:[UIImage imageNamed:IMAGE_NAME_COMMENT_32] forState:UIControlStateNormal];
            hugCell.commentTextLabel.textColor = [UIColor darkModerateCyanColor];
            hugCell.totalCommentLabel.textColor = [UIColor darkModerateCyanColor];
            break;
        }
    }
    
    return hugCell;
}

-(void)showDetailViewControllerAtIndex:(NSNumber*)index{
    FeelingRecord *record = [_feelingRecords objectAtIndex:index.intValue];
    DetailCommentsViewController *detailCommentsViewController = [DetailCommentsViewController new];
    detailCommentsViewController.username = record.username;
    detailCommentsViewController.userId = record.userId;
    detailCommentsViewController.feelingRecordCode = record.code;
    [self.navigationController pushViewController:detailCommentsViewController animated:YES];
}

#pragma mark - Click Emotion Image

- (void)clickedButtonStatus:(NSNumber *)indexPath{
    [self showDetailViewControllerAtIndex:indexPath];
}

#pragma mark - TextComment Delegate

- (void)clickedButtonComment:(NSNumber *)indexPath{
    [self showDetailViewControllerAtIndex:indexPath];
}

#pragma mark - Hug Delegate

- (void)clickedButtonActionComment:(NSNumber *)indexPath{
    [self showDetailViewControllerAtIndex:indexPath];
}

- (void)didUpdateNumberHuggerSuccessful:(NSNumber *)section {
    NSMutableArray *arrayForIndexPath = [_arrayHugDetails objectAtIndex:section.integerValue];
    [_arrayHugDetails replaceObjectAtIndex:section.integerValue withObject:[self arrayUserHugWithCurrentUser:arrayForIndexPath]];
    NSInteger numberOfRows = [self.contentTableView numberOfRowsInSection:[section integerValue]];
    NSIndexPath *indexPathToReload = [NSIndexPath indexPathForRow:(numberOfRows - 1) inSection:[section integerValue]];
    [self.contentTableView reloadRowsAtIndexPaths:@[indexPathToReload] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didUpdateNumberHuggerFail{
}

- (void)didUpdateNumberLikerSuccessful:(NSNumber *)section{
    NSMutableArray *arrayForIndexPath = [_arrayLikeDetails objectAtIndex:section.integerValue];
    [_arrayLikeDetails replaceObjectAtIndex:section.integerValue withObject:[self arrayUserLikeWithCurrentUser:arrayForIndexPath]];
    NSInteger numberOfRows = [self.contentTableView numberOfRowsInSection:[section integerValue]];
    NSIndexPath *indexPathToReload = [NSIndexPath indexPathForRow:(numberOfRows - 1) inSection:[section integerValue]];
    [self.contentTableView reloadRowsAtIndexPaths:@[indexPathToReload] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didUpdateNumberLikerFail{
}

- (void)didTouchCountHuggerButton:(NSIndexPath *)indexPath {
    NSArray *arrayForIndexPath = [_arrayHugDetails objectAtIndex:indexPath.section];
    MoreHugsUserViewController *moreHugsUser = [[MoreHugsUserViewController alloc] init];
    moreHugsUser.titleLabel.text = NSLocalizedString(TITLE_HUGGER_MORE_USER, nil);
    moreHugsUser.arrayMoreUsers = arrayForIndexPath;
    moreHugsUser.arrayListFollowingMe = _arrayListFollowingMe;
    [moreHugsUser compareListFollowing];
    [self.navigationController pushViewController:moreHugsUser animated:YES];
}

- (void)didTouchCountLikerButton:(NSIndexPath *)indexPath {
    NSArray *arrayForIndexPath = [_arrayLikeDetails objectAtIndex:indexPath.section];
    MoreHugsUserViewController *moreLikesUser = [[MoreHugsUserViewController alloc] init];
    moreLikesUser.titleLabel.text = NSLocalizedString(TITLE_LIKERS_MORE_USER, nil);
    moreLikesUser.arrayMoreUsers = arrayForIndexPath;
    moreLikesUser.arrayListFollowingMe = _arrayListFollowingMe;
    [moreLikesUser compareListFollowing];
    [self.navigationController pushViewController:moreLikesUser animated:YES];
}

- (BOOL)willTouchHugButton:(NSNumber *)section {
    return allowToClickHugLike;
}

- (BOOL)willTouchLikeButton:(NSNumber *)section {
    return allowToClickHugLike;
}

#pragma mark - Image Delegate

- (void)clickedButtonImage:(NSIndexPath *)indexPath{
    FeelingRecord *record = [_feelingRecords objectAtIndex:indexPath.section];
    AttachmentFullscreenViewController *controllerr = [AttachmentFullscreenViewController new];
    [controllerr setAttachFeelingCode:record.code];
    [self.navigationController pushViewController:controllerr animated:YES];
}

#pragma mark - Check Current User Like

- (NSArray *)arrayUserLikeWithCurrentUser :(NSArray *)arrayLikes{
    NSMutableArray *arrLikes = [NSMutableArray new];
    if ([self checkIncludeCurrentUserInArrayLikes:arrayLikes ]) {
        for (NSDictionary *dicLikerr in arrayLikes) {
            if (![[dicLikerr valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]) {
                [arrLikes addObject:dicLikerr];
            }
        }
    }else{
        NSDictionary *param = @{KEY_USER_ID:[UserSession currentSession].userId ,
                                KEY_NICK_NAME:[UserSession currentSession].username};
        arrLikes = [NSMutableArray arrayWithArray:arrayLikes];
        [arrLikes addObject:param];
    }
    arrayLikes = [NSArray arrayWithArray:arrLikes];
    return arrayLikes;
}

- (BOOL)checkIncludeCurrentUserInArrayLikes :(NSArray *)arrayLikes{
    for (NSDictionary *arrLikes in arrayLikes) {
        if ([[arrLikes valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]) {
            return YES;
        }
    }
    return NO;
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

#pragma mark - update List Follower With Token

-(void)updateFollowerWithToken:(NSDictionary *)parameterss{
    [_baseModel getFollowerEndPointWithParameters:parameterss completion:^(id responseObject, NSError *error){
        if (!error) {
            _arrayListFollower = [NSMutableArray arrayWithArray:[FollowObject followObjectsWith:responseObject]];
            [followerTableViewController setUserId:_userId];
            [followerTableViewController setDicParamPublic:_dicParamPublic];
            
            followerTableViewController.arrayFollower = _arrayListFollower;
            followerTableViewController.arrayFollowingMe = _arrayListFollowingMe;
            [followerTableViewController compareListFollowing];
            
            [followerTableViewController.tableView reloadData];
            [self setFollowersLabel];
            
            [_followsButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_FOLLOW] forState:UIControlStateNormal];
            for (NSDictionary * listFollower in _arrayListFollower) {
                if ([[listFollower valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]) {
                    [_followsButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_UNFOLLOW] forState:UIControlStateNormal];
                    break;
                }
            }
            [MBProgressHUD hideAllHUDsForView:_followersView animated:YES];
        }else {
            NSLog(@"error = %@",error);
            [MBProgressHUD hideAllHUDsForView:_followersView animated:YES];
        }
    }];
}

- (void)reloadFollower{
    NSDictionary * parameterss = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken,
                                   KEY_USER_ID:_userId};
    [self updateFollowerWithToken:parameterss];
}

#pragma mark - update List Following With Token

-(void)updateFollowingWithToken:(NSDictionary *)parameterss{
    [_baseModel getFollowingEndPointWithParameters:parameterss completion:^(id responseObject, NSError *error){
        if (!error) {
            _arrayListFollowing = [NSMutableArray arrayWithArray:[FollowObject followObjectsWith:responseObject]];
            [followingTableViewController setUserId:_userId];
            [followingTableViewController setDicParamPublic:_dicParamPublic];
            
            followingTableViewController.arrayFollowing = _arrayListFollowing;
            followingTableViewController.arrayFollowingMeMe = _arrayListFollowingMe;
            [followingTableViewController compareListFollowingTwo];
            
            [followingTableViewController.tableView reloadData];
            [self setFollowingsLabel];
            
            [MBProgressHUD hideAllHUDsForView:_followingsView animated:YES];
        }else {
            NSLog(@"error = %@",error);
            [MBProgressHUD hideAllHUDsForView:_followingsView animated:YES];
        }
    }];
}

- (void)reloadFollowing{
    NSDictionary * parameterss = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken,
                                   KEY_USER_ID:_userId};
    [self updateFollowingWithToken:parameterss];
}

#pragma mark - update List Following With Token Me

-(void)updateFollowingMeWithToken:(NSDictionary *)parameterss{
    MBProgressHUD *hubFollowing = [MBProgressHUD showHUDAddedTo:_followingsView animated:YES];
    hubFollowing.userInteractionEnabled = NO;
    MBProgressHUD *hubFollower = [MBProgressHUD showHUDAddedTo:_followersView animated:YES];
    hubFollower.userInteractionEnabled = NO;
    
    [_baseModel getFollowingEndPointWithParameters:parameterss completion:^(id responseObject, NSError *error){
        if (!error) {
            _arrayListFollowingMe = [NSMutableArray arrayWithArray:[FollowObject followObjectsWith:responseObject]];
            [self reloadFollower];
            [self reloadFollowing];
        }else {
            NSLog(@"error = %@",error);
            [MBProgressHUD hideAllHUDsForView:_followingsView animated:YES];
            [MBProgressHUD hideAllHUDsForView:_followersView animated:YES];
        }
    }];
}

- (void)reloadFollowingMe{
    NSDictionary * parameterss = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken,
                                   KEY_USER_ID:[UserSession currentSession].userId};
    [self updateFollowingMeWithToken:parameterss];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _contentTableView) {
        [self updateUserProfileFrame:_userProfileViewForCheckins withTableView:_contentTableView andScrollView:scrollView];
    }
    if (scrollView == followerTableViewController.tableView) {
        [self updateUserProfileFrame:_userProfileViewForFollower withTableView:followerTableViewController.tableView andScrollView:scrollView];
    }
    if (scrollView == followingTableViewController.tableView) {
        [self updateUserProfileFrame:_userProfileViewForFollowing withTableView:followingTableViewController.tableView andScrollView:scrollView];
    }
}

#pragma mark - ProfileView Delegate

- (void)checkinsAction {
    followerTableViewController.tableView.hidden = YES;
    followingTableViewController.tableView.hidden = YES;
    _contentTableView.hidden = NO;
    _checkinsView.hidden = NO;
    _followersView.hidden = YES;
    _followingsView.hidden = YES;
    [self setTitleButtonWithCheckinsColor:[UIColor darkModerateCyanColor2]
                           followersColor:[UIColor veryLightGrayColor]
                          followingsColor:[UIColor veryLightGrayColor]];
}

- (void)followersAction {
    [followerTableViewController compareListFollowing];
    followerTableViewController.tableView.hidden = NO;
    followingTableViewController.tableView.hidden = YES;
    _contentTableView.hidden = YES;
    _checkinsView.hidden = YES;
    _followersView.hidden = NO;
    _followingsView.hidden = YES;
    [self setTitleButtonWithCheckinsColor:[UIColor veryLightGrayColor]
                           followersColor:[UIColor darkModerateCyanColor2]
                          followingsColor:[UIColor veryLightGrayColor]];
}

- (void)followingsAction {
    [followingTableViewController compareListFollowingTwo];
    followingTableViewController.tableView.hidden = NO;
    followerTableViewController.tableView.hidden = YES;
    _contentTableView.hidden = YES;
    _checkinsView.hidden = YES;
    _followersView.hidden = YES;
    _followingsView.hidden = NO;
    [self setTitleButtonWithCheckinsColor:[UIColor veryLightGrayColor]
                           followersColor:[UIColor veryLightGrayColor]
                          followingsColor:[UIColor darkModerateCyanColor2]];
}

- (void)updateScrollIndicatorInset:(UIEdgeInsets)edgeInsets userProfileView:(UserProfileView *)userProfileView{
    if (userProfileView == _userProfileViewForCheckins) {
        _heightProfileView = _userProfileViewForCheckins.heightProfileView;
        self.contentTableView.scrollIndicatorInsets = edgeInsets;
    }
    
    if (userProfileView == _userProfileViewForFollower) {
        followerTableViewController.tableView.scrollIndicatorInsets = edgeInsets;
    }
    
    if (userProfileView == _userProfileViewForFollowing) {
        followingTableViewController.tableView.scrollIndicatorInsets = edgeInsets;
    }
}

- (void)updateTableContentInset:(UIEdgeInsets)edgeInsets userProfileView:(UserProfileView *)userProfileView{
    if (userProfileView == _userProfileViewForCheckins) {
        CGFloat offsetYPlusCheckinsTableView = self.contentTableView.contentOffset.y + USER_PROFILE_HEADER_DEFAULT_HEIGHT;
        self.contentTableView.contentInset = edgeInsets;
        [self.contentTableView setContentOffset:CGPointMake(0, -edgeInsets.top + offsetYPlusCheckinsTableView) animated:YES];
    }
    
    if (userProfileView == _userProfileViewForFollower) {
        followerTableViewController.tableView.contentInset = edgeInsets;
    }
    
    if (userProfileView == _userProfileViewForFollowing) {
        followingTableViewController.tableView.contentInset = edgeInsets;
    }
}

- (void)textViewDidScroll:(UIScrollView *)scrollView userProfileView:(UserProfileView *)userProfileView {
    CGFloat xOffset  = scrollView.contentOffset.x;
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGRect rect = CGRectMake(xOffset, yOffset, userProfileView.biographyTextView.frame.size.width, userProfileView.biographyTextView.frame.size.height);
    if (userProfileView != _userProfileViewForCheckins) {
        [_userProfileViewForCheckins.biographyTextView scrollRectToVisible:rect animated:NO];
    }
    if (userProfileView != _userProfileViewForFollower) {
        [_userProfileViewForFollower.biographyTextView scrollRectToVisible:rect animated:NO];
    }
    if (userProfileView != _userProfileViewForFollowing) {
        [_userProfileViewForFollowing.biographyTextView scrollRectToVisible:rect animated:NO];
    }
}

#pragma mark - FollowerTableView & FollowingTableView Delegate

- (void)didScrollFollower:(UIScrollView *)scrollView {
    [self scrollViewDidScroll:scrollView];
}

- (void)didScrollFollowing:(UIScrollView *)scrollView {
    [self scrollViewDidScroll:scrollView];
}

- (void)didSelectFollowingUser:(FollowObject*)followObject{
    //TODO: Push following user here
    [self pushToUserSelected:followObject];
}

- (void)didSelectFollowerUser:(FollowObject*)followObject{
    //TODO: Push follower user here
    [self pushToUserSelected:followObject];
}

- (void)pushToUserSelected:(FollowObject *)followObject {
    UserSession *userSession = [UserSession currentSession];
    if (userSession == nil || userSession.isGuestSession) {
        return;
    }
    NSDictionary *parameters = @{KEY_TOKEN_PARAM:userSession.sessionToken, KEY_END_PARAM:@0,KEY_COUNT:@NUMBER_MAX_DATA_DOWNLOAD, KEY_USER_ID:followObject.user_id};
    PublicProfileViewController *publicProfileViewControllerForUser = [[PublicProfileViewController alloc]init];
    [publicProfileViewControllerForUser setUsername:followObject.nickname];
    [publicProfileViewControllerForUser setUserId:followObject.user_id];
    [publicProfileViewControllerForUser setDicParamPublic:parameters];
    [self.navigationController pushViewController:publicProfileViewControllerForUser animated:YES];
    
}

#pragma mark - User Profile View

- (void)initProfileView {
    _userProfileViewForCheckins = [[UserProfileView alloc]initWithFrame:CGRectZero];
    _userProfileViewForFollower = [[UserProfileView alloc]initWithFrame:CGRectZero];
    _userProfileViewForFollowing = [[UserProfileView alloc]initWithFrame:CGRectZero];
    _userProfileViewForCheckins.delegate = self;
    _userProfileViewForFollower.delegate = self;
    _userProfileViewForFollowing.delegate = self;
    _heightProfileView = USER_PROFILE_HEADER_DEFAULT_HEIGHT;
}

- (void)setUserProfileName {
    _userProfileViewForCheckins.usernameLabels.text = _userProfileViewForFollower.usernameLabels.text = _userProfileViewForFollowing.usernameLabels.text = _username;
    _userProfileViewForCheckins.userID = _userProfileViewForFollower.userID = _userProfileViewForFollowing.userID = _userId;
}

- (void)setUserProfileAvatar {
    UserSession *userSession = [UserSession currentSession];
    BOOL isNeedRequestAvatar = YES;
    if ([[_dicParamPublic objectForKey:KEY_USER_ID] isEqualToString:userSession.userId] && (userSession.userAvatar)) {
        _userProfileViewForCheckins.avatarImageView.image = _userProfileViewForFollower.avatarImageView.image = _userProfileViewForFollowing.avatarImageView.image = userSession.userAvatar;
        isNeedRequestAvatar = NO;
    }
    if (isNeedRequestAvatar) {
        UIImage *avatar = [_avatarCache objectForKey:[_dicParamPublic objectForKey:KEY_USER_ID]];
        NSDictionary *parameters = @{KEY_USER_ID: [_dicParamPublic objectForKey:KEY_USER_ID]};
        if (!avatar) {
            [_baseModel getUserAvatarWithParameters:parameters completion:^(id responseObject, NSError *error){
                if (!error) {
                    UIImage *avatar = responseObject;
                    if (avatar == nil) {
                        avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                    } else {
                        [_avatarCache setObject:responseObject forKey:[_dicParamPublic objectForKey:KEY_USER_ID]];
                    }
                    _userProfileViewForCheckins.avatarImageView.image = _userProfileViewForFollower.avatarImageView.image = _userProfileViewForFollowing.avatarImageView.image = avatar;
                }else {
                    UIImage *avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                    _userProfileViewForCheckins.avatarImageView.image = _userProfileViewForFollower.avatarImageView.image = _userProfileViewForFollowing.avatarImageView.image = avatar;
                }
            }];
        }
    }
}

- (void)setCheckinsLabel {
    _userProfileViewForCheckins.checkinsLabel.text = _userProfileViewForFollower.checkinsLabel.text = _userProfileViewForFollowing.checkinsLabel.text = [NSString stringWithFormat:@"%d",(int)_feelingRecords.count];
}

- (void)setFollowersLabel {
    _userProfileViewForCheckins.followersLabel.text = _userProfileViewForFollower.followersLabel.text = _userProfileViewForFollowing.followersLabel.text = [NSString stringWithFormat:@"%d",(int)_arrayListFollower.count];
}

- (void)setFollowingsLabel {
    _userProfileViewForCheckins.followingLabel.text = _userProfileViewForFollower.followingLabel.text = _userProfileViewForFollowing.followingLabel.text = [NSString stringWithFormat:@"%d",(int)_arrayListFollowing.count];
}

- (void)setTitleButtonWithCheckinsColor:(UIColor *)checkinsColor followersColor:(UIColor *)followersColor followingsColor:(UIColor *)followingsColor{
    [_userProfileViewForCheckins.checkinsButton setTitleColor:checkinsColor forState:UIControlStateNormal];
    [_userProfileViewForCheckins.followerButton setTitleColor:followersColor forState:UIControlStateNormal];
    [_userProfileViewForCheckins.followingButton setTitleColor:followingsColor forState:UIControlStateNormal];
    _userProfileViewForCheckins.checkinsLabel.textColor = checkinsColor;
    _userProfileViewForCheckins.followersLabel.textColor = followersColor;
    _userProfileViewForCheckins.followingLabel.textColor = followingsColor;
    
    [_userProfileViewForFollower.checkinsButton setTitleColor:checkinsColor forState:UIControlStateNormal];
    [_userProfileViewForFollower.followerButton setTitleColor:followersColor forState:UIControlStateNormal];
    [_userProfileViewForFollower.followingButton setTitleColor:followingsColor forState:UIControlStateNormal];
    _userProfileViewForFollower.checkinsLabel.textColor = checkinsColor;
    _userProfileViewForFollower.followersLabel.textColor = followersColor;
    _userProfileViewForFollower.followingLabel.textColor = followingsColor;
    
    [_userProfileViewForFollowing.checkinsButton setTitleColor:checkinsColor forState:UIControlStateNormal];
    [_userProfileViewForFollowing.followerButton setTitleColor:followersColor forState:UIControlStateNormal];
    [_userProfileViewForFollowing.followingButton setTitleColor:followingsColor forState:UIControlStateNormal];
    _userProfileViewForFollowing.checkinsLabel.textColor = checkinsColor;
    _userProfileViewForFollowing.followersLabel.textColor = followersColor;
    _userProfileViewForFollowing.followingLabel.textColor = followingsColor;
}

- (void)updateUserProfileFrame:(UIView *)userProfile withTableView:(UITableView *)tableView  andScrollView:(UIScrollView *)scrollView {
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -_heightProfileView) {
        CGRect fixedFrame = userProfile.frame;
        fixedFrame.origin.y = yOffset;
        fixedFrame.size.height =  -yOffset;
        userProfile.frame = fixedFrame;
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-yOffset, 0, 0, 0);
    }else{
        CGRect fixedFrame = userProfile.frame;
        fixedFrame.origin.y = yOffset;
        userProfile.frame = fixedFrame;
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView, 0, 0, 0);
    }
}

- (void)getBiographyAndBackgroundUserFromServer {
    UserSession *userSession = [UserSession currentSession];
    UIImage *defaultBackgroundImage = [UIImage imageNamed:IMAGE_NAME_AUTUMN_COLOR];
    BOOL needRequestBiography = YES;
    BOOL needRequestBackground = YES;
    
    // Biography
    if ([userSession.userId isEqualToString:_userId]) {
        if (![_userBiograyphy isEqualToString:userSession.userBiography]) {
            currentContentOffsetTableView = _contentTableView.contentOffset;
            [self setValueBiography:userSession.userBiography];
        }
        _userBiograyphy = userSession.userBiography;
        needRequestBiography = NO;
    }
    
    // Background
    if ((userSession.userId) && ([userSession.userId isEqualToString:_userId])) {
        if ((userSession.backgroundImage)) {
            _userProfileViewForCheckins.profileBackgroundImageView.image = _userProfileViewForFollower.profileBackgroundImageView.image = _userProfileViewForFollowing.profileBackgroundImageView.image = userSession.backgroundImage;
            needRequestBackground = NO;
        }else {
            _userProfileViewForCheckins.profileBackgroundImageView.image = defaultBackgroundImage;
            _userProfileViewForFollower.profileBackgroundImageView.image = defaultBackgroundImage;
            _userProfileViewForFollowing.profileBackgroundImageView.image = defaultBackgroundImage;
            needRequestBackground = YES;
        }
    }
    
    if (needRequestBiography || needRequestBackground)  {
        NSDictionary *parameters = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken, KEY_USER_ID:_userId};
        [_baseModel getUserEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
            if (!error) {
                NSDictionary *userDataDict = (NSDictionary *)[responseObject objectForKey:KEY_USER];
                if (needRequestBiography) {
                    NSString *biograyphy = [userDataDict objectForKey:KEY_BIOGRAPHY];
                    if (![_userBiograyphy isEqualToString:biograyphy]) {
                        currentContentOffsetTableView = _contentTableView.contentOffset;
                        [self setValueBiography:biograyphy];
                    }
                    _userBiograyphy = biograyphy;
                }
                
                if (needRequestBackground) {
                    NSString *urlPathNameBackground = [userDataDict objectForKey:KEY_IMAGE_COVER];
                    [self downloadBackgroundProfileImageWithURLPathName:urlPathNameBackground];
                }
                
            }else {
                NSLog(@"Couldn't complete with error: %@",error);
            }
        }];
    }
}

- (void)setValueBiography:(NSString *)biography {
    [_userProfileViewForCheckins setValueBiographyTextViewWithString:biography];
    [_userProfileViewForFollower setValueBiographyTextViewWithString:biography];
    [_userProfileViewForFollowing setValueBiographyTextViewWithString:biography];
}

- (void)downloadBackgroundProfileImageWithURLPathName:(NSString *)urlPathName {
    UIImage *defaultBackgroundImage = [UIImage imageNamed:IMAGE_NAME_AUTUMN_COLOR];
    [_baseModel downloadUserImageWithImageKey:KEY_IMAGE_COVER andURLPathName:urlPathName completion:^(id responseObject, NSError *error){
        if (!error) {
            UIImage *userProfileBackgroundImage = responseObject;
            _userProfileViewForCheckins.profileBackgroundImageView.image = _userProfileViewForFollower.profileBackgroundImageView.image = _userProfileViewForFollowing.profileBackgroundImageView.image = (userProfileBackgroundImage)?userProfileBackgroundImage:defaultBackgroundImage;
        }else {
            NSLog(@"Couldn't complete with error: %@",error);
        }
    }];
}

@end
