//
//  UIColor+ColorUtilities.h
//  My Therapist
//
//  Created by Josky on 11/5/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorUtilities)

#pragma mark - Colors

+ (UIColor *)color256WithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

// Gray
+ (UIColor *)grayColor2;
+ (UIColor *)lightGrayColor2;
+ (UIColor *)lightGrayColor3;
+ (UIColor *)veryLightGrayColor;
+ (UIColor *)veryLightGrayColor2;
+ (UIColor *)veryLightGrayColor3;
+ (UIColor *)veryLightGrayColor4;
+ (UIColor *)veryLightGrayColor5;
+ (UIColor *)veryLightGrayColor6;
+ (UIColor *)veryDarkGrayColor;
+ (UIColor *)veryDarkGrayColor2;
+ (UIColor *)veryDarkGrayColor3;
+ (UIColor *)veryDarkGrayColor4;
+ (UIColor *)veryDarkGrayColor4WithAlpha:(CGFloat)alpha;
+ (UIColor *)veryDarkGrayColor5;
//Cyan
+ (UIColor *)pureCyanColor;
+ (UIColor *)darkCyanColor;
+ (UIColor *)mostlyDesaturatedDarkCyanColor;
+ (UIColor *)darkModerateCyanColor;
+ (UIColor *)darkModerateCyanColor2;
+ (UIColor *)darkModerateCyanColor3;
//Red
+ (UIColor *)strongRedColor;
//Blue
+ (UIColor *)veryDarkBlueColor;
+ (UIColor *)veryDarkGrayishBlueColor;

@end
