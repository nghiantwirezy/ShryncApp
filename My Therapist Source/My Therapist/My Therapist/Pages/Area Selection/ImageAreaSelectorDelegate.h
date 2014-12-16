//
//  ImageAreaSelectorDelegate.h
//  My Therapist
//
//  Created by Yexiong Feng on 2/2/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageAreaSelectorDelegate <NSObject>

@required
- (void)setAreaSelectedImage:(UIImage *)image;

@end
