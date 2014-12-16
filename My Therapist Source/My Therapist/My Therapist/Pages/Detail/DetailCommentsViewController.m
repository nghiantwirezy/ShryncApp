
//  DetailCommentsViewController.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "DetailCommentsViewController.h"
#import "UIColor+ColorUtilities.h"

static NSDateFormatter *_dateFormatter;

@implementation DetailCommentsViewController

#pragma mark - DetailCommentsViewController management

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    _baseModel = [BaseModel shareBaseModel];
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *backImage = [UIImage imageNamed:IMAGE_NAME_BACK_BUTTON];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:FRAME_BACK_BUTTON_DETAIL_COMMENTS];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:barButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME_TITLE_LABEL_DETAIL_COMMENTS];
    titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_TITLE_DEFAULT);
    titleLabel.text = NSLocalizedString(TITLE_DETAIL_COMMENTS, nil);
    titleLabel.textColor = [UIColor veryLightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.messageTableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = YES;
    
    _arrayComment = [NSMutableArray new];
    [self addplaceholder];
    
    _sendMessageButton.layer.cornerRadius = CORNER_RADIUS_SEND_MESSAGE_BUTTON;
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self hideKeyboard];
    [self.textViewMessage resignFirstResponder];
    _arrayFollowingMe = [NSMutableArray new];
    _hud = [[MBProgressHUD alloc] initWithView:_containerView];
    _hud.userInteractionEnabled = NO;
    _hud.labelFont = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    [_containerView addSubview:_hud];
    allowChangeHugLike = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.textViewMessage resignFirstResponder];
    _sendMessageButton.enabled = NO;
    _userProfileView.usernameLabels.text = _username;
    _userProfileView.userID = _userId;
    
    [self.view endEditing:YES];
    [DetailCommentsViewController subscribeController:self forKeyboardAppears:@selector(keyboardWillShow:) disapears:@selector(keyboardWillHide:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _hud.labelText = NSLocalizedString(TEXT_LOADING_MY_FEELINGS, nil);
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud show:YES];
    [self reloadComment];
    [self setAvatarForImage:_userProfileView.avatarImageView withUserID:_userId];
    [self getBiographyAndBackgroundUserFromServer];
    [self reloadFollowingMe];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [DetailCommentsViewController unsubscribeControllerFromNotifications:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods

- (void)setFeelingRecordTherapy:(FeelingRecord *)feelingRecord{
    _feelingRecord = feelingRecord;
    allowChangeHugLike = YES;
    [_feelingSummarySection setHeaderString:[NSString stringWithFormat:@"ON %@  I FELT:", [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_feelingRecord.time]]]];
}

-(void)addplaceholder{
    placeHolder = [[UILabel alloc]initWithFrame:FRAME_PLACE_HOLDER_DETAIL_COMMENTS];
    placeHolder.backgroundColor=[UIColor clearColor];
    placeHolder.text= NSLocalizedString(TITLE_PLACE_HOLDER_DETAIL_COMMENTS, nil);
    placeHolder.textColor=[UIColor grayColor];
    placeHolder.font=[UIFont systemFontOfSize:14];
    _textViewMessage.textColor=[UIColor grayColor];
    [_textViewMessage addSubview:placeHolder];
}

- (NSString *)formatSummaryStringFromRecord:(FeelingRecord *)record
{
    NSString *string = nil;
    if (record.activityIndex != 0 || record.comment.length > 0) {
        NSMutableString *activityAndCommentString = [[NSMutableString alloc] init];
        if (record.comment.length != 0) {
            [activityAndCommentString appendFormat:@"%@", record.comment];
        }
        string = activityAndCommentString;
    }
    return string;
}

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}


- (NSString *)formatSummaryStringFromCommentObject:(CommentObject *)comObj
{
    NSString *string = nil;
    NSMutableString *activityAndCommentString = [[NSMutableString alloc] init];
    if (comObj.data.length != 0) {
        [activityAndCommentString appendFormat:@"%@", comObj.data];
    }
    string = activityAndCommentString;
    return string;
}

