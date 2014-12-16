//
//  AddressMap.m
//  Maybook
//
//  Created by BUI VAN HUY on 3/23/13.
//  Copyright (c) 2013 CMCSoft. All rights reserved.
//

#import "AddressMap.h"

@implementation AddressMap

@synthesize title, subtitle, coordinate;

- (id)initWithTitle:(NSString *)ttl subtitle:(NSString*)_stt andCoordinate:(CLLocationCoordinate2D)c2d {
	title = ttl;
    subtitle = _stt;
	coordinate = c2d;
	return self;
}



@end