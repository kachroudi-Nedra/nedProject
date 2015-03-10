//
//  Leg.h
//  Apila
//
//  Created by Nedra Kachroudi on 08/01/2015.
//  Copyright (c) 2015 1CPARABLE SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSMarker.h>
#import <MapKit/MapKit.h>
@interface Leg : NSObject<GMSMapViewDelegate>

@property(nonatomic,retain)CLLocation *startLoc;
@property(nonatomic,retain)CLLocation *endLoc;
@property(nonatomic,retain)NSString *htmlInstruction;
@property(nonatomic,retain)NSString *indication;
@property int distance;
@property int duration;
@property(nonatomic,retain)GMSPolyline *polyline;
-(id)initWith:(CLLocation*)startLocation EndLocation:(CLLocation*)endLocation HtmlInstruction:(NSString*)HtmlInstruction Distance:(double)Distance Duration:(double)Duration Polyline:(GMSPolyline*)Polyline;
@end
