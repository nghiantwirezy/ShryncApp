//
//  PublicFeelingRecordLoader.h
//  My Therapist
//
//  Created by Yexiong Feng on 8/11/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "FeelingRecordLoader.h"
#import <MapKit/MapKit.h>

@interface PublicFeelingRecordLoader : FeelingRecordLoader

@property (assign, nonatomic) BOOL shallRefreshLocationOnce;

@end
