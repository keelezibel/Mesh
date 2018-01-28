//
//  MapController.m
//  ChatSample
//
//  Created by Le Tang Boon on 1/28/18.
//

#import "MapController.h"

@interface MapController ()

@end

@implementation MapController

@synthesize map_main = _map_main;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    // Init locationManager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    // Set MapView location
    CLLocationCoordinate2D coord = {.latitude = 1.39567259, .longitude = 103.74985329};
    MKCoordinateSpan span = {.latitudeDelta = 0.050f, .longitudeDelta = 0.050f};
    MKCoordinateRegion region = {coord, span};
    [_map_main setRegion:region];
}

- (IBAction)sendGPSLocation:(id)sender
{
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        // Set pin
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        CLLocationCoordinate2D coordforpin = {.latitude = currentLocation.coordinate.latitude, .longitude = currentLocation.coordinate.longitude};
        [annotation setCoordinate:coordforpin];
        [annotation setTitle:@"Test"];
        [_map_main addAnnotation:annotation];
    }
    [_locationManager stopUpdatingLocation];
}

- (void) dismissKeyboard
{
    // add self
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
