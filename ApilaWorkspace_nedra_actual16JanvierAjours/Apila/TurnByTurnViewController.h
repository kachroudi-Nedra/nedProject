//
//  TurnByTurnViewController.h
//  Apila
//
//  Created by Vincenzo GALATI on 06/06/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "NSString+MD5.h"
#import "MDDirectionService.h"
#import "AlertePleaseWaitViewController.h"

@protocol TurnByTurnProtocolDelegate <NSObject>
@required
- (void) navigationEnded;
@end

@interface TurnByTurnViewController : UIViewController
{
    id <TurnByTurnProtocolDelegate> _delegate;
    
    NSString * responseString;
    float destLat;
    float destLng;
    
    float lastEtapeLat;
    float lastEtapeLng;
    float distLastEtape;
    
    NSMutableArray * waypoints_;
    NSMutableArray * waypointStrings_;
    NSMutableArray * etapes;
    NSMutableArray * diffDistance;
    int prochaineEtape;
    float lastLat;
    float lastLng;
    float lastDist;
    int compassEnable;
    int roule;
    int hasSpoken;
    int hasSpoken2;
    int hasSpoken3;
    int hasSpoken4;
    int hasSearch;
    int mapMoved;
    
    GMSPolyline * polyline;
    
    MDDirectionService * mds;
    
    AlertePleaseWaitViewController * alertePleaseWaitViewController;
}

- (void) startNavigationWithMap:(GMSMapView *) mapGoogle andUserMarker:(GMSMarker *) markerUserLocation andDestinationMarker:(GMSMarker *) markerDestination showUserMarker:(BOOL) toShowOrNotToShow andLocationManager : (CLLocationManager *)locationManager;

@end
