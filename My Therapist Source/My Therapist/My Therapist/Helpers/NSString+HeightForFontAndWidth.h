//
//  NSString+HeightForFontAndWidth.h
//  My Therapist
//
//  Created by Yexiong Feng on 12/25/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HeightForFontAndWidth)

- (CGFloat)heightForFont:(UIFont *)font andWidth:(CGFloat)width;
- (CGFloat)widthForFont:(UIFont *)font andHeight:(CGFloat)height;

@end
