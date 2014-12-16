//
//  UserProfileView.h
//  My Therapist
//

#import <UIKit/UIKit.h>
#import "UIColor+ColorUtilities.h"
#import "ProfileViewController.h"

@class UserProfileView;
@protocol UserProfileViewDelegate <NSObject>
@optional
- (void)checkinsAction;
- (void)followersAction;
- (void)followingsAction;
- (void)updateScrollIndicatorInset:(UIEdgeInsets)edgeInsets userProfileView:(UserProfileView *)userProfileView;
- (void)updateTableContentInset:(UIEdgeInsets)edgeInsets userProfileView:(UserProfileView *)userProfileView;
- (void)textViewDidScroll:(UIScrollView *)scrollView userProfileView:(UserProfileView *)userProfileView;
- (void)updateFrameViewsRelatedUserProfile:(UserProfileView *)userProfileView;

@end

@interface UserProfileView : UIView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *checkinsButton;
@property (weak, nonatomic) IBOutlet UIButton *followerButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UILabel *checkinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabels;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileBackgroundImageView;
@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTextViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (assign, nonatomic) CGFloat heightDefaultProfileView;
@property (strong, nonatomic) NSString *userID;

@property (nonatomic, weak) id<UserProfileViewDelegate> delegate;
@property (assign, nonatomic) CGFloat heightProfileView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstaintBottomView;
- (IBAction)userNameButtonAction:(id)sender;
- (IBAction)checkinsButtonAction:(id)sender;
- (IBAction)followersButtonAction:(id)sender;
- (IBAction)followingButtonAction:(id)sender;
- (IBAction)avatarAction:(id)sender;
- (void)changeBiographyTextViewHeight:(CGFloat)height;
- (void)setValueBiographyTextViewWithString:(NSString *)string;

@end
