//
//  SubFeelingButton.m
//  My Therapist
//
//  Created by Yexiong Feng on 12/1/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "SubFeelingButton.h"

#define WIDTH 100
#define SEPARATOR_WIDTH 1
#define HEIGHT 40

static UIImage *_selectedBackground, *_notSelectedBackground;
static UIColor *_selectedTitleColor, *_notSelectedTitleColor;

@implementation SubFeelingButton

- (id)initWithIndex:(NSUInteger)index title:(NSString *)title
{
  CGFloat offsetX = 1 + index * (WIDTH + SEPARATOR_WIDTH);
  self = [super initWithFrame:CGRectMake(offsetX, 0, WIDTH, HEIGHT)];
  if (self) {
    self.adjustsImageWhenHighlighted = NO;
    self.titleLabel.font = [UIFont fontWithName:@"BebasNeue" size:13.0];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self setTitle:title forState:UIControlStateNormal];
    
    _index = index;
    
    if (_selectedBackground == nil) {
      _selectedBackground = [UIImage imageNamed:@"subfeeling selected background.png"];
      _notSelectedBackground = [UIImage imageNamed:@"subfeeling not selected background.png"];
      
      _selectedTitleColor = [UIColor colorWithRed:0 green:128.0 / 255 blue:142.0 / 255 alpha:1];
      _notSelectedTitleColor = [UIColor whiteColor];
    }
    
    self.subFeelingSelected = NO;
  }
  return self;
}

- (void)setSubFeelingSelected:(BOOL)subFeelingSelected
{
  UIImage *backgroundImage = subFeelingSelected ? _selectedBackground : _notSelectedBackground;
  UIColor *titleColor = subFeelingSelected ? _selectedTitleColor : _notSelectedTitleColor;
  [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
  [self setTitleColor:titleColor forState:UIControlStateNormal];
  
  _subFeelingSelected = subFeelingSelected;
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
