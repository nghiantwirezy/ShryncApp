//
//  ReferralFinder.m
//  My Therapist
//

#import "ReferralFinder.h"
#import "MBProgressHUD.h"
#import "ContainedWebViewController.h"


@implementation ReferralFinder {
    //  CLLocationManager *_locationManager;
    CLLocation *_location;
    NSString *_zipCode;
    
    UIViewController *_controller;
    MBProgressHUD *_hud;
    UIAlertView *_askForZipCodeAlertView;
    ContainedWebViewController *_containedWebView;
    BOOL needShowAlertZipCode;
}

#pragma mark - ReferralFinder management

- (id)init
{
    self = [super init];
    if (self) {
        _locationManagement = [LocationManagement shareLocation];
        _locationManagement.locationManager.delegate = self;
        _locationManagement.locationManager.distanceFilter = DISTANCEFILTER_REFERRAL_FINDER;
        
        _askForZipCodeAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(ZIPCODE_QUESTION_REFERRAL_FINDER, nil) message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        _askForZipCodeAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        _containedWebView = [[ContainedWebViewController alloc] init];
    }
    return self;
}

- (void)beginInViewController:(UIViewController *)controller withHUD:(MBProgressHUD *)hud
{
    _controller = controller;
    _hud = hud;
    needShowAlertZipCode = YES;
    _location = nil;
    
    _locationManagement.delegate = self;
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = NSLocalizedString(TEXT_FIND_THERAPISTS_IN_PROGRESS_REFERRAL_FINDER, nil);
    [_hud show:YES];
    [_locationManagement requestTurnOnLocationServices];
    [self performSelector:@selector(stopLocationUpdate) withObject:nil afterDelay:LOCATION_TIME_OUT_REFERRAL_FINDER];
}

- (void)beginLocationReversal
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray *placemarks, NSError *error) {
        [_hud hide:YES];
        if([placemarks count]) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            _zipCode = placemark.postalCode;
            [self openTherapistWebView];
        } else {
            NSLog(@"Failed on reverseGeocodeLocation: %@", error);
            if (needShowAlertZipCode) {
                needShowAlertZipCode = NO;
                [_askForZipCodeAlertView performSelector:@selector(show) withObject:nil afterDelay:TIME_TO_SHOW_ZIP_CODE_POP_UP];
            }
        }
    }];
}

- (void)openTherapistWebView
{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_THERAPIST_SITE, _zipCode];
    [_containedWebView setUrl:url title:NSLocalizedString(TITLE_THERAPIST_SITE_REFERRAL_FINDER, nil)];
    [_containedWebView presentFromController:_controller];
}

#pragma mark - Alert

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *text = textField.text;
    if (text.length == 0) {
        return NO;
    }
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_TEXT_ZIPCODE_INPUT_REFERRAL_FINDER];
    return [test evaluateWithObject:text];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        _zipCode = [alertView textFieldAtIndex:0].text;
        [self openTherapistWebView];
    }
}

#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
    if (locationAge > MAX_LOCATION_AGE) {
        return;
    }
    
    if (location.horizontalAccuracy < 0 || location.horizontalAccuracy > DISTANCEFILTER_REFERRAL_FINDER) {
        return;
    }
    
    [_locationManagement.locationManager stopUpdatingLocation];
    _location = location;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopLocationUpdate) object:nil];
    [self beginLocationReversal];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationManagement.locationManager stopUpdatingLocation];
    NSLog(@"Location failed: %@", error);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopLocationUpdate) object:nil];
    [self stopLocationUpdate];
}

- (void)stopLocationUpdate
{
    [_hud hide:YES];
    [_locationManagement.locationManager stopUpdatingLocation];
    if (needShowAlertZipCode) {
        needShowAlertZipCode = NO;
        [_askForZipCodeAlertView performSelector:@selector(show) withObject:nil afterDelay:TIME_TO_SHOW_ZIP_CODE_POP_UP];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"kCLAuthorizationStatusAuthorized");
            // Re-enable the post button if it was disabled before.
            [_locationManagement.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"kCLAuthorizationStatusRestricted");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
            break;
    }
}

#pragma mark - LocationManagement delegate

- (void)didSelectedCancelButtonAlert {
    [self stopLocationUpdate];
}

@end
