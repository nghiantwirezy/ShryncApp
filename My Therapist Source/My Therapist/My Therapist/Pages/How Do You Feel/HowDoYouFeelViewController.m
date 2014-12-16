//
//  HowDoYouFeelViewController.m
//  My Therapist
//
//  Created by Yexiong Feng on 11/19/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "HowDoYouFeelViewController.h"
#import "AppDelegate.h"
#import "FeelingCell.h"
#import "AddCommentViewController.h"
#import "UserSession.h"
#import "Feeling.h"
#import "UIColor+ColorUtilities.h"
#import "BaseModel.h"

@implementation HowDoYouFeelViewController {
    NSArray *_feelingCells;
    UIView *_checkinLabelCoveringView, *_resetLabelCoveringView;
    UIView *_emotionPopupView;
    Feeling *_feelingCustom;
    NSArray *_emotionsArray;
    BOOL showHideEmotionPopupViewDone;
    UserProfileView *_userProfileView;
    BaseModel *_baseModel;
    NSCache *_avatarCache;
}

#pragma mark - HowDoYouFeelViewController management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _baseModel = [BaseModel shareBaseModel];
    _feelings = [Feeling createAllFeelings];
    _avatarCache = [[NSCache alloc] init];
    [self initHeaderView];
    
    NSMutableArray *feelingCells = [[NSMutableArray alloc] init];
    for (int i = 0; i < _feelings.count; ++i) {
        FeelingCell *cell = [[FeelingCell alloc] initWithFeeling:[_feelings objectAtIndex:i]];
        [feelingCells addObject:cell];
    }
    _feelingCells = feelingCells;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME_LABEL_TITLE_HOW_DO_YOU_FEEL];
    titleLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_TITLE_DEFAULT);
    titleLabel.text = NSLocalizedString(TITLE_APPLICATION, nil);
    titleLabel.textColor = [UIColor veryLightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    self.checkinLabel.font = self.resetLabel.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_LABEL_CHECKIN_HOW_DO_YOU_FEEL);
    [self.checkinLabel sizeToFit];
    [self.resetLabel sizeToFit];
    
    _checkinLabelCoveringView = [[UIView alloc] initWithFrame:self.checkinLabel.bounds];
    _resetLabelCoveringView = [[UIView alloc] initWithFrame:self.resetLabel.bounds];
    _checkinLabelCoveringView.userInteractionEnabled = _resetLabelCoveringView.userInteractionEnabled = NO;
    _checkinLabelCoveringView.backgroundColor = _resetLabelCoveringView.backgroundColor = [UIColor whiteColor];
    
    [self.checkinLabel addSubview:_checkinLabelCoveringView];
    [self.resetLabel addSubview:_resetLabelCoveringView];
    
    [self setButtonsEnabled:NO];
    showHideEmotionPopupViewDone = YES;
    [self createEmotionPopupView];
    _needResetFeeling = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem = ((AppDelegate *) [[UIApplication sharedApplication] delegate]).revealMenuButtonItem;
    
    UserSession *userSession = [UserSession currentSession];
    _userProfileView.usernameLabels.text = userSession.username;
    _userProfileView.userID = userSession.userId;
    [self setUserAvatarForImage:_userProfileView.avatarImageView];
    [self getBiographyAndBackgroundUserFromServer];
    if (_needResetFeeling) {
        [self resetButtonAction];
        _needResetFeeling = NO;
    }
}

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
    profileViewFrame.origin.y = 0;
    profileViewFrame.size.height = _heightProfileView;
    _userProfileView.frame = profileViewFrame;
    _userProfileView.delegate = self;
    
    _feelingTableView.contentInset = UIEdgeInsetsMake(_heightProfileView + HEIGHT_INPUT_FEELING_HOW_DO_YOU_FEEL, 0, 0, 0);
    [_feelingTableView addSubview:_userProfileView];
    _feelingTableView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView + HEIGHT_INPUT_FEELING_HOW_DO_YOU_FEEL, 0, 0, 0);
}

