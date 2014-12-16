//
//  UIImage+ScaleImage.h
//  My Therapist
//
//  Created by Yexiong Feng on 2/3/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScaleImage)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
