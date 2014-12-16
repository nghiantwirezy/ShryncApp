//
//  SignInViewController.m
//  My Therapist
//
//  Created by Yexiong Feng on 11/24/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "SignInViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserSession.h"
#import "FeelingRecordLoader.h"
#import "MyFeelingsViewController.h"

#define TITLE @"SIGN IN"
#define NICKNAME_LABEL @"NICKNAME"
#define PASSWORD_LABEL @"PASSWORD"

//#define SIGNIN_ENDPOINT @"https://secure.mytherapistapp.com/api/user/login"
#define SIGNIN_ENDPOINT @"https://secure.shrync.com/api/user/login"
#define LOGIN_PARAM @"login"
#define PASSWORD_PARAM @"password"

#define SIGNIN_LABEL @"Signing In..."
#define SIGNIN_LOADING_LABEL @"Loading..."
#define ERROR_DENIED_LABEL @"Wrong username or password!"
#define ERROR_GENERAL_LABEL @"Unable to contact server!"
#define ERROR_DENIED_CODE 403

#define GET_AVATAR_ENDPOINT @"https://secure.shrync.com/api/user/getavatar"
#define USER_ID_PARAM @"userid"
#define ERROR_LOADING_FAILED_LABEL @"Loading failed!"
#define ERROR_AVATAR_NOT_FOUND 404

#define USER_DICT_KEY @"user"
#define USER_ID_KEY @"id"

#define DEFAULT_USER_IMAGE_NAME @"signup default user image.png"
#define USER_AVATAR_FILE_NAME @"/user.png"

@interface SignInViewController ()

@end

@implementation SignInViewController {
  UIView *_activeKeyboardView;
  MBProgressHUD *_hud;
  UIImageView *_hudCustomeView;
}

- (MBProgressHUD *)hud
{
  return _hud;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==self.nicknameTextField) {
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }
    _hud.labelText = NSLocalizedString(SIGNIN_LABEL, nil);
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud show:YES];
    
    NSString *nickname = self.nicknameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    NSDictionary *parameters = @{LOGIN_PARAM: nickname, PASSWORD_PARAM: password};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:SIGNIN_ENDPOINT parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [UserSession signOut];
             [self loadUserData:responseObject];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             _hud.mode = MBProgressHUDModeCustomView;
             _hud.customView = _hudCustomeView;
             
             if (operation.response.statusCode == ERROR_DENIED_CODE) {
                 _hud.labelText = NSLocalizedString(ERROR_DENIED_LABEL, nil);
             } else {
                 _hud.labelText = NSLocalizedString(ERROR_GENERAL_LABEL, nil);
             }
             
             [_hud hide:YES afterDelay:2.0];
         }];
    [self hideKeyboard];
    return YES;
}

- (UITextField *)textFieldForContainerView:(UIView *)containerView
{
  if (containerView == self.nicknameContainerView) {
    return self.nicknameTextField;
  } else if (containerView == self.passwordContainerView) {
    return self.passwordTextField;
  }
  return nil;
}

- (UIView *)containerViewForTextField:(UITextField *)textField
{
  if (textField == self.nicknameTextField) {
    return self.nicknameContainerView;
  } else if (textField == self.passwordTextField) {
    return self.passwordContainerView;
  }
  return nil;
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
    
    CGRect frame = self.signInButton.frame;
    CGPoint lowerLeftPoint = CGPointMake(frame.origin.x, frame.origin.y + frame.size.height);
    lowerLeftPoint = [self.view convertPoint:lowerLeftPoint fromView:self.signInButton.superview];
    
    CGFloat absoluteY = self.view.frame.origin.y + lowerLeftPoint.y;
    CGFloat diffByKeyboard = absoluteY - (self.view.frame.origin.y + self.view.frame.size.height - kbSize.height);
    
    if (diffByKeyboard >= -10) {
      self.scrollView.contentOffset = CGPointMake(0, diffByKeyboard + 10);
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

- (void)hideKeyboard
{
  [self.nicknameTextField resignFirstResponder];
  [self.passwordTextField resignFirstResponder];
}

- (void)popBack
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpButtonAction
{
  AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  [self.navigationController pushViewController:delegate.signUpViewController animated:YES];
}

- (void)loadUserData:(NSDictionary *)serverResponse
{
  NSDictionary *userDict = [serverResponse objectForKey:USER_DICT_KEY];
  NSString *userId = [userDict objectForKey:USER_ID_KEY];
  
  _hud.labelText = NSLocalizedString(SIGNIN_LOADING_LABEL, nil);
  
  NSDictionary *param = @{USER_ID_PARAM: userId};
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.responseSerializer = [AFImageResponseSerializer serializer];
  [manager GET:GET_AVATAR_ENDPOINT parameters:param
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         UIImage *avatar = responseObject;
         
         if (avatar == nil) {
           avatar = [UIImage imageNamed:DEFAULT_USER_IMAGE_NAME];
         }
         NSData *photoData = UIImagePNGRepresentation(avatar);
         NSString *localFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:USER_AVATAR_FILE_NAME];
         [photoData writeToFile:localFilePath atomically:YES];
         
         [UserSession signedInWithDictonary:serverResponse];
         
         [_hud hide:YES];
         
         AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
         [delegate.myFeelingsViewController setRefreshOnce:YES];
         [delegate navigateToLandingPage];
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [UserSession signOut];
         
         _hud.mode = MBProgressHUDModeCustomView;
         _hud.customView = _hudCustomeView;
         
         if (operation.response.statusCode == ERROR_AVATAR_NOT_FOUND) {
           _hud.labelText = NSLocalizedString(ERROR_LOADING_FAILED_LABEL, nil);
         } else {
           _hud.labelText = NSLocalizedString(ERROR_GENERAL_LABEL, nil);
         }
         
         [_hud hide:YES afterDelay:2.0];
       }];
}

