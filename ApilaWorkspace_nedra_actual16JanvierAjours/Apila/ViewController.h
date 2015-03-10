//
//  ViewController.h
//  Apila
//
//  Created by Vincenzo GALATI on 18/02/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSMarker.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "MenuModalViewController.h"
#import "Alert1JLViewController.h"
#import "AlerteArretViewController.h"
#import "AlerteTypePlaceViewController.h"
#import "AlerteNavigationViewController.h"
#import "AppDelegate.h"
#import "CustomInfoWindow.h"
#import "AlerteEchangeReussiViewController.h"
#import "AlerteAbandonnerViewController.h"
#import "SRWebSocket.h"
#import "NSString+MD5.h"
#import "JSONKit.h"
#import "CustomInfoWindowPlaceLibreJL.h"
#import "MDDirectionService.h"
#import "CustomInfoWindowParkopedia.h"
#import "DetectEvent.h"
#import <MessageUI/MessageUI.h>
#import "LogScreen1ViewController.h"
#import "LocationTracker.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "AlertChooseNavigationViewController.h"
#import "ApiParkViewController.h"
#import "Parking.h"
#import "HomeRecommandedViewCtrl.h"
#import "GoogleMapViewController.h"
#import "ServerResponseViewController.h"
#import "NavigationMapViewController.h"
#import "Reachability.h"
#import "UserInformationData.h"
#import <MapKit/MapKit.h>
#import <SKMaps/SKMaps.h>
#import <SKMaps/SKRouteInformation.h>
#import "SkobblerNavigationViewController.h"
@class AppDelegate;
@class HomeRecommandedViewCtrl;
@class SPGooglePlacesAutocompleteQuery;
@class AlertChooseNavigationViewController;
@class ServerResponseViewController;
@class NavigationMapViewController;
@class SkobblerNavigationViewController;
// variable de détection arret / marche / voiture / se garer / partir / s'approcher de la voiture
#define SPEEDLIMITWALK 0.7200/3.6   // km/h convertis en m/s
#define SPEEDLIMITDRIVE 9.000/3.6  // km/h convertis en m/s
#define DELAYFORPARKING 15.000      // en secondes
#define MOTIONDETECTIONDIFF 0.6     // marge du mouvement de l'accéléromètre pour la prise en compte du mouvement
#define DISTANCEAROUNDMYCAR 100     // en mêtre

// mode/état de l'écran en cours
#define MODENULL 10000
#define MODEJLCHOIXPLACE 10001
#define MODEATTENTEAPPROCHEDEVOITURE 10002
#define MODEPROCHEVOITURE 10003
#define MODERECHERCHENAVIGADRESSE 10005
#define MODEPLACEESTLIBRE 10006
#define MODEJECHERCHE 10007
#define MODEJLECHANGEENCOURS 10008
#define MODEJCECHANGEENCOURS 10009
#define MODEJLECHANGEPRET 10010
#define MODEJCECHANGEPRET 10011
#define MODEJCNAVIG 10012
#define MODEJCNAVIGAPIWAY 10013

// proximité avec la voiture
#define VOITURE_NULL 20000
#define VOITURE_PROCHE 20001
#define VOITURE_LOIN 20002

// type de place
#define PLACE_INCONNUE 0
#define PLACE_GRATUITE 1
#define PLACE_PAYANTE 2
#define PLACE_LIVRAISON 3
#define PLACE_INTERDITE 4

// état de l'user
#define IMMOBILE 0
#define MARCHE 1
#define VOITURE 2

// vue affiché ou pas


@class NavigationViewController;
@class ApiParkViewController;
@class AlertePleaseWaitViewController;
@class MenuModalViewController;
//@protocol ServerResponseDelegate;

@interface ViewController : UIViewController <GMSMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,SRWebSocketDelegate,UIAlertViewDelegate,NSURLConnectionDelegate,MFMailComposeViewControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate,UITextFieldDelegate,SKRoutingDelegate,SKNavigationDelegate>
{
    DetectEvent * detect;
    SKMapView *skMap;
    NSString *pinName;
    Parking *parking;
    NSMutableArray *parkingArray;
    
