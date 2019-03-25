//
//  MapController.m
//  ChatSample
//

#import "MapController.h"
#import "MapAnnotation.h"
#import "Location.h"
@import Mapbox;

// MGLPointAnnotation subclass
@interface OperatorPointAnnotation : MGLPointAnnotation
@property (nonatomic, assign) BOOL useOperatorImage;
@property (nonatomic, assign) NSString * opName;
@end

@implementation OperatorPointAnnotation
@end

// MGLPointAnnotation subclass
@interface VictimPointAnnotation : MGLPointAnnotation
@property (nonatomic, assign) BOOL useVictimImage;
@property (nonatomic, assign) NSString * victimName;
@end

@implementation VictimPointAnnotation
@end

#define METERS_PER_MILE 1609.344
#define FULLPATH(X) [[NSSearchPathForDirectoriesInDomains\
(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]\
stringByAppendingPathComponent:(X)]

@interface MapController () <MGLMapViewDelegate>
@property (nonnull, retain) NSMutableDictionary *locations;
@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UIProgressView *progressView;
@end

@implementation MapController

@synthesize map_main = _map_main;
@synthesize currentLocation = _currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _map_main.delegate=(id)self;
    
    self.mapPackName = @"Offline Street Style Pack";
    self.isMapPackageDownloaded = FALSE;
    
    [self addMapboxMap];
    
    // 5 sec timer
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadTable) userInfo:nil repeats:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    // Init locationManager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    self.currentLocation = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // Plot locations on map
    [self plotPositions];
    [self addAnnotation];
    [self plotOperators];
}

- (void)plotOperators
{
    OperatorPointAnnotation *op1 = [[OperatorPointAnnotation alloc] init];
    op1.coordinate = CLLocationCoordinate2DMake(1.281991, 103.814028);
    op1.title = @"Operator 1";
    op1.subtitle = @"Last Updated: ";
    op1.useOperatorImage = YES;
    op1.opName = @"Op1";
    
    OperatorPointAnnotation *op2 = [[OperatorPointAnnotation alloc] init];
    op2.coordinate = CLLocationCoordinate2DMake(1.275169, 103.819408);
    op2.title = @"Operator 2";
    op2.subtitle = @"Last Updated: ";
    op2.useOperatorImage = YES;
    op2.opName = @"Op2";
    
    NSArray * opPlaces = @[op1,op2];

    [self.mapView addAnnotations:opPlaces];
}

- (void)addMapboxMap
{
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.tintColor = [UIColor lightGrayColor];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(1.279673, 103.816502)
                            zoomLevel:14
                             animated:NO];
    // Allow the map view to display the user's location
    self.mapView.showsUserLocation = YES;
    self.mapView.styleURL = [MGLStyle streetsStyleURL];
    self.mapView.showsScale = YES;
    self.mapView.showsHeading = YES;
    self.mapView.showsUserHeadingIndicator = YES;
    
    //[self addToggleButton];
}

