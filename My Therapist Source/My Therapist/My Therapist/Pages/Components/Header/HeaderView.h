//
//  HeaderView.h
//  My Therapist
//
//  Created by Yexiong Feng on 4/1/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

- (id)initWithAvatar:(UIImage *)avatar title:(NSString *)title subtitle:(NSString *)subtitle;

- (void)setAvatar:(UIImage *)avatar;
- (void)setSubtitle:(NSString *)subtitle;
@property (strong, nonatomic) NSString *username;

@end
