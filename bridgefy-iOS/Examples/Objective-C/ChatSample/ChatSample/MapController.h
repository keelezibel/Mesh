//
//  MapController.h
//  ChatSample
//
//  Created by Le Tang Boon on 1/28/18.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate> {
    MKMapView *map_main;
}

- (MKOverlayView *)mapView:(MKMapView *)map rendererForOverlay:(id <MKOverlay>)overlay;

@property (strong,nonatomic) IBOutlet MKMapView * map_main;
@property(nonatomic,retain) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
