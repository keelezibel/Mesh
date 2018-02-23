//
//  MapController.h
//  ChatSample
//
//  Created by Le Tang Boon on 1/28/18.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPerson.h"
#import <CoreLocation/CoreLocation.h>

@interface MapController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource> {
    MKMapView *map_main;
    CLLocation *currentLocation;
    
    NSArray *titles;
    NSArray *descriptions;
    NSArray *images;
}

- (MKOverlayView *)mapView:(MKMapView *)map rendererForOverlay:(id <MKOverlay>)overlay;

@property(strong,nonatomic) IBOutlet MKMapView * map_main;
@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) CLLocation *currentLocation;
@property(strong,nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *zoomToUser;

@end
