//
//  MapController.m
//  ChatSample
//
//  Created by Le Tang Boon on 1/28/18.
//

#import "MapController.h"
#import "MapAnnotation.h"

#define METERS_PER_MILE 1609.344
#define FULLPATH(X) [[NSSearchPathForDirectoriesInDomains\
(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]\
stringByAppendingPathComponent:(X)]

@interface MapController ()
@property (nonnull, retain) NSMutableDictionary *locations;
@end

@implementation MapController

@synthesize map_main = _map_main;
@synthesize currentLocation = _currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 5 sec timer
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadTable) userInfo:nil repeats:YES];

    // Load location information
    self.locations = [self loadLocation];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
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
    
    titles = [[NSArray alloc] init];
    titles = [self.locations allKeys];
    descriptions = [[NSArray alloc] init];
    descriptions = [self.locations allValues];
    [self.tableView reloadData];
    
    [self plotPositions];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void) reloadTable
{
    //Load location information
    self.locations = [self loadLocation];
    
    titles = [[NSArray alloc] init];
    titles = [self.locations allKeys];
    [self.tableView reloadData];
    descriptions = [[NSArray alloc] init];
    descriptions = [self.locations allValues];
    [self.tableView reloadData];
    
    [self plotPositions];
}

-(NSMutableDictionary *)loadLocation
{
    NSString * const locFile = @"locfile";
    NSString * filePath = FULLPATH(locFile);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    
    NSMutableDictionary *locations;
    if (data) {
        locations = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    if (locations == nil)
        locations = [[NSMutableDictionary alloc] init];
    
    return locations;
}

// Initialize region to zoom in
- (void)initMap:(CLLocationCoordinate2D)coord{
    MKCoordinateSpan span = {.latitudeDelta = 0.50f, .longitudeDelta = 0.50f};
    MKCoordinateRegion region = {coord, span};
    [_map_main setRegion:region animated:YES];
}

// Add new method above refreshTapped
- (void)plotPositions {
    for (id<MKAnnotation> annotation in _map_main.annotations) {
        [_map_main removeAnnotation:annotation];
    }
    
    //Load location information
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.locations = [self loadLocation];
    for (NSString * key in self.locations) {
        NSString * value = self.locations[key];
        NSArray * pos = [value componentsSeparatedByString: @","];
        NSString * latStr = [pos[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString * lonStr = [pos[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSNumber * latitude = [f numberFromString:latStr];
        double latDouble = [latitude doubleValue];
        NSNumber * longitude = [f numberFromString:lonStr];
        double lonDouble = [longitude doubleValue];
        
        NSString * locDescription = key;
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latDouble;
        coordinate.longitude = lonDouble;
        MapAnnotation *annotation = [[MapAnnotation alloc] initWithName:locDescription coordinate:coordinate] ;
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
             [self->_map_main addOverlay:line];
             NSLog(@"Rout Name : %@",rout.name);
             NSLog(@"Total Distance (in Meters) :%f",rout.distance);
             
             NSArray *steps = [rout steps];
             
             [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 NSLog(@"Rout Instruction : %@",[obj instructions]);
                 NSLog(@"Rout Distance : %f",[obj distance]);
             }];
         }];
    }];
}

#pragma mark - TableView Delegate and Datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MapPerson *cell = [tableView dequeueReusableCellWithIdentifier:@"mapPerson" forIndexPath:indexPath];
    [cell updateCellWithTitle:[titles objectAtIndex:indexPath.row] description:[descriptions objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
