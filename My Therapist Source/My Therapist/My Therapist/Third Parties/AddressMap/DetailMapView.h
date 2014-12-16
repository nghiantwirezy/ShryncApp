//
//  DetailMapView.h
//  My Therapist
//
//  Created by PhamHuuPhuong on 4/9/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AddressMap.h"

@interface DetailMapView : UIViewController<MKMapViewDelegate>{
    IBOutlet MKMapView *_mapView;
    NSString *_tittle;
    CLPlacemark *placemark;
    NSString *_subtitle;
}

@property(nonatomic, retain)  MKMapView *mapView;
@property(nonatomic,retain) NSString *latitude;
@property(nonatomic,retain) NSString *longitude;
@property(nonatomic,retain) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D currenLocations;
@end