    ApiParkViewController *apiparkView;
    IBOutlet UIView *recommandedView;
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    BOOL shouldBeginEditing;
    IBOutlet UITableView *placeTable;
    CLLocationManager *locationManager;
    float speed; // vitesse actuelle de déplacement de l'iPhone (gps)
    float speedStation; // vitesse lors du dernier relevé (utile pour savoir s'il y a stationnement ou départ)
    NSDate * oldDate;
    HomeRecommandedViewCtrl *homeRecommanded;
    MenuModalViewController * menuView;
    Alert1JLViewController * alert1JLViewController;
    AlerteArretViewController * alerteArretViewController;
    AlerteTypePlaceViewController * alerteTypePlaceViewController;
    AlerteNavigationViewController * alerteNavigationViewController;
    AlerteEchangeReussiViewController * alerteEchangeReussiViewController;
    AlerteAbandonnerViewController * alerteAbandonnerViewController;
    NavigationMapViewController *navigationMap;
    SkobblerNavigationViewController *skobblerNavigation;
    BOOL dismissAlert;
    float emplacementPlaceLat;
    float emplacementPlaceLng;
    UIImageView * markerPlaceImg;
    GMSMarker *markerUserLocation;
    GMSMarker *CarMarker;
    NSMutableArray * markersUserArray;
    NSMutableArray * markersParkoArray;
    NSMutableArray * infoParko;
    NSArray *leavePosition;
    float fakeDiffLat;
    float fakeDiffLng;
    
    float latParkingReserve;
    float lngParkingReserve;
    
    CATransition *applicationLoadViewIn;
    int mode;
    int voiture;
    int typePlace;
    int etat_user;
    int secRestantAvantArriveReserveur;
    //int reservUserID;
    NSString * reservUserID;
    NSString * reservOwnerID;
    int jcArrive;
    int allSourcesCalled;
    int appeared;
    BOOL eloigneVoiture;
    BOOL seuilDepasse;
    BOOL mapMoved;
    int limiteDetect;
    
    NavigationViewController * navigView;
    
    SRWebSocket * webSocket;
    NSMutableArray * user_tab_JC_JL;
    NSString *destinationLocation;
    NSString * responseString;
    NSURLConnection * parkopediaConnection;
    NSMutableData * dataParko;
    
    NSURLConnection * apiwayConnection;
    
    NSMutableArray *waypointsApiway;
    NSMutableArray *waypointStringsApiway;
    NSMutableArray * waypoints_;
    NSMutableArray * waypointStrings_;
    
    GMSPolyline * polyline;
    NSMutableArray * etapes;
    NSMutableArray * diffDistance;
    NSMutableArray * apiwayPolylines;
    MDDirectionService * mds;
    MDDirectionService * mdsApiway;
    NSDictionary * jsonApiway;
    int polylineSegmentDestination;
    int polylineSegmentDestination2;
    GMSPolyline * segmentApiwayPolyline;
    GMSPolyline * segmentApiwayPolyline2;
    int prochaineEtape;
    int etapefounded;
      BOOL Apila;
    // détection stationnement
    float s2;
    float s3;
    float epsilon;
    NSMutableArray * saveSpeed;
    float lastArretLat;
    float lastArretLng;
    float lastArretLat2;
    float lastArretLng2;
    NSString * userAddress;
    float lastEtapeLat;
    float lastEtapeLng;
    float distLastEtape;
    int hasSpoken;
    int hasSpoken2;
    int hasSpoken3;
    int hasSpoken4;
    
