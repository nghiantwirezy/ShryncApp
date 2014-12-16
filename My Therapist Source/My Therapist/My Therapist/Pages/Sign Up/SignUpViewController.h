//
//  SignUpViewController.h
//  My Therapist
//
//  Created by Yexiong Feng on 11/27/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAreaSelectorDelegate.h"

@interface SignUpViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, ImageAreaSelectorDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentContainerView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;

@property (strong, nonatomic) IBOutlet UILabel *signUpTopLabel, *termLabelTop, *termLabelDown;
@property (strong, nonatomic) IBOutlet UIButton *selectPhotoButton, *signUpButton, *termButton, *privacyButton;
@property (strong, nonatomic) IBOutlet UITextField *nicknameTextField, *emailTextField, *passwordTextField, *confirmPasswordTextField;

- (IBAction)showImagePicker:(id)sender;
- (IBAction)signUpButtonPressed:(id)sender;
- (IBAction)privacyButtonAction;
- (IBAction)termButtonAction;

@end
