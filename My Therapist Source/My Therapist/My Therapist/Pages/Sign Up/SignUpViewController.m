//
//  SignUpViewController.m
//  My Therapist
//
//  Created by Yexiong Feng on 11/27/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "SignUpViewController.h"
#import "ImageAreaSelectionViewController.h"
#import "AppDelegate.h"
#import "UserSession.h"
#import "AFHTTPRequestOperationManager.h"
#import "ContainedWebViewController.h"
#import "MBProgressHUD.h"

#define USER_AVATAR_FILE_NAME @"/user.png"

#define TITLE @"SIGN UP"
#define NICKNAME_LABEL @"NICKNAME"
#define EMAIL_LABEL @"E-MAIL"
#define PASSWORD_LABEL @"PASSWORD"
#define CONFIRM_PASSWORD_LABEL @"CONFIRM PASSWORD"

#define DEFAULT_USER_IMAGE_NAME @"signup default user image.png"

#define NICKNAME_REQUEST_KEY @"nickname"
#define PASSWORD_REQUEST_KEY @"password"
#define EMAIL_REQUEST_KEY @"email"
#define USER_PHOTO_REQUEST_KEY @"avatar"

#define USER_EXISTS_ERROR_CODE 409

#define SIGNUP_IN_PROGRESS @"Signing Up..."
#define SIGNUP_SUCCEEDED @"Welcome to MyTherapist!"
#define ERROR_USER_EXISTS @"Nickname or email already used!"
#define ERROR_GENERAL @"Unable to contact server!"

#define SIGNUP_ENDPOINT @"https://secure.shrync.com/api/user/register"

@interface SignUpViewController ()

@end

@implementation SignUpViewController {
  UIImagePickerController *_imagePicker;
  UIImage *_profileImage;
  
  MBProgressHUD *_hud;
  UIImageView *_hudCustomeView;
}

- (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
  BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
  NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
  NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:checkString];
}

- (void)privacyButtonAction
{
  ContainedWebViewController *viewController = myAppDelegate.privacyTextView;
  [viewController presentFromController:self];
}

- (void)termButtonAction
{
  ContainedWebViewController *viewController = myAppDelegate.termTextView;
  [viewController presentFromController:self];
}

- (void)popBack
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboard
{
  [self.nicknameTextField resignFirstResponder];
  [self.emailTextField resignFirstResponder];
  [self.passwordTextField resignFirstResponder];
  [self.confirmPasswordTextField resignFirstResponder];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotification
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    if (self.scrollView.contentOffset.y < 130) {
      self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 130);
    }
    
  } completion:nil];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
  [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
  } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self hideKeyboard];
  [super viewWillDisappear:animated];
}

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
  _imagePicker = [[UIImagePickerController alloc] init];
  _imagePicker.navigationBar.translucent = NO;
  _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  _imagePicker.delegate = self;
  
  _hud = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:_hud];
  _hud.labelFont = [UIFont fontWithName:@"BebasNeue" size:13.0];
  
  _hudCustomeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yes.png"]];
  _hud.customView = _hudCustomeView;
  
  self.profilePictureImageView.contentMode = UIViewContentModeScaleAspectFit;
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
  titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:21.0f];
  titleLabel.text = NSLocalizedString(TITLE, nil);
  titleLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  self.navigationItem.titleView = titleLabel;
  
  UIImage *backImage = [UIImage imageNamed:@"back button.png"];
  UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
  [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  self.navigationItem.leftBarButtonItem = backButtonItem;
  
  self.signUpTopLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:19.0f];
  
  self.selectPhotoButton.titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:10.0f];
  
  UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 24)];
  nicknameLabel.text = NSLocalizedString(NICKNAME_LABEL, nil);
  nicknameLabel.font =[UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  nicknameLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
  self.nicknameTextField.leftView = nicknameLabel;
  self.nicknameTextField.leftViewMode = UITextFieldViewModeAlways;
  self.nicknameTextField.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  
  UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 38, 24)];
  emailLabel.text = NSLocalizedString(EMAIL_LABEL, nil);
  emailLabel.font =[UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  emailLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
  self.emailTextField.leftView = emailLabel;
  self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
  self.emailTextField.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  
  UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 24)];
  passwordLabel.text = NSLocalizedString(PASSWORD_LABEL, nil);
  passwordLabel.font =[UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  passwordLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
  self.passwordTextField.leftView = passwordLabel;
  self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
  
  UILabel *confirmPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 24)];
  confirmPasswordLabel.text = NSLocalizedString(CONFIRM_PASSWORD_LABEL, nil);
  confirmPasswordLabel.font =[UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  confirmPasswordLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
  self.confirmPasswordTextField.leftView = confirmPasswordLabel;
  self.confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
  
  [self.signUpButton setBackgroundImage:myAppDelegate.lightGreenImage forState:UIControlStateNormal];
  self.signUpButton.titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  
  UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
  [self.scrollView addGestureRecognizer:gestureRecognizer];
  gestureRecognizer.cancelsTouchesInView = NO;  // this prevents the gesture recognizers to 'block' touches
  
  self.termLabelTop.font = self.termLabelDown.font = self.termButton.titleLabel.font = self.privacyButton.titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:13.0f];
  
  [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  BOOL canSignUp = YES;
  
  NSArray *textFields = [NSArray arrayWithObjects:self.nicknameTextField, self.emailTextField, self.passwordTextField, self.confirmPasswordTextField, nil];
  for (UITextField *checkedTextField in textFields) {
    canSignUp = canSignUp && checkedTextField.text.length > 0;
  }
  
  canSignUp = canSignUp && [self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text];
  
  self.signUpButton.enabled = canSignUp;
}

