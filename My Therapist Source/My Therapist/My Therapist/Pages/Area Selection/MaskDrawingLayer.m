//
//  MaskDrawingLayer.m
//  Censored!
//
//  Created by Yexiong Feng on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MaskDrawingLayer.h"
#import <tgmath.h>

@interface MaskDrawingLayer ()

@property (nonatomic, assign) CGRect maskRect;

@end

@implementation MaskDrawingLayer

@synthesize maskRect = _maskRect;

- (id)init
{
  self = [super init];
  if (self) {
    self.delegate = self;
    self.backgroundColor = [[UIColor clearColor] CGColor];
    self.contentsScale = [UIScreen mainScreen].scale;
  }
  return self;
}

- (void)drawMaskInRect:(CGRect)rect
{
  self.maskRect = rect;
  [self setNeedsDisplay];
}

- (void)clearMask
{
  self.maskRect = CGRectMake(0, 0, 0, 0);
  [self setNeedsDisplay];
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{
  // Clear existing drawings on layer.
	CGContextClearRect(context, layer.frame);
  
  // Do not draw if the area is 0.
  if (self.maskRect.size.width == 0 || self.maskRect.size.height == 0) {
    return;
  }
    
  // Set stroke and filling color.
	CGContextSetLineWidth(context, 3.0f);
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 0.5);
	CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.25);
  
  // Calculate the four corners of the drawing rect.
	CGRect drawRect = self.maskRect;
  
	CGFloat minx = CGRectGetMinX(drawRect), midx = CGRectGetMidX(drawRect), maxx = CGRectGetMaxX(drawRect);
	CGFloat miny = CGRectGetMinY(drawRect), midy = CGRectGetMidY(drawRect), maxy = CGRectGetMaxY(drawRect);
  	
  // Draw the rect.
  CGFloat radius = 0.0;
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
  
  // Close and render the rect area.
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
}

@end
