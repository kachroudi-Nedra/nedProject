//
//  NavigationMapViewController.m
//  Apila
//
//  Created by Nedra Kachroudi on 29/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "NavigationMapViewController.h"
#define arrondi(a) (floor((a) + 0.5))
@interface NavigationMapViewController ()

@end

@implementation NavigationMapViewController

- (void)mapPannedByTouch:(UIGestureRecognizer*)gestureRecognizer {
    
    //NSLog(@"map panned by touch!");
    mapMoved = YES;
}

- (void)mapPinchedByTouch:(UIGestureRecognizer*)gestureRecognizer {
    
    //NSLog(@"map pinched by touch!");
    //mapMoved = YES;
}
-(void)sendSteps:(NSMutableArray*)steps andPolyline:(GMSPolyline*)polylineAp{

    [map.mapView clear];
    etapes= [[NSMutableArray alloc]initWithArray:steps];
    polyline= polylineAp;
    polylineAp.strokeWidth = 6.f;
    polylineAp.strokeColor = [UIColor redColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        //polyline.map = map.mapView;
        //polylineAp.map=map.mapView;

    });
    if(startNavig == NO){

        [self zoomToPolyLine:path];
    }else{
        
      // polyline.map =nil;
    }

}
- (void)viewDidAppear:(BOOL)animated
{
    self.isVisible = 1;
    [self.back_view setHidden:NO];
    [self.go_view setHidden:NO];
    [self.cancelView setHidden:YES];
    markerUserLocation.icon = [UIImage imageNamed:@"user_buddy.png"];
    markerUserLocation.map = map.mapView;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentViewController" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self, @"lastViewController", nil]];

}

