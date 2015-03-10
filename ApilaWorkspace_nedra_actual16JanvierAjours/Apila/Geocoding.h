//
//  Geocoding.h
//  Apila
//
//  Created by Nedra Kachroudi on 20/01/2015.
//  Copyright (c) 2015 1CPARABLE SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "NSString+MD5.h"
@protocol Geocode <NSObject>
@required
- (void) SendResponse:(GMSMarker*)markerDestination;
@end
@interface Geocoding : NSObject<GMSMapViewDelegate>
{
   NSString* responseString;
    float destLat;
    float destLng;
    GMSMarker* markerDestination;
}
@property id <Geocode> delegate;
- (void) startNavigRequest:(NSString*)destinationLocation;
@end
