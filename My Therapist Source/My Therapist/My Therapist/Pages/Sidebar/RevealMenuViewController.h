//
//  RevealMenuViewController.h
//  My Therapist
//
//  Created by Yexiong Feng on 11/19/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CenterCircleImageView;

@interface RevealMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sideTableView;
@property (strong, nonatomic) IBOutlet CenterCircleImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel, *nameSubLabel;
@property (strong, nonatomic) IBOutlet UIButton *privacyButton, *termButton, *aboutButton, *feedbackButton, *signoutButton;

- (IBAction)feedbackButtonAction;

- (IBAction)privacyButtonAction;
- (IBAction)termButtonAction;
- (IBAction)aboutButtonAction;

- (IBAction)signoutButtonAction;

@end