- (void)viewDidDisappear:(BOOL)animated
{
    self.isVisible = 0;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.isVisible = 1;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initWithdestLoc:(CLLocation*)destLocation {
    
    destinationLoc = destLocation;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    map = (GoogleMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"GoogleMapViewController"];
    [map.view setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
     map.mapView.indoorEnabled = YES;
     map.mapView.accessibilityElementsHidden = NO;
     map.mapView.settings.scrollGestures = YES;
     map.mapView.settings.zoomGestures = YES;
     map.mapView.settings.compassButton = YES;

    map.delegate=self;
    [NavView addSubview:map.mapView];
    [map navigateTo:destinationLoc];
    waypointsApiway = [[NSMutableArray alloc]init];
    waypointStringsApiway = [[NSMutableArray alloc]init];
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    if(appDelegate.detect == NULL){
        
        appDelegate.detect = [[DetectEvent alloc]init];
    }
    appDelegate.detect.locationManager.delegate =self ;
    /*locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
    if ([locationManager headingAvailable]) {
        locationManager.headingFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingHeading];
    }
    // on affiche l'icône user
    if(markerUserLocation == nil)
    {
        markerUserLocation = [[GMSMarker alloc] init];
        markerUserLocation.icon = [UIImage imageNamed:@"user_buddy.png"];
        markerUserLocation.map = map.mapView;
        markerUserLocation.snippet = @"MOI";
    }
     */
    etapeCount = 0;
    spoken = 0;
    spokenNextStep = 0;
    spokenSecond =0;
    spokenArrived=0;
    markerOrigin = [[GMSMarker alloc] init];
    userLocation = [[CLLocation alloc]init];
    if (FirstViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FirstViewController = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    }

   // FirstViewController->appDelegate.detect.delegate =self;
    appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    //appDelegate.detect.delegate =self;
    //UITapGestureRecognizer *mSwipeUpRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopHeading)];
    //[map.mapView setUserInteractionEnabled:YES];
    //[map.mapView setMultipleTouchEnabled:YES];
    //[map.mapView addGestureRecognizer:mSwipeUpRecognizer];
    //map.mapView.settings.consumesGesturesInView = YES;
    for (UIGestureRecognizer *gestureRecognizer in map.mapView.gestureRecognizers) {
        [gestureRecognizer addTarget:self action:@selector(handlePan:)];
    }
    //instructionLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    [self.back_view setHidden:NO];
    startNavig =NO;
    skMap = [[SKMapView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f,  CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) )];
    //set the map region
    
    [map.mapView addSubview:skMap];
    
    [SKRoutingService sharedInstance].routingDelegate = self; // set for receiving routing callbacks
    [SKRoutingService sharedInstance].navigationDelegate = self;// set for receiving navigation callbacks
    [SKRoutingService sharedInstance].mapView = skMap; // use the map view for route rendering
    

}
- (void)routingService:(SKRoutingService *)routingService didUpdateFilteredAudioAdvices:(NSArray *)audioAdvices{
    
     NSLog(@"audio advices: %@",audioAdvices);
}
- (void)routingService:(SKRoutingService *)routingService didChangeCurrentStreetName:(NSString *)currentStreetName streetType:(SKStreetType)streetType countryCode:(NSString *)countryCode{
    
    instructionLabel.text =currentStreetName;
    NSLog(@"street name: %@,%d,%@",currentStreetName,streetType,countryCode );
    // NSLog(@"routing service array: %@",routingService.visualAdviceConfigurations);
    
}
- (void)routingService:(SKRoutingService *)routingService didChangeCurrentAdviceImage:(UIImage *)adviceImage withLastAdvice:(BOOL)isLastAdvice{
    
    NSLog(@"image changed");
}
- (void)routingService:(SKRoutingService *)routingService didChangeCurrentAdviceInstruction:(NSString *)currentAdviceInstruction nextAdviceInstruction:(NSString *)nextAdviceInstruction{
    
    NSLog(@"current instruction: %@",currentAdviceInstruction);
}
- (void)routingService:(SKRoutingService *)routingService didChangeCurrentSpeed:(double)speed{
  
    NSLog(@"speed: %f",speed);
    
}
- (void)routingService:(SKRoutingService *)routingService didChangeDistanceToDestination:(int)distance withFormattedDistance:(NSString *)formattedDistance{
    
    NSLog(@"distance: %@",formattedDistance);
    self.apiway_distance_label.text= [NSString stringWithFormat:@"%@ m",formattedDistance];

}
- (void)routingServiceDidReachDestination:(SKRoutingService *)routingService{
    
    NSLog(@"destination reached");
}
- (void)routingService:(SKRoutingService *)routingService didFinishRouteCalculationWithInfo:(SKRouteInformation*)routeInformation{
    NSLog(@"Route is calculated.");
    [routingService zoomToRouteWithInsets:UIEdgeInsetsZero]; // zooming to currrent route
    //NSArray *adviceList = [routingService routeAdviceListWithDistanceFormat:SKDistanceFormatMetric]; // array of SKRouteAdvice
    NSLog(@"routing distance : %d",routeInformation.distance);
    NSLog(@"routing time : %d",routeInformation.estimatedTime);
    self.apiway_all_time_label.text = [NSString stringWithFormat:@"%d min", routeInformation.estimatedTime / 60];
    self.apiway_distance_label.text= [NSString stringWithFormat:@"%d m",routeInformation.distance];
    SKNavigationSettings* navSettings = [SKNavigationSettings navigationSettings];
    navSettings.navigationType=SKNavigationTypeReal;
    navSettings.distanceFormat=SKDistanceFormatMetric;
    [SKRoutingService sharedInstance].mapView.settings.displayMode = SKMapDisplayMode3D;
    [[SKRoutingService sharedInstance]startNavigationWithSettings:navSettings];
}
-(IBAction) handlePan:(UIPanGestureRecognizer*)sender {
    
    
  //  mapMoved=YES;
    
}
- (void) stopHeading
{
    [locationManager stopUpdatingHeading];
}
/********************************** HANDLE APIPARK NOTIFICATION **************************************************/

-(void)checkNearToApipark{
    
    int nb_park=0;
    NSMutableArray *parkingNear = [[NSMutableArray alloc]init];
    NSLog(@" -----------Check near parking start -----------");
    for(int i=0;i<appDelegate.parkingArray.count;i++){
        
        Parking *park=[appDelegate.parkingArray objectAtIndex:i];
        
        if([userLocation distanceFromLocation:park.position] <= 200){
             NSLog(@" -----------parking near detected -----------");
            //choosenParking = park;
            //[self showApiParkNotif:choosenParking];
            [parkingNear insertObject:park atIndex:nb_park];
            nb_park++;
        }
        [self choosePark:parkingNear];
        
    }

}
int compareDistance(const void *first, const void *second)
{
    return *(const int *)first - *(const int *)second;
}
- (void)sortArray:(int *)array ofSize:(size_t)sz
{
    qsort(array, sz, sizeof(*array), compareDistance);
}
-(void)choosePark:(NSArray*)parkings{
    
    if(parkings.count>0){
    sortedParkings = [parkings sortedArrayUsingComparator:^NSComparisonResult(Parking *a, Parking *b) {
        if ( a.distance < b.distance) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( a.distance > b.distance) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    choosenParking = [sortedParkings objectAtIndex:0];
    [self showApiParkNotif:choosenParking];
    }
}
-(void)showApiParkNotif:(Parking*)parkToShow{
    
    if(showNotifPark == NO){
        [self.apipark_notif_view setHidden:NO];
        NSLog(@"park name:%@",parkToShow.name);
        NSLog(@"park distance: %d",parkToShow.distance);
        CGRect frame = self.apipark_notif_view.frame;
        frame.origin.x = 320;
        self.apipark_notif_view.frame = frame;
        
        NSLog(@"--------------------------notif apipark ---------------");
        NSLog(@"x: %f,y: %f,w: %f,h: %f",self.apipark_notif_view.frame.origin.x,
              self.apipark_notif_view.frame.origin.y,
              self.apipark_notif_view.frame.size.width,
              self.apipark_notif_view.frame.size.height);
        if(self.apipark_notif_view.frame.origin.x  == +320)
        {
            [UIView animateWithDuration:0.4 animations:^{
                CGRect frame = self.apipark_notif_view.frame;
                frame.origin.x = frame.origin.x - frame.size.width;
                self.apipark_notif_view.frame = frame;
            } completion:nil];
        }
    [self.apipark_notif_label setText: [NSString stringWithFormat:@"%@",parkToShow.name]];
    self.apipark_notif_label_distance.text = [NSString stringWithFormat:@"%d m",[self roundUpDistance:(int)[userLocation distanceFromLocation:parkToShow.position]]];

        //[self.apipark_notif_label_distance setText: [NSString stringWithFormat:@"%d",(int)[userLocation distanceFromLocation:parkToShow.position]];
    
    [self performSelector:@selector(hideApiparkNotif) withObject:nil afterDelay:4.0];
    showNotifPark = YES;
    }
    

}
-(void)hideApiparkNotif{
    
    [self.apipark_notif_view setHidden:YES];
    [UIView animateWithDuration:0.4
                     animations:^{
                         CGRect frame = self.apipark_notif_view.frame;
                         frame.origin.x = frame.origin.x+frame.size.width;
                         self.apipark_notif_view.frame = frame;
                     } completion:nil];
    [self.apipark_notif_fermee setHidden:NO];
    self.apipark_notiffermee_label_distance.text = [NSString stringWithFormat:@"%d m",[self roundUpDistance:(int)[userLocation distanceFromLocation:choosenParking.position]]];


}
-(IBAction)goToParking:(id)sender{
    
    [self navigatetoAddress:choosenParking.address];
}
-(IBAction)goToParkingNotifFermee:(id)sender{
    
    [self navigatetoAddress:choosenParking.address];
}
/********************************** FIN **************************************************/


/********************************** NAVIGATION APIWAY **************************************************/

// Naviguer sans destination

-(void)NavigationApiwayWithoutDest{
    
    
        serverResponse =[[ServerResponseViewController alloc]init];
        serverResponse.delegate = self;
        [serverResponse getResponse:userLocation andResponseOption: PARKNOW andHeading:currenHeading];
        parknow = YES;
  }

//Naviguer avec destination

-(void)NavigationApiwayWithDest{
    
    
        serverResponse =[[ServerResponseViewController alloc]init];
        serverResponse.delegate = self;
        [serverResponse getResponse:userLocation andDestination:destinationLoc andResponseOption: PARKNOW andHeading:currenHeading];
        parknowDestination = YES;
}

//Recalculer le apiway
-(void)RecalculApiway{
    
    recalcul = YES;
    startNavig = YES;
    [map.mapView clear];
    etapes = nil;
    etapeCount =0;
    if(parknowDestination == YES){
        [self NavigationApiwayWithDest];
    }
    if (parknow == YES) {
        [self NavigationApiwayWithoutDest];
    }
    
}
//Demander plus de points apiway
-(void)AddPointsApiway{
    
    
}
//Start navigation apiway
-(void)startNavig{

if( startNavig == YES){
    
    NSLog(@"etapes count 0: %d",allEtapes.count);
    
  
    if(etapes.count > 0)
    {
        [self NavigateToLeg:etapes];
        
    }
}

}
-(void)parkNow {
    
    [appDelegate showPleaseWait];
    [self performSelector:@selector(HideAlert) withObject:nil afterDelay:3.0];
    [locationManager startUpdatingLocation];
    //parknow =YES;
    [self performSelector:@selector(NavigationApiwayWithoutDest) withObject:nil afterDelay:3.0];

    //[self NavigationApiwayWithoutDest];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)parkNowToDestination:(CLLocation*)destination {
    
   [appDelegate showPleaseWait];
    
    [self performSelector:@selector(HideAlert) withObject:nil afterDelay:3.0];

    destinationLoc = destination;
    [locationManager startUpdatingLocation];
   // parknowDestination =YES;
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self performSelector:@selector(NavigationApiwayWithDest) withObject:nil afterDelay:3.0];
}
-(IBAction)navigateApiway:(id)sender{
    
    SKRouteSettings* route = [[SKRouteSettings alloc]init];
    route.startCoordinate=CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    //route.destinationCoordinate=CLLocationCoordinate2DMake(48.825583,2.3836126);
    route.destinationCoordinate=CLLocationCoordinate2DMake(48.8215965,2.3715504);
    
    [[SKRoutingService sharedInstance] calculateRoute:route];
    [self.instructionView setHidden:NO];
    [self.back_view setHidden:YES];
    [self.go_view setHidden:YES];
    [self.cancelView setHidden:NO];
    /*startNavig = YES;
    originLoc = userLocation;
   
    if(etapes.count > 0)
    {
        [self NavigateToLeg:etapes];
        
    }
    [self.instructionView setHidden:NO];
    [self.back_view setHidden:YES];
   
    //markerUserLocation.icon = [UIImage imageNamed:@"fleche_navig_small2.png"];
    //markerUserLocation.map = map.mapView;
    [map.mapView animateToZoom:17];
    [self.go_view setHidden:YES];
    [self.cancelView setHidden:NO];
*/
   
}
-(NSMutableArray*)getNewApiway:(int)indexApiway{
    
    NSMutableArray *newArray =[[NSMutableArray alloc]init];
    
    for(int i=indexApiway;i<savedApiwayArray.count;i++){
        
        [newArray insertObject:[savedApiwayArray objectAtIndex:i] atIndex:i];
    }
    
    return newArray;
    
}
-(void)sendApiwayResults:(NSMutableArray*)apiwayArray andDistance:(NSString*)time{
    /*if(map == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        map = (GoogleMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"GoogleMapViewController"];
        
    }
    if(recalcul == YES){
        map.recalcul = YES;
        
    }
    [map showFakeMarkers:apiwayArray andMap:map.mapView];
    
    map.delegate=self;
    //self->apiwayDistance =distance;
     */
    int minutes = [time intValue] / 60;
    self.apiway_time_label.text = [NSString stringWithFormat:@"%d min",minutes];
    self.apiway_all_time_label.text = [NSString stringWithFormat:@"%d min",minutes];
}
-(void)sendParkingResults:(NSMutableArray*)parkingArray andApiway:(NSMutableArray*)routesApiway{
    
    NSLog(@"this is called");

    // j'affiche le polyline sur la carte et j'affiche la view en bas : l'heure et temps et confiance et le bouton GO
    if(map == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        map = (GoogleMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"GoogleMapViewController"];
        
    }
    map.delegate=self;
    /*if (recalcul == YES) {
        [map showFakeMarkers:routesApiway andMap:map.mapView andRecalcul:YES];

    }else{
        [map showFakeMarkers:routesApiway andMap:map.mapView];

    }*/
    
    savedParkingsArray = parkingArray;
    savedApiwayArray = routesApiway;
    [self NavigationQuery:savedApiwayArray];
    NSLog(@"this is called");
    /*if (homeRecommanded == nil)
     {
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     homeRecommanded = (HomeRecommandedViewCtrl*)[storyboard instantiateViewControllerWithIdentifier:@"HomeRecommandedViewCtrl"];
     
     CLLocation *userLoc = [[CLLocation alloc]initWithLatitude:markerUserLocation.position.latitude longitude:markerUserLocation.position.longitude];
     //[homeRecommanded initWithParkings:parkingArray userLocation:userLocation ];
     homeRecommanded.view.backgroundColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.0 alpha:0.0];
     
     homeRecommanded.parentController =self;
     // [menuView.closeMenuButton addTarget:self action:@selector(closeMenuAction:) forControlEvents:UIControlEventTouchUpInside];
     //[menuView.myTableView setDelegate:self];
     //[menuView.myTableView setDataSource:self];
     
     CGRect frame = homeRecommanded.view.frame;
     frame.origin.y = frame.origin.y + frame.size.height;
     homeRecommanded.view.frame = frame;
     
     [self.view addSubview:homeRecommanded.view];
     //[menuView.myTableView reloadData];
     }
     if(homeRecommanded.view.frame.origin.y == +568)
     {
     [UIView animateWithDuration:0.4 animations:^{
     CGRect frame = homeRecommanded.view.frame;
     frame.origin.y = frame.origin.y - frame.size.height;
     homeRecommanded.view.frame = frame;
     } completion:nil];
     }
     */
    
    /* if(homeRecommanded->isVisible){
     
     }*/
    // else
    //[ self showHomeList:parkingArray];
    
    //[map showFakeMarkers:apiwayArray];
}

/********************************** FIN **************************************************/

/************************************************* NAVIGATION ***************************************************/
-(void)NavigationDeMerdre:(CLLocation*)destLoc{
    
    
    alertePleaseWaitViewController.view.alpha = 0.0;
    //userLocation = [[CLLocation alloc]initWithLatitude:48.825583 longitude:2.3836126];
    destinationLoc = destLoc;
    //[self NavigationQuery:myLocation andDestLoc:destLoc andMode:@"driving"];
    if (alerteNavigationViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        alerteNavigationViewController = (AlerteNavigationViewController*)[storyboard instantiateViewControllerWithIdentifier:@"AlerteNavigationViewController"];
        alerteNavigationViewController.view.alpha = 0.0;
    }
    alerteNavigationViewController.textToShow.text =@"Vous Souhaitez Naviguer à : ";
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view addSubview:alerteNavigationViewController.view];
                         alerteNavigationViewController.view.alpha = 1.0;
                     } completion:nil];
    [self speakPlease:@"Choisissez votre mode de navigation"];
    [alerteNavigationViewController.YESButton addTarget:self action:@selector(walkingNavig:) forControlEvents:UIControlEventTouchUpInside];
    [alerteNavigationViewController.NOButton addTarget:self action:@selector(drivingNavig:) forControlEvents:UIControlEventTouchUpInside];
    

}
-(IBAction)walkingNavig:(id)sender{
    
    [InformationView setHidden:NO];
    alerteNavigationViewController.view.alpha = 0.0;
    alerteNavigationViewController = nil;
    NavigMode = @"walking";
    //[self NavigationQuery:destinationLoc andMode:@"walking"];
    etapes= [[NSMutableArray alloc]init];
    // on affiche l'alerte
    if (alertePleaseWaitViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        alertePleaseWaitViewController = (AlertePleaseWaitViewController*)[storyboard instantiateViewControllerWithIdentifier:@"AlertePleaseWaitViewController"];
        alertePleaseWaitViewController.view.alpha = 0.0;
    }
    
    [UIView animateWithDuration:0.8
                     animations:^{
                         [self.view addSubview:alertePleaseWaitViewController.view];
                         alertePleaseWaitViewController.view.alpha = 1.0;
                     } completion:nil];
    
    

}
-(IBAction)drivingNavig:(id)sender{
    
    [InformationView setHidden:NO];
    alerteNavigationViewController.view.alpha = 0.0;
    alerteNavigationViewController = nil;
    NavigMode = @"driving";
    //[self NavigationQuery:destinationLoc andMode:@"driving"];
    etapes= [[NSMutableArray alloc]init];
    // on affiche l'alerte
    /*if (alertePleaseWaitViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        alertePleaseWaitViewController = (AlertePleaseWaitViewController*)[storyboard instantiateViewControllerWithIdentifier:@"AlertePleaseWaitViewController"];
        alertePleaseWaitViewController.view.alpha = 0.0;
    }
    
    [UIView animateWithDuration:0.6
                     animations:^{
                         [self.view addSubview:alertePleaseWaitViewController.view];
                         alertePleaseWaitViewController.view.alpha = 1.0;
                     } completion:nil];
    */
    originLoc = userLocation;
    NSLog(@"origin loc: %@",originLoc);

}
-(void)NavigationQuery:(NSMutableArray*)apiwayPointsArray {
   
    NSLog(@"show fake Markers please!");
    GMSMarker *marker=[[GMSMarker alloc]init];
    CLLocationManager *locationm = [LocationTracker sharedLocationManager];
    marker.position=CLLocationCoordinate2DMake(locationm.location.coordinate.latitude,locationm.location.coordinate.longitude);
    // marker.icon=[UIImage imageNamed:@"aaa.png"] ;
    marker.groundAnchor=CGPointMake(0.5,0.5);
    GMSMarker  *markerUserLocation = [[GMSMarker alloc] init];
    markerUserLocation.position = marker.position;
    //markerUserLocation.map=GMSmap;
    //[GMSmap clear];
    /********************** APIWAY ARRAY ******************************/
    NSMutableArray *apiwayLocations= [[NSMutableArray alloc]init];
    apiwayPoints= [[NSMutableArray alloc]init];
    colorArray = [[NSMutableArray alloc]init]; //]initWithObjects:[UIColor orangeColor],[UIColor blueColor],[UIColor redColor],[UIColor greenColor],[UIColor brownColor],[UIColor yellowColor],[UIColor blackColor], nil];
    
    for(int i=0;i<apiwayPointsArray.count;i++){
        
        NSLog(@"APIWAY: %@",[apiwayPointsArray objectAtIndex:i]);
        CLLocation  *posLocation = [[CLLocation alloc] initWithLatitude:[[apiwayPointsArray objectAtIndex:i][0]doubleValue] longitude:[[apiwayPointsArray objectAtIndex:i][1]doubleValue]];
        NSString* color =[apiwayPointsArray objectAtIndex:i][2];
        GMSMarker  *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(posLocation.coordinate.latitude,posLocation.coordinate.longitude);
        //marker.icon = [GMSMarker markerImageWithColor:[colorArray objectAtIndex:i]];
        marker.title = [NSString stringWithFormat:@"Point %d",i];
        marker.snippet = [NSString stringWithFormat:@"%f,%f", marker.position.latitude,marker.position.longitude];;
        // marker.map =mapToShow;
        //[apiwayPoints insertObject:marker atIndex:i];
        [apiwayLocations insertObject:posLocation atIndex:i];
        [colorArray insertObject:color atIndex:i];
        
    }
    NSLog(@"color array: %d",colorArray.count);
    [self getRouteFromGoogleApiWithPoints:apiwayLocations andMode:@"driving" error:nil];
    

    
    /*etapeCount =0;
    spoken=0;
    spokenNextStep=0;
    spokenSecond =0;
    spokenArrived=0;
    destinationLoc = [[CLLocation alloc] initWithCoordinate: destLoc.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
    markerDestination = [[GMSMarker alloc] init];
    markerDestination.position = CLLocationCoordinate2DMake(destLoc.coordinate.latitude,destLoc.coordinate.longitude);
    markerDestination.icon = [UIImage imageNamed:@"pinArriver.png"];
    [map.mapView clear];
    markerDestination.map = map.mapView;
    markerOrigin.position=CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    //markerOrigin.map=map.mapView;
    [waypoints_ removeAllObjects];
    [waypointStrings_ removeAllObjects];
    
    [waypoints_ addObject:markerOrigin];
    NSString * positionString = [NSString stringWithFormat:@"%f,%f",markerOrigin.position.latitude,markerOrigin.position.longitude];  //
    [waypointStrings_ addObject:positionString];
    [waypoints_ addObject:markerDestination];
    NSString * positionString2 = [NSString stringWithFormat:@"%f,%f",markerDestination.position.latitude,markerDestination.position.longitude];
    [waypointStrings_ addObject:positionString2];
    NSString *sensor = @"true";
    NSString *modeN = NavigM;
    NSString *Alternative = @"true";
    NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,modeN,Alternative, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints",@"mode",@"alternatives", nil];
    NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters forKeys:keys];
    mds=[[MDDirectionService alloc] init];
    SEL selector = @selector(addDirections:);
    [mds setDirectionsQuery:query withSelector:selector withDelegate:self];
     */
}

