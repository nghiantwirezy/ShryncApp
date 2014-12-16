//
//  CenterCircleImageView.h
//  My Therapist
//
//  Created by Yexiong Feng on 2/17/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonAction)();

@interface CenterCircleImageView : UIImageView

@property (strong, nonatomic) ButtonAction buttonAction;

@end
