//
//  MainViewController.m
//  My Therapist
//
//  Created by Yexiong Feng on 11/12/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "UserSession.h"
#import "HowDoYouFeelViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
  
  [self.signInButton setBackgroundImage:myAppDelegate.lightGreenImage forState:UIControlStateNormal];
  //[self.signInButton setBackgroundImage:delegate.lightGreenHighLightImage forState:UIControlStateHighlighted];
  [self.signUpButton setBackgroundImage:myAppDelegate.darkGreenImage forState:UIControlStateNormal];
  //[self.signUpButton setBackgroundImage:delegate.darkGreenHighLightImage forState:UIControlStateHighlighted];
  [self.skipButton setBackgroundImage:myAppDelegate.whiteImage forState:UIControlStateNormal];
  
  self.middleTextLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:19.0f];
  self.signInButton.titleLabel.font = self.signUpButton.titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
  self.skipLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:21.0f];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(IBAction) signInButtonAction
{
  [self.navigationController pushViewController:myAppDelegate.signInViewController animated:YES];
}

-(IBAction) signUpButtonAction
{
  [self.navigationController pushViewController:myAppDelegate.signUpViewController animated:YES];
}

- (IBAction)skipButtonAction
{
  [UserSession signInAsGuest];
  [self.navigationController setViewControllers:[NSArray arrayWithObject:myAppDelegate.howDoYouFeelViewController] animated:YES];
}

@end