-(NSDictionary*)getRouteFromGoogleApiWithPoints:(NSArray*)arrayOfPoints andMode:(NSString*)mode error:(NSError **)error
{
    NSDictionary *result = nil;
    CLLocation* origin ;
    CLLocation* destination;
    
    NSString *waypoints = @"";
    if(arrayOfPoints.count>0){
        if(arrayOfPoints.count>=8){
             origin = [arrayOfPoints objectAtIndex:0];
             destination = [arrayOfPoints objectAtIndex:7];
            
            // Create the waypoints
            for(int i = 1; i < 8; i++)
            {
                CLLocation* current = [arrayOfPoints objectAtIndex:i];
                
                waypoints = [waypoints stringByAppendingString:[NSString stringWithFormat:@"%0.9f,%0.9f%%7C",current.coordinate.latitude,current.coordinate.longitude]];
            }
 
        }
        else{
        origin = [arrayOfPoints objectAtIndex:0];
        destination = [arrayOfPoints objectAtIndex:arrayOfPoints.count - 1];
        
        // Create the waypoints
        for(int i = 1; i < arrayOfPoints.count - 2; i++)
        {
            CLLocation* current = [arrayOfPoints objectAtIndex:i];
            
            waypoints = [waypoints stringByAppendingString:[NSString stringWithFormat:@"%0.9f,%0.9f%%7C",current.coordinate.latitude,current.coordinate.longitude]];
        }
    }
        CLLocation* lastWaypoint = [arrayOfPoints objectAtIndex:arrayOfPoints.count - 2];
        waypoints = [waypoints stringByAppendingString:[NSString stringWithFormat:@"%0.9f,%0.9f",lastWaypoint.coordinate.latitude,lastWaypoint.coordinate.longitude]];
        
        NSString *urlString =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%0.9f,%0.9f&destination=%0.9f,%0.9f&waypoints=%@&sensor=true&mode=%@",origin.coordinate.latitude,origin.coordinate.longitude,destination.coordinate.latitude,destination.coordinate.longitude,waypoints,mode];
        NSLog(@"url string: %@",urlString);
        //waypoints	__NSCFString *	@"48.827000,2.386050%7C48.825100,2.388820%7C48.827500,2.385580%7C48.826100,2.387450%7C48.820700,2.377860"	0x15d2fe50
        [self getResponse:urlString];
        NSDictionary* response;
        if (response != nil)
        {
            if ([[response objectForKey:@"status"] isEqualToString:@"OK"])
            {
                result = response;
                NSLog(@"%@",response);
                
            }
            else
            {
                if (error)
                {
                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:[response objectForKey:@"status"] forKey:NSLocalizedDescriptionKey];
                    *error = [[NSError alloc] initWithDomain:@"AppName" code:2 userInfo:details];
                }
            }
        }
        else
        {
            if(error)
            {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:NSLocalizedString(@"ErrorServidor", nil) forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"AppName" code:1 userInfo:details];
                return nil;
            }
        }
    }
    else{
        
        NSLog(@"Apiway Array is empty");
    }
    return result;
}
-(void)declencherTimer{
    
    timer= [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(calculerTimer) userInfo:nil repeats:YES];

}
-(void)calculerTimer{
    
    nb_time++;
}
-(void)getResponse:(NSString*)url{
    
    //NSString *post2 = [NSString stringWithFormat:@"address=%@&sensor=true",[[destinationLocation stringByReplacingOccurrencesOfString:@" " withString:@"+"] urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"REQUEST ADRESSE : %@",post2);
    NSMutableURLRequest * request2 = [[NSMutableURLRequest alloc] init];
    [request2 setURL:[NSURL URLWithString:url]];
    [request2 setHTTPMethod:@"GET"];
    connectionApiway = [[NSURLConnection alloc] initWithRequest:request2 delegate:self];
    
    [connectionApiway start];

    /*[self declencherTimer];
    NSLog(@"time: %d",nb_time);
    if (nb_time == 0) {
        
        connectionApiway = [[NSURLConnection alloc] initWithRequest:request2 delegate:self];
        
        [connectionApiway start];
    }
    if (nb_time > 0 && nb_time <= 10) {
        
        NSLog(@"Total time was: %d seconds", nb_time);
        [appDelegate hidePleaseWait];
        
    }else{
        
         NSLog(@"Total time was: %d seconds", nb_time);
        connectionApiway = [[NSURLConnection alloc] initWithRequest:request2 delegate:self];
        
        [connectionApiway start];
        nb_time=0;
    }
    */
   /* if(timeInMilisecondsNow - timeInMilisecondsLast <= 10){
    
        //je fais rien
    }else{
*/
    

   // }
    
}
/******** FIN APIWAY ***/
- (void)addDirections:(NSDictionary *)json
{
    [appDelegate hidePleaseWait];
    NSLog(@"ADD POLYLINE");
    if([[json objectForKey:@"routes"] count] > 0)
    {
        polyline.map = nil;
        polyline = nil;
        
        NSDictionary *routes = [json objectForKey:@"routes"][0];
        // on récupère les indications avec leurs coordonnées :
        NSArray * legs = [routes objectForKey:@"legs"];
        NSLog(@"leg count: %d",legs.count);
        allEtapes =[[NSMutableArray alloc]init];
        allPaths =[[NSMutableArray alloc]init];
        for(int i=0;i<legs.count;i++){
            
            NSArray *smallEtape =[[legs objectAtIndex:i] objectForKey:@"steps"];
            NSLog(@"small etapes count: %d",smallEtape.count);
            //[etapes arrayByAddingObjectsFromArray:smallEtape];
            [allEtapes insertObject:smallEtape atIndex:i];
        }
      
        NSLog(@"all etapes after add objects: %d",allEtapes.count);
        etapes =[[NSMutableArray alloc]init];
        etapeCount=0;
        CGFloat hue = 135;// ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = 171;//( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = 21;//( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        //UIColor *colorCustom = [UIColor colorWithRed:(160/255.0) green:(97/255.0) blue:(5/255.0) alpha:1.0];
         //[UIColor colorWithRed:hue/255.0f green:saturation/255.0f blue:brightness/255.0f alpha:1.0];// colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        UIColor *color;
        int idx=0;
        // je prends 8 couleurs du tableau apiway colors
        if(colorArray.count >=8){
        for(int i=0;i<8;i++){
             
             int colorCode = [[colorArray objectAtIndex:i]intValue];
             switch (colorCode) {
                 case 0:
                    // color = colorCustom;
                     break;
                 case 1:
                     //color = [UIColor greenColor];
                      color = [UIColor colorWithRed:(135/255.0) green:(171/255.0) blue:(21/255.0) alpha:1.0];
                     break;
                 case 2:
                     color = [UIColor colorWithRed:(234/255.0) green:(167/255.0) blue:(38/255.0) alpha:1.0];
                     break;
                 case 3:
                     color = [UIColor colorWithRed:(199/255.0) green:(66/255.0) blue:(74/255.0) alpha:1.0];
                     break;
                 default:
                     break;
             }
         }
        }
        GMSPath *smallPath = [[GMSPath alloc]init];
        GMSPolyline *smallPolyline = [[GMSPolyline alloc]init];
        for(int i=0;i<allEtapes.count;i++){
            
            etapeGlobale = [allEtapes objectAtIndex:i];
            for(int j=0;j<etapeGlobale.count;j++){
                
                [etapes insertObject:[etapeGlobale objectAtIndex:j] atIndex:idx];
                NSDictionary *actualEtape = [etapeGlobale objectAtIndex:j];
                 NSLog(@"etape globale n° %d et etape petite n° %d : son polyline est :%@",i,j,[[actualEtape objectForKey:@"polyline"]objectForKey:@"points"]);
                smallPath= [GMSPath pathFromEncodedPath:[[actualEtape objectForKey:@"polyline"]objectForKey:@"points"]];
                smallPolyline = [GMSPolyline polylineWithPath:smallPath];
                smallPolyline.strokeWidth = 7.0f;
                smallPolyline.strokeColor = color;
                if(smallPath.count >1)
                smallPolyline.map=map.mapView;
                idx++;
            }
        }
       
        for(int k=0;k<etapes.count;k++){
            
            [allPaths insertObject:[[[etapes objectAtIndex:k]objectForKey:@"polyline"]objectForKey:@"points"] atIndex:k];
        }
         NSLog(@"path count:%d",allPaths.count);
        if(allPaths.count>2){
       /* for(int k=0;k<allPaths.count;k++){
            CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
            CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
            CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
            UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            smallPath= [GMSPath pathFromEncodedPath:[allPaths objectAtIndex:k]];
            smallPolyline = [GMSPolyline polylineWithPath:smallPath];
            smallPolyline.strokeWidth = 10.f;
            smallPolyline.strokeColor = color;
            smallPolyline.map=map.mapView;
        }*/
        }
        for(int i=0;i<colorArray.count;i++){
            
            
        }
      
        NSLog(@"LEGS : %@",[[legs objectAtIndex:0] objectForKey:@"duration"]);
        NSDictionary *route = [routes objectForKey:@"overview_polyline"];
        NSDictionary *legsApiway = [routes objectForKey:@"legs"][0];
        NSDictionary *distance = [legsApiway objectForKey:@"distance"];
        NSString* duree =[distance objectForKey:@"value"];;
        NSString* dist =[distance objectForKey:@"text"];
        //_ApiwayLab.text =[NSString stringWithFormat:@"Apiway dans %lld minutes à %d m",[duree longLongValue]/60,(int)[dist doubleValue]*1000 ];
        NSString *overview_route = [route objectForKey:@"points"];
        path = [GMSPath pathFromEncodedPath:overview_route];
        if(path.count > 1){
        NSLog(@"Route: %@",overview_route);
        NSLog(@"GMS PATH : %@",path);
        for(int i=0;i<path.count;i++)
        {
            NSLog(@"path %d is %f",i,[path coordinateAtIndex:i]);
            
        }
        
        polyline = [GMSPolyline polylineWithPath:path];
        [self zoomToPolyLine:path];
       
           // [self.GoView setHidden:YES];
            /* polyline = [GMSPolyline polylineWithPath:path];
            polyline.strokeWidth = 5.f;
            polyline.strokeColor = [UIColor greenColor];
           
            //polyline.map = nil;
           polyline.map = map.mapView;
           */
        //self  sendSteps:etapes andPolyline:polyline];
         dispatch_async(dispatch_get_main_queue(), ^{
                //polyline.map = map.mapView;
                //[self zoomToPolyLine:path];
                //[self  sendSteps:etapes andPolyline:polyline];
                
            });
        
        }else{
            //if (![appDelegate.ETAT isEqual:@"ROULE"]) {
                [appDelegate showNotif:@"Pas d'itinéraire possible, rejoignez la route svp" duringSec:3];
                [self cancelAction:nil];
            
            //}
            /*if ([appDelegate.ETAT isEqual:@"ROULE"]) {
                
                [self RecalculApiway];
            }*/
            
        }
       
    }
        // self.tempsLabel.text = [NSString stringWithFormat:@"TEMPS : %@",[[[legs objectAtIndex:0] objectForKey:@"duration"] objectForKey:@"text"]];
        // self.distanceLabel.text = [NSString stringWithFormat:@"DISTANCE : %@",[[[legs objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"text"]];
        
        /*for (int i = 0; i<[etapes count]; i++)
         {
         NSLog(@"Steps : %@",[[etapes objectAtIndex:i] objectForKey:@"html_instructions"]);
         }*/

    /*NSMutableArray* HeadingValues = [[NSMutableArray alloc]init];
    NSMutableArray* RoadsArray = [[NSMutableArray alloc]init];

    NSLog(@"ADD POLYLINE %@",json );
    if([[json objectForKey:@"routes"] count] > 0)
    {
        polyline.map = nil;
        polyline = nil;
        int i;
        NSMutableArray *routes = [json objectForKey:@"routes"];
        for(i=0; i<routes.count;i++){
            
            Road *currentRoad = [[Road alloc]init];
            currentRoad.overviewPolyline = [[routes objectAtIndex:i] objectForKey:@"overview_polyline"];
            currentRoad.legs = [[routes objectAtIndex:i] objectForKey:@"legs"];
            currentRoad.steps = [[currentRoad.legs objectAtIndex:0] objectForKey:@"steps"];
           CLLocation* LegstartLoc= [[ CLLocation alloc]initWithLatitude:[[[ [currentRoad.steps objectAtIndex:0]  objectForKey:@"start_location"] objectForKey:@"lat"] floatValue] longitude:[[[ [currentRoad.steps objectAtIndex:0] objectForKey:@"start_location"] objectForKey:@"lng"] floatValue]];
           CLLocation* LegsendLoc= [[ CLLocation alloc]initWithLatitude:[[[ [currentRoad.steps objectAtIndex:0]  objectForKey:@"end_location"] objectForKey:@"lat"] floatValue] longitude:[[[ [currentRoad.steps objectAtIndex:0] objectForKey:@"end_location"] objectForKey:@"lng"] floatValue]];
           
            NSLog(@"First loc: %@ second loc : %@",LegstartLoc,LegsendLoc);
            currentRoad.startLoc= [[ CLLocation alloc]initWithLatitude:[[[[routes objectAtIndex:i]  objectForKey:@"start_location"] objectForKey:@"lat"] floatValue] longitude:[[[[routes objectAtIndex:i]  objectForKey:@"start_location"] objectForKey:@"lng"] floatValue]];
           [HeadingValues insertObject:[NSNumber numberWithFloat:[self getHeadingForDirectionFromCoordinate:LegstartLoc.coordinate toCoordinate:LegsendLoc.coordinate]] atIndex:i];
            [RoadsArray insertObject:currentRoad atIndex:i];
        
        }
       // NSLog(@"Heading : %f",[self getHeadingForDirectionFromCoordinate:userLocation.coordinate toCoordinate:currentRoad.startLoc.coordinate]);
        //float heading = [self getHeadingForDirectionFromCoordinate:userLocation.coordinate toCoordinate:currentRoad.startLoc.coordinate];
        //[HeadingValues insertObject:[NSNumber numberWithFloat:heading] atIndex:i];
     
        if(RoadsArray.count> 1){
            xmin =[[HeadingValues objectAtIndex:0]floatValue];
            
            for(int j=0; j<HeadingValues.count;j++){
                NSLog(@"Heading value at %d is  : %@",j,[HeadingValues objectAtIndex:j]);
            }
            for(int j=0; j<HeadingValues.count-1;j++){
                
                if ([[HeadingValues objectAtIndex:j]floatValue] <= xmin) {
                    
                    xmin =[[HeadingValues objectAtIndex:j]floatValue];
                    index = j;
                }
            }
            NSLog(@"minimum value is %f for index: %d",xmin,index);
            choosenRoad =[RoadsArray objectAtIndex:index];
        }
       if(RoadsArray.count == 1){
           choosenRoad =[RoadsArray objectAtIndex:0];
       }
        etapeCount=0;
        etapes = choosenRoad.steps;
        DistanceGlobalLabel.text =  [NSString stringWithFormat:@"DISTANCE: %@",[[[choosenRoad.legs objectAtIndex:0] objectForKey:@"distance"]objectForKey:@"text"]];
        TempsGlobalLabel.text =  [NSString stringWithFormat:@"TEMPS: %@",[[[choosenRoad.legs objectAtIndex:0] objectForKey:@"duration"]objectForKey:@"text"]];
        GMSPath *path = [GMSPath pathFromEncodedPath:[choosenRoad.overviewPolyline objectForKey:@"points"]];
        polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeWidth = 10.f;
        polyline.strokeColor = [UIColor blueColor];
        polyline.map = map.mapView;
     

        /******** ON DOIT FAIRE ÇA *******/
        //[self NavigateToLeg:etapes andOriginLoc:originLoc];
        //poken = 0;
        //spokenNextStep = 0;
        //[self NavigateToLeg:etapes];
        /******************************** FIN ************************************/
        //testLoc = [[CLLocation alloc]initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];

        //[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];

        /***** A ENLEVER APRES VERIFICATION *******/
        
        /*instructionLabel.text = [[self stringByStrippingHTML:[[[[etapes objectAtIndex:0] objectForKey:@"html_instructions"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""]] stringByReplacingOccurrencesOfString:@"Traverser le rond-point" withString:@""];
        [map.mapView animateToLocation:markerOrigin.position];
        [map.mapView animateToViewingAngle:50];
        [map.mapView animateToZoom:17.5];
        [self speakPlease:instructionLabel.text];
        
    
        
    }
    */
}
-(void)zoomToPolyLine:(GMSPath*)path
{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [map.mapView moveCamera:update];
    
}
-(void)zoomToPolyLineNavig:(GMSPath*)path
{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [map.mapView moveCamera:update];
    
}
-(void)updateLocation{
    
    [self NavigateToLeg:etapes];
    
}
/******************************** GET LEG OBJECT FROM STEPS ************************************/

