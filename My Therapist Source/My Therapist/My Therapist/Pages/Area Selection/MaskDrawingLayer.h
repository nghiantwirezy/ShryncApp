//
//  MaskDrawingLayer.h
//  Censored!
//
//  Created by Yexiong Feng on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MaskDrawingLayer : CALayer

- (void)drawMaskInRect:(CGRect)rect;

- (void)clearMask;

@end
