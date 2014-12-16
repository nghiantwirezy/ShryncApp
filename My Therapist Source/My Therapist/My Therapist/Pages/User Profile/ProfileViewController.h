//
//  ProfileViewController.h
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAreaSelectionViewController.h"

@class ContainedWebViewController;

@interface ProfileViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, ImageAreaSelectorDelegate,UIActionSheetDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel, *memberSinceLabel, *defaultVisibilityLabel, *defaultProfileVisibilityLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField, *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userBiographyTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton, *updatePhotoTextButton, *updateEmailButton, *updatePasswordButton, *updatePhotoButton, *revertEmailButton, *revertPasswordButton, *revertPhotoButton, *updateBackgroundImageButton, *updateBackgroundImageTextButton, *revertBackgroundImageButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyButton, *termButton, *aboutButton;
@property (weak, nonatomic) IBOutlet UISwitch *defaultSwitch, *defaultProfileSwitch;
@property (weak, nonatomic) IBOutlet UIButton *labelDefaulAllCheckin, *labelDefaultProfilePublic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceProfileViewConstaint;
@property (weak, nonatomic) IBOutlet UIButton *resetUserBiographyButton;
@property (weak, nonatomic) IBOutlet UIButton *updateUserBiographuButton;
@property (weak, nonatomic) IBOutlet UIView *avatarContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightProfileViewConstaint;
@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBiographyConstaint;
@property (assign, nonatomic) CGFloat heightProfileView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContentContainerConstaint;
@property (assign, nonatomic) CGFloat heightDefaultContentContainer;

- (IBAction)updateEmailButtonPressed;
- (IBAction)resetEmailButtonPressed;
- (IBAction)updatePasswordButtonPressed;
- (IBAction)resetPasswordButtonPressed;
- (IBAction)updatePhotoButtonPressed;
- (IBAction)resetPhotoButtonPressed;
- (IBAction)updateBackgroundImageButtonPressed;
- (IBAction)resetBackgroundImageButtonPressed;
- (IBAction)submitButtonPressed;
- (IBAction)resetUserBiographyButtonPress:(id)sender;
- (IBAction)updateUserBiographyButtonPress:(id)sender;
- (IBAction)defaultSwitchedAction:(id)sender;
- (IBAction)defaultSwitchedProfileAction:(id)sender;
- (IBAction)privacyButtonAction;
- (IBAction)termButtonAction;
- (IBAction)aboutButtonAction;

- (void)resetNavigationLeftItems;
- (void)resetEditStates;
- (void)getBackgroundUserFromServer;

@end
