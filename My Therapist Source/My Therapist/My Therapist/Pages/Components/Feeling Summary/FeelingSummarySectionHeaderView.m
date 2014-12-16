//
//  FeelingSummarySectionHeaderView.m
//  My Therapist
//
//  Created by Yexiong Feng on 12/3/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "FeelingSummarySectionHeaderView.h"
#import "NSString+HeightForFontAndWidth.h"

#define HEIGHT 22

static NSArray *_headerCache;

@implementation FeelingSummarySectionHeaderView {
  UIView *_headerContentContainerView, *_headerImageContainerView, *_headerImageView;
  UILabel *_timeStampLabel;
}

+ (FeelingSummarySectionHeaderView *)dequeueHeaderView
{
  if (_headerCache == nil) {
    NSMutableArray *headerCache = [[NSMutableArray alloc] initWithCapacity:25];
    for (int i = 0; i < 25; ++i) {
      [headerCache addObject:[[FeelingSummarySectionHeaderView alloc] initForSingleRecord:NO]];
    }
    _headerCache = headerCache;
  }
  
  for (FeelingSummarySectionHeaderView *headerView in _headerCache) {
    if (headerView.superview == nil) {
      return headerView;
    }
  }
  
  return nil;
}

- (id)initForSingleRecord:(BOOL)singleRecord
{
  NSInteger outerHeight = HEIGHT + (singleRecord ? 15 : 0);
  NSInteger innerOffset = singleRecord ? 15 : 0;
  
  self = [super initWithFrame:CGRectMake(0, 0, 320, outerHeight)];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    
    _headerContentContainerView = [[UIView alloc] initWithFrame:CGRectMake(13, innerOffset, 294, HEIGHT)];
    _headerContentContainerView.backgroundColor = [UIColor colorWithRed:80.0 / 255 green:144.0 / 255 blue:155.0 / 255 alpha:1];
    
    _headerImageContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HEIGHT, HEIGHT)];
    _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"small calendar icon.png"]];
    [_headerImageContainerView addSubview:_headerImageView];
    
    _timeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 200, HEIGHT - 3)];
    _timeStampLabel.backgroundColor = [UIColor clearColor];
    _timeStampLabel.font = [UIFont fontWithName:@"BebasNeue" size:14.0];
    _timeStampLabel.textColor = [UIColor whiteColor];
    
    [_headerContentContainerView addSubview:_timeStampLabel];
    [_headerContentContainerView addSubview:_headerImageContainerView];
    
    
    [self addSubview:_headerContentContainerView];
  }
  return self;
}

- (void)setHeaderString:(NSString *)headerString;
{
  _timeStampLabel.text = headerString;
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