    BOOL isFirstUpdate;
    @public
    AlertChooseNavigationViewController * alertChooseNavigationViewController;
    AlertePleaseWaitViewController * alertePleaseWaitViewController;
    AppDelegate * appDelegate;
    BOOL parkingList;
    BOOL HomeList;
    BOOL ApiwayList;
    IBOutlet UIButton *parkHereButton;
    NSMutableArray *savedParkingsArray;
    NSMutableArray *routesApiway ;
    IBOutlet UIView *parkingNavView;
    GoogleMapViewController *map ;
    ServerResponseViewController *serverResponse;
    IBOutlet UITextView *debugTextView;
    NSString *apiwayDistance;
    NSMutableArray *predictions;
    NSURLConnection * Placeconnection;
    IBOutlet UITableView *autocompleteTableView;
    IBOutlet UILabel *debugText;
    UIView * notifView;
    UIImageView * backNotif;
    UILabel * notifMessage;
    int notifIsShowing;
    NSString *lastMessage;
    IBOutlet UIView *mapView;
    UIAlertView  * chooseServer;
    UserInformationData  * userInformation ;
    CLLocation* location;
    CLLocation* savedDestination;
    NSURLConnection *connectionAddress;
    NSString* responseStringAddress;
    bool Waze;
    float currenHeading;
}
@property bool WTP;
@property (strong, nonatomic) IBOutlet UILabel *apiway_time_label;
@property (strong, nonatomic) IBOutlet UILabel *apiparkLabel;
@property (strong, nonatomic) IBOutlet UILabel *apiwayLabel;
@property (strong, nonatomic) IBOutlet UILabel *apishareLabel;
@property (readwrite, nonatomic) int isVisible;
@property (strong, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) IBOutlet UIView *chooseView;
@property (strong, nonatomic) IBOutlet GMSMapView *mapGoogle;
@property (strong, nonatomic) IBOutlet UIView *DebugView;
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) IBOutlet UIButton * menuLibereButton;
@property (strong, nonatomic) IBOutlet UIButton * menuChercheButton;
@property (strong, nonatomic) IBOutlet UIButton * menuNavigButton;
- (IBAction)alertNewStationnementFoundedYESAction:(id)sender;
- (IBAction)alertNewStationnementFoundedNOAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *debugLabel;
- (IBAction)menuAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *preciserEmplacementView;
- (IBAction)validerEmplacementPlace:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UILabel *preciserEmplacementLabel;
@property (strong, nonatomic) IBOutlet UIImageView *preciserEmplacementBlueImgView;
@property (strong, nonatomic) IBOutlet UIImageView *preciserEmplacementRoundImgView;
@property (strong, nonatomic) IBOutlet UIButton *preciserEmplacementYESButton;
- (IBAction)testDebugAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *menuButtonView;
@property (strong, nonatomic) IBOutlet UIView *barreBasView;
- (IBAction)stopAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *centrerButtonView;
- (IBAction)centrerAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UILabel *labelSuiviVoitureReserveur;
@property (strong, nonatomic) IBOutlet UILabel *labelSuiviTempsReserveur;
@property (strong, nonatomic) IBOutlet UILabel *labelSuiviDistanceReserveur;
@property (strong, nonatomic) IBOutlet UIButton *validerPretEchangerButton;
- (IBAction)validerPretEchangerAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *navigIndicationView;
@property (strong, nonatomic) IBOutlet UILabel *navigIndicationLabel1;
@property (strong, nonatomic) IBOutlet UILabel *navigIndicationLabelM;
@property (strong, nonatomic) IBOutlet UIImageView *navigIndicationImg;
@property (strong, nonatomic) IBOutlet UITextView *debugTextView;
@property (strong, nonatomic) IBOutlet UILabel *debugVoitureLabel;
- (IBAction)jeChercheAction:(id)sender;
- (IBAction)jeChercheActionFromNavig:(id)sender;
- (void) startItineraireToMarker:(GMSMarker*) theMarker;
@property (strong, nonatomic) IBOutlet UIButton *apiwayNavigButton;
- (IBAction)apiwayNavigAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
- (IBAction)refreshAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *navigBarButton;
- (IBAction)validerAbandon:(id)sender;
- (IBAction)exportAction:(id)sender;
- (void)setMode:(int)modee;
- (IBAction)eraseLogs:(id)sender;
-(IBAction)cancelAction:(id)sender;
-(void)showParkings;
- (IBAction)showParkingList:(id)sender;
-(void)navigateToParking:(Parking*)parking;
-(void)changeDestLoc:(NSString *)destLocation;
-(IBAction)ApilaNavigation:(id)sender;
-(IBAction)WazeNavigation:(id)sender;
-(IBAction)GoogleMapNavigation:(id)sender;
-(IBAction)AppleNavigation:(id)sender;
-(void)showApiway;
-(void)ZoomToApiway;
// delegate method automate
@property (strong, nonatomic) NSString * last_event;
-(void)showMessage:(NSString*)Message;
-(void)showPin:(NSString*)Pin;
@property (strong, nonatomic) IBOutlet UIView *homeView;

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
-(void)showPinCar:(NSString*)Pin;
- (IBAction)parkHere:(id)sender;
@end
