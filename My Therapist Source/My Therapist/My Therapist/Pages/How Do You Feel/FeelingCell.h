//
//  FeelingCell.h
//  My Therapist
//
//  Created by Yexiong Feng on 11/28/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Feeling;

@interface FeelingCell : UITableViewCell<UIScrollViewDelegate>

@property (assign, nonatomic) BOOL cellExpanded;
@property (readonly, nonatomic) Feeling *feeling;

@property (readonly, nonatomic) UIView *contentContainerView, *upperContainerView, *lowerContainerView;
@property (strong, nonatomic) UISlider *feelingStrengthSlider;
@property (assign, nonatomic) BOOL isUserChangeStrengthSlider;
- (id)initWithFeeling:(Feeling *)feeling;
- (void)reset;
- (void)prepareForCheckIn;
- (void)feelingStrengthSliderValueChanged;
- (void)didChangeValueSlider;

@end