- (NSArray *)arrayUserLikeWithCurrentUser:(NSArray *)arrayLikes{
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

- (void)updateHugLikeCommentCell:(NSNumber *)section{
    
    NSInteger numberOfRows = [self.messageTableView numberOfRowsInSection:[section integerValue]];
    NSMutableArray *arrayIndexPathToReload = [[NSMutableArray alloc] init];
    NSIndexPath *indexPathHugDetailCell = nil;
    NSIndexPath *indexPathLikeDetailCell = nil;
    for (int i = 0; i < numberOfRows - _arrayComment.count; i++) {
        NSIndexPath *indexPathFound = [NSIndexPath indexPathForRow:i inSection:[section integerValue]];
        UITableViewCell *tableViewCell = [self.messageTableView cellForRowAtIndexPath:indexPathFound];
        if ([tableViewCell isKindOfClass:[HugCell class]]) {
            [arrayIndexPathToReload addObject:indexPathFound];
        }
        if ([tableViewCell isKindOfClass:[HugDetailViewCell class]]) {
            indexPathHugDetailCell = indexPathFound;
        }
        if ([tableViewCell isKindOfClass:[LikeDetailViewCell class]]) {
            indexPathLikeDetailCell = indexPathFound;
        }
    }
    
    if (indexPathHugDetailCell && (_feelingRecord.huggerDict.count == 0)) {
        [self.messageTableView deleteRowsAtIndexPaths:@[indexPathHugDetailCell] withRowAnimation:UITableViewRowAnimationFade];
        indexPathHugDetailCell = nil;
    }else if(indexPathHugDetailCell){
        [arrayIndexPathToReload addObject:indexPathHugDetailCell];
    }else if(!indexPathHugDetailCell && (_feelingRecord.huggerDict.count > 0)){
        [self.messageTableView reloadData];
        return;
    }
    
    if (indexPathLikeDetailCell && (_feelingRecord.likerDict.count == 0)) {
        [self.messageTableView deleteRowsAtIndexPaths:@[indexPathLikeDetailCell] withRowAnimation:UITableViewRowAnimationFade];
        indexPathLikeDetailCell = nil;
    }else if(indexPathLikeDetailCell){
        [arrayIndexPathToReload addObject:indexPathLikeDetailCell];
    }else if(!indexPathLikeDetailCell && (_feelingRecord.likerDict.count > 0)){
        [self.messageTableView reloadData];
        return;
    }
    
    if (arrayIndexPathToReload.count > 0) {
        [self.messageTableView reloadRowsAtIndexPaths:arrayIndexPathToReload withRowAnimation:UITableViewRowAnimationNone];
    }
}

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

- (void)getBiographyAndBackgroundUserFromServer {
    UserSession *userSession = [UserSession currentSession];
    BOOL needRequestBiography = YES;
    BOOL needRequestBackground = YES;
    
    // Biography
    if ([userSession.userId isEqualToString:_userId]) {
        if ((userSession.userBiography != (id)[NSNull null]) && (userSession.userBiography.length > 0)) {
            [_userProfileView setValueBiographyTextViewWithString:userSession.userBiography];
            needRequestBiography = NO;
        }
    }
    
    // Background
    if ((userSession.userId) && ([userSession.userId isEqualToString:_userId])) {
        if ((userSession.backgroundImage)) {
            _userProfileView.profileBackgroundImageView.image = userSession.backgroundImage;
            needRequestBackground = NO;
        }else {
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
                    [_userProfileView setValueBiographyTextViewWithString:biograyphy];
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

- (void)downloadBackgroundProfileImageWithURLPathName:(NSString *)urlPathName {
    [_baseModel downloadUserImageWithImageKey:KEY_IMAGE_COVER andURLPathName:urlPathName completion:^(id responseObject, NSError *error){
        if (!error) {
            UIImage *userProfileBackgroundImage = responseObject;
            if(userProfileBackgroundImage) {
                _userProfileView.profileBackgroundImageView.image = userProfileBackgroundImage;
                UserSession *userSession = [UserSession currentSession];
                if([userSession.userId isEqualToString:_userId]){
                    userSession.backgroundImage = userProfileBackgroundImage;
                }
            }else {
                UIImage *defaultBackgroundImage = [UIImage imageNamed:IMAGE_NAME_AUTUMN_COLOR];
                _userProfileView.profileBackgroundImageView.image = defaultBackgroundImage;
            }
        }else {
            NSLog(@"Couldn't complete with error: %@",error);
        }
    }];
}

#pragma mark - Keyboard management

+ (void)subscribeController:(UIViewController *)controller forKeyboardAppears: (SEL) appears disapears: (SEL) disapears {
    [[NSNotificationCenter defaultCenter] addObserver:controller selector:appears name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:controller selector:disapears name:UIKeyboardWillHideNotification object:nil];
}

+ (void)unsubscribeControllerFromNotifications: (UIViewController *) controller{
    [[NSNotificationCenter defaultCenter] removeObserver:controller];
}

- (void)keyboardWillShow:(NSNotification *) notification{
    [self animateControlsShift:^{
        [self keyboardStateChanged:YES];
        self.bottomChatViewConstraint.constant += [self shiftHeightByKeyboard];
        [self.containerView setNeedsLayout];
        [self.containerView layoutIfNeeded];
        NSInteger numberOfRows = [self.messageTableView numberOfRowsInSection:0];
        NSIndexPath *indexPathToScroll = [NSIndexPath indexPathForRow:(numberOfRows - 1) inSection: 0];
        [self.messageTableView scrollToRowAtIndexPath:indexPathToScroll atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
}

- (void)keyboardWillHide:(NSNotification *) notification{
    [self animateControlsShift:^{
        [self keyboardStateChanged:NO];
        self.bottomChatViewConstraint.constant -= [self shiftHeightByKeyboard];
        [self.containerView layoutIfNeeded];
    }];
}

- (void)animateControlsShift: (void(^)()) block{
    [UIView animateWithDuration:TIME_SHOW_KEYBOARD_DETAIL_COMMENT delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (block) {
            block();
        }
    } completion:nil];
}

- (CGFloat)shiftHeightByKeyboard{
    return SHIFT_HEIGHT_BY_KEYBOARD_DETAIL_COMMENTS;
}

- (void)keyboardStateChanged:(BOOL) state{
}

- (void)hideKeyboard
{
    [self.textViewMessage resignFirstResponder];
}

#pragma mark - Actions

- (void)backAction{
    [self.textViewMessage resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendMessageButtonAction:(id)sender {
    _hud.labelText = NSLocalizedString(TEXT_SENDING, nil);
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud show:YES];
    
    NSDictionary *parameters = @{KEY_TOKEN_PARAM: [UserSession currentSession].sessionToken,
                                 KEY_FEELING_ID: [NSNumber numberWithInteger:[ _feelingRecord.recordId integerValue]],
                                 KEY_TYPE: [NSNumber numberWithInteger:TYPE_KEY_COMMENT_HUG_CELL],
                                 KEY_DATA: self.textViewMessage.text};
    [_baseModel postFeelingHugEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
        if (!error) {
            NSLog(@"Success = %@",responseObject);
            [self reloadComment];
            [_hud hide:YES];
        }else {
            NSLog(@"Error = %@", error);
            [_hud hide:YES];
        }
    }];
    
    _textViewMessage.text = @"";
    [self addplaceholder];
    _sendMessageButton.backgroundColor = [UIColor lightGrayColor];
    _sendMessageButton.enabled = NO;
    [self hideKeyboard];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_arrayComment.count inSection:0];
    [_messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (IBAction)viewDidTapAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - TextView delegate

-(void)textViewDidChange:(UITextView *)textView{
    _textViewMessage.textColor=[UIColor blackColor];
    if (_textViewMessage.text.length >0) {
        placeHolder.hidden=YES;
        _sendMessageButton.enabled = YES;
        _sendMessageButton.backgroundColor = [UIColor grayColor];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_arrayComment.count inSection:0];
        [_messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }else if(_textViewMessage.text.length == 0) {
        _sendMessageButton.enabled = NO;
        _sendMessageButton.backgroundColor = [UIColor lightGrayColor];
        placeHolder.text= NSLocalizedString(TITLE_PLACE_HOLDER_DETAIL_COMMENTS, nil);
        placeHolder.hidden=NO;
    }
}

#pragma mark - TableView delegate & datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = HEIGHT_CELL_DETAIL_COMMENTS;
    FeelingRecord *record = _feelingRecord;
    NSArray *hugCount = record.huggerDict;
    
    if (indexPath.row < record.feelings.count) {
        height = HEIGHT_CELL_INFO_DETAIL_COMMENTS;
    }
    else if (indexPath.row == record.feelings.count) {
        if (record.comment.length > 0) {
            NSString *commentString = record.comment;
            height = ceilf(commentString != nil ? ([commentString heightForFont:COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_FEELING_CELL_DETAIL_COMMENT) andWidth:WIDTH_FEELING_CELL_CONTENT_DETAIL_COMMENT] + SPACE_FEELING_CELL_CONTENT_DETAIL_COMMENT) : 0);
        }
        else if (record.thumbnailPath.length > 0) {
            height = [ImageAttachmentCell cellHeight];
        }
        else {
            height = [HugCell cellHeight];
        }
    }
    else if (indexPath.row == record.feelings.count + ((record.comment.length > 0)?1:0)) {
        if (record.comment.length > 0 && record.thumbnailPath.length > 0) {
            height = [ImageAttachmentCell cellHeight];
        }
        else if(record.huggers.count != 0) {
            height = [HugCell cellHeight];
        }
    }
    else if (indexPath.row==(record.feelings.count+ ((record.comment.length > 0)?1:0) + ((record.thumbnailPath.length > 0)?1:0))){
        height = [HugCell cellHeight];
    }
    else if (indexPath.row==(record.feelings.count+ ((record.comment.length > 0)?1:0) + ((record.thumbnailPath.length > 0)?1:0))
             + ((_feelingRecord.huggers.count > 0)?1:0)){
        height = HEIGHT_CELL_HUG_DETAIL_COMMENTS;
    }
    else if (indexPath.row==(record.feelings.count+ ((record.comment.length > 0)?1:0) + ((record.thumbnailPath.length > 0)?1:0))
             + ((hugCount.count > 0)?1:0) + ((_feelingRecord.likerDict.count > 0)?1:0)){
        height = HEIGHT_CELL_LIKE_DETAIL_COMMENTS;
    }
    else if (indexPath.row==(record.feelings.count+ ((record.comment.length > 0)?1:0) + ((record.thumbnailPath.length > 0)?1:0))
             + ((hugCount.count > 0)?1:0) + ((_feelingRecord.likerDict.count > 0)?1:0) + 1){
        height = 5;
    }
    else if (indexPath.row > (record.feelings.count+ ((record.comment.length > 0)?1:0) + ((record.thumbnailPath.length > 0)?1:0))
             + ((hugCount.count > 0)?1:0) + ((_feelingRecord.likerDict.count > 0)?1:0) + 1){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return HEIGHT_CELL_MESSAGE_DETAIL_COMMENTS + cell.contentView.frame.size.height ;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *hugCount = _feelingRecord.huggerDict;
    
    return (_feelingRecord.feelings.count+ ((_feelingRecord.comment.length > 0)?1:0) + ((_feelingRecord.thumbnailPath.length > 0)?1:0)
            + ((hugCount.count > 0)?1:0) + ((_feelingRecord.likerDict.count > 0)?1:0) + 2 + _arrayComment.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *hugCount = _feelingRecord.huggerDict;
    
    UITableViewCell *tableCell = nil;
    if (indexPath.row < _feelingRecord.feelings.count){
        FeelingSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FEELING_CELL];
        if (cell == nil) {
            cell = [[FeelingSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_FEELING_CELL];
        }
        [cell setFeeling:[_feelingRecord.feelings objectAtIndex:indexPath.row]];
        tableCell = cell;
    }
    else if (indexPath.row == _feelingRecord.feelings.count) {
        if (_feelingRecord.comment.length != 0) {
            FeelingTextCell *textCells = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FEELING_TEXT_CELL];
            if (textCells == nil) {
                textCells = [[FeelingTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_FEELING_TEXT_CELL];
            }
            NSString *commentString = _feelingRecord.comment;
            textCells.textView.text = commentString;
            [textCells.textView sizeToFit];
            
            CGRect textFrame = textCells.textView.frame;
            textFrame.size.width = WIDTH_FEELING_TEXT_CELL_DETAIL_COMMENTS;
            textCells.textView.frame = textFrame;
            
            CGRect containerFrame = textCells.containerView.frame;
            containerFrame.size.height = textCells.textView.frame.size.height;
            textCells.containerView.frame = containerFrame;
            tableCell = textCells;
        }
        else if (_feelingRecord.thumbnailPath.length > 0){
            ImageAttachmentCell *imageCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_IMAGE_ATTACHMENT_CELL];
            if (imageCell == nil) {
                imageCell = [[ImageAttachmentCell alloc] initWithReuseIdentifier:IDENTIFIER_IMAGE_ATTACHMENT_CELL];
            }
            [imageCell setFeelingRecord:_feelingRecord];
            [imageCell setDelegate:self];
            [imageCell.btnImage setTag:indexPath.section];
            tableCell = imageCell;
        }
        else{
            tableCell = [self hugCellWithIndexPath:indexPath andFeelingRecord:_feelingRecord andTableView:tableView];
        }
    }
    else if(indexPath.row == _feelingRecord.feelings.count + ((_feelingRecord.comment.length > 0)?1:0)){
        if (_feelingRecord.comment.length > 0 && _feelingRecord.thumbnailPath.length > 0) {
            ImageAttachmentCell *imageCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_IMAGE_ATTACHMENT_CELL];
            if (imageCell == nil) {
                imageCell = [[ImageAttachmentCell alloc] initWithReuseIdentifier:IDENTIFIER_IMAGE_ATTACHMENT_CELL];
            }
            [imageCell setFeelingRecord:_feelingRecord];
            [imageCell setDelegate:self];
            [imageCell.btnImage setTag:indexPath.section];
            tableCell = imageCell;
        }
        else{
            tableCell = [self hugCellWithIndexPath:indexPath andFeelingRecord:_feelingRecord andTableView:tableView];
        }
    }
    else if (indexPath.row == (_feelingRecord.feelings.count+ ((_feelingRecord.comment.length > 0)?1:0) + ((_feelingRecord.thumbnailPath.length > 0)?1:0))){
        tableCell = [self hugCellWithIndexPath:indexPath andFeelingRecord:_feelingRecord andTableView:tableView];
    }
    else if(indexPath.row == (_feelingRecord.feelings.count+ ((_feelingRecord.comment.length > 0)?1:0) + ((_feelingRecord.thumbnailPath.length > 0)?1:0)) +
            ((hugCount.count > 0)?1:0)){
        HugDetailViewCell *hugDetailViewCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_HUG_DETAIL_CELL];
        if (hugDetailViewCell == nil) {
            hugDetailViewCell = [[HugDetailViewCell alloc] initWithReuseIdentifier:IDENTIFIER_HUG_DETAIL_CELL];
        }
        if (_feelingRecord) {
            UIFont *fontHug = COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_SMALL);
            hugDetailViewCell.delegate = self;
            hugDetailViewCell.fontUsers = fontHug;
            NSArray *hugCount = _feelingRecord.huggerDict;
            hugDetailViewCell.arrayHugs = hugCount;
            [hugDetailViewCell initBase];
        }
        tableCell = hugDetailViewCell;
    }
    else if(indexPath.row == (_feelingRecord.feelings.count+ ((_feelingRecord.comment.length > 0)?1:0) + ((_feelingRecord.thumbnailPath.length > 0)?1:0))
            + ((hugCount.count > 0)?1:0) + ((_feelingRecord.likerDict.count > 0)?1:0)){
        LikeDetailViewCell *likeDetailViewCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_LIKE_DETAIL_CELL];
        if (likeDetailViewCell == nil) {
            likeDetailViewCell = [[LikeDetailViewCell alloc] initWithReuseIdentifier:IDENTIFIER_LIKE_DETAIL_CELL];
        }
        if (_feelingRecord) {
            UIFont *fontHug = COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_SMALL);
            likeDetailViewCell.delegate = self;
            likeDetailViewCell.fontUsers = fontHug;
            likeDetailViewCell.arrayLikes = _feelingRecord.likerDict;
            [likeDetailViewCell initBase];
        }
        tableCell = likeDetailViewCell;
    }
    else if (indexPath.row == (_feelingRecord.feelings.count+ ((_feelingRecord.comment.length > 0)?1:0) + ((_feelingRecord.thumbnailPath.length > 0)?1:0))
             + ((hugCount.count > 0)?1:0) + ((_feelingRecord.likerDict.count > 0)?1:0) + 1){
        SeparatorViewCell *separatorViewCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_SEPARATOR_CELL];
        if (separatorViewCell == nil) {
            separatorViewCell = [[SeparatorViewCell alloc]initWithReuseIdentifier:IDENTIFIER_SEPARATOR_CELL];
        }
        tableCell = separatorViewCell;
    }
    else {
        MessageViewCell *_messViewCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MESSAGE_CELL];
        if (_messViewCell == nil) {
            _messViewCell = [[MessageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_MESSAGE_CELL ];
        }
        _commentObject = [_arrayComment objectAtIndex:indexPath.row - (_feelingRecord.feelings.count
                                                                       + ((_feelingRecord.comment.length > 0)?1:0)
                                                                       + ((_feelingRecord.thumbnailPath.length > 0)?1:0)
                                                                       + ((hugCount.count > 0)?1:0)
                                                                       + ((_feelingRecord.likerDict.count > 0)?1:0)
                                                                       + 2 )];
        //USERNAME COMMENT
        [_messViewCell.usernameComment setText:[NSString stringWithFormat:@"%@ :",_commentObject.nickname]];
        
        //GET TIME
        _messViewCell.timeOfComment.text = [TimeHelper timeFromTimeInterval:_commentObject.posted_time];
        
        //COMMENT SIZE
        [_messViewCell.commentTextView setText:_commentObject.data];
        NSString *activityAndCommentString = [self formatSummaryStringFromCommentObject:_commentObject];
        _messViewCell.commentTextView.text = activityAndCommentString;
        [_messViewCell.commentTextView sizeToFit];
        
        CGRect textFrame = _messViewCell.commentTextView.frame;
        textFrame.size.width = 240;
        textFrame.origin.y = CGRectGetMaxY(_messViewCell.usernameComment.frame);
        _messViewCell.commentTextView.frame = textFrame;
        _messViewCell.commentTextView.backgroundColor = [UIColor lightGrayColor];
        _messViewCell.commentTextView.layer.cornerRadius = 10;
        
        CGRect containerFrame = _messViewCell.commentTextView.frame;
        containerFrame.size.height = _messViewCell.commentTextView.frame.size.height;
        CGRect frameCell = [_messViewCell frame];
        frameCell.size.height = containerFrame.size.height+CGRectGetMaxY(_messViewCell.usernameComment.frame);
        _messViewCell.messageContentView.frame = containerFrame;
        
        //GET AVATAR
        [self setAvatarForImage:_messViewCell.imageUserComment withUserID:_commentObject.userid];
        _messViewCell.delegate = self;
        [_messViewCell.btnClickMessage setTag:indexPath.row];
        tableCell = _messViewCell;
    }
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

#pragma mark - HugCell management

- (HugCell *)hugCellWithIndexPath :(NSIndexPath *)indexPath andFeelingRecord:(FeelingRecord *)record andTableView:(UITableView *)tableView{
    
    CommentObject *_commentObj = [[CommentObject alloc]init];
    HugCell *hugCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_HUG_CELL];
    if (hugCell == nil) {
        hugCell = [[HugCell alloc] initWithReuseIdentifier:IDENTIFIER_HUG_CELL];
    }
    hugCell.delegate = self;
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
    [hugCell setComments:_commentObj];
    
    // Comment button
    hugCell.commentButtonClick.tag = indexPath.section;
    if (_arrayComment.count == 0) {
        hugCell.totalCommentLabel.text = @"";
        hugCell.commentTextLabel.text = NSLocalizedString(TEXT_COMMENT_DETAIL_COMMENTS, nil);
    }else{
        hugCell.totalCommentLabel.text = [NSString stringWithFormat:@" %ld ",(unsigned long)_arrayComment.count];
    }
    [hugCell.commentButton setImage:[UIImage imageNamed:IMAGE_NAME_COMMENT_32_NORMAL] forState:UIControlStateNormal];
    hugCell.commentTextLabel.textColor = [UIColor grayColor];
    hugCell.totalCommentLabel.textColor = [UIColor grayColor];
    for (NSDictionary *dicComment in _feelingRecord.commentDict) {
        if ([[dicComment valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]){
            hugCell.commentTextLabel.text = NSLocalizedString(TEXT_COMMENTS_DETAIL_COMMENTS, nil);
            [hugCell.commentButton setImage:[UIImage imageNamed:IMAGE_NAME_COMMENT_32] forState:UIControlStateNormal];
            hugCell.commentTextLabel.textColor = [UIColor darkModerateCyanColor];
            hugCell.totalCommentLabel.textColor = [UIColor darkModerateCyanColor];
            break;
        }
    }
    
    // Hug button
    [hugCell.hugButton setImage:[UIImage imageNamed:IMAGE_NAME_HEART_64] forState:UIControlStateNormal];
    hugCell.hugTextLabel.textColor = [UIColor grayColor];
    [hugCell.huggedCountButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    hugCell.hugButtonClick.tag = indexPath.section;
    for (NSDictionary *dicHugger in _feelingRecord.huggerDict) {
        if ([[dicHugger valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]){
            [hugCell.hugButton setImage:[UIImage imageNamed:IMAGE_NAME_HEART_64_SELECTED] forState:UIControlStateNormal];
            hugCell.hugTextLabel.textColor = [UIColor darkModerateCyanColor];
            [hugCell.huggedCountButton setTitleColor:[UIColor darkModerateCyanColor] forState:UIControlStateNormal];
            break;
        }
    }
    
    // Like button
    [hugCell.likeButton setImage:[UIImage imageNamed:IMAGE_NAME_THUMB_UP] forState:UIControlStateNormal];
    hugCell.likeTextLabel.textColor = [UIColor grayColor];
    [hugCell.likedCountButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    hugCell.likeButtonClick.tag = indexPath.section;
    for (NSDictionary *dicLiker in _feelingRecord.likerDict) {
        if ([[dicLiker valueForKey:KEY_NICK_NAME] isEqualToString:[UserSession currentSession].username]) {
            [hugCell.likeButton setImage:[UIImage imageNamed:IMAGE_NAME_THUMB_UP_SELECTED] forState:UIControlStateNormal];
            hugCell.likeTextLabel.textColor = [UIColor darkModerateCyanColor];
            [hugCell.likedCountButton setTitleColor:[UIColor darkModerateCyanColor] forState:UIControlStateNormal];
            break;
        }
    }
    
    if (_feelingRecord.likerDict.count == 0) {
        [hugCell.likedCountButton setTitle:@"" forState:UIControlStateNormal];
        hugCell.likeTextLabel.text = NSLocalizedString(TEXT_LIKE_DETAIL_COMMENTS, nil);
        
    }else {
        [hugCell.likedCountButton setTitle:[NSString stringWithFormat:@" %d ",(int)_feelingRecord.likerDict.count] forState:UIControlStateNormal];
        hugCell.likeTextLabel.text = NSLocalizedString(TEXT_LIKES_DETAIL_COMMENTS, nil);
    }
    
    NSArray *hugCount = _feelingRecord.huggerDict;
    if (hugCount.count == 0) {
        [hugCell.huggedCountButton setTitle:@"" forState:UIControlStateNormal];
        hugCell.hugTextLabel.text = NSLocalizedString(TEXT_HUG_DETAIL_COMMENTS, nil);
        
    }else{
        [hugCell.huggedCountButton setTitle:[NSString stringWithFormat:@" %d ",(int)hugCount.count] forState:UIControlStateNormal];
        hugCell.hugTextLabel.text = NSLocalizedString(TEXT_HUGS_DETAIL_COMMENTS, nil);
    }
    
    return hugCell;
}

- (NSString *)setFormatDate :(NSDate *)date andFormat:(NSString *)stringFormat{
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:stringFormat];
    NSString *sentDate = [_formatter stringFromDate:date];
    return sentDate;
}

- (NSMutableDictionary *)buildParamsDictWithToken:(NSString *)token andUserId:(NSString *)userId
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:token forKey:KEY_TOKEN_PARAM];
    [dict setObject:userId forKey:KEY_USER_ID];
    return dict;
}

#pragma mark - ViewHug & ViewLike delegate

- (void)didTouchUserButton:(id)sender{
    UserSession *userSession = [UserSession currentSession];
    PublicProfileViewController *nextViewController = [PublicProfileViewController new];
    NSDictionary *parameters = [self buildParamsDictWithToken:userSession.sessionToken andUserId:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];
    NSDictionary *currentDictHugger = nil;
    for (NSDictionary *dicHuggerr in _feelingRecord.huggerDict) {
        if ([[dicHuggerr valueForKey:KEY_USER_ID] integerValue]==[sender tag]) {
            currentDictHugger = dicHuggerr;
            break;
        }
    }
    if (currentDictHugger) {
        [nextViewController setUsername:[currentDictHugger objectForKey:KEY_NICK_NAME]];
        [nextViewController setUserId:[currentDictHugger objectForKey:KEY_USER_ID]];
        [nextViewController setDicParamPublic:parameters];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

- (void)didTouchLikeUserButton:(id)sender{
    UserSession *userSession = [UserSession currentSession];
    PublicProfileViewController *nextViewController = [PublicProfileViewController new];
    NSDictionary *parameters = [self buildParamsDictWithToken:userSession.sessionToken andUserId:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];
    NSDictionary *currentDictLiker = nil;
    for (NSDictionary *dicLikerr in _feelingRecord.likerDict) {
        if ([[dicLikerr valueForKey:KEY_USER_ID] integerValue]==[sender tag]) {
            currentDictLiker = dicLikerr;
            break;
        }
    }
    if (currentDictLiker) {
        [nextViewController setUsername:[currentDictLiker objectForKey:KEY_NICK_NAME]];
        [nextViewController setUserId:[currentDictLiker objectForKey:KEY_USER_ID]];
        [nextViewController setDicParamPublic:parameters];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

- (void)didTouchMoreHugUserButton:(id)sender{
    MoreHugsUserViewController *moreHugsUser = [[MoreHugsUserViewController alloc] init];
    moreHugsUser.arrayMoreUsers = [NSArray arrayWithArray:_feelingRecord.huggerDict];
    moreHugsUser.titleLabel.text = NSLocalizedString(TITLE_HUGGER_MORE_USER, nil);
    moreHugsUser.arrayListFollowingMe = _arrayFollowingMe;
    [moreHugsUser compareListFollowing];
    [self.navigationController pushViewController:moreHugsUser animated:YES];
}

- (void)didTouchMoreLikeUserButton:(id)sender{
    MoreHugsUserViewController *moreLikesUser = [[MoreHugsUserViewController alloc] init];
    moreLikesUser.arrayMoreUsers = [NSArray arrayWithArray:_feelingRecord.likerDict];
    moreLikesUser.titleLabel.text = NSLocalizedString(TITLE_HUGGER_MORE_USER, nil);
    moreLikesUser.arrayListFollowingMe = _arrayFollowingMe;
    [moreLikesUser compareListFollowing];
    [self.navigationController pushViewController:moreLikesUser animated:YES];
}

#pragma mark - HugCell delegate

- (void)clickedButtonActionComment:(NSNumber *)indexPath{
    // TODO: 
}

- (void)didUpdateNumberHuggerSuccessful:(NSNumber *)section {
    _feelingRecord.huggerDict = [self arrayUserHugWithCurrentUser:_feelingRecord.huggerDict];
    [self updateHugLikeCommentCell:section];
}

- (void)didUpdateNumberLikerSuccessful:(NSNumber *)section{
    _feelingRecord.likerDict = [self arrayUserLikeWithCurrentUser:_feelingRecord.likerDict];
    [self updateHugLikeCommentCell:section];
}

- (void)didUpdateNumberLikerFail{
    [self reloadComment];
}

- (void)didUpdateNumberHuggerFail{
    [self reloadComment];
}

- (BOOL)willTouchHugButton:(NSNumber *)section {
    return allowChangeHugLike;
}

- (BOOL)willTouchLikeButton:(NSNumber *)section {
    
    return allowChangeHugLike;
}

#pragma mark - MessageViewCell delegate 

- (void)clickedMessageViewCell:(NSIndexPath *)indexPath{
    CommentObject *commentsObj = [_arrayComment objectAtIndex:indexPath.row - (_feelingRecord.feelings.count
                                                                   + ((_feelingRecord.comment.length > 0)?1:0)
                                                                   + ((_feelingRecord.thumbnailPath.length > 0)?1:0)
                                                                   + ((_feelingRecord.huggers > 0)?1:0)
                                                                   + ((_feelingRecord.likers > 0)?1:0)
                                                                   + 2 )];
    UserSession *userSession = [UserSession currentSession];
    NSDictionary *parameters = [self buildParamsDictWithToken:userSession.sessionToken andUserId:commentsObj.userid];
    PublicProfileViewController *nextViewController = [PublicProfileViewController new];
    [nextViewController setUsername:commentsObj.nickname];
    [nextViewController setUserId:commentsObj.userid];
    [nextViewController setDicParamPublic:parameters];
    [self.navigationController pushViewController:nextViewController animated:YES];
}


#pragma mark - ImageAttachment delegate

- (void)clickedButtonImage:(NSIndexPath *)indexPath{
    FeelingRecord *record = _feelingRecord;
    AttachmentFullscreenViewController *controllerr = [AttachmentFullscreenViewController new];
    [controllerr setAttachFeelingCode:record.code];
    [self.navigationController pushViewController:controllerr animated:YES];
}

#pragma mark - Services

- (void)reloadComment{
    NSDictionary * parameters = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken,
                                  KEY_FEELING:_feelingRecordCode};
    allowChangeHugLike = NO;
    [_baseModel getFeelingDetailWithParameters:parameters completion:^(id responseObject, NSError *error){
        if (!error) {
            [self setFeelingRecordTherapy:[FeelingRecord fromDictionary:[(NSDictionary *)responseObject objectForKey:KEY_FEELING]]];
            _arrayComment = [NSMutableArray arrayWithArray:[CommentObject commentObjectsWith:(NSDictionary *)responseObject]];
            [_messageTableView reloadData];
            NSInteger numberOfRows = [self.messageTableView numberOfRowsInSection:0];
            NSIndexPath *indexPathToScroll = [NSIndexPath indexPathForRow:(numberOfRows - 1) inSection: 0];
            [self.messageTableView scrollToRowAtIndexPath:indexPathToScroll atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            [_hud hide:YES];
        }else {
            NSLog(@"error = %@",error);
            [_hud hide:YES];
        }
    }];
    [self hideKeyboard];
    _sendMessageButton.enabled = NO;
}

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

#pragma mark - Init View
- (void)initHeaderView {
    // Profile View
    _userProfileView = [[UserProfileView alloc]initWithFrame:CGRectZero];
    _userProfileView.titleLabel.shadowColor = [UIColor whiteColor];
    _userProfileView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    _userProfileView.titleLabel.textColor = [UIColor veryLightGrayColor];
    _userProfileView.titleLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_VERY_BIG);
    _userProfileView.titleLabel.text = TEXT_HEADER_TITLE_DETAIL_COMMENT;
    
    _userProfileView.usernameLabels.textColor = [UIColor darkModerateCyanColor];
    _userProfileView.usernameLabels.font = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    
    _userProfileView.bottomView.hidden = YES;
    _userProfileView.heightConstaintBottomView.constant = 0;
    _userProfileView.separatorView.hidden = YES;
    _userProfileView.heightDefaultProfileView = _heightProfileView = USER_PROFILE_HEADER_DEFAULT_HEIGHT_WITHOUT_BOTTOM_VIEW;
    CGRect profileViewFrame = _userProfileView.frame;
    profileViewFrame.origin.y = -_heightProfileView;
    profileViewFrame.size.height = _heightProfileView;
    _userProfileView.frame = profileViewFrame;
    _userProfileView.delegate = self;
    
    // Feeling Sumary Section
    _feelingSummarySection = [[FeelingSummarySectionHeaderView alloc] initForSingleRecord:YES];
    
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    [_feelingSummarySection setHeaderString:@""];
    
    CGRect feelingSummarySectionFrame = _userProfileView.frame;
    feelingSummarySectionFrame.origin.y += _userProfileView.frame.size.height;
    feelingSummarySectionFrame.size.height = HEIGHT_FEELING_SUMARY_SECTION_HEADER_VIEW;
    _feelingSummarySection.frame = feelingSummarySectionFrame;
    
    _messageTableView.contentInset = UIEdgeInsetsMake(_heightProfileView + HEIGHT_FEELING_SUMARY_SECTION_HEADER_VIEW, 0, 0, 0);
    [_messageTableView addSubview:_userProfileView];
    [_messageTableView addSubview:_feelingSummarySection];
    _messageTableView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView + HEIGHT_FEELING_SUMARY_SECTION_HEADER_VIEW, 0, 0, 0);
    
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _messageTableView) {
        CGFloat yOffset  = scrollView.contentOffset.y;
        if (yOffset < -(_heightProfileView + HEIGHT_FEELING_SUMARY_SECTION_HEADER_VIEW)) {
            CGRect fixedFrame = _userProfileView.frame;
            fixedFrame.origin.y = yOffset;
            fixedFrame.size.height =  -yOffset - HEIGHT_FEELING_SUMARY_SECTION_HEADER_VIEW;
            _userProfileView.frame = fixedFrame;
            
            CGRect feelingSummarySectionFrame = _userProfileView.frame;
            feelingSummarySectionFrame.origin.y += _userProfileView.frame.size.height;
            feelingSummarySectionFrame.size.height = HEIGHT_FEELING_SUMARY_SECTION_HEADER_VIEW;
            _feelingSummarySection.frame = feelingSummarySectionFrame;
            
            _messageTableView.scrollIndicatorInsets = UIEdgeInsetsMake(-yOffset, 0, 0, 0);
        }else{
            CGRect fixedFrame = _userProfileView.frame;
            fixedFrame.origin.y = yOffset;
            _userProfileView.frame = fixedFrame;
            
            CGRect feelingSummarySectionFrame = _userProfileView.frame;
            feelingSummarySectionFrame.origin.y += _userProfileView.frame.size.height;
            feelingSummarySectionFrame.size.height = HEIGHT_FEELING_SUMARY_SECTION_HEADER_VIEW;
            _feelingSummarySection.frame = feelingSummarySectionFrame;
            
            _messageTableView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView + HEIGHT_FEELING_SUMARY_SECTION_HEADER_VIEW, 0, 0, 0);
        }
    }
}

#pragma mark - GestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (([touch.view isKindOfClass:[UIButton class]])) {
        return NO;
    }
    return YES;
}

