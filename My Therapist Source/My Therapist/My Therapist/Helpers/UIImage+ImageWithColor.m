//
//  UIImage+ImageFromColor.m
//  My Therapist
//
//  Created by Yexiong Feng on 11/27/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "UIImage+ImageWithColor.h"

@implementation UIImage (ImageFromColor)

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
  CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
  return [UIImage imageWithColor:color andSize:CGSizeMake(1.0f, 1.0f)];
}

@end
