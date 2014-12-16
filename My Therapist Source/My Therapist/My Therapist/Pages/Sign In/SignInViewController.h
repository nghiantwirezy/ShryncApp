//
//  SignInViewController.h
//  My Therapist
//
//  Created by Yexiong Feng on 11/24/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface SignInViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentContainerView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel *signInTopLabel, *switchToSignUpTopLabel;
@property (strong, nonatomic) IBOutlet UIButton *signInButton, *switchToSignUpButton;

@property (strong, nonatomic) IBOutlet UIView *nicknameContainerView, *passwordContainerView;
@property (strong, nonatomic) IBOutlet UITextField *nicknameTextField, *passwordTextField;

@property (readonly, nonatomic) MBProgressHUD *hud;

- (IBAction)signUpButtonAction;
- (IBAction)signInButtonAction;

@end
