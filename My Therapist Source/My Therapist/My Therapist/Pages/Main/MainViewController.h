//
//  MainViewController.h
//  My Therapist
//
//  Created by Yexiong Feng on 11/12/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *middleTextLabel, *skipLabel;
@property (strong, nonatomic) IBOutlet UIButton *signInButton, *signUpButton, *skipButton;

-(IBAction) signInButtonAction;
-(IBAction) signUpButtonAction;
-(IBAction) skipButtonAction;

@end
