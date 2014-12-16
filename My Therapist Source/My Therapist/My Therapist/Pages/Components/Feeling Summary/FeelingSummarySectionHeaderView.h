//
//  FeelingSummarySectionHeaderView.h
//  My Therapist
//
//  Created by Yexiong Feng on 12/3/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeelingSummarySectionHeaderView : UIView

+ (FeelingSummarySectionHeaderView *)dequeueHeaderView;

- (id)initForSingleRecord:(BOOL)singleRecord;

- (void)setHeaderString:(NSString *)headerString;

@end
