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
    _map_main.delegate=(id)self;
    
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
     
    
    MKPlacemark *source = [[MKPlacemark   alloc]initWithCoordinate:CLLocationCoordinate2DMake(1.395581, 103.749943)   addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(1.302974, 103.810412) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        /*
        NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *rout = obj;
            
            MKPolyline *line = [rout polyline];
            [_map_main addOverlay:line];
            NSLog(@"Rout Name : %@",rout.name);
            NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            
            NSArray *steps = [rout steps];
                        
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"Rout Instruction : %@",[obj instructions]);
                NSLog(@"Rout Distance : %f",[obj distance]);
            }];
        }];
         */
        
        if (!error) {
            for (MKRoute *route in [response routes]) {
                [_map_main addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
                // You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
            }
        }
    }];
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

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor redColor]];
        [renderer setLineWidth:3.0];
        return renderer;
    }
    return nil;
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
