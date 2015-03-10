//
//  GoogleMapViewController.h
//  Apila
//
//  Created by Nedra Kachroudi on 19/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LocationTracker.h"
#import "MDDirectionService.h"
#import <Math.h>
#import "AlertePleaseWaitViewController.h"
#import <AVFoundation/AVFoundation.h>

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@protocol GoogleMapDelegate <NSObject>
@required

-(void)sendInstructions:(NSString*)instructions;
-(void)sendSteps:(NSMutableArray*)steps andPolyline:(GMSPolyline*)polyline;

@end
@interface GoogleMapViewController : UIViewController <GMSMapViewDelegate,NSURLConnectionDelegate,CLLocationManagerDelegate>
{
    NSMutableArray * waypoints_;
    NSMutableArray * waypointStrings_;
    NSMutableArray * etapes;
    GMSPath *path;
    GMSPolyline * polyline;
    
    MDDirectionService * mds;
    NSString* responseString;
    NSMutableArray *apiwayPoints;
    int prochaineEtape;
    int etapefounded;
    NSString* indicationNavig;
    GMSMarker* markerUserLocation;
    float lastEtapeLat;
    float lastEtapeLng;
    float distLastEtape;
    float lastLat;
    float lastLng;
    int hasSpoken;
    int hasSpoken2;
    int hasSpoken3;
    int hasSpoken4;
   NSMutableArray* diffDistance ;
    GMSMapView * GMSmap;

    AlertePleaseWaitViewController * alertePleaseWaitViewController;

}
@property (readwrite, nonatomic) bool recalcul;

@property (readwrite, nonatomic) float speed;

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *ApiwayLab;

@property id <GoogleMapDelegate> delegate;
@property LocationTracker * locationTracker;
- (IBAction)takeMeThere:(CLLocation*)destLoc;
-(void)showFakeMarkers:(NSMutableArray*)apiwayPointsArray andMap:(GMSMapView*)mapToShow;
-(void)showFakeMarkers:(NSMutableArray*)apiwayPointsArray andMap:(GMSMapView*)mapToShow andRecalcul:(bool)recalcul;
-(void)getResponse:(NSString*)url;
-(void)zoomToPolyLine;
- (IBAction)navigateTo:(CLLocation*)destLoc;
@end
