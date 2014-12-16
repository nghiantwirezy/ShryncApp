//
//  HowDoYouFeelViewController.h
//  My Therapist
//
//  Created by Yexiong Feng on 11/19/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileView.h"

@interface HowDoYouFeelViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, UserProfileViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *outerContainerView;
@property (weak, nonatomic) IBOutlet UITableView *feelingTableView;
@property (weak, nonatomic) IBOutlet UILabel *checkinLabel, *resetLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkinButton, *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *emotionButton;
@property (weak, nonatomic) IBOutlet UITextField *howYouFeelTextField;
@property (readonly, nonatomic) NSArray *feelings;
@property (assign, nonatomic) BOOL needResetFeeling;
@property (assign, nonatomic) CGFloat heightProfileView;
@property (strong, nonatomic) IBOutlet UIView *inputFeelingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topInputFeelingConstraint;

- (IBAction)checkInButtonAction;
- (IBAction)resetButtonAction;
- (IBAction)emotionButtonAction:(id)sender;
- (void)setButtonsEnabled:(BOOL)enabled;
- (IBAction)viewTapAction:(id)sender;

@end
