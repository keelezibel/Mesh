//
//  MapAnnotation.h
//  ChatSample
//
//  Created by Le Tang Boon on 2/9/18.
//  Copyright © 2018 Bridgefy Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapAnnotation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