- (void)showImagePicker:(id)sender
{
  [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  
  ImageAreaSelectionViewController *imageSelectionViewController = [ImageAreaSelectionViewController new];
  imageSelectionViewController.delegate = self;
  imageSelectionViewController.image = image;
  [picker pushViewController:imageSelectionViewController animated:YES];
}

- (void)setAreaSelectedImage:(UIImage *)image
{
  _profileImage = image;
  self.profilePictureImageView.image = image;
  self.selectPhotoButton.titleLabel.text = nil;
  
  [self.selectPhotoButton setTitle:@"" forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [NSArray arrayWithObjects:self.nicknameTextField, self.emailTextField, self.passwordTextField, self.confirmPasswordTextField, nil];
    if (textField == self.nicknameTextField) {
        [self.emailTextField becomeFirstResponder];
    }
    else if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self.confirmPasswordTextField becomeFirstResponder];
    }
    else if (textField == self.confirmPasswordTextField) {
        [self.confirmPasswordTextField resignFirstResponder];
        if ([self canSignUp]) {
            [self signUpButtonPressed:nil];
        }
        else{
            return NO;
        }
    }
    return YES;
}

-(BOOL)canSignUp{
    BOOL canSignUp = YES;
    NSArray *textFields = [NSArray arrayWithObjects:self.nicknameTextField, self.emailTextField, self.passwordTextField, self.confirmPasswordTextField, nil];
    for (UITextField *checkedTextField in textFields) {
        if (checkedTextField == self.emailTextField) {
            canSignUp &= [self NSStringIsValidEmail:self.emailTextField.text];
        } else {
            canSignUp &= checkedTextField.text.length > 0;
        }
    }
    return canSignUp;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  NSMutableString *endString = [NSMutableString stringWithString:textField.text];
  [endString replaceCharactersInRange:range withString:string];
  BOOL canSignUp = endString.length > 0;
  
  if (textField == self.passwordTextField) {
    canSignUp &= [endString isEqualToString:self.confirmPasswordTextField.text];
  } else if (textField == self.confirmPasswordTextField) {
    canSignUp &= [endString isEqualToString:self.passwordTextField.text];
  } else if (textField == self.emailTextField) {
    BOOL isEmailValid = [self NSStringIsValidEmail:endString];
    if (!isEmailValid) {
      self.emailTextField.textColor = [UIColor redColor];
    } else {
      self.emailTextField.textColor = [UIColor darkGrayColor];
    }
    canSignUp &= isEmailValid;
  }
  
  NSArray *textFields = [NSArray arrayWithObjects:self.nicknameTextField, self.emailTextField, self.passwordTextField, self.confirmPasswordTextField, nil];
  for (UITextField *checkedTextField in textFields) {
    if (textField != checkedTextField) {
      if (checkedTextField == self.emailTextField) {
        canSignUp &= [self NSStringIsValidEmail:self.emailTextField.text];
      } else {
        canSignUp &= checkedTextField.text.length > 0;
      }
    }
  }

  self.signUpButton.enabled = canSignUp;
  
  return YES;
}

- (void)signUpButtonPressed:(id)sender
{  
  NSString *username = self.nicknameTextField.text;
  NSString *email = self.emailTextField.text;
  NSString *password = self.passwordTextField.text;
  UIImage *userImage = _profileImage;
  
  if (userImage == nil) {
    userImage = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
  }
  NSData *photoData = UIImagePNGRepresentation(userImage);
  NSString *localFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:USER_AVATAR_FILE_NAME];
  [photoData writeToFile:localFilePath atomically:YES];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  NSDictionary *parameters = @{NICKNAME_REQUEST_KEY: username, EMAIL_REQUEST_KEY: email, PASSWORD_REQUEST_KEY: password};
  NSURL *filePath = [NSURL fileURLWithPath:localFilePath];
  
  [manager POST:SIGNUP_ENDPOINT parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileURL:filePath name:USER_PHOTO_REQUEST_KEY error:nil];
    
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = NSLocalizedString(SIGNUP_IN_PROGRESS, nil);
    [_hud show:YES];
  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    _hud.labelText = NSLocalizedString(SIGNUP_SUCCEEDED, nil);
    _hudCustomeView.image = [UIImage imageNamed:@"yes.png"];
    _hud.customView = _hudCustomeView;
    _hud.mode = MBProgressHUDModeCustomView;
    [_hud hide:YES afterDelay:2.0];
    
    [UserSession signedInWithDictonary:responseObject];
    
    [myAppDelegate performSelector:@selector(navigateToLandingPage) withObject:nil afterDelay:2.0];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    
    if (operation.response.statusCode == USER_EXISTS_ERROR_CODE) {
      _hud.labelText = NSLocalizedString(ERROR_USER_EXISTS, nil);
    } else {
      _hud.labelText = NSLocalizedString(ERROR_GENERAL, nil);
    }
    _hudCustomeView.image = [UIImage imageNamed:@"no.png"];
    _hud.customView = _hudCustomeView;
    _hud.mode = MBProgressHUDModeCustomView;
    [_hud hide:YES afterDelay:2.0];
  }];
    [self hideKeyboard];
}

@end
