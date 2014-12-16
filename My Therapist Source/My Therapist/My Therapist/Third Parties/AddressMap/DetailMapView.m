//
//  DetailMapView.m
//  My Therapist
//
//  Created by PhamHuuPhuong on 4/9/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "DetailMapView.h"
#import "AppDelegate.h"
#define TITLE @"DETAIL MAPS"

@interface DetailMapView ()

@end

@implementation DetailMapView
@synthesize mapView=_mapView,subtitle=_subtitle,longitude=_longitude,latitude=_latitude;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *backImage = [UIImage imageNamed:@"back button.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 28, 28)];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack2) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:barButton];

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:21.0f];
    titleLabel.text = NSLocalizedString(TITLE, nil);
    titleLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    // Do any additional setup after loading the view from its nib.
}

- (void)popBack2{
    [self.navigationController popViewControllerAnimated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = nil;
    if(annotation != _mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                         initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    }
    else {
        [_mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1500, 1500);
    [mv setRegion:region animated:YES];
    [mv selectAnnotation:mp animated:YES];
}
-(void)beginEdit{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setLocations :(CLLocationCoordinate2D )locations{
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
    [_mapView setDelegate:self];
    CLLocationCoordinate2D location = locations;
    
    AddressMap *newAnnotation = [[AddressMap alloc] initWithTitle:placemark.country subtitle:placemark.thoroughfare  andCoordinate:location];
    // Do any additional setup after loading the view from its nib.
    [_mapView addAnnotation:newAnnotation];
}

-(void)viewWillAppear:(BOOL)animated{
    //right barbutton item
    self.title= @"Detail map";
    self.navigationController.navigationBarHidden = NO;
    
    [self setLocations:_currenLocations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
