//
//  ImageAreaSelectionViewController.h
//  My Therapist
//
//  Created by Yexiong Feng on 2/2/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaSelectableViewDelegate.h"
#import "ImageAreaSelectorDelegate.h"

@class TouchCapturingView;

@interface ImageAreaSelectionViewController : UIViewController<AreaSelectableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet TouchCapturingView *touchCapturingView;

@property (strong, nonatomic) UIImage *image;

@property (assign, nonatomic) id<ImageAreaSelectorDelegate> delegate;

@end
