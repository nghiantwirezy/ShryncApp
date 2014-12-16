//
//  UIImage+ScaleImage.m
//  My Therapist
//
//  Created by Yexiong Feng on 2/3/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "UIImage+ScaleImage.h"

@implementation UIImage (ScaleImage)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
  //UIGraphicsBeginImageContext(newSize);
  // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
  // Pass 1.0 to force exact pixel size.
  UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

@end
