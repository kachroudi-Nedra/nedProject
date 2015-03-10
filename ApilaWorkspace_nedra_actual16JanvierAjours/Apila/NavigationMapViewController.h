//
//  NavigationMapViewController.h
//  Apila
//
//  Created by Nedra Kachroudi on 29/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleMapViewController.h"
#import "MDDirectionService.h"
#import <AVFoundation/AVFoundation.h>
#import "AlertePleaseWaitViewController.h"
#import "AlerteNavigationViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "Leg.h"
#import "HomeRecommandedViewCtrl.h"
#import "ServerResponseViewController.h"
#import "Road.h"
#import <MapKit/MapKit.h>
#import <SKMaps/SKMaps.h>
#import <SKMaps/SKRouteInformation.h>
@class GoogleMapDelegate;
@class AppDelegate;
@class ViewController;
@class ServerResponseViewController;
@class HomeRecommandedViewCtrl;
@class AlertChooseNavigationViewController;

@interface NavigationMapViewController : UIViewController<GoogleMapDelegate,CLLocationManagerDelegate,DetectionnProtocolDelegate,SKRoutingDelegate,SKNavigationDelegate>
{

    SKMapView *skMap;
    ViewController *FirstViewController;
    AppDelegate *appDelegate;
    IBOutlet UITextView *debugTextView;
    IBOutlet UIView *NavView;
    GoogleMapViewController *map ;
    CLLocation *userLocation;
    CLLocation* destinationLoc;
    CLLocation* originLoc;
    CLLocation *carLocation;
    CLLocationManager *locationManager;
    IBOutlet UIView *InformationView;
    IBOutlet UIImageView *IndicationImage;
    IBOutlet UILabel *distanceLabel;
    IBOutlet UILabel *instructionLabel;
    IBOutlet UILabel *DistanceGlobalLabel;
    NSMutableArray *waypointsApiway;
    IBOutlet UILabel *TempsGlobalLabel;
    NSMutableArray *waypointStringsApiway;
    NSMutableArray * waypoints_;
    NSMutableArray * waypointStrings_;
    NSMutableArray * etapes;
     MDDirectionService * mds;
    GMSPolyline *polyline;
    GMSMarker  *markerOrigin ;
    GMSMarker  *markerDestination ;
    GMSMarker* markerUserLocation;
    GMSMarker* CarMarker;
    int etapeCount;
    int allEtapeCount;
    Leg *leg;
    int spoken;
    int spokenNextStep;
    int spokenSecond;
    int spokenArrived;
    CLLocation *testLoc;
    BOOL test;
    NSString* NavigMode;
    AlertePleaseWaitViewController *alertePleaseWaitViewController;
    AlerteNavigationViewController * alerteNavigationViewController;
    int countAlert;
    NSString *responseString;
     NSString *responseStringWaypoints;
     NSString *responseApiway;
    Leg *nextLeg;
    NSMutableArray *apiwayPoints;
    NSMutableArray *roads;
    GMSPolyline *roadPoyline;
    HomeRecommandedViewCtrl *homeRecommanded;
    NSMutableArray *savedParkingsArray;
    NSMutableArray *savedApiwayArray;
    ServerResponseViewController *serverResponse;
    CLLocationDirection currenHeading;
    Road *choosenRoad;
    float xmin;
    int index;
    NSMutableArray *WaypointsArray;
    NSURLConnection * connectionAddress;
    NSURLConnection * connectionWaypoints;
    NSURLConnection * connectionApiway;
    float destLat;
    float  destLng;
    NSString* destLatString;
    NSString* destLngString;
    NSString *destinationAddress;
    NSString * userAddress;
    bool parknow;
    bool parknowDestination;
    bool startNavig;
    double distanceParc;
    NSString* parkType;
    bool recalcul;
    GMSPath *path;
    bool mapMoved;
    AlertChooseNavigationViewController * alertChooseNavigationViewController;
    NSMutableArray *allEtapes;
    NSMutableArray * etapeGlobale;
    NSMutableArray *allPaths;
    bool showNotifPark;
    Parking *choosenParking;
    NSArray *sortedParkings;
    NSMutableArray *colorArray ;
    uint32_t hasCompleted;
    MKReverseGeocoder *geoCoder;
    NSTimeInterval timeInMilisecondsNow;
    NSTimeInterval timeInMilisecondsLast;
    NSTimer *timer;
    int nb_time;
}
@property (strong, nonatomic) IBOutlet UIView *cancelView;
@property (strong, nonatomic) IBOutlet UIView *go_view;
@property (strong, nonatomic) IBOutlet UILabel *apiway_all_time_label;
@property (strong, nonatomic) IBOutlet UILabel *apiway_distance_label;
@property (strong, nonatomic) IBOutlet UILabel *apiway_time_label;
@property (strong, nonatomic) IBOutlet UILabel *apipark_notiffermee_label_distance;
@property (strong, nonatomic) IBOutlet UIView *apipark_notif_fermee;
@property (strong, nonatomic) IBOutlet UILabel *apipark_notif_label_distance;
@property (strong, nonatomic) IBOutlet UILabel *apipark_notif_label;
@property (strong, nonatomic) IBOutlet UIView *apipark_notif_view;
@property (strong, nonatomic) IBOutlet UIButton *cancel_btn;
@property (strong, nonatomic) IBOutlet UIButton *go_btn;
@property (strong, nonatomic) IBOutlet UIView *back_view;
@property (strong, nonatomic) IBOutlet UIView *GoView;
@property (strong, nonatomic) IBOutlet UIView *instructionView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (readwrite, nonatomic) int isVisible;
@property CLLocation* savedDestination;
@property bool Waze;
-(void)initWithdestLoc:(CLLocation*)destLocation ;
-(void)NavigateToParking;
-(void)NavigateToDestination;
-(void)NavigateToApiShare;
-(void)NavigationQuery:(CLLocation *)myLocation  andDestLoc:(CLLocation*)destLoc andMode:(NSString*)NavigMode;
-(void)NavigationDeMerdre:(CLLocation*)destLoc;
-(void) navigatetoAddress:(NSString*)address;
-(void)parkNow ;
-(void)parkNowToDestination:(CLLocation*)destination;
-(IBAction)cancelAction:(id)sender;
@end