#pragma mark - Custom Methods

- (void)setButtonsEnabled:(BOOL)enabled
{
    self.checkinButton.userInteractionEnabled = self.resetButton.userInteractionEnabled = enabled;
    [UIView animateWithDuration:0.3 animations:^{
        _checkinLabelCoveringView.alpha = _resetLabelCoveringView.alpha = enabled ? 0 : ALPHA_LABEL_CHECKIN_COVERING_VIEW_HOW_DO_YOU_FEEL;
    }];
}

- (void)scrollToExpandedRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_feelingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)showHideEmotionPopupView {
    if (showHideEmotionPopupViewDone) {
        showHideEmotionPopupViewDone = NO;
        BOOL needShow = _emotionPopupView.isHidden;
        CGRect emotionFrameHide = CGRectMake(_emotionPopupView.frame.origin.x, _emotionPopupView.frame.origin.y, 0, 0);
        CGRect emotionFrameShow = CGRectMake(_emotionPopupView.frame.origin.x, _emotionPopupView.frame.origin.y, _inputFeelingView.frame.size.width, HEIGHT_EMOTION_SCROLL_VIEW_HOW_DO_YOU_FEEL);
        
        _emotionPopupView.frame = (needShow)?emotionFrameHide:emotionFrameShow;
        [UIView animateWithDuration:TIME_SHOW_HIDE_EMOTION_HOW_DO_YOU_FEEL delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            if (needShow) {
                _emotionPopupView.hidden = NO;
                _emotionPopupView.frame = emotionFrameShow;
            }else{
                _emotionPopupView.frame = emotionFrameHide;
            }
        }completion:^(BOOL finished){
            _emotionPopupView.hidden = (needShow)?NO:YES;
            showHideEmotionPopupViewDone = YES;
        }];
    }
}

