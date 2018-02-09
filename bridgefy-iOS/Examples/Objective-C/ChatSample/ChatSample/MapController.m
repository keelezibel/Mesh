//
//  MapController.m
//  ChatSample
//
//  Created by Le Tang Boon on 1/28/18.
//

#import "MapController.h"
#import "MapAnnotation.h"
#define METERS_PER_MILE 1609.344

@interface MapController ()

@end

@implementation MapController

@synthesize map_main = _map_main;
@synthesize currentLocation = _currentLocation;

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
    self.currentLocation = nil;
    
    // Set MapView initial location
    CLLocationCoordinate2D coord = {.latitude = 1.3521, .longitude = 103.8198};
    [self initMap:coord];
    
    // Mark personal location on map
    [self initUpdateLocation];
    
}

// Initialize region to zoom in
- (void)initMap:(CLLocationCoordinate2D)coord{
    MKCoordinateSpan span = {.latitudeDelta = 0.50f, .longitudeDelta = 0.50f};
    MKCoordinateRegion region = {coord, span};
    [_map_main setRegion:region animated:YES];
}

// Add new method above refreshTapped
- (void)plotCrimePositions:(NSData *)responseData {
    for (id<MKAnnotation> annotation in _map_main.annotations) {
        [_map_main removeAnnotation:annotation];
    }
    
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    NSArray *data = [root objectForKey:@"data"];
    
    for (NSArray *row in data) {
        NSNumber * latitude = [[row objectAtIndex:22]objectAtIndex:1];
        NSNumber * longitude = [[row objectAtIndex:22]objectAtIndex:2];
        NSString * crimeDescription = [row objectAtIndex:18];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        MapAnnotation *annotation = [[MapAnnotation alloc] initWithName:crimeDescription coordinate:coordinate] ;
        [_map_main addAnnotation:annotation];
    }
}

- (void)initUpdateLocation{
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
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:@"Failed to Get Your Location"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handler for Ok
                                }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];

}

// Update location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    self.currentLocation = newLocation;
    
    if (self.currentLocation != nil && fabs(self.currentLocation.coordinate.latitude - 0.0) > DBL_EPSILON) {
        // currentLocation is updated
        [_locationManager stopUpdatingLocation];
        // Route from current to dest
        CLLocationCoordinate2D startCoord = {.latitude = self.currentLocation.coordinate.latitude, .longitude = self.currentLocation.coordinate.longitude};
        CLLocationCoordinate2D endCoord = {.latitude = 1.340708, .longitude = 103.898001};
        [self routeSourceDest:startCoord end:endCoord];
    }
}

// Set Routing
- (void)routeSourceDest:(CLLocationCoordinate2D)startLoc end:(CLLocationCoordinate2D)endLoc{
    // Set start pin
    MKPointAnnotation *annotationStart = [[MKPointAnnotation alloc]init];
    [annotationStart setCoordinate:startLoc];
    [annotationStart setTitle:@"Your Position"];
    [_map_main addAnnotation:annotationStart];
    
    // Set end pin
    MKPointAnnotation *annotationEnd = [[MKPointAnnotation alloc]init];
    [annotationEnd setCoordinate:endLoc];
    [annotationEnd setTitle:@"Destination"];
    [_map_main addAnnotation:annotationEnd];
    
    // Set start map item
    MKPlacemark *source = [[MKPlacemark   alloc]initWithCoordinate:CLLocationCoordinate2DMake(startLoc.latitude, startLoc.longitude)   addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    
    // Set end map item
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(endLoc.latitude, endLoc.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    // Create route from start to destination
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
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
        /*
        if (!error) {
            for (MKRoute *route in [response routes]) {
                [_map_main addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
                // You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
            }
        }
         */
    }];
}

- (IBAction)zoomToUser:(id)sender{
    CLLocationCoordinate2D startCoord = {.latitude = self.currentLocation.coordinate.latitude, .longitude = self.currentLocation.coordinate.longitude};
    
    MKCoordinateSpan span = {.latitudeDelta = 0.0050f, .longitudeDelta = 0.0050f};
    MKCoordinateRegion region = {startCoord, span};
    [_map_main setRegion:region animated:YES];
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
