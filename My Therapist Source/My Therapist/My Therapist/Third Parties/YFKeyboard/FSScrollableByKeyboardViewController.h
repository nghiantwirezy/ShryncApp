//
//  FSScrollableByKeyboardViewController.h
//  Copyright (c) 2014 WeezLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSScrollableByKeyboardViewController : UIViewController
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;

+ (void)subscribeController: (UIViewController *) controller forKeyboardAppears: (SEL) appears disapears: (SEL) disapears;
+ (void)unsubscribeControllerFromNotifications: (UIViewController *) controller;
- (CGFloat) shiftHeightByKeyboard;
- (void) keyboardStateChanged: (BOOL) state;
@end
