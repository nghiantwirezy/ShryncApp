//
//  TextTherapiesViewController.h
//  My Therapist
//
//  Created by Yexiong Feng on 6/28/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeelingRecord;

@interface TextTherapiesViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *feelingsIconContainerView;
@property (weak, nonatomic) IBOutlet UIView *textPagingContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *textTherapyScrollView;

@property (strong, nonatomic) FeelingRecord *feelingRecord;

@end
