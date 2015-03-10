//
//  AppDelegate.h
//  Apila
//
//  Created by Vincenzo GALATI on 18/02/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreMotion/CoreMotion.h>
#import "ViewController.h"
#import "LogScreen1ViewController.h"
#import "ServerViewController.h"
#import "MenuModalViewController.h"
#import "Reachability.h"
#import "UserInformationData.h"
#import "NavigationMapViewController.h"
#import "SplashScreenViewController.h"
#import "DetectEvent.h"
#import <SKMaps/SKMaps.h>
@class LogScreen1ViewController;
@class ViewController;
@class NavigationMapViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,DetectionnProtocolDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    @public
    CMMotionManager *motionManager;
    UIView * notifView;
    UIImageView * backNotif;
    UILabel * notifMessage;
    int notifIsShowing;
    UIAlertView * pleaseWait;
    UIAlertView * pleaseWaitCnx;
    UIAlertView * chooseServer;
    int pleaseWaitShown;
    CLLocationManager *locationManager;
    NSString *ETAT;
    int show;
    UserInformationData *userInformation;
    NavigationMapViewController *navigationMap;
    bool launch;
    bool isAppResumingFromBackground;
    UIAlertView *notificationAlert;
}
@property (nonatomic, retain) LogScreen1ViewController *logScreen1ViewController;
@property bool WTP;
@property bool arrived;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, weak) IBOutlet UILabel* summaryLabel;

@property (nonatomic, weak) IBOutlet UITextField *remoteHostLabel;
@property (nonatomic, weak) IBOutlet UIImageView *remoteHostImageView;
@property (nonatomic, weak) IBOutlet UITextField *remoteHostStatusField;

@property (nonatomic, weak) IBOutlet UIImageView *internetConnectionImageView;
@property (nonatomic, weak) IBOutlet UITextField *internetConnectionStatusField;

@property (nonatomic, weak) IBOutlet UIImageView *localWiFiConnectionImageView;
@property (nonatomic, weak) IBOutlet UITextField *localWiFiConnectionStatusField;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@property (strong, nonatomic)CLLocation *userLocation;
@property (strong, nonatomic)CLLocation *carLocation;
@property  float currenHeading;
@property (strong, nonatomic)NSString *debugText;
@property (strong, nonatomic)GMSMarker *markerUserLocation;
@property (strong, nonatomic)GMSMarker *  CarMarker;
@property (strong, nonatomic) UIWindow *window;
@property DetectEvent * detect;
@property (readonly) CMMotionManager *motionManager;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet GMSMapView *map;

@property (strong, nonatomic) ViewController *firstViewController;
- (void) showNotif:(NSString *) message duringSec : (float) sec;
@property (readwrite, nonatomic) int user_id;
@property  int navigChoice;
@property (strong, nonatomic) NSMutableArray * parkingArray;
@property (strong, nonatomic) CLLocation * savedCarLocation;
@property (strong, nonatomic) CLLocation * savedDestination;
@property (strong, nonatomic) NSString * ETAT;
@property (strong, nonatomic) NSString * user_sid;
@property (strong, nonatomic) NSString * device_id;
@property (strong, nonatomic) NSString * img_name;
@property (strong, nonatomic) NSString * user_name;
@property (strong, nonatomic) NSString * user_pseudo;       // new server
@property (strong, nonatomic) NSString * user_pass;         // new server
@property (strong, nonatomic) NSString * user_car_marque;   // new server
@property (strong, nonatomic) NSString * user_car_modele;   // new server
@property (strong, nonatomic) NSString * user_car_couleur;  // new server
@property (strong, nonatomic) NSString * user_email;        // new server
@property (strong, nonatomic) NSString * user_fb_token;     // new server
@property (strong, nonatomic) NSString * user_fb_id;        // new server
@property (strong, nonatomic) NSString * user_fb_birthday;  // new server
@property (strong, nonatomic) NSString * user_ldi_id;        // new server
@property (readwrite, nonatomic) int user_age;              // new server
@property (strong, nonatomic) NSString * user_sexe;         // new server
@property (strong, nonatomic) ServerViewController * serverWebSocket;
@property (strong, nonatomic) LogScreen1ViewController * logScreen1;


- (void) showPleaseWait;
- (void) hidePleaseWait;
- (void)openFacebookSession;
- (void)closeFacebookSession;
    


@end
