//
//  HeaderView.m
//  My Therapist
//
//  Created by Yexiong Feng on 4/1/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "HeaderView.h"
#import "CenterCircleImageView.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"

@implementation HeaderView {
  CenterCircleImageView *_avatarImageView;
  UILabel *_titleLabel, *_subtitleLabel;
}

- (id)initWithAvatar:(UIImage *)avatar title:(NSString *)title subtitle:(NSString *)subtitle
{
  self = [super initWithFrame:CGRectMake(0, 0, 320, 95)];
  if (self) {
    _avatarImageView = [[CenterCircleImageView alloc] initWithFrame:CGRectMake(18, 14, 67, 67)];
    _avatarImageView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    [self addSubview:_avatarImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 23, 200, 27)];
    _titleLabel.shadowColor = [UIColor whiteColor];
    _titleLabel.shadowOffset = CGSizeMake(0, 1);
    _titleLabel.textColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    _titleLabel.font = [UIFont fontWithName:@"BebasNeue" size:30.0];
    [self addSubview:_titleLabel];
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 52, 200, 13)];
    _subtitleLabel.textColor = [UIColor colorWithRed:91 / 255.0 green:163 / 255.0 blue:174 / 255.0 alpha:1];
    _subtitleLabel.font = [UIFont fontWithName:@"BebasNeue" size:13.0];
    [self addSubview:_subtitleLabel];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:234 / 255.0 green:234 / 255.0 blue:234 / 255.0 alpha:1];
    [self addSubview:separatorView];
    
    _avatarImageView.image = avatar;
    _titleLabel.text = title;
    _subtitleLabel.text = subtitle;
    
    _avatarImageView.buttonAction = ^() {
      ProfileViewController *controller = myAppDelegate.profileViewController;
      [controller resetEditStates];
      
      NSMutableArray *controllers = [[NSMutableArray alloc] init];
      for (UIViewController *viewController in myAppDelegate.navigationController.viewControllers) {
        if (viewController != controller) {
          [controllers addObject:viewController];
        }
      }
      [controllers addObject:controller];
      
      [myAppDelegate.navigationController setViewControllers:controllers animated:YES];
    };
  }
  return self;
}

- (void)setAvatar:(UIImage *)avatar
{
  _avatarImageView.image = avatar;
}

- (void)setSubtitle:(NSString *)subtitle
{
  _subtitleLabel.text = subtitle;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
