//
//  ReferralFinder.h
//  My Therapist
//
//  Created by Yexiong Feng on 8/4/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "LocationManagement.h"

@class MBProgressHUD;

@interface ReferralFinder : NSObject<CLLocationManagerDelegate, LocationManagementDelegate>

@property (strong, nonatomic) LocationManagement *locationManagement;

- (void)beginInViewController:(UIViewController *)controller withHUD:(MBProgressHUD *)hud;

@end
