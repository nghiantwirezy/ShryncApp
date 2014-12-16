//
//  UIPlaceHolderTextView.h
//  My Therapist
//
//  Created by Yexiong Feng on 12/17/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