-(Leg *)getLegFromSteps:(NSMutableArray *)Steps forIndex:(int)index {
    
    Leg *LocalLeg = [[Leg alloc]init];
    
    LocalLeg.startLoc= [[ CLLocation alloc]initWithLatitude:[[[[Steps objectAtIndex:index] objectForKey:@"start_location"] objectForKey:@"lat"] floatValue] longitude:[[[[Steps objectAtIndex:index] objectForKey:@"start_location"] objectForKey:@"lng"] floatValue]];
    
    LocalLeg.endLoc= [[ CLLocation alloc]initWithLatitude:[[[[Steps objectAtIndex:index] objectForKey:@"end_location"] objectForKey:@"lat"] floatValue] longitude:[[[[Steps objectAtIndex:index] objectForKey:@"end_location"] objectForKey:@"lng"] floatValue]];
    
    LocalLeg.htmlInstruction = [[self stringByStrippingHTML:[[[[Steps objectAtIndex:index] objectForKey:@"html_instructions"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""]] stringByReplacingOccurrencesOfString:@"Traverser le rond-point" withString:@""];
    
    LocalLeg.distance = [[[[Steps objectAtIndex:index] objectForKey:@"distance"] objectForKey:@"value"] doubleValue];
    LocalLeg.duration = [[[[Steps objectAtIndex:index] objectForKey:@"duration"] objectForKey:@"value"] doubleValue];
    LocalLeg.indication =[[Steps objectAtIndex:index] objectForKey:@"maneuver"];
    NSDictionary *legRoute = [[Steps objectAtIndex:index]  objectForKey:@"polyline"];
    NSString *overview_route = [legRoute objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    LocalLeg.polyline = [GMSPolyline polylineWithPath:path];

    return LocalLeg;
}
// formatter string
-(NSString*)formatGoogleInstruction:(NSString*)instruction{
    
    NSString *sub;
    NSString *str = instruction;//[self getLegFromSteps:Steps forIndex:etapeCount].htmlInstruction;
    NSString *search1 = @"Prendre la direction nord-ouest sur";
    NSString *search2 = @"Prendre la direction sud-ouest sur";
    NSString *search3 = @"Prendre la direction nord-est sur";
    NSString *search4 = @"Prendre la direction sud-est sur";
    NSString *search5 = @"Prendre la direction sud sur";
    NSString *search6 = @"Prendre la direction nord sur";
    NSString *search7 = @"Prendre la direction ouest sur";
    NSString *search8 = @"Prendre la direction est sur";
    if ([str rangeOfString:search1].location != NSNotFound){
        sub = [str substringFromIndex:NSMaxRange([str rangeOfString:search1])];
        
    }
    if ([str rangeOfString:search2].location != NSNotFound){
        sub = [str substringFromIndex:NSMaxRange([str rangeOfString:search2])];
        
    }
    if ([str rangeOfString:search3].location != NSNotFound){
        sub = [str substringFromIndex:NSMaxRange([str rangeOfString:search3])];
        
    }
    if ([str rangeOfString:search4].location != NSNotFound){
        sub = [str substringFromIndex:NSMaxRange([str rangeOfString:search4])];
        
    }
    if ([str rangeOfString:search5].location != NSNotFound){
        sub = [str substringFromIndex:NSMaxRange([str rangeOfString:search5])];
        
    }
    if ([str rangeOfString:search6].location != NSNotFound){
        sub = [str substringFromIndex:NSMaxRange([str rangeOfString:search6])];
        
    }
    if ([str rangeOfString:search7].location != NSNotFound){
        sub = [str substringFromIndex:NSMaxRange([str rangeOfString:search7])];
        
    }
    if ([str rangeOfString:search8].location != NSNotFound){
        sub = [str substringFromIndex:NSMaxRange([str rangeOfString:search8])];
        
    }
    return sub;

}
/******************************** NAVIGATE TO LEG ************************************/
-(void)NavigateToAllEtapes:(NSMutableArray *)AllEtapes {
    
    NSLog(@"LE TABLEAU GLOABEL CONTIENT: = %d",AllEtapes.count);
    NSLog(@"LE NUMERO DE L'ETAPE GLOBALE = %d",allEtapeCount);
    /********* je prends le 1er tableau leg *****/
    /*if(allEtapeCount < allEtapes.count){
     
        etapeGlobale = [allEtapes objectAtIndex:allEtapeCount];
        [self NavigateToLeg:etapeGlobale];
    }*/
    etapes =[[NSMutableArray alloc]init];
    int idx=0;
    for(int i=0;i<allEtapes.count;i++){
        
        etapeGlobale = [allEtapes objectAtIndex:i];
        for(int j=0;j<etapeGlobale.count;j++){
            
            [etapes insertObject:[etapeGlobale objectAtIndex:j] atIndex:idx];
            idx++;
        }
    }
    NSLog(@"etapes count------ :%d",etapes.count);
    [self NavigateToLeg:etapes];
}
-(void)NavigateToLeg:(NSMutableArray *)Steps {
    
    /**** nouveau CODE******/
    timeInMilisecondsLast = timeInMilisecondsNow;

    Leg *nextLeg;
    NSLog(@"ETAPES COUNT = %d",etapes.count);
    NSLog(@"ETAPES NUMERO = %d",etapeCount);
    
    
    if(etapeCount < etapes.count){
        leg = [self getLegFromSteps:etapes forIndex:etapeCount];
        distanceLabel.text = [NSString stringWithFormat:@"%d m",[self roundUpDistance:(int)[userLocation distanceFromLocation:leg.endLoc]]];
        //[NSString stringWithFormat:@"%d m",[self roundUpDistance:leg.distance]];
        
        
        NSLog(@"Polyline Points: %@",leg.polyline.path);
        
        //leg.polyline.strokeWidth = 10.f;
        //leg.polyline.strokeColor = [UIColor colorWithRed:255 green:102 blue:102 alpha:1.0];
        /*if(leg.polyline.path.count > 1){
            leg.polyline.map = map.mapView;
        }*/
        if(mapMoved == NO){
            [map.mapView animateToZoom:18];
            //[map.mapView animateToViewingAngle:0];
            [map.mapView animateToLocation:userLocation.coordinate];
            [map.mapView animateToBearing:[self getHeadingForDirectionFromCoordinate:leg.startLoc.coordinate toCoordinate:leg.endLoc.coordinate]];
            //[self zoomToPolyLineNavig:leg.polyline.path];
            
        }
        
        if([self isOnLineLat1:[polyline.path coordinateAtIndex:0].latitude andLng1:[polyline.path coordinateAtIndex:0].longitude andLat2:[polyline.path coordinateAtIndex:1].latitude andLng2:[polyline.path coordinateAtIndex:1].longitude andLatP:userLocation.coordinate.latitude andLngP:userLocation.coordinate.longitude]==NO){
            
            [appDelegate showPleaseWait];
            //[map.mapView clear];
            etapes = nil;
            etapeCount =0;
            //recalcul
            [self RecalculApiway];
        }
        else{
            
            for (int i = 0; i < polyline.path.count-1; i++)
            {
                
                // on positionne le heading dans le sens du segment sur lequel se trouve l'user
                double lat1 = [polyline.path coordinateAtIndex:i].latitude;
                double lng1 = [polyline.path coordinateAtIndex:i].longitude;
                
                double lat2 = [polyline.path coordinateAtIndex:i+1].latitude;
                double lng2 = [polyline.path coordinateAtIndex:i+1].longitude;
                
                CLLocationCoordinate2D loc1;
                loc1.latitude = lat1;
                loc1.longitude = lng1;
                CLLocationCoordinate2D loc2;
                loc2.latitude = lat2;
                loc2.longitude = lng2;
                
                double dLon = (lng2-lng1);
                double y = sin(dLon) * cos(lat2);
                double x = cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(dLon);
                double brng = RADIANS_TO_DEGREES(atan2(y, x));
                
                [map.mapView animateToBearing:[self getHeadingForDirectionFromCoordinate:loc1 toCoordinate:loc2]];
                break;
                NSLog(@"BEARING 1 : %f, BEARING 2 : %f, SEGMENT %i, POLYCOUNT : %i",brng,[self getHeadingForDirectionFromCoordinate:loc1 toCoordinate:loc2],i,polyline.path.count);
            }
            
            
            if (etapes.count == 1 ){
                
                if([self roundUpDistance:(int)[userLocation distanceFromLocation:leg.endLoc]] <= 10)
                    if(spokenArrived ==0){
                        [self speakPlease:@"On va vous rechercher une place de parking"];
                        [appDelegate showNotif:@"On va vous rechercher une place de parking" duringSec:0.3];
                        [self RecalculApiway];
                        spokenArrived =1;
                    }
            }
            /*if(etapeCount == etapes.count-1){
             
             Leg *lastLeg = [self getLegFromSteps:Steps forIndex:etapeCount];
             }*/
            if (etapes.count > 1 && etapeCount < etapes.count-1) {
                
                nextLeg = [self getLegFromSteps:Steps forIndex:etapeCount+1];
                
                // ICI QUAND ON COMMENCE LA NAVIGATION FIRST LEG
                NSString *sub;
                if(spoken == 0){
                    // IL VA LIRE LE TEXTE DU LEG
                    //instructionLabel.text = [self getLegFromSteps:Steps forIndex:etapeCount].htmlInstruction;
                    
                    instructionLabel.text = [self formatGoogleInstruction:[self getLegFromSteps:Steps forIndex:etapeCount].htmlInstruction];
                    [self speakPlease:[self getLegFromSteps:Steps forIndex:etapeCount].htmlInstruction];
                    
                    if ([leg.indication isEqualToString:@"turn-right"]) {
                       
                        IndicationImage.image = [UIImage imageNamed:@"turn_right.png"];
                        
                    }
                    if ([leg.indication isEqualToString:@"turn-left"]) {
                       
                        IndicationImage.image = [UIImage imageNamed:@"turn_left.png"];
                        
                    }
                    else{
                       
                        IndicationImage.image = [UIImage imageNamed:@"go.png"];
                    }

                    spoken = 1;
                }
                
                // APRES 30 M IL VA LIRE LE TEXTE DU 2EME ETAPE
                if(spokenSecond ==0){
                    
                    if([self roundUpDistance:(int)[userLocation distanceFromLocation:leg.startLoc]] > 30){
                        //instructionLabel.text = nextLeg.htmlInstruction;
                        instructionLabel.text = [self formatGoogleInstruction:nextLeg.htmlInstruction];

                        if ([nextLeg.indication isEqualToString:@"turn-right"]) {
                            IndicationImage.image = [UIImage imageNamed:@"turn_right.png"];
                            
                        }
                        if ([nextLeg.indication isEqualToString:@"turn-left"]) {
                            IndicationImage.image = [UIImage imageNamed:@"turn_left.png"];
                            
                        }
                        else{
                            IndicationImage.image = [UIImage imageNamed:@"go.png"];
                        }
                        
                        [self speakForSecondLeg:Steps andDistance:[self roundUpDistance:(int)[userLocation distanceFromLocation:leg.endLoc]]];
                        spokenSecond= 1;
                    }
                    
                }
                // AVANT 30M DE LA FIN DU LEG, JE LUI FAIS UN RAPPEL ET LE PASSE AU NEXT LEG
                //[instructionLabel setFont:[UIFont fontWithName:@"Lato Regular" size:30]];

                if([self checkDistanceForNextLeg:userLocation andThisLeg:leg]){
                    
                    if(spoken == 0){
                        
                        if ([nextLeg.indication isEqualToString:@"turn-right"]) {
                            instructionLabel.text = @"Tournez à droite";
                            [self speakPlease:@"Tournez à droite"];
                            IndicationImage.image = [UIImage imageNamed:@"turn_right.png"];
                            
                        }
                        if ([nextLeg.indication isEqualToString:@"turn-left"]) {
                            instructionLabel.text = @"Tournez à gauche";
                            [self speakPlease:@"Tournez à gauche"];
                            IndicationImage.image = [UIImage imageNamed:@"turn_left.png"];
                            
                        }
                        else{
                            instructionLabel.text = @"Continuez tout droit";
                            [self speakPlease:@"Continuez tout droit"];
                            IndicationImage.image = [UIImage imageNamed:@"go.png"];
                        }
                    }
                    
                    
                    etapeCount++;
                    spoken = 0;
                    spokenSecond =0;
                    [self NavigateToLeg:etapes];
                }
            }
            if (etapeCount == etapes.count-1){ //&& ([self roundUpDistance:(int)[userLocation distanceFromLocation:leg.endLoc]] < 30)) {
                
                //Leg *lastLeg = [[Leg alloc]init];
                if([self roundUpDistance:(int)[userLocation distanceFromLocation:leg.endLoc]] <= 10){
                    if(spokenArrived ==0){
                        [self speakPlease:@"On va vous rechercher une place de parking"];
                        [appDelegate showNotif:@"On va vous rechercher une place de parking" duringSec:0.3];
                        
                        // ON RECALCUL UN CHEMIN APIWAY
                        [self RecalculApiway];
                        spokenArrived =1;
                        
                    }
                }
                
                
            }
        }
    }

    
    
    
    
    
    
    /**** ANCIEN CODE******/
    
    /*NSLog(@"LE TABLEAU LEG CONTIENT = %d",Steps.count);
    NSLog(@"LE NUMERO DE L'ETAPE LEG = %d",etapeCount);
    
    
    if(etapeCount < Steps.count){
        leg = [self getLegFromSteps:Steps forIndex:etapeCount];
        distanceLabel.text = [NSString stringWithFormat:@"%d m",[self roundUpDistance:(int)[userLocation distanceFromLocation:leg.endLoc]]];
        leg.polyline.strokeWidth = 10.f;
        leg.polyline.strokeColor = [UIColor blueColor];
         if(leg.polyline.path.count > 1){
        leg.polyline.map = map.mapView;
         }
        if(mapMoved == NO){
            [map.mapView animateToLocation:userLocation.coordinate];
            [map.mapView animateToZoom:19];
            [self zoomToPolyLineNavig:leg.polyline.path];
            
        }
        for (int i = 0; i < polyline.path.count-1; i++)
        {
            
            // on positionne le heading dans le sens du segment sur lequel se trouve l'user
            double lat1 = [polyline.path coordinateAtIndex:i].latitude;
            double lng1 = [polyline.path coordinateAtIndex:i].longitude;
            
            double lat2 = [polyline.path coordinateAtIndex:i+1].latitude;
            double lng2 = [polyline.path coordinateAtIndex:i+1].longitude;
            
            CLLocationCoordinate2D loc1;
            loc1.latitude = lat1;
            loc1.longitude = lng1;
            CLLocationCoordinate2D loc2;
            loc2.latitude = lat2;
            loc2.longitude = lng2;
            
            double dLon = (lng2-lng1);
            double y = sin(dLon) * cos(lat2);
            double x = cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(dLon);
            double brng = RADIANS_TO_DEGREES(atan2(y, x));
            
            [map.mapView animateToBearing:[self getHeadingForDirectionFromCoordinate:loc1 toCoordinate:loc2]];
            break;
            NSLog(@"BEARING 1 : %f, BEARING 2 : %f, SEGMENT %i, POLYCOUNT : %i",brng,[self getHeadingForDirectionFromCoordinate:loc1 toCoordinate:loc2],i,polyline.path.count);
        }
        if (Steps.count > 1 && etapeCount < Steps.count-1) {
            
            nextLeg = [self getLegFromSteps:Steps forIndex:etapeCount+1];
            instructionLabel.text = leg.htmlInstruction;
            
            if(spoken == 0){
                // IL VA LIRE LE TEXTE DU LEG
                [self speakPlease:leg.htmlInstruction];
                spoken = 1;
            }
            
            // APRES 30 M IL VA LIRE LE TEXTE DU 2EME ETAPE
            if(spokenSecond ==0){
                
                if([self roundUpDistance:(int)[userLocation distanceFromLocation:leg.startLoc]] > 30){
                    instructionLabel.text = nextLeg.htmlInstruction;
                    if ([nextLeg.indication isEqualToString:@"turn-right"]) {
                        IndicationImage.image = [UIImage imageNamed:@"turn_right.png"];
                        
                    }
                    if ([nextLeg.indication isEqualToString:@"turn-left"]) {
                        IndicationImage.image = [UIImage imageNamed:@"turn_left.png"];
                        
                    }
                    else{
                        IndicationImage.image = [UIImage imageNamed:@"go.png"];
                    }
                    
                    [self speakForSecondLeg:Steps andDistance:[self roundUpDistance:(int)[userLocation distanceFromLocation:leg.endLoc]]];
                    spokenSecond= 1;
                }
                //[map.mapView animateToBearing:[self getHeadingForDirectionFromCoordinate:leg.startLoc.coordinate toCoordinate:nextLeg.startLoc.coordinate]];
                
            }
            // AVANT 30M DE LA FIN DU LEG, JE LUI FAIS UN RAPPEL ET LE PASSE AU NEXT LEG
            
            if([self checkDistanceForNextLeg:userLocation andThisLeg:leg]){
                
                if(spoken == 0){
                    
                    if ([nextLeg.indication isEqualToString:@"turn-right"]) {
                        instructionLabel.text = @"Tournez à droite";
                        [self speakPlease:@"Tournez à droite"];
                        IndicationImage.image = [UIImage imageNamed:@"turn_right.png"];
                        
                    }
                    if ([nextLeg.indication isEqualToString:@"turn-left"]) {
                        instructionLabel.text = @"Tournez à gauche";
                        [self speakPlease:@"Tournez à gauche"];
                        IndicationImage.image = [UIImage imageNamed:@"turn_left.png"];
                        
                    }
                    else{
                        instructionLabel.text = @"Continuez tout droit";
                        [self speakPlease:@"Continuez tout droit"];
                        IndicationImage.image = [UIImage imageNamed:@"go.png"];
                    }
                }
                
                // ON PASSE AU LEG SUIVANT DU 1ER TABLEAU LEG
                etapeCount++;
                spoken = 0;
                spokenSecond =0;
                [self NavigateToLeg:Steps];
            }
        }

        if (Steps.count > 1 && etapeCount == Steps.count-1){
            
            if([self roundUpDistance:(int)[userLocation distanceFromLocation:leg.endLoc]] <= 10){
                
               // ON PASSE AU 2EME TABLEAU LEG
                allEtapeCount++;
            }
        }


        for (int i = 0; i < leg.polyline.path.count-1; i++)
        {
            
            //double lng1 = [polyline.path coordinateAtIndex:i].longitude;
            NSLog(@"path coordinate: %f,%f",[polyline.path coordinateAtIndex:i].latitude,[polyline.path coordinateAtIndex:i].longitude);
        }
        if([self isOnLineLat1:[leg.polyline.path coordinateAtIndex:0].latitude andLng1:[leg.polyline.path coordinateAtIndex:0].longitude andLat2:[leg.polyline.path coordinateAtIndex:1].latitude andLng2:[leg.polyline.path coordinateAtIndex:1].longitude andLatP:userLocation.coordinate.latitude andLngP:userLocation.coordinate.longitude]==NO){
            spoken = 0;
            spokenSecond =0;
            allEtapes = nil;
            Steps = nil;
            [map.mapView clear];
            // on affiche l'alerte
            if (alertePleaseWaitViewController == nil)
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                alertePleaseWaitViewController = (AlertePleaseWaitViewController*)[storyboard instantiateViewControllerWithIdentifier:@"AlertePleaseWaitViewController"];
                alertePleaseWaitViewController.view.alpha = 0.0;
            }
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 [self.view addSubview:alertePleaseWaitViewController.view];
                                 alertePleaseWaitViewController.view.alpha = 1.0;
                             } completion:nil];
            
            
            
            [self performSelector:@selector(HideAlert) withObject:nil afterDelay:2.0];
            //recalcul
            [self RecalculApiway];
        }

        if((allEtapes.count == 1)&&  (Steps.count == 1 )) {
            
            if(spoken == 0){
                // IL VA LIRE LE TEXTE DU LEG
                instructionLabel.text = leg.htmlInstruction;
                [self speakPlease:leg.htmlInstruction];
                spoken = 1;
            }
            if([self roundUpDistance:(int)[userLocation distanceFromLocation:leg.endLoc]] <= 10){
                if(spokenArrived ==0){
                    [self speakPlease:@"On va vous rechercher une place de parking"];
                    [appDelegate showNotif:@"On va vous rechercher une place de parking" duringSec:0.3];
                    [self RecalculApiway];
                    spokenArrived =1;
                }
            }
        }
     

        if((allEtapes.count >1)&&  (Steps.count == 1 )) {
            
            if(spoken == 0){
                // IL VA LIRE LE TEXTE DU LEG
                instructionLabel.text = leg.htmlInstruction;
                [self speakPlease:leg.htmlInstruction];
                spoken = 1;
            }
            if([self roundUpDistance:(int)[userLocation distanceFromLocation:leg.endLoc]] <= 10){
               
                // ON PASSE AU TABLEAU LEG D'APRES
                allEtapeCount++;
            }
        }
     
        if ((allEtapeCount == allEtapes.count-1)&&(etapeCount == Steps.count-1)){
            
            if([self roundUpDistance:(int)[userLocation distanceFromLocation:leg.endLoc]] <= 10){
                 if(spokenArrived ==0){
                 [self speakPlease:@"On va vous rechercher une place de parking"];
                 [appDelegate showNotif:@"On va vous rechercher une place de parking" duringSec:0.3];

                // ON RECALCUL UN CHEMIN APIWAY
                 [self RecalculApiway];
                 spokenArrived =1;
                 
                 }
            }
        }

        //FIN
    }
    
    */
    
    //}
}
/************************************************* FIN ***************************************************/
/********************************* CLLOCATION MANAGER DELEGATE ********************************************/

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation* location =[locations lastObject];
     userLocation = [[CLLocation alloc] initWithCoordinate: manager.location.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];

    UIImageView *coloredView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 40, 45)];
    coloredView.image = [UIImage imageNamed:@"pinEmplacementPlace.png"];
    //create the SKAnnotationView
    SKAnnotationView *view = [[SKAnnotationView alloc] initWithView:coloredView reuseIdentifier:@"viewID"];
    
    //create the annotation
    SKAnnotation *viewAnnotation = [SKAnnotation annotation];
    //set the custom view
    viewAnnotation.annotationView = view;
    viewAnnotation.identifier = 100;
    viewAnnotation.location = CLLocationCoordinate2DMake( location.coordinate.latitude, location.coordinate.longitude);
    [skMap addAnnotation:viewAnnotation withAnimationSettings:nil];
    //set the map region
    SKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
    region.zoomLevel = 17;
    skMap.visibleRegion = region;
    //alertePleaseWaitViewController.view.alpha = 0.0;
   /* userLocation = [[CLLocation alloc] initWithCoordinate: manager.location.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
    markerUserLocation.position = CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    markerUserLocation.map=map.mapView;
    [self startNavig];
    if (carLocation) {
        debugTextView.text = [NSString stringWithFormat:@"\nDISTANCE: %d \n%@",(int)[userLocation distanceFromLocation:carLocation],debugTextView.text];
        
    }
    if(startNavig == YES){
       
        [self checkNearToApipark];
    }
  
   // CALCUL DE DISTANCE PARCOURUE
    if ([appDelegate.ETAT isEqual:@"STATIONNE"]) {
        [appDelegate showNotif:@"Vous êtes Stationné" duringSec:3];
        [self cancelAction:nil];
        
    }
    distanceParc = [originLoc distanceFromLocation:userLocation];
    self.apiway_distance_label.text = [NSString stringWithFormat:@"%d m",[self roundUpDistance:(int)distanceParc]];
    */
    //[map.mapView animateToLocation:userLocation.coordinate];
    //[map.mapView animateToZoom:17.0f];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    if (newHeading.headingAccuracy < 0)
        return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
   
    currenHeading = theHeading;
  
    //[map.mapView animateToBearing:currenHeading];
    

}
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error
{
    [manager stopUpdatingLocation];
    NSLog(@"error%@",error);
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"please check your network connection or that you are not in airplane mode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"user has denied to use current Location " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"unknown network error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }

}
/************************************************* FIN ***************************************************/

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = DEGREES_TO_RADIANS(fromLoc.latitude);
    float fLng = DEGREES_TO_RADIANS(fromLoc.longitude);
    float tLat = DEGREES_TO_RADIANS(toLoc.latitude);
    float tLng = DEGREES_TO_RADIANS(toLoc.longitude);
    
    float degree = RADIANS_TO_DEGREES(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360+degree;
    }
}