- (NSArray *)componentsSeparatedFromString:(NSString *)stringInput byString:(NSString *)stringSeparated{
    NSArray *separatedArray = [stringInput componentsSeparatedByString:stringSeparated];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    for (NSString *feelingFromArray in separatedArray) {
        //Trim String
        NSString *stringTrimmed = [feelingFromArray stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSMutableCharacterSet *charactersToKeep = [NSMutableCharacterSet alphanumericCharacterSet];
        [charactersToKeep addCharactersInString:@" "];
        
        NSCharacterSet *charactersToRemove = [charactersToKeep invertedSet];
        
        NSString *trimmedReplacement = [[stringTrimmed componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
        if ((trimmedReplacement) && (![trimmedReplacement  isEqualToString: @""])) {
            [resultArray addObject:trimmedReplacement];
        }
    }
    return [NSArray arrayWithArray:resultArray];
}

- (void)setUserAvatarForImage:(UIImageView *)imageView {
    imageView.image = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
    UserSession *userSession = [UserSession currentSession];
    BOOL isNeedRequestAvatar = YES;
    if (userSession.userAvatar) {
        imageView.image = userSession.userAvatar;
        isNeedRequestAvatar = NO;
    }
    if (isNeedRequestAvatar) {
        UIImage *avatar = [_avatarCache objectForKey:userSession.userId];
        NSDictionary *parameters = @{KEY_USER_ID:userSession.userId};
        if (!avatar) {
            [_baseModel getUserAvatarWithParameters:parameters completion:^(id responseObject, NSError *error){
                if (!error) {
                    UIImage *avatar = responseObject;
                    if (avatar == nil) {
                        avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
                    } else {
                        [_avatarCache setObject:responseObject forKey:userSession.userId];
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
    if ((userSession.userBiography != (id)[NSNull null]) && (userSession.userBiography.length > 0)) {
        [_userProfileView setValueBiographyTextViewWithString:userSession.userBiography];
        needRequestBiography = NO;
    }
    
    // Background
    if ((userSession.backgroundImage)) {
        _userProfileView.profileBackgroundImageView.image = userSession.backgroundImage;
        needRequestBackground = NO;
    }else {
        needRequestBackground = YES;
    }
    
    if (needRequestBiography || needRequestBackground)  {
        NSDictionary *parameters = @{KEY_TOKEN_PARAM:[UserSession currentSession].sessionToken, KEY_USER_ID:userSession.userId};
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
            if(userProfileBackgroundImage){
                UserSession *userSession = [UserSession currentSession];
                _userProfileView.profileBackgroundImageView.image = userSession.backgroundImage = userProfileBackgroundImage;
            }else {
                UIImage *defaultBackgroundImage = [UIImage imageNamed:IMAGE_NAME_AUTUMN_COLOR];
                _userProfileView.profileBackgroundImageView.image = defaultBackgroundImage;
            }
        }else {
            NSLog(@"Couldn't complete with error: %@",error);
        }
    }];
}

- (BOOL)canUserCheckins{
    BOOL result = NO;
    if (_feelingCustom) {
        if (_feelingCustom.mainFeelingName.length > 0) {
            result = YES;
        }
    }else {
        for (Feeling *feeling in _feelings) {
            if (feeling.feelingStrength > 0) {
                result = YES;
                break;
            }
        }
    }
    return result;
}

#pragma mark - Actions

- (IBAction)checkInButtonAction
{
    if ([self canUserCheckins]) {
        NSMutableArray *feelings = [[NSMutableArray alloc] init];
        for (FeelingCell *cell in _feelingCells) {
            [cell prepareForCheckIn];
            if (cell.feeling.feelingStrength > 0) {
                cell.feeling.subFeelingNames = [Feeling subFeelingNamesFromIndexesArray:cell.feeling.selectedSubFeelingIndexes
                                                                    andMainFeelingIndex:[NSString stringWithFormat:@"%d",cell.feeling.mainFeelingIndex]];
                cell.feeling.selectedSubFeelingNames = [NSMutableArray arrayWithArray:cell.feeling.subFeelingNames];
                [feelings addObject:cell.feeling];
            }
        }
        if ((_feelingCustom) && (![_feelingCustom.iconID isEqualToString:@""]) && (![_feelingCustom.mainFeelingName isEqualToString:@""])) {
            [feelings addObject:_feelingCustom];
        }
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [((AddCommentViewController *)delegate.addCommentViewController) setFeelings:feelings];
        [self.navigationController pushViewController:delegate.addCommentViewController animated:YES];
    }
}

- (IBAction)resetButtonAction
{
    for (FeelingCell *cell in _feelingCells) {
        [cell reset];
    }
    _feelingCustom = nil;
    self.howYouFeelTextField.text = @"";
    [self.feelingTableView beginUpdates];
    [self.feelingTableView endUpdates];
}

- (IBAction)emotionButtonAction:(id)sender {
    [self showHideEmotionPopupView];
}

- (void)iconAction:(UIButton *)sender{
    UIImage *imageDefaultEmtionButton = [Feeling imageEmotionWithID:[NSString stringWithFormat:@"%d",(int)sender.tag]];
    [_emotionButton setBackgroundImage:imageDefaultEmtionButton forState:UIControlStateNormal];
    _emotionButton.tag = sender.tag;
    _feelingCustom.iconID = [NSString stringWithFormat:@"%d",(int)_emotionButton.tag];
    if (!_emotionPopupView.isHidden) {
        [self showHideEmotionPopupView];
    }
}

- (IBAction)viewTapAction:(id)sender {
    [self.view endEditing:YES];
    if (!_emotionPopupView.isHidden) {
        [self showHideEmotionPopupView];
    }
}

#pragma mark - TableView Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _feelingCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_feelingCells objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeelingCell *cell = (FeelingCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ((cell.feelingStrengthSlider.value == 0) && !cell.cellExpanded) {
        cell.feelingStrengthSlider.value = FEELING_STRENGTH_DEFAULT;
        [cell didChangeValueSlider];
    }
    BOOL needScrollToRow = YES;
    if (cell.cellExpanded) {
        NSInteger numberOfRow = [tableView numberOfRowsInSection:indexPath.section];
        CGFloat bottomYOffSet = tableView.contentSize.height - tableView.frame.size.height;
        CGFloat currentYOffSet = tableView.contentOffset.y;
        if (((numberOfRow - INDEX_START_BY_1(indexPath.row)) == 0) || (currentYOffSet == bottomYOffSet)) {
            needScrollToRow = NO;
            CGFloat yOffSetCellExpandedToCellCollapse = HEIGHT_FEELING_CELL_EXPAND_HOW_DO_YOU_FEEL - HEIGHT_FEELING_CELL_COLLAPSE_HOW_DO_YOU_FEEL;
            [UIView animateWithDuration:(TIME_DELAY_SCOLL_CELL_FEELING_CELL + TIME_EXPAND_CELL_FEELING_CELL) animations:^{
                tableView.contentOffset = CGPointMake(tableView.contentOffset.x, currentYOffSet - yOffSetCellExpandedToCellCollapse);
            }];
        }
    }
    cell.cellExpanded = !cell.cellExpanded;
    if (cell.cellExpanded && needScrollToRow) {
        [self performSelector:@selector(scrollToExpandedRowAtIndexPath:) withObject:indexPath afterDelay:TIME_DELAY_SCOLL_CELL_FEELING_CELL];
    }
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeelingCell *cell = (FeelingCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.cellExpanded ? HEIGHT_FEELING_CELL_EXPAND_HOW_DO_YOU_FEEL : HEIGHT_FEELING_CELL_COLLAPSE_HOW_DO_YOU_FEEL;
}

#pragma mark - Custom emotion icon

- (void)createEmotionPopupView{
    _emotionPopupView = [[UIView alloc]initWithFrame:CGRectMake(_inputFeelingView.frame.origin.x, _inputFeelingView.frame.origin.y, _inputFeelingView.frame.size.width, HEIGHT_EMOTION_SCROLL_VIEW_HOW_DO_YOU_FEEL)];
    [_emotionPopupView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_EMOTION_BACKGROUND_HOW_DO_YOU_FEEL]];
    _emotionPopupView.Hidden = YES;
    _emotionPopupView.clipsToBounds = YES;
    
    // Make ScrollView to center emotion View
    CGFloat scrollViewPositionX = HALF_OF((_inputFeelingView.frame.size.width - WIDTH_EMOTION_SCROLL_VIEW_HOW_DO_YOU_FEEL));
    UIScrollView *emotionScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(scrollViewPositionX, 0, WIDTH_EMOTION_SCROLL_VIEW_HOW_DO_YOU_FEEL, HEIGHT_EMOTION_SCROLL_VIEW_HOW_DO_YOU_FEEL)];
    emotionScrollView.showsHorizontalScrollIndicator    = NO;
    emotionScrollView.showsVerticalScrollIndicator      = YES;
    
    _emotionsArray = [Feeling loadEmotionDataFromPlist];
    NSMutableArray *buttonArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < _emotionsArray.count; i++) {
        NSDictionary *emotionDict = [_emotionsArray objectAtIndex:i];
        if ([[emotionDict objectForKey:KEY_GROUP] isEqualToString:KEY_CUSTOM_ICON]) {
            UIImage *buttonImage = [UIImage imageNamed:[emotionDict objectForKey:KEY_URL]];
            if ([emotionDict objectForKey:KEY_SHOW] && (buttonImage)) {
                int indexOfRow = (int)(buttonArray.count / NUMBER_ICON_IN_ROW_EMOTION_HOW_DO_YOU_FEEL);
                int indexOfButtonInRow = (buttonArray.count % NUMBER_ICON_IN_ROW_EMOTION_HOW_DO_YOU_FEEL);
                CGFloat positionXButton = (INDEX_START_BY_1(indexOfButtonInRow) * MARGIN_EMOTION_BUTTON_HOW_DO_YOU_FEEL) + (indexOfButtonInRow *WIDTH_EMOTION_BUTTON_HOW_DO_YOU_FEEL);
                CGFloat positionYButton = (INDEX_START_BY_1(indexOfRow) * MARGIN_EMOTION_BUTTON_HOW_DO_YOU_FEEL) + (indexOfRow *HEIGHT_EMOTION_BUTTON_HOW_DO_YOU_FEEL);
                
                UIButton *emotionButton = [[UIButton alloc] initWithFrame:CGRectMake(positionXButton, positionYButton, WIDTH_EMOTION_BUTTON_HOW_DO_YOU_FEEL, HEIGHT_EMOTION_BUTTON_HOW_DO_YOU_FEEL)];
                [emotionButton setTitle:@"" forState:UIControlStateNormal];
                [emotionButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                emotionButton.backgroundColor = [UIColor clearColor];
                [emotionButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
                emotionButton.tag = [[emotionDict objectForKey:KEY_ID_UPPERCASE] integerValue];
                [emotionButton addTarget:self action:@selector(iconAction:) forControlEvents:UIControlEventTouchUpInside];
                [buttonArray addObject:emotionButton];
            }
        }
    }
    
    int totalOfRowScrollView = ((buttonArray.count % NUMBER_ICON_IN_ROW_EMOTION_HOW_DO_YOU_FEEL) == 0)?((int)(buttonArray.count /NUMBER_ICON_IN_ROW_EMOTION_HOW_DO_YOU_FEEL)):(INDEX_START_BY_1((int)(buttonArray.count /NUMBER_ICON_IN_ROW_EMOTION_HOW_DO_YOU_FEEL)));
    CGFloat emotionScrollViewContentWidth   = WIDTH_EMOTION_SCROLL_VIEW_HOW_DO_YOU_FEEL;
    CGFloat emotionScrollViewContentHeight  = (totalOfRowScrollView * HEIGHT_EMOTION_BUTTON_HOW_DO_YOU_FEEL) + (totalOfRowScrollView * MARGIN_EMOTION_BUTTON_HOW_DO_YOU_FEEL);
    emotionScrollView.contentSize   = CGSizeMake(emotionScrollViewContentWidth, emotionScrollViewContentHeight);
    emotionScrollView.contentInset  = UIEdgeInsetsMake(0.0, 0.0, MARGIN_EMOTION_BUTTON_HOW_DO_YOU_FEEL, 0.0);
    
    for (UIButton *button in buttonArray) {
        [emotionScrollView addSubview:button];
    }
    
    if (buttonArray.count > 0) {
        UIImage *imageDefaultEmotionButton = [Feeling imageEmotionWithID:[NSString stringWithFormat:@"%d",(int)((UIButton *)[buttonArray objectAtIndex:0]).tag]];
        [_emotionButton setBackgroundImage:imageDefaultEmotionButton forState:UIControlStateNormal];
        _emotionButton.tag = (int)((UIButton *)[buttonArray objectAtIndex:0]).tag;
    }
    
    [_emotionPopupView addSubview:emotionScrollView];
    [self.outerContainerView addSubview:_emotionPopupView];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (!_emotionPopupView.isHidden) {
        [self showHideEmotionPopupView];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *emotionString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // Button check-In show/hide
    BOOL controllerButtonsEnabled = NO;
    if ((emotionString) && ([emotionString length] > 0)) {
        NSMutableArray *feelingNamesCutomTrimArray = [[NSMutableArray alloc]init];
        feelingNamesCutomTrimArray = [NSMutableArray arrayWithArray:[self componentsSeparatedFromString:emotionString byString:@","]];
        if (feelingNamesCutomTrimArray.count > 0) {
            //TODO: Add feeling
            _feelingCustom = [[Feeling alloc] init];
            _feelingCustom.feelingStrength = FEELING_STRENGTH_MAX;
            _feelingCustom.mainFeelingName = [feelingNamesCutomTrimArray objectAtIndex:0];
            _feelingCustom.iconID = [NSString stringWithFormat:@"%d",(int)_emotionButton.tag];
            _feelingCustom.feelingNameActiveColor = [Feeling colorEmotionWithIconID:_feelingCustom.iconID];
            if (feelingNamesCutomTrimArray.count > 1) {
                [feelingNamesCutomTrimArray removeObjectAtIndex:0];
                _feelingCustom.subFeelingNames = [NSArray arrayWithArray:feelingNamesCutomTrimArray];
                _feelingCustom.selectedSubFeelingNames = [NSMutableArray arrayWithArray:_feelingCustom.subFeelingNames];
            }
            controllerButtonsEnabled = YES;
        }
    }else{
        _feelingCustom = nil;
        for (Feeling *feeling in _feelings) {
            if (feeling.feelingStrength > 0) {
                controllerButtonsEnabled = YES;
                break;
            }
        }
    }
    [self setButtonsEnabled:controllerButtonsEnabled];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        [self checkInButtonAction];
    }
    return YES;
}

#pragma mark - Profile View delegate

- (void)updateScrollIndicatorInset:(UIEdgeInsets)edgeInsets userProfileView:(UserProfileView *)userProfileView {
    if (userProfileView == _userProfileView) {
        _heightProfileView = _userProfileView.heightProfileView;
        edgeInsets.top = _heightProfileView + HEIGHT_INPUT_FEELING_HOW_DO_YOU_FEEL;
        _feelingTableView.scrollIndicatorInsets = edgeInsets;
    }
}

- (void)updateTableContentInset:(UIEdgeInsets)edgeInsets userProfileView:(UserProfileView *)userProfileView {
    if (userProfileView == _userProfileView) {
        edgeInsets.top = _heightProfileView + HEIGHT_INPUT_FEELING_HOW_DO_YOU_FEEL;
        _feelingTableView.contentInset = edgeInsets;
        [_feelingTableView setContentOffset:CGPointMake(0,_feelingTableView.contentOffset.y) animated:YES];
    }
}

- (void)updateFrameViewsRelatedUserProfile:(UserProfileView *)userProfileView {
    if (userProfileView == _userProfileView) {
        self.topInputFeelingConstraint.constant = _userProfileView.frame.size.height;
        CGRect emotionFrame = _emotionPopupView.frame;
        emotionFrame.origin.y = _userProfileView.frame.size.height + HEIGHT_INPUT_FEELING_HOW_DO_YOU_FEEL;
        _emotionPopupView.frame = emotionFrame;

    }
}

#pragma mark - ScrollView Delegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _feelingTableView) {
        CGFloat yOffset  = scrollView.contentOffset.y;
        if (yOffset < -(_heightProfileView + HEIGHT_INPUT_FEELING_HOW_DO_YOU_FEEL)) {
            CGRect fixedFrame = _userProfileView.frame;
            fixedFrame.size.height =  -yOffset - HEIGHT_INPUT_FEELING_HOW_DO_YOU_FEEL;
            fixedFrame.origin.y = yOffset;
            _userProfileView.frame = fixedFrame;
            
            self.topInputFeelingConstraint.constant = fixedFrame.size.height;
            CGRect emotionFrame = _emotionPopupView.frame;
            emotionFrame.origin.y = fixedFrame.size.height + HEIGHT_INPUT_FEELING_HOW_DO_YOU_FEEL;
            _emotionPopupView.frame = emotionFrame;

            _feelingTableView.scrollIndicatorInsets = UIEdgeInsetsMake(-yOffset, 0, 0, 0);
        }else{
            CGRect fixedFrame = _userProfileView.frame;
            fixedFrame.origin.y = yOffset;
            _userProfileView.frame = fixedFrame;
            
            self.topInputFeelingConstraint.constant = fixedFrame.size.height;
            CGRect emotionFrame = _emotionPopupView.frame;
            emotionFrame.origin.y = fixedFrame.size.height + HEIGHT_INPUT_FEELING_HOW_DO_YOU_FEEL;
            _emotionPopupView.frame = emotionFrame;
            
            _feelingTableView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightProfileView + HEIGHT_INPUT_FEELING_HOW_DO_YOU_FEEL, 0, 0, 0);
        }
    }
}

@end
