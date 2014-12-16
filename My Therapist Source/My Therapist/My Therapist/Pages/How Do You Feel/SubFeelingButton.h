//
//  SubFeelingButton.h
//  My Therapist
//
//  Created by Yexiong Feng on 12/1/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubFeelingButton : UIButton

@property (readonly, nonatomic) NSUInteger index;
@property (assign, nonatomic) BOOL subFeelingSelected;

- (id)initWithIndex:(NSUInteger)index title:(NSString *)title;

@end