#pragma mark - UserProfileView delegate

- (void)updateScrollIndicatorInset:(UIEdgeInsets)edgeInsets userProfileView:(UserProfileView *)userProfileView{
    if(userProfileView == _userProfileView) {
        _heightProfileView = _userProfileView.heightProfileView;
        edgeInsets.top = _heightProfileView + HEIGHT_FEELING_SUMARY_SECTION_HEADER_VIEW;
        _messageTableView.scrollIndicatorInsets = edgeInsets;
    }
}

- (void)updateTableContentInset:(UIEdgeInsets)edgeInsets userProfileView:(UserProfileView *)userProfileView{
    if (userProfileView == _userProfileView) {
        edgeInsets.top = _heightProfileView + HEIGHT_FEELING_SUMARY_SECTION_HEADER_VIEW;
        _messageTableView.contentInset = edgeInsets;
        [_messageTableView setContentOffset:CGPointMake(0, _messageTableView.contentOffset.y) animated:YES];
    }
}

- (void)updateFrameViewsRelatedUserProfile:(UserProfileView *)userProfileView {
    if (userProfileView == _userProfileView) {
        CGRect feelingSummarySectionFrame = _userProfileView.frame;
        feelingSummarySectionFrame.origin.y += _userProfileView.frame.size.height;
        feelingSummarySectionFrame.size.height = HEIGHT_FEELING_SUMARY_SECTION_HEADER_VIEW;
        _feelingSummarySection.frame = feelingSummarySectionFrame;
    }
}

@end
