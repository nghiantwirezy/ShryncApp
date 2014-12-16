//
//  CenterCircleImageView.m
//  My Therapist
//
//  Created by Yexiong Feng on 2/17/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "CenterCircleImageView.h"

@implementation CenterCircleImageView {
  CAShapeLayer *_circleLayer, *_circleStrokeLayer;
  UIButton *_button;
}

- (void)commonInit
{
  _circleLayer = [CAShapeLayer layer];
  _circleLayer.fillRule = kCAFillRuleEvenOdd;
  _circleLayer.fillColor = self.backgroundColor.CGColor;
  
  _circleStrokeLayer = [CAShapeLayer layer];
  _circleStrokeLayer.fillColor = [UIColor clearColor].CGColor;
  _circleStrokeLayer.strokeColor = [UIColor colorWithRed:200.0 / 255 green:200.0 / 255 blue:200.0 / 255 alpha:1].CGColor;
  _circleStrokeLayer.lineWidth = 0.8;
  
  _button = [[UIButton alloc] init];
  _button.enabled = NO;
  [_button addTarget:self action:@selector(executeButtonAction) forControlEvents:UIControlEventTouchUpInside];
  
  [self.layer addSublayer:_circleLayer];
  [self.layer addSublayer:_circleStrokeLayer];
  
  [self addSubview:_button];
  
  self.userInteractionEnabled = YES;
  self.clipsToBounds = YES;
  self.contentMode = UIViewContentModeScaleAspectFill;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (void)layoutSubviews
{
  CGRect circleBox = CGRectInset(self.bounds, 0.4, 0.4);
  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0];
  UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:circleBox cornerRadius:circleBox.size.height / 2.0];
  [path appendPath:circlePath];
  [path setUsesEvenOddFillRule:YES];
  _circleLayer.path = path.CGPath;
  
  CGRect strokeBox = circleBox;
  UIBezierPath *circleStrokePath = [UIBezierPath bezierPathWithRoundedRect:strokeBox cornerRadius:strokeBox.size.height / 2.0];
  _circleStrokeLayer.path = circleStrokePath.CGPath;
  
  _button.frame = self.bounds;
  
  [super layoutSubviews];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
  [super setBackgroundColor:backgroundColor];
  _circleLayer.fillColor = backgroundColor.CGColor;
}

- (void)executeButtonAction
{
  _buttonAction();
}

- (void)setButtonAction:(ButtonAction)buttonAction
{
  _buttonAction = buttonAction;
  _button.enabled = _buttonAction != nil;
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
