//
//  FSScrollableByKeyboardViewController.m
//  Copyright (c) 2014 WeezLabs. All rights reserved.
//

#import "FSScrollableByKeyboardViewController.h"

@implementation FSScrollableByKeyboardViewController

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[FSScrollableByKeyboardViewController subscribeController:self forKeyboardAppears:@selector(keyboardWillShow:) disapears:@selector(keyboardWillHide:)];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[FSScrollableByKeyboardViewController unsubscribeControllerFromNotifications:self];
}

#pragma mark - Custom Methods
/**
 Subscribes controllers for keyboard notifications
 */
+ (void)subscribeController: (UIViewController *) controller forKeyboardAppears: (SEL) appears disapears: (SEL) disapears {
	//subscribe for notifications
	[[NSNotificationCenter defaultCenter] addObserver:controller selector:appears name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:controller selector:disapears name:UIKeyboardWillHideNotification object:nil];
}

/**
 Ussubscribes controllers from keyboard notifications
 */
+ (void)unsubscribeControllerFromNotifications: (UIViewController *) controller{
	[[NSNotificationCenter defaultCenter] removeObserver:controller];
}

- (void) keyboardWillShow:(NSNotification *) notification{
	[self animateControlsShift:^{
		[self keyboardStateChanged:YES];
		self.bottomViewConstraint.constant += [self shiftHeightByKeyboard];
		[self.view layoutIfNeeded];
	}];
}

- (void) keyboardWillHide:(NSNotification *) notification{
	[self animateControlsShift:^{
		[self keyboardStateChanged:NO];
		self.bottomViewConstraint.constant -= [self shiftHeightByKeyboard];
		[self.view layoutIfNeeded];
	}];
}

- (void) animateControlsShift: (void(^)()) block{
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		if (block) {
			block();
		}
	} completion:nil];
}

/**
 Override this method to shift all content
 */
- (CGFloat) shiftHeightByKeyboard{
	return 0;
}

/**
 Override this method if you want to get keyboard state
 */
- (void) keyboardStateChanged: (BOOL) state{
}

@end
