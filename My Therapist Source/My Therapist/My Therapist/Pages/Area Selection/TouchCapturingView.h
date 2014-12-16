//
//  TouchCapturingView.h
//  CensoringView
//
//  Created by Yexiong Feng on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AreaSelectableViewDelegate;

@class MaskDrawingLayer;

@interface TouchCapturingView : UIView

@property (assign, nonatomic) id<AreaSelectableViewDelegate> delegate;
@property (readonly, nonatomic) MaskDrawingLayer *drawingLayer;

@end