// Add new method above refreshTapped
- (void)plotPositions {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //Load location information
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.locations = [self loadLocation];
    NSMutableArray<MGLPointAnnotation *> *victimLocArr = [[NSMutableArray alloc] init];
    for (id key in self.locations.allKeys) {
        NSLog(@"%@",key);
        if (![key  isEqual: @"null"]) {
            Location *value = [self.locations objectForKey:key];
            NSString *locStr = value.location;
            NSArray * pos = [value.location componentsSeparatedByString: @","];
            NSString * latStr = [pos[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString * lonStr = [pos[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSNumber * latitude = [f numberFromString:latStr];
            double latDouble = [latitude doubleValue];
            NSNumber * longitude = [f numberFromString:lonStr];
            double lonDouble = [longitude doubleValue];
            VictimPointAnnotation *annotation = [[VictimPointAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(latDouble, lonDouble);
            annotation.title = value.sender;
            annotation.subtitle = [NSString stringWithFormat:@"%@ %@", @"Last Updated: ", value.date];
            annotation.useVictimImage = YES;
            annotation.victimName = key;
            
            [victimLocArr insertObject:annotation atIndex:0];
        }
    }
    [self.mapView addAnnotations:victimLocArr];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[OperatorPointAnnotation class]]) {
        OperatorPointAnnotation *castAnnotation = (OperatorPointAnnotation *)annotation;
        if (!castAnnotation.useOperatorImage) {
            return nil;
        }
        else {
            // For better performance, always try to reuse existing annotations.
            MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:castAnnotation.opName];
            
            // If there is no reusable annotation image available, initialize a new one.
            if (!annotationImage) {
                UIImage *image = [UIImage imageNamed:@"operator-icon"];
                image = [self resizeImageWithImage:image toSize:CGSizeMake(30, 30)];
                image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
                annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:castAnnotation.opName];
                
                return annotationImage;
            }
        }
    }
    else if ([annotation isKindOfClass:[VictimPointAnnotation class]]) {
        VictimPointAnnotation *castAnnotation = (VictimPointAnnotation *)annotation;
        if (!castAnnotation.useVictimImage) {
            return nil;
        }
        else {
            // For better performance, always try to reuse existing annotations.
            MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:castAnnotation.victimName];
            
            // If there is no reusable annotation image available, initialize a new one.
            if (!annotationImage) {
                UIImage *image = [UIImage imageNamed:@"boy"];
                image = [self resizeImageWithImage:image toSize:CGSizeMake(30, 30)];
                image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
                annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:castAnnotation.victimName];
                
                return annotationImage;
            }
        }
    }
    
    
    return nil;
}

- (UIImage*)resizeImageWithImage:(UIImage*)image toSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // draw in new context, with the new size
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)addToggleButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button setTitle:@"Toggle Contours" forState:UIControlStateNormal];
    [button setSelected:YES];
    [button sizeToFit];
    button.center = CGPointMake(self.view.center.x, 0);
    button.frame = CGRectMake(button.frame.origin.x, self.view.frame.size.height - button.frame.size.height - 100, button.frame.size.width, button.frame.size.height);
    [button addTarget:self action:@selector(toggleLayer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)addAnnotation
{
    // Add a point annotation
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(1.277305, 103.817390);
    annotation.title = @"Fire drill safe point";
    annotation.subtitle = @"Gather here";
    
    [self.mapView addAnnotation:annotation];
}

- (UIView *)mapView:(MGLMapView *)mapView leftCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    if ([annotation.title isEqualToString:@"Fire drill safe point"])
    {
        // Callout height is fixed; width expands to fit its content.
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.f, 50.f)];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor colorWithRed:0.81f green:0.71f blue:0.23f alpha:1.f];
        label.text = @"SAFRA";
        
        return label;
    }
    
    return nil;
}

- (UIView *)mapView:(MGLMapView *)mapView rightCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    return [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    // Always allow callouts to popup when annotations are tapped.
    return YES;
}

// Zoom to the annotation when it is selected
- (void)mapView:(MGLMapView *)mapView didSelectAnnotation:(id<MGLAnnotation>)annotation {
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate: annotation.coordinate fromDistance:3000 pitch:0 heading:0];
    [mapView setCamera:camera animated:true];
}

- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
    // Start downloading tiles and resources for z13-16.
    [self startOfflinePackDownload];
}

