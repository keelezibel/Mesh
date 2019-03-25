//
//  MapAnnotation.h
//  ChatSample
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapAnnotation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
