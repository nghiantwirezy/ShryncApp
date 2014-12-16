//
//  ImageViewDelegate.h
//  CensoringView
//
//  Created by Yexiong Feng on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AreaSelectableViewDelegate <NSObject>

@required
- (void)areaTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)areaTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)areaTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)areaTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
