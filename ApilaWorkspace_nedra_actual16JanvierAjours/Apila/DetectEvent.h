//
//  DetectEvent.h
//  AutomateV4
//
//  Created by Nedra Kachroudi on 12/11/2014.
//  Copyright (c) 2014 Nedra Kachroudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <math.h>
#import "LocationTracker.h"
#import "Moteur.h"
#import "UserInformationData.h"
@class AppDelegate;
#define Vs 2.0 // seuil de la vitesse en m/s
#define Vss 0.2 // seuil de la vitesse en m/s
#define Sm 2.3
#define Sa 1.67 // seuil pour la moyenne et la variance glissante de l'accélération
#define Sb 2.00 // seuil pour la moyenne glissante de l'accélération, utilisé pour identifié le stationnement
#define EPSILON 20.00 // limite de rapprochement de la voiture
#define DIST_PROCHE 50
#define DIST_LOIN 100
#define DISTANCE_MAX_ME_CAR  50 // EN M
#define DISTANCE_APIWAY_CAR_DEST 25 //EN M
#define pi 3.14159265358979323846
@protocol DetectionProtocolDelegate <NSObject>
@required
- (void) arretPied:(double)distance;
- (void) arretProche:(double)ancienneDist nouvelleDist:(double)nouvelleDist;
- (void) arretMoyen:(double)ancienneDist nouvelleDist:(double)nouvelleDist;
- (void) arretLoin:(double)ancienneDist nouvelleDist:(double)nouvelleDist;
- (void) marche;
- (void) marcheProche;
- (void) marcheMoyen;
- (void) marcheLoin;
- (void) liberer:(CLLocation*)savedCarLocation;
- (void) rouler:(CLLocation*)myCarLocation;
- (void) arretVoiture:(CLLocation*)savedCarLocation;
- (void) stationner:(CLLocation*)savedCarLocation ancienneDist:(double)ancienneDist nouvelleDist:(double)nouvelleDist;
- (void) eloigner:(CLLocation*)savedCarLocation ancienneDist:(double)ancienneDist nouvelleDist:(double)nouvelleDist;
- (void) stabiliser:(CLLocation*)savedCarLocation distanceFromCar: (double)distance;
- (void) revenirVersVoiture:(CLLocation*)savedCarLocation ancienneDist:(double)ancienneDist nouvelleDist:(double)nouvelleDist;
- (void) apifindImplicite:(CLLocation*)savedCarLocation ancienneDist:(double)ancienneDist nouvelleDist:(double)nouvelleDist;
- (void) sendDistance:(double)distance;
- (void)usageCourt:(NSString *)ConnectionDate;
-(void)usageVieux:(NSString *)ConnectionDate;
-(void) activelocation;
-(void) desactivelocation;
-(void)Rien:(CLLocation*)savedCarLocation;;
-(void)RIENOTHER;
@end
@interface DetectEvent : NSObject <CLLocationManagerDelegate>

{
   @public
    UserInformationData *userInformation;
    int dist_proche, dist_loin;
    int timeFromStat;
    NSTimer *timer;
   int secondsLeft , hours ,minutes ,seconds ;

    NSDateFormatter *dateFormat;
    NSString * date;
    NSString*fileN;
    NSString*textDebug;
    enum state currentState;
    enum event currentEvent;
    enum event lastEvent;
    enum action currentAction;
    enum action lastAction;
    enum state lastState;
    /** LOCATIONS **/
    CLLocation *myCurrentLocation ;
    CLLocation *myLastLocation ;
    CLLocation *myCarLocation ;
    CLLocation *myLastCarLocation;
    CLLocation *myDestLocation;
    CLLocation *carStoppedLocation;
    CLLocation *savedLoc;
    double GPSTimer;
    /** DATES **/
    NSDate *lastConnectionDate;
    NSDate *currentDate;
    NSDate *yesterday;
    /** GPS STATUS **/
    BOOL gps_on;
    BOOL gps_stable;
    BOOL apiguide;
    BOOL apiway;
    BOOL apipark;
    BOOL apiwalk;
    BOOL apifind;
    BOOL saveIt;
    BOOL Apied;
    NSString *Message;
    NSString *transition;
    NSString *transition1;
    /** DISTANCE **/
    double Distance_me_car;
    double OldDistance_me_car;
    double VeryOldDistance_me_car;
    double Distance_me_dest;
    double Distance_car_dest;
    double ancienneDistance;
    double nouvelleDistance ;
    /** ACCELERATION **/
    float acc_x;
    float acc_y;
    float acc_z;
    float AU;
    float speed;
    double calculatedSpeed;
    double gpsSpeed;
     double distance;
    /** ACCELERATION && VARIANCE **/
     float MGAU;                     // moyenne glissante de l'accélération mesurée par accéléromètre/gyroscope (1 mesure par seconde, dans une période de 15 sec)
     float VMAU;                     // variance glissante de l'accélération (1 mesure par seconde, dans une période de 15 sec)
    NSMutableArray * mvgauArray;    // tableau des 15 dernières accélérations mesurées pour calculer la moyenne glissante et la variance
    NSMutableArray * mvgauArray1;    // tableau des 15 dernières accélérations mesurées pour calculer la moyenne glissante et la variance
  LocationTracker * locationTracker;
  UIBackgroundTaskIdentifier *bgTaskID;
    NSMutableArray *eventArray;
    NSMutableArray *actionArray;
    int i,k;
    int counter;
    float  currenHeading;
   AppDelegate *appDelegate ;
    NSArray *keys;
    NSArray *objects;
    NSDictionary *dict;
    NSDictionary *latitude;
    NSDictionary *longitude;
    NSMutableDictionary *eventData;
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property LocationTracker * locationTracker;
@property (nonatomic,strong) id delegate;
@property (nonatomic, strong) CMMotionManager *motionManager;
- (id)detectEvent;
-(void)detectAcceleration;
- (float) moyenneVitesse;
- (float) varianceVitesse;
-(NSDate*)getCurrentDate;
-(void)startGPS;
-(void)stopGPS;
-(void)usageCourt;
-(void)usageVieux;
-(void)drive;
-(void)stop;
-(void)walk;
-(void)DoIt:(enum action)currentAction;
-(void)MyCarIsHere;
-(double)getOldDistance;
-(double)getCurrentDistance;
-(double)rad2deg:(double)rad ;
-(double)deg2rad:(double)deg ;
-(double )distance: (double) lat1 lon1: (double) lon1 lat2: (double) lat2  lon2: (double) lon2 unit: (char) unit ;
- (void)moyen;
- (void)proche;
-(void) writeToTextFile:(NSString*) line;
-(void) detectMovement;
-(void)initAutomate;
@end

