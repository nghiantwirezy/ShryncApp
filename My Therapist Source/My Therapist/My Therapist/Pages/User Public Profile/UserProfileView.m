//
//  UserProfileView.m
//  My Therapist
//

#import "UserProfileView.h"
#import "AppDelegate.h"
#import "UserSession.h"
#import "PublicProfileViewController.h"

@implementation UserProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
    CGFloat widthProfileView = [[UIScreen mainScreen] bounds].size.width;
    CGRect profileViewFrame = CGRectMake(0, 0, widthProfileView, USER_PROFILE_HEADER_DEFAULT_HEIGHT);
    self.frame = profileViewFrame;
    [self initStyle];
    return self;
}

#pragma mark - Customs Methods

- (void)initStyle{
    [_checkinsButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_SMALL)];
    [_checkinsLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_checkinsButton setTitleColor:[UIColor darkModerateCyanColor] forState:UIControlStateNormal];
    _checkinsLabel.textColor = [UIColor darkModerateCyanColor];
    [_followerButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_SMALL)];
    [_followersLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_followerButton setTitleColor:[UIColor veryLightGrayColor] forState:UIControlStateNormal];
    _followersLabel.textColor = [UIColor veryLightGrayColor];
    [_followingButton.titleLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_SMALL)];
    [_followingLabel setFont:COMMON_BEBAS_FONT(SIZE_FONT_MEDIUM)];
    [_followingButton setTitleColor:[UIColor veryLightGrayColor] forState:UIControlStateNormal];
    _followingLabel.textColor = [UIColor veryLightGrayColor];
    [_usernameLabels setFont:COMMON_BEBAS_FONT(SIZE_FONT_BIG)];
    
    [_avatarImageView.layer setMasksToBounds:YES];
    [_avatarImageView.layer setCornerRadius:30];
    [_avatarImageView setImage:[UIImage imageNamed:DEFAULT_USER_IMAGE_NAME]];
    
    _titleLabel.shadowColor = [UIColor whiteColor];
    _titleLabel.shadowOffset = CGSizeMake(0, 1);
    _titleLabel.textColor = [UIColor veryLightGrayColor];
    _titleLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_VERY_BIG);
    
    _usernameLabels.textColor = [UIColor veryLightGrayColor];
    _usernameLabels.font = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    
    // Setup Bio TextView
    _biographyTextView.font = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
    _biographyTextView.textColor = [UIColor veryLightGrayColor];
    _heightDefaultProfileView = USER_PROFILE_HEADER_DEFAULT_HEIGHT;
}

- (void)changeBiographyTextViewHeight:(CGFloat)height {
    height = (height > HEIGHT_MAX_BIOGRAPHY_TEXT_VIEW)?HEIGHT_MAX_BIOGRAPHY_TEXT_VIEW:height;
    _heightTextViewConstraint.constant = (height >= 0)?height:0;
    CGRect userProfileFrame = self.frame;
    userProfileFrame.size.height = (height > 0)?(_heightDefaultProfileView + height):_heightDefaultProfileView;
    _heightProfileView = userProfileFrame.size.height;
    [UIView animateWithDuration:TIME_TO_EXPAND_PROFILE_VIEW animations:^{
        self.frame = userProfileFrame;
        if (_delegate &&[_delegate respondsToSelector:@selector(updateFrameViewsRelatedUserProfile:)]) {
            [_delegate performSelector:@selector(updateFrameViewsRelatedUserProfile:) withObject:self];
        }
        [self layoutIfNeeded];
    }completion:^(BOOL finished){
        if (_delegate &&[_delegate respondsToSelector:@selector(updateScrollIndicatorInset:userProfileView:)]) {
            [_delegate updateScrollIndicatorInset:UIEdgeInsetsMake(_heightProfileView, 0, 0, 0) userProfileView:self];
        }
        if (_delegate &&[_delegate respondsToSelector:@selector(updateTableContentInset:userProfileView:)]) {
            [_delegate updateTableContentInset:UIEdgeInsetsMake(_heightProfileView, 0, 0, 0) userProfileView:self];
        }
    }];
}

- (void)setValueBiographyTextViewWithString:(NSString *)biography {
    if ((biography != (id)[NSNull null]) && (biography.length > 0)) {
        biography = [biography stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (biography.length > 0) {
            _biographyTextView.text = biography;
            CGSize textViewSize = [_biographyTextView sizeThatFits:CGSizeMake(_biographyTextView.frame.size.width, FLT_MAX)];
            _biographyTextView.scrollEnabled = (textViewSize.height >= HEIGHT_MAX_BIOGRAPHY_TEXT_VIEW)?YES:NO;
            [self changeBiographyTextViewHeight:textViewSize.height];
        }
    }
}

#pragma mark - Actions

- (IBAction)userNameButtonAction:(id)sender {
    [self showDetailProfileUser];
}

- (IBAction)checkinsButtonAction:(id)sender {
    if (_delegate &&[_delegate respondsToSelector:@selector(checkinsAction)]) {
        [self.delegate checkinsAction];
    }
}

- (IBAction)followersButtonAction:(id)sender {
    if (_delegate &&[_delegate respondsToSelector:@selector(followersAction)]) {
        [self.delegate followersAction];
    }
}

- (IBAction)followingButtonAction:(id)sender {
    if (_delegate &&[_delegate respondsToSelector:@selector(followingsAction)]) {
        [self.delegate followingsAction];
    }
}

- (IBAction)avatarAction:(id)sender {
    [self showDetailProfileUser];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_delegate &&[_delegate respondsToSelector:@selector(textViewDidScroll:userProfileView:)]) {
        [self.delegate textViewDidScroll:scrollView userProfileView:self];
    }
}

#pragma mark - Custom Methods

- (void)showDetailProfileUser {
    UserSession *userSession = [UserSession currentSession];
    if (_userID && (![_userID isEqualToString:userSession.userId])) {
        // Do nothing
    }else {
        ProfileViewController *profileViewController = myAppDelegate.profileViewController;
        [profileViewController resetEditStates];
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        for (UIViewController *viewController in myAppDelegate.navigationController.viewControllers) {
            if (viewController != profileViewController) {
                [controllers addObject:viewController];
            }
        }
        [controllers addObject:profileViewController];
        [myAppDelegate.navigationController setViewControllers:controllers animated:YES];
    }
}

@end