- (void)dealloc {
    // Remove offline pack observers.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startOfflinePackDownload {
    NSArray<MGLOfflinePack *> *packs = MGLOfflineStorage.sharedOfflineStorage.packs;
    if(packs) {
        if (packs.count > 0) {
            for (int i = 0; i < [packs count]; i++) {
                MGLOfflinePack * pack = [packs objectAtIndex:i];
                // Get the associated user info for the pack; in this case, `name = My Offline Pack`
                NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:pack.context];
                if ([userInfo[@"name"] isEqualToString:self.mapPackName]) {
                    self.isMapPackageDownloaded = TRUE;
                }
            }
        }
    }
    // If region is downloaded - return
    if (self.isMapPackageDownloaded) {
        return;
    }
    
    // Setup offline pack notification handlers.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offlinePackProgressDidChange:) name:MGLOfflinePackProgressChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offlinePackDidReceiveError:) name:MGLOfflinePackErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offlinePackDidReceiveMaximumAllowedMapboxTiles:) name:MGLOfflinePackMaximumMapboxTilesReachedNotification object:nil];
    
    // Create a region that includes the current viewport and any tiles needed to view it when zoomed further in.
    // Because tile count grows exponentially with the maximum zoom level, you should be conservative with your `toZoomLevel` setting.
    id <MGLOfflineRegion> region = [[MGLTilePyramidOfflineRegion alloc] initWithStyleURL:self.mapView.styleURL bounds:self.mapView.visibleCoordinateBounds fromZoomLevel:self.mapView.zoomLevel toZoomLevel:16];
    
    // Store some data for identification purposes alongside the downloaded resources.
    NSDictionary *userInfo = @{ @"name": self.mapPackName };
    NSData *context = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    
    // Create and register an offline pack with the shared offline storage object.
    [[MGLOfflineStorage sharedOfflineStorage] addPackForRegion:region withContext:context completionHandler:^(MGLOfflinePack *pack, NSError *error) {
        if (error != nil) {
            // The pack couldn’t be created for some reason.
            NSLog(@"Error: %@", error.localizedFailureReason);
        } else {
            // Start downloading.
            [pack resume];
        }
    }];
}

#pragma mark - MGLOfflinePack notification handlers

- (void)offlinePackProgressDidChange:(NSNotification *)notification {
    MGLOfflinePack *pack = notification.object;
    
    // Get the associated user info for the pack; in this case, `name = My Offline Pack`
    NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:pack.context];
    
    MGLOfflinePackProgress progress = pack.progress;
    // or [notification.userInfo[MGLOfflinePackProgressUserInfoKey] MGLOfflinePackProgressValue]
    uint64_t completedResources = progress.countOfResourcesCompleted;
    uint64_t expectedResources = progress.countOfResourcesExpected;
    
    // Calculate current progress percentage.
    float progressPercentage = (float)completedResources / expectedResources;
    
    // Setup the progress bar.
    if (!self.progressView) {
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        CGSize frame = self.view.bounds.size;
        self.progressView.frame = CGRectMake(frame.width / 4, frame.height * 0.75, frame.width / 2, 10);
        [self.view addSubview:self.progressView];
    }
    
    [self.progressView setProgress:progressPercentage animated:YES];
    
    // If this pack has finished, print its size and resource count.
    if (completedResources == expectedResources) {
        NSString *byteCount = [NSByteCountFormatter stringFromByteCount:progress.countOfBytesCompleted countStyle:NSByteCountFormatterCountStyleMemory];
        NSLog(@"Offline pack “%@” completed: %@, %llu resources", userInfo[@"name"], byteCount, completedResources);
    } else {
        // Otherwise, print download/verification progress.
        NSLog(@"Offline pack “%@” has %llu of %llu resources — %.2f%%.", userInfo[@"name"], completedResources, expectedResources, progressPercentage * 100);
    }
}

- (void)offlinePackDidReceiveError:(NSNotification *)notification {
    MGLOfflinePack *pack = notification.object;
    NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:pack.context];
    NSError *error = notification.userInfo[MGLOfflinePackUserInfoKeyError];
    NSLog(@"Offline pack “%@” received error: %@", userInfo[@"name"], error.localizedFailureReason);
}

- (void)offlinePackDidReceiveMaximumAllowedMapboxTiles:(NSNotification *)notification {
    MGLOfflinePack *pack = notification.object;
    NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:pack.context];
    uint64_t maximumCount = [notification.userInfo[MGLOfflinePackUserInfoKeyMaximumCount] unsignedLongLongValue];
    NSLog(@"Offline pack “%@” reached limit of %llu tiles.", userInfo[@"name"], maximumCount);
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
    MKCoordinateSpan span = {.latitudeDelta = 0.0050f, .longitudeDelta = 0.0050f};
    MKCoordinateRegion region = {coord, span};
    [_map_main setRegion:region animated:YES];
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
    }
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
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
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