-(void)HideAlert{
    
    alertePleaseWaitViewController.view.alpha = 0.0;

}
/********************* CHECK IF USER CHANGE THE PATH ****************/
- (BOOL) isOnLineLat1:(double) lat1 andLng1 : (double) lng1 andLat2 : (double) lat2 andLng2 : (double) lng2 andLatP : (double) latP andLngP : (double) lngP
{
    double distance1P = sqrt(  pow((lat1 - latP), 2)   +   pow((lng1 - lngP), 2)  );
    double distance2P = sqrt(  pow((lat2 - latP), 2)   +   pow((lng2 - lngP), 2)  );
    double distance12 = sqrt(  pow((lat1 - lat2), 2)   +   pow((lng1 - lng2), 2)  );
    
    NSLog(@"\n\n1 <-> P + 2 <-> P = %f\n1 <-> 2 = %f\n",distance1P+distance2P,distance12);
    // 0.001
    if ((distance12 < ((distance1P+distance2P)+0.001))&&(distance12 > ((distance1P+distance2P)-0.001)))
    {
        NSLog(@"YES");
        return YES;
    }
    else return NO;
    NSLog(@"NO");
}
/**** **/
-(void)speakForSecondLeg:(NSMutableArray*)Steps andDistance:(int)distance {
    
    [self speakPlease:[NSString stringWithFormat:@" Dans %d m %@",distance,[self getLegFromSteps:Steps forIndex:etapeCount+1].htmlInstruction]];
}

