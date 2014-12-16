//
//  AudioPlayerViewController.h
//  My Therapist
//
//  Created by Yexiong Feng on 7/13/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeelingRecord;

@interface AudioPlayerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *previousTrackButton, *nextTrackButton, *playPauseButton;
@property (weak, nonatomic) IBOutlet UITableView *trackListTableView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *trackTitleLabel;

@property (strong, nonatomic) FeelingRecord *feelingRecord;

- (IBAction)playPauseButtonPressed;
- (IBAction)nextButtonPressed;
- (IBAction)prevButtonPressed;

@end
