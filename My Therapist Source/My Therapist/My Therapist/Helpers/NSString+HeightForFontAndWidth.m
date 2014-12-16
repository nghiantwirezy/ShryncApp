//
//  NSString+HeightForFontAndWidth.m
//  My Therapist
//
//  Created by Yexiong Feng on 12/25/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "NSString+HeightForFontAndWidth.h"

static UITextView *_textView;

@implementation NSString (HeightForFontAndWidth)

- (CGFloat)heightForFont:(UIFont *)font andWidth:(CGFloat)width
{
  if (_textView == nil) {
    _textView = [[UITextView alloc] init];
  }
  
  _textView.font = font;
  _textView.text = self;
  CGSize size = [_textView sizeThatFits:CGSizeMake(width, 0)];
  return size.height;
}

- (CGFloat)widthForFont:(UIFont *)font andHeight:(CGFloat)height
{
  if (_textView == nil) {
    _textView = [[UITextView alloc] init];
  }
  
  _textView.font = font;
  _textView.text = self;
  CGSize size = [_textView sizeThatFits:CGSizeMake(0, height)];
  return size.width;
}

@end