- (IBAction)signInButtonAction
{
  _hud.labelText = NSLocalizedString(SIGNIN_LABEL, nil);
  _hud.mode = MBProgressHUDModeIndeterminate;
  [_hud show:YES];
  
  NSString *nickname = self.nicknameTextField.text;
  NSString *password = self.passwordTextField.text;
  NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"DEVICE_TOKEN"];
  NSDictionary *parameters = @{LOGIN_PARAM: nickname, PASSWORD_PARAM: password,@"device_token":deviceToken};
//    NSDictionary *parameters = @{LOGIN_PARAM: nickname, PASSWORD_PARAM: password};
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:SIGNIN_ENDPOINT parameters:parameters
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [UserSession signOut];
         [self loadUserData:responseObject];
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         _hud.mode = MBProgressHUDModeCustomView;
         _hud.customView = _hudCustomeView;
         
         if (operation.response.statusCode == ERROR_DENIED_CODE) {
           _hud.labelText = NSLocalizedString(ERROR_DENIED_LABEL, nil);
         } else {
           _hud.labelText = NSLocalizedString(ERROR_GENERAL_LABEL, nil);
         }
         
         [_hud hide:YES afterDelay:2.0];
       }];
    [self hideKeyboard];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  NSMutableString *endString = [NSMutableString stringWithString:textField.text];
  [endString replaceCharactersInRange:range withString:string];
  BOOL canSignIn = endString.length > 0;
  
  NSArray *textFields = [NSArray arrayWithObjects:self.nicknameTextField, self.passwordTextField, nil];
  for (UITextField *checkedTextField in textFields) {
    if (textField != checkedTextField) {
        canSignIn &= checkedTextField.text.length > 0;
    }
  }
  
  self.signInButton.enabled = canSignIn;
  
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  _activeKeyboardView = [self containerViewForTextField:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  _activeKeyboardView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  self.nicknameTextField.text = self.passwordTextField.text = nil;
  self.signInButton.enabled = NO;
  
  [super viewWillAppear:animated];
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
  
  UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
  nicknameLabel.text = NSLocalizedString(NICKNAME_LABEL, nil);
  nicknameLabel.font =[UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  nicknameLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
  self.nicknameTextField.leftView = nicknameLabel;
  self.nicknameTextField.leftViewMode = UITextFieldViewModeAlways;
  
  UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
  passwordLabel.text = NSLocalizedString(PASSWORD_LABEL, nil);
  passwordLabel.font =[UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  passwordLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
  self.passwordTextField.leftView = passwordLabel;
  self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
  
  self.signInTopLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:19.0f];
  self.switchToSignUpTopLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  self.signInButton.titleLabel.font = self.switchToSignUpButton.titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  self.nicknameTextField.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  
  [self.signInButton setBackgroundImage:myAppDelegate.lightGreenImage forState:UIControlStateNormal];
  [self.switchToSignUpButton setBackgroundImage:myAppDelegate.lightGreenImage forState:UIControlStateNormal];
  
  self.signInButton.enabled = NO;
  
  UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
  [self.scrollView addGestureRecognizer:gestureRecognizer];
  gestureRecognizer.cancelsTouchesInView = NO;  // this prevents the gesture recognizers to 'block' touches
  
  [self registerForKeyboardNotifications];
  
  _hud = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:_hud];
  _hud.labelFont = [UIFont fontWithName:@"BebasNeue" size:13.0];
  
  _hudCustomeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no.png"]];
  _hud.customView = _hudCustomeView;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
