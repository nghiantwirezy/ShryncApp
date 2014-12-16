//
//  AttachmentFullscreenViewController.h
//  My Therapist
//
//  Created by Yexiong Feng on 3/29/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeelingRecord;
@interface AttachmentFullscreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSString *attachFeelingCode;

- (void)setImage:(UIImage *)image;
- (void)setFeelingCode:(NSString *)code;
- (void)setFeelingRecordTherapy:(FeelingRecord *)feelingRecord ;

@end