/******************************** CHECK DISTANCE FROM MY LOCATION TO LEG END LOCATION FOR SPEAK  ************************************/
-(BOOL)checkDistanceForSpeak:(CLLocation*)myLocation andThisLeg:(Leg*)thisLeg {
    
    if([myLocation distanceFromLocation:thisLeg.endLoc] == 200){
        
        return YES;
    }
    return NO;
}
/********************** CHECK DISTANCE FROM MY LOCATION TO LEG END LOCATION FOR PASSING TO NEXT LEG ************************/

-(BOOL)checkDistanceForNextLeg:(CLLocation*)myLocation andThisLeg:(Leg*)thisLeg {
    
    if([myLocation distanceFromLocation:thisLeg.endLoc] < 35 ){
        
        return YES;
    }
    return NO;
}
/********************** ROUND UP DISTANCE VALUE ************************/
-(int)roundUpDistance:(int)distance{
    
    // 428 -->> 430
    // 571 --> 570
    //431 --> 430
    NSString* dist = [NSString stringWithFormat:@"%d",distance];
    
    NSString* chiffre= [dist substringWithRange:NSMakeRange(dist.length-1, 1)];
    
    int chiffreInt = [chiffre intValue];
    
    if (chiffreInt > 5 ) {
        
        distance = distance+ (10-chiffreInt);
    }
    if (chiffreInt < 5 ) {
        
        distance = distance - (0+chiffreInt);
    }
    return distance;
}
- (IBAction)GoQuaiIvry:(id)sender {
    
    //testLoc = [[CLLocation alloc]initWithLatitude: 48.8253402 longitude:2.3882207];
    
        etapeCount++;
      [self NavigateToLeg:etapes];
}
- (IBAction)GoGo:(id)sender {
    
   
        [map.mapView animateToLocation:userLocation.coordinate];
        [map.mapView animateToZoom:17.0f];
    
}
 
