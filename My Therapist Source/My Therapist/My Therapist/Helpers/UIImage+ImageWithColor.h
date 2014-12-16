//
//  UIImage+ImageFromColor.h
//  My Therapist
//
//  Created by Yexiong Feng on 11/27/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageFromColor)

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
