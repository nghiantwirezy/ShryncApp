//
//  TextPage.h
//  My Therapist
//
//  Created by Yexiong Feng on 8/4/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feeling;

@interface TextPage : NSObject

@property (strong, nonatomic) Feeling *feeling;
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UIWebView *webView;

@end