-(NSString *) stringByStrippingHTML:(NSString *)s
{
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}


/******** VOICE SPEAK ********/

-(void)speakPlease:(NSString*)speech{
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:speech];
    utterance.rate = 0.25f;
    AVSpeechSynthesizer *syn = [[AVSpeechSynthesizer alloc] init];
    [syn speakUtterance:utterance];
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
    {
        [appDelegate showNotif:speech duringSec:0.5];
    }
}
-(void)sendInstructions:(NSString*)instructions{
    
    instructionLabel.text = instructions;
}
-(void)ZoomToApiway{
    
    

}
/********************** 3 TYPES DE NAVIGATION*******************/
-(void)NavigateToParking{
    
    [map navigateTo:destinationLoc];
  
}
-(void)NavigateToDestination{
    
    
}
-(void)NavigateToApiway{
    
    
}
-(IBAction)cancelAction:(id)sender{
    
    etapes = nil;
    polyline=nil;
    polyline.map =nil;
    [map.mapView clear];
    self.view=nil;
    [self.instructionView setHidden:YES];;
 //   self.view.userInteractionEnabled = NO;
    [self dismissViewControllerAnimated:YES completion:NULL];
    /*[UIView animateWithDuration:0.0
                     animations:^{
                         self.view.alpha = 0.0;
                         
                     } completion:nil];*/
    [UIView animateWithDuration:0.4
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.x = frame.size.width;
                         self.view.frame = frame;
                     } completion:nil];
    appDelegate.WTP = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSDictionary*)navigateWithWaypoints:(NSArray*)arrayOfPoints andMode:(NSString*)mode error:(NSError **)error
{
    NSDictionary *result = nil;
    
    NSString *waypoints = @"";
    if(arrayOfPoints.count>0){
       // CLLocation* origin = [arrayOfPoints objectAtIndex:0];
        //CLLocation* destination = [arrayOfPoints objectAtIndex:arrayOfPoints.count - 1];
        
        // Create the waypoints
        for(int i = 0; i < arrayOfPoints.count; i++)
        {
            CLLocation* current = [arrayOfPoints objectAtIndex:i];
            
            waypoints = [waypoints stringByAppendingString:[NSString stringWithFormat:@"%f,%f%%7C",current.coordinate.latitude,current.coordinate.longitude]];
        }
        
       // CLLocation* lastWaypoint = [arrayOfPoints objectAtIndex:arrayOfPoints.count - 2];
       // waypoints = [waypoints stringByAppendingString:[NSString stringWithFormat:@"%f,%f",lastWaypoint.coordinate.latitude,lastWaypoint.coordinate.longitude]];
        
        NSString *urlString =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&waypoints=%@&sensor=true&mode=%@",userLocation.coordinate.latitude,userLocation.coordinate.longitude,destinationLoc.coordinate.latitude,destinationLoc.coordinate.longitude,waypoints,mode];
        
        //waypoints	__NSCFString *	@"48.827000,2.386050%7C48.825100,2.388820%7C48.827500,2.385580%7C48.826100,2.387450%7C48.820700,2.377860"	0x15d2fe50
        [self getResponseWaypoints:urlString];
        NSDictionary* response;
        if (response != nil)
        {
            if ([[response objectForKey:@"status"] isEqualToString:@"OK"])
            {
                result = response;
                NSLog(@"%@",response);
                
            }
            else
            {
                if (error)
                {
                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:[response objectForKey:@"status"] forKey:NSLocalizedDescriptionKey];
                    *error = [[NSError alloc] initWithDomain:@"AppName" code:2 userInfo:details];
                }
            }
        }
        else
        {
            if(error)
            {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:NSLocalizedString(@"ErrorServidor", nil) forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"AppName" code:1 userInfo:details];
                return nil;
            }
        }
    originLoc = [arrayOfPoints objectAtIndex:arrayOfPoints.count-1];
    }
    else{
        
        NSLog(@"Apiway Array is empty");
    }
    return result;
}
-(void)getResponseWaypoints:(NSString*)url{
    
    //NSString *post2 = [NSString stringWithFormat:@"address=%@&sensor=true",[[destinationLocation stringByReplacingOccurrencesOfString:@" " withString:@"+"] urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"REQUEST ADRESSE : %@",post2);
    
    NSMutableURLRequest * request2 = [[NSMutableURLRequest alloc] init];
    [request2 setURL:[NSURL URLWithString:url]];
    [request2 setHTTPMethod:@"GET"];
    
     connectionWaypoints = [[NSURLConnection alloc] initWithRequest:request2 delegate:self];
    
    [connectionWaypoints start];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d
{
    if(connection == connectionAddress){
        
        responseString = [NSString stringWithFormat:@"%@%@",responseString,[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]];

    }
    if(connection == connectionWaypoints){
        
        responseStringWaypoints = [NSString stringWithFormat:@"%@%@",responseStringWaypoints,[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]];
        
    }
    if(connection == connectionApiway){
        
        responseApiway = [NSString stringWithFormat:@"%@%@",responseApiway,[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]];
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:@"Il y a eu une coupure de connexion, l'opération a été annulée."/*[error localizedDescription]*/
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
    
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if(connection == connectionApiway){
        
        NSLog(@"RECEIVED POI : %@",responseApiway);
        
        
        NSString* bar = [responseApiway stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        NSLog(@"%@", bar);
        
        NSData * data = [bar dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"JSON DIct: %@", jsonObjects);
        
        [self addDirections:jsonObjects];
        
        
        responseApiway = @"";
    }

    if(connection == connectionWaypoints){
        
    NSLog(@"RECEIVED POI : %@",responseStringWaypoints);
    
    
    NSString* bar = [responseStringWaypoints stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    NSLog(@"%@", bar);
    
    NSData * data = [bar dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"JSON DIct: %@", jsonObjects);
    
    [self addDirections:jsonObjects];
    
    
    responseStringWaypoints = @"";
    }
    if(connection == connectionAddress){
        NSLog(@"RECEIVED POI : %@",responseString);
        
        @try
        {
            
            NSString* bar = [responseString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            NSLog(@"%@", bar);
            
            NSData * data = [bar dataUsingEncoding:NSUTF8StringEncoding];
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * entries = [jsonObjects objectForKey:@"results"];
            
            NSLog(@"---- RESULT : %@",[[[[entries objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"]);
            destLat = [[[[[entries objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] floatValue];
            destLng = [[[[[entries objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];
            destLatString =[[[[entries objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
            destLngString =[[[[entries objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
            if(markerDestination == nil)
            {
                markerDestination = [[GMSMarker alloc] init];
                markerDestination.icon = [UIImage imageNamed:@"pinArriver.png"];
                markerDestination.map = map.mapView;
            }
            
            [markerDestination setPosition:CLLocationCoordinate2DMake(destLat, destLng)];
            destinationLoc = [[CLLocation alloc]initWithLatitude:destLat longitude:destLng];
             NSLog(@"lat : %f, lng: %f",destLat,destLng);
          
            NSLog(@"destination loc : %@",destinationLoc);
            self.savedDestination = destinationLoc;
            appDelegate.savedDestination = self.savedDestination;
            appDelegate.arrived = NO;
            switch (appDelegate.navigChoice) {
                case -1:
                    break;
                case 0:
                    [self GoogleMapNavigation:nil];
                    break;
                case 1:
                    [self WazeNavigation:nil];
                    break;
                case 2:
                    [self AppleNavigation:nil];
                    break;
                default:
                [self NavigationDeMerdre:destinationLoc];
                    break;
            }

        }
        @catch (NSException *exception)
        {
            NSLog(@"ERROR ADRESSE INCONNUE");
            
            [appDelegate showNotif:@"ADRESSE INCONNUE, VEUILLEZ RECOMMENCER EN DONNANT PLUS DE PRÉCISIONS" duringSec:3];
        }
        
        responseString = @"";

    }
    
}
-(void)showWazeNotif{
    
    
    
    [appDelegate showNotif:[NSString stringWithFormat:@"Revenir à APILA"] duringSec:20];
    
   }

-(IBAction)WazeNavigation:(id)sender{

if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]]) {
    //Waze is installed. Launch Waze and start navigation
    NSString *urlStr = [NSString stringWithFormat:@"waze://?ll=%@,%@&navigate=yes", destLatString, destLngString];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];

} else {
    //Waze is not installed. Launch AppStore to install Waze app
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
}
   // [self performSelector:@selector(showWazeNotif) withObject:nil afterDelay:3.0];
}
-(IBAction)GoogleMapNavigation:(id)sender{
    
    
    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
        NSString *directionsRequest = [NSString stringWithFormat:@"comgooglemaps-x-callback://?saddr=%0.9f,%0.9f&daddr=%0.9f,%0.9f&directionsmode=driving&x-success=sourceapp://?resume=true&x-source=Apila",userLocation.coordinate.latitude,userLocation.coordinate.longitude,destLat,destLng];
        
        
        NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
        [[UIApplication sharedApplication] openURL:directionsURL];
    } else {
        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    }
    //[self performSelector:@selector(showWazeNotif) withObject:nil afterDelay:3.0];
    
}
-(IBAction)AppleNavigation:(id)sender{
    
    
    [appDelegate showPleaseWait];
    geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:userLocation.coordinate];
    geoCoder.delegate = self;
    [geoCoder start];
    // Check for iOS 6
    [self performSelector:@selector(applenavigation) withObject:nil afterDelay:4.0];
    
    
   // [self performSelector:@selector(showWazeNotif) withObject:nil afterDelay:3.0];
    
    
}
// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    MKPlacemark * myPlacemark = placemark;
    // with the placemark you can now retrieve the city name
    //  NSString *city = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
    userAddress = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
}
-(void)applenavigation{
    
    [appDelegate hidePleaseWait];
    if(userAddress){
        NSString *directionsRequest = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@,+CA&saddr=%@",
                                       [[destinationAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"] urlEncodeUsingEncoding:NSUTF8StringEncoding],
                                       [[userAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"] urlEncodeUsingEncoding:NSUTF8StringEncoding]
                                       ];
        
        
        NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
        [[UIApplication sharedApplication] openURL:directionsURL];
    }
    
    
}
// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
}

/************************************************* GEOCODING ***********************************************/
-(void) navigatetoAddress:(NSString*)address
{
    
    destinationAddress= address;
    // on affiche l'alerte
    /*if (alertePleaseWaitViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        alertePleaseWaitViewController = (AlertePleaseWaitViewController*)[storyboard instantiateViewControllerWithIdentifier:@"AlertePleaseWaitViewController"];
        alertePleaseWaitViewController.view.alpha = 0.0;
    }
    
    [UIView animateWithDuration:0.8
                     animations:^{
                         [self.view addSubview:alertePleaseWaitViewController.view];
                         alertePleaseWaitViewController.view.alpha = 1.0;
                     } completion:nil];
    
    
    */
    
    //destinationLocation=@"6 Rue Neuve Tolbiac 75013‎,Paris,France";
    NSString* dest = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *post2 = [NSString stringWithFormat:@"address=%@&sensor=true",[dest urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"REQUEST ADRESSE : %@",post2);
    
    NSMutableURLRequest * request2 = [[NSMutableURLRequest alloc] init];
    [request2 setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true",[dest urlEncodeUsingEncoding:NSUTF8StringEncoding]]]];
    [request2 setHTTPMethod:@"GET"];
    
     connectionAddress = [[NSURLConnection alloc] initWithRequest:request2 delegate:self];
    
    [connectionAddress start];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
