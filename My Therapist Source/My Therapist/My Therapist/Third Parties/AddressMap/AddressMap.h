//
//  AddressMap.h
//  Maybook
//
//  Created by BUI VAN HUY on 3/23/13.
//  Copyright (c) 2013 CMCSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MKAnnotation.h>


@interface AddressMap : NSObject <MKAnnotation> {
    
	NSString *title;
	CLLocationCoordinate2D coordinate;
	NSString *subtitle;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (id)initWithTitle:(NSString *)ttl subtitle:(NSString*)_stt andCoordinate:(CLLocationCoordinate2D)c2d;

@end
