//
//  FeelingSummaryFirstRowCell.m
//  My Therapist
//
//  Created by Yexiong Feng on 4/7/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "FeelingSummaryFirstRowCell.h"

@implementation FeelingSummaryFirstRowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    CGRect frame = _contentContainerView.frame;
    frame.origin.y += 7;
    _contentContainerView.frame = frame;
  }
  return self;
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
