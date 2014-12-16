//
//  TouchCapturingView.m
//  CensoringView
//
//  Created by Yexiong Feng on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TouchCapturingView.h"
#import "AreaSelectableViewDelegate.h"
#import "MaskDrawingLayer.h"

@implementation TouchCapturingView {
  MaskDrawingLayer *_drawingLayer;
}

@synthesize delegate = _delegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.userInteractionEnabled = YES;
    _drawingLayer = [[MaskDrawingLayer alloc] init];
    [self.layer addSublayer:_drawingLayer];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  _drawingLayer.frame = self.bounds;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.delegate areaTouchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.delegate areaTouchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.delegate areaTouchesEnded:touches withEvent:event];
  [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.delegate areaTouchesCancelled:touches withEvent:event];
}

- (MaskDrawingLayer *)drawingLayer {
  return _drawingLayer;
}

@end
