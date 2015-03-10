//
//  ViewController.m
//  Apila
//
//  Created by Vincenzo GALATI on 18/02/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "GoogleMapViewController.h"
#import <SKMaps/SKRouteInformation.h>
@interface ViewController ()

@end

@implementation ViewController

- (void) viewWillAppear:(BOOL)animated
{
    self.isVisible =1;
    if(self.view.frame.size.height == 278)
    {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect newFrame = self.mapGoogle.frame;
            newFrame.size.width = 320;
            newFrame.size.height = 568;
            [self.mapGoogle setFrame:newFrame];
            [self.centrerButtonView setFrame:CGRectMake(0, 220, self.centrerButtonView.frame.size.width, self.centrerButtonView.frame.size.height)];
            
        } completion:nil];
        
    }
}

- (IBAction)drive:(id)sender {
    
    [appDelegate.detect drive];
    
}
- (IBAction)stop:(id)sender {
    [appDelegate.detect stop];
}
- (IBAction)walk:(id)sender {
    [appDelegate.detect walk];
}
- (IBAction)moyen:(id)sender {
    [appDelegate.detect moyen];
}
- (IBAction)proche:(id)sender {
    [appDelegate.detect proche];
}

-(IBAction)cancelAction:(id)sender{
   
    [alertChooseNavigationViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)centrerAction:(id)sender
{
       [self.mapGoogle animateToZoom:17.0f];
          [self.mapGoogle animateToLocation:markerUserLocation.position];

   
}
-(void)showMessage:(NSString*)Message{
    
    //appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    if(![lastMessage isEqual:Message]){
        [self showNotif:Message duringSec:3.0f];
        lastMessage = Message;
    
    }
   
}
-(void)showPin:(NSString*)Pin{
    
    appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    appDelegate.markerUserLocation.icon = [UIImage imageNamed:Pin];
    
}
-(void)showPinCar:(NSString*)Pin{
    
    //appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    //appDelegate.CarMarker.icon = [UIImage imageNamed:Pin];
    appDelegate.CarMarker.map= self.mapGoogle;
    appDelegate.CarMarker.icon=[UIImage imageNamed:@"pinEmplacementPlace.png"];

}
- (void)showNotif:(NSString *)message duringSec : (float) sec
{
    
        UILocalNotification *howLongCanANotificationLast = [[UILocalNotification alloc]init];
        howLongCanANotificationLast.alertBody=message;
        [[UIApplication sharedApplication] presentLocalNotificationNow:howLongCanANotificationLast];
}
- (void)hideNotif
{
    if(notifIsShowing == 1)
    {
        [UIView animateWithDuration:0.4
                         animations:^{
                             CGRect frameNotif = notifView.frame;
                             frameNotif.origin.y = frameNotif.origin.y - frameNotif.size.height;
                             notifView.frame = frameNotif;
                         } completion:nil];
        
        notifIsShowing = 0;
    }
}


-(void)showApiway{
    
    [self centrerAction:nil];
}
-(void)ZoomToApiway{
    
    
    if(self.view.frame.origin.y == +0)
    {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect newFrame = self.mapGoogle.frame;
            newFrame.size.width = 320;
            newFrame.size.height = 568;
            [self.mapGoogle setFrame:newFrame];
            [self.centrerButtonView setFrame:CGRectMake(0, 455, self.centrerButtonView.frame.size.width, self.centrerButtonView.frame.size.height)];

        } completion:nil];
        
        [map zoomToPolyLine];
    }

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //Change the host name here to change the server you want to monitor.
    self.searchDisplayController.searchBar.frame = CGRectMake ( self.searchDisplayController.searchBar.frame.origin.x,
                                                               self.searchDisplayController.searchBar.frame.origin.y,
                                                               250,
                                                               self.searchDisplayController.searchBar.frame.size.height);
    //[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{
                                                                                                 //NSFontAttributeName: [UIFont fontWithName:@"Lato" size:27],
    markersParkoArray  = [[NSMutableArray alloc]init];                                                                          //}];
    NSString *remoteHostName = @"www.apple.com";
    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    self.remoteHostLabel.text = [NSString stringWithFormat:remoteHostLabelFormatString, remoteHostName];
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self updateInterfaceWithReachability:self.wifiReachability];
    predictions = [[NSMutableArray alloc]  init];
     self.searchText.delegate = self;
    appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    if(appDelegate.detect == NULL){
    
        appDelegate.detect = [[DetectEvent alloc]init];
    }
    appDelegate.detect.locationManager.delegate =self ;
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
    searchQuery.language = @"fr";
    searchQuery.radius = 100.0;
    shouldBeginEditing = YES;
   // autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(210, 225, 310, 120) style:UITableViewStylePlain];
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    //[self.view addSubview:autocompleteTableView];

    self.searchDisplayController.searchBar.placeholder = @"Je navigue et je me gare";
    float ratio = [UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width;
    // assuming your controller has identifier "privacy" in the Storyboard
    _menuButton.alpha=1.0;
    if(ratio == 1.500000)
    {
        NSLog(@"IPHONE 3GS OU 4 ou 4S");
        
        CGRect frame = self.centrerButtonView.frame;
        frame.origin.y = self.centrerButtonView.frame.origin.y-88;
        self.centrerButtonView.frame = frame;
        
        frame = self.barreBasView.frame;
        frame.origin.y = frame.origin.y-88;
        self.barreBasView.frame = frame;
        
        frame = self.menuButtonView.frame;
        frame.origin.y = frame.origin.y-88;
        self.menuButtonView.frame = frame;
    }
    
    diffDistance = [[NSMutableArray alloc] init];
    
    self.debugTextView.text = @"";
    
    self.preciserEmplacementView.alpha = 0.0;
    emplacementPlaceLat = 0.0;
    emplacementPlaceLng = 0.0;
    /*appDelegate.locationManager = [[CLLocationManager alloc]init];
    locationManager=  appDelegate.locationManager;
     locationManager.delegate=self;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    */
     // pour détecter les mouvements de l'iPhone (accéléromètre)
    //[self startMyMotionDetect];
    
    self.mapGoogle.delegate = self;
    self.mapGoogle.settings.compassButton = YES;
    [self performSelector:@selector(updateMapCenter) withObject:nil afterDelay:0.5];
    self.mapGoogle.mapType = kGMSTypeNormal;
    //self.mapGoogle = [[GMSMapView alloc]initWithFrame:CGRectMake(0, 20, 320, 568)];
    //[self.view addSubview:self.mapGoogle];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(didPan:)];
    self.mapGoogle.gestureRecognizers = @[panRecognizer];
    appDelegate.markerUserLocation.map =self.mapGoogle;
    appDelegate.CarMarker.map =self.mapGoogle;
       [self performSelector:@selector(restartLocation) withObject:nil afterDelay:480];
    
    speedStation = 0.0;
    mode = MODENULL;
    voiture = VOITURE_NULL;
    etat_user = 1000;
    allSourcesCalled = 0;
    seuilDepasse = NO;
    
    self.barreBasView.userInteractionEnabled = NO;
    self.barreBasView.alpha = 0.0;
    self.apiwayNavigButton.alpha = 0.0;
    self.apiwayNavigButton.userInteractionEnabled = NO;
    self.refreshButton.alpha = 0.0;
    self.refreshButton.userInteractionEnabled = NO;
    
    markersUserArray = [[NSMutableArray alloc] init];
    markersParkoArray = [[NSMutableArray alloc] init];
    
    self.labelSuiviDistanceReserveur.hidden = YES;
    self.labelSuiviTempsReserveur.hidden = YES;
    self.labelSuiviVoitureReserveur.hidden = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"TEST" message: @"Quel user voulez-vous être pour le test ?" delegate: self cancelButtonTitle:nil otherButtonTitles:@"USER 0", @"USER 1", nil];
    alert.tag = 10;
    //[alert show];
    [self.searchText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    dataParko = [[NSMutableData alloc] init];
    responseString = @"";
    
    waypointsApiway = [[NSMutableArray alloc]init];
    waypointStringsApiway = [[NSMutableArray alloc]init];
    apiwayPolylines = [[NSMutableArray alloc]init];
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    self.navigIndicationView.hidden = YES;
    
    s2 = 3;
    s3 = 1.388888889;
    epsilon = 5;
    saveSpeed = [[NSMutableArray alloc] init];
    
    appeared = 0;
    
    mapMoved = NO;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mapPannedByTouch:)];
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(mapPinchedByTouch:)];
    
    [self.mapGoogle addGestureRecognizer:panGestureRecognizer];
    [self.mapGoogle addGestureRecognizer:pinchGestureRecognizer];
    
    eloigneVoiture = YES;
    jcArrive = 0;
    debugText.text = appDelegate.debugText;
    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToRight)];
    
    [mSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self.homeView addGestureRecognizer:mSwipeUpRecognizer];
    skMap = [[SKMapView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f,  CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) )];
    //set the map region
   
    [self.mapGoogle addSubview:skMap];
    
    pinName=@"pinJeMarche.png";
    [SKRoutingService sharedInstance].routingDelegate = self; // set for receiving routing callbacks
    [SKRoutingService sharedInstance].navigationDelegate = self;// set for receiving navigation callbacks
    [SKRoutingService sharedInstance].mapView = skMap; // use the map view for route rendering
    
    //add a rhombus overlay with dotted border
    /*CLLocation *rhombusVertex1 = [[CLLocation alloc]initWithLatitude:48.8293885 longitude:2.3786657];
    CLLocation *rhombusVertex2 = [[CLLocation alloc]initWithLatitude:48.831336 longitude:2.378081];
    CLLocation *rhombusVertex3 = [[CLLocation alloc]initWithLatitude:48.830418 longitude:2.378167];
    //CLLocation *rhombusVertex4 = [[CLLocation alloc]initWithLatitude:48.828349  longitude:2.382758];
    //adding a polyline with the same coordinates as the polygon
    SKPolyline *polyline = [SKPolyline polyline];
    polyline.coordinates = @[rhombusVertex1, rhombusVertex2, rhombusVertex3];
    polyline.fillColor = [UIColor redColor];
    polyline.lineWidth = 10;
    polyline.backgroundLineWidth = 2;
    polyline.borderDotsSize = 20;
    polyline.borderDotsSpacingSize = 5;
    [skMap addPolyline:polyline];
    */
}
- (void)routingService:(SKRoutingService *)routingService didChangeCurrentStreetName:(NSString *)currentStreetName streetType:(SKStreetType)streetType countryCode:(NSString *)countryCode{
    
    NSLog(@"street name: %@,%d,%@",currentStreetName,streetType,countryCode );
   // NSLog(@"routing service array: %@",routingService.visualAdviceConfigurations);
    
}
- (void)routingService:(SKRoutingService *)routingService didChangeDistanceToDestination:(int)distance withFormattedDistance:(NSString *)formattedDistance{
    
    NSLog(@"distance: %@",formattedDistance);
}
- (void)routingServiceDidReachDestination:(SKRoutingService *)routingService{
    
        NSLog(@"destination reached");
}
- (void)routingService:(SKRoutingService *)routingService didFinishRouteCalculationWithInfo:(SKRouteInformation*)routeInformation{
    NSLog(@"Route is calculated.");
    [routingService zoomToRouteWithInsets:UIEdgeInsetsZero]; // zooming to currrent route
   //NSArray *adviceList = [routingService routeAdviceListWithDistanceFormat:SKDistanceFormatMetric]; // array of SKRouteAdvice
    NSLog(@"routing distance : %d",routeInformation.distance);

    SKNavigationSettings* navSettings = [SKNavigationSettings navigationSettings];
    navSettings.navigationType=SKNavigationTypeReal;
    navSettings.distanceFormat=SKDistanceFormatMetric;
    [SKRoutingService sharedInstance].mapView.settings.displayMode = SKMapDisplayMode3D;
    [[SKRoutingService sharedInstance]startNavigationWithSettings:navSettings];
}
- (void) swipeToRight
{
    NSLog(@"FERMER MENU");
    [self.homeView setHidden:YES];
    [UIView animateWithDuration:0.4
                     animations:^{
                         CGRect frame = self.homeView.frame;
                         frame.origin.x = frame.size.width;
                         self.homeView.frame = frame;
                     } completion:nil];
     parkHereButton.alpha=1.0;
    [[SKRoutingService sharedInstance]stopNavigation];
    [[SKRoutingService sharedInstance] clearCurrentRoutes];

}
- (IBAction)apiShare:(id)sender {
    
    [appDelegate showNotif:@"Cette fonctionnalité sera disponible prochainement" duringSec:3.0];
     SKRouteSettings* route = [[SKRouteSettings alloc]init];
     route.startCoordinate=CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
     //route.destinationCoordinate=CLLocationCoordinate2DMake(48.825583,2.3836126);
     route.destinationCoordinate=CLLocationCoordinate2DMake(48.8215965,2.3715504);
     
     [[SKRoutingService sharedInstance] calculateRoute:route];
    

}
- (IBAction)apiWay:(id)sender {
    
    if (navigationMap == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        navigationMap = (NavigationMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationMapViewController"];
    }
    
    //[self presentViewController:navigationMap animated:YES completion:nil];
    //[ navigationMap NavigationDeMerdre:parking.position];
    

    CGRect frame = navigationMap.view.frame;
    frame.origin.x = frame.size.width;
    navigationMap.view.frame = frame;
    
    NSLog(@"frame:%f",navigationMap.view.frame.origin.x);
    if(navigationMap.view.frame.origin.x  == +320)
    {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame = navigationMap.view.frame;
            frame.origin.x = frame.origin.x - frame.size.width;
            navigationMap.view.frame = frame;
        } completion:nil];
    }
    [self.view addSubview:navigationMap.view];
   //[navigationMap parkNow];
}
/************ create parkings view in scrollview prog ************/
-(void)drawParkingView{
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, 320, 568)];
    
    for(int i =0;i<savedParkingsArray.count;i++){
        
        UIView *parkingView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, 568)];
        UIImageView *parkingImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 320, 568)];
        parkingImg.image = [UIImage imageNamed:@"pin_parking_small.png"];
        
        UINib *nib = [UINib nibWithNibName:@"CustomView" bundle:nil];
        //CustomView *parkingView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    }

}
- (IBAction)apiPark:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeRecommanded = (HomeRecommandedViewCtrl*)[storyboard instantiateViewControllerWithIdentifier:@"HomeRecommandedViewCtrl"];
    
    CLLocation *userLoc = [[CLLocation alloc]initWithLatitude:markerUserLocation.position.latitude longitude:markerUserLocation.position.longitude];
    
    homeRecommanded.parentController =self;
    [homeRecommanded apiPark:sender];

}



-(void)sendApiwayResults:(NSMutableArray*)apiwayArray andDistance:(NSString*)time{
    NSLog(@"this is called");
    int minutes = [time intValue] / 60;
    self.apiway_time_label.text = [NSString stringWithFormat:@"%d min",minutes];

}
-(void)sendParkingResults:(NSMutableArray*)parkingArray andApiway:(NSMutableArray*)apiwayArray{

    savedParkingsArray = parkingArray;
    appDelegate.parkingArray =parkingArray;
    // ajout des places parkopedia
   // NSLog(@"park0: %@",[savedParkingsArray objectAtIndex:0]);
    for (int i=0;i<savedParkingsArray.count;i++)
    {
        //NSLog(@"---- RESULT : %@",[infoParko objectAtIndex:i]);
        
        GMSMarker * markerUser = [[GMSMarker alloc] init];
        Parking *park =[savedParkingsArray objectAtIndex:i];
        markerUser.position = park.position.coordinate;
        
        markerUser.icon = [UIImage imageNamed:@"pin_parking_small.png"];
        
        markerUser.map = self.mapGoogle;
        
        markerUser.snippet = park.name;// [NSString stringWithFormat:@"parkopedia%i",i];
        
        [markersParkoArray insertObject:markerUser atIndex:i];
    }
    [self focusMapToShowAllMarkers];
    //[self.mapGoogle animateToZoom:19.0f];
    NSLog(@"this is called");
   
    [self.homeView setHidden:NO];
    CGRect frame = self.homeView.frame;
    frame.origin.x = frame.size.width;
    self.homeView.frame = frame;
    
    
    [self showApiway];
    NSLog(@"frame:%f",self.homeView.frame.origin.x);
    if(self.homeView.frame.origin.x  == +320)
    {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame = self.homeView.frame;
            frame.origin.x = frame.origin.x - frame.size.width;
            self.homeView.frame = frame;
        } completion:nil];
    }

    [appDelegate hidePleaseWait];
    self.apiparkLabel.text= [NSString stringWithFormat:@"%d",savedParkingsArray.count];
    parkHereButton.alpha=0.0;
   
}

- (void)focusMapToShowAllMarkers
{
    CLLocationCoordinate2D myLocation = ((GMSMarker *)markersParkoArray.firstObject).position;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:myLocation coordinate:myLocation];
    
    for (GMSMarker *marker in markersParkoArray)
        bounds = [bounds includingCoordinate:marker.position];
    
    [self.mapGoogle animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:50.0f]];
}
- (void)viewDidDisappear:(BOOL)animated
{
    self.isVisible = 0;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void) didPan:(UIPanGestureRecognizer*) gestureRecognizer
{
    //NSLog(@"DID PAN");
}
/*
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    if (newHeading.headingAccuracy < 0)
        return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    
    currenHeading = theHeading;
    NSLog(@"head: %f",currenHeading);
    //[map.mapView animateToBearing:currenHeading];
    
    
}
*/
- (IBAction)parkHere:(id)sender {
    
    NSDictionary *dict;
    
   // dict = [NSDictionary dictionaryWithObjectsAndKeys: yourStuff, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WTP" object:nil userInfo:nil];
     serverResponse =[[ServerResponseViewController alloc]init];
    serverResponse.delegate = self;
    [serverResponse getResponse:appDelegate.locationManager.location andResponseOption: PARKNOW andHeading:currenHeading];
        //[appDelegate showPleaseWait];
    
    
}
- (void) movePlaceMarker
{
    ///markerPlace.position = CLLocationCoordinate2DMake([self.mapGoogle.projection coordinateForPoint:self.mapGoogle.center].latitude,[self.mapGoogle.projection coordinateForPoint:self.mapGoogle.center].longitude);
}

- (void) restartLocation
{
    NSLog(@"RESTART LOCATION MANAGER");
    [locationManager stopUpdatingLocation];
    [locationManager startUpdatingLocation];
    
    [self performSelector:@selector(restartLocation) withObject:nil afterDelay:480];
}

- (void) updateMapCenter
{
    NSLog(@"CHECK LOCATION");
     NSLog(@"CHECK : %@",[appDelegate.detect.locationManager location]);
    
    if([appDelegate.detect.locationManager location].coordinate.latitude == 0 && [appDelegate.detect.locationManager location].coordinate.longitude == 0)
    {
        [self performSelector:@selector(updateMapCenter) withObject:nil afterDelay:0.1];
    }
    else
    {
        NSLog(@"USER LOCATION OK");
        [self.mapGoogle animateToLocation:[appDelegate.detect.locationManager location].coordinate];
        [self.mapGoogle animateToZoom:17];
    }
}
- (void)adjustFrame:(NSNotification *) notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    if ([[notification name] isEqual:UIKeyboardWillHideNotification]) {
        // revert back to the normal state.
        self.searchDisplayController.searchBar.frame = CGRectMake ( self.searchDisplayController.searchBar.frame.origin.x,
                                                                   self.searchDisplayController.searchBar.frame.origin.y,
                                                                   250,
                                                                   self.searchDisplayController.searchBar.frame.size.height);
    }
    else  {
        //resize search bar
        self.searchDisplayController.searchBar.frame = CGRectMake ( self.searchDisplayController.searchBar.frame.origin.x,
                                                                   self.searchDisplayController.searchBar.frame.origin.y,
                                                                   250,
                                                                   self.searchDisplayController.searchBar.frame.size.height);
    }
    
    [UIView commitAnimations];
}
-(void)rien:(NSNotification*)notification{
    
    NSDictionary *tmp = notification.userInfo;
     //markerUserLocation.icon = [UIImage imageNamed:@"pinJeMarche.png"];
    pinName=@"pinJeMarche.png";

}
-(void)arretPied:(NSNotification*)notification{
    
    NSDictionary *tmp = notification.userInfo;
   // markerUserLocation.icon = [UIImage imageNamed:@"pinJeMarche.png"];
    pinName=@"pinJeMarche.png";

    NSLog(@"Automate a detecté arret pied -------:%@", tmp);
}
-(void)marcher:(NSNotification*)notification{
    
    NSDictionary *tmp = notification.userInfo;
    pinName=@"pinJeMarche.png";
   // markerUserLocation.icon = [UIImage imageNamed:@"pinJeMarche.png"];
    NSLog(@"Automate a detecté marche -------:%@", tmp);
}
-(void)rouler:(NSNotification*)notification{
    
    NSDictionary *tmp = notification.userInfo;
    CarMarker.map = nil;
    pinName=@"pinEmplacementPlace.png";
    //markerUserLocation.icon = [UIImage imageNamed:@"pinEmplacementPlace.png"];
    NSLog(@"Automate a detecté rouler -------:%@", tmp);
}
-(void)stationner:(NSNotification*)notification{
    
    NSDictionary *tmp = notification.userInfo;
    NSLog(@"Automate a detecté stationner -------:%@", tmp);
    
    if(CarMarker == nil)
    {
        CarMarker = [[GMSMarker alloc] init];
        
    }
    CarMarker.icon = [UIImage imageNamed:@"pinEmplacementPlace.png"];
    CarMarker.snippet = @"My CAR";
    CarMarker.position =CLLocationCoordinate2DMake([[[notification.userInfo objectForKey:@"savedLoc"]objectAtIndex:0] doubleValue], [[[notification.userInfo objectForKey:@"savedLoc"]objectAtIndex:1] doubleValue]);
    //NSLog(@"marker position: %f, %f",markerUserLocation.position.latitude,markerUserLocation.position.longitude);
    CarMarker.map= self.mapGoogle;
    if (appDelegate == nil) {
        appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    }
    [appDelegate.serverWebSocket gotAPlace:[NSString stringWithFormat:@"%0.9f",CarMarker.position.latitude] andLng :[NSString stringWithFormat:@"%0.9f",CarMarker.position.longitude]];

}
-(void)revenir:(NSNotification*)notification{
    
    NSDictionary *tmp = notification.userInfo;
    NSLog(@"Automate a detecté revenir-------:%@", tmp);
    if (appDelegate == nil) {
        appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    }
    [appDelegate.serverWebSocket moveToLeave:[NSString stringWithFormat:@"%0.9f",markerUserLocation.position.latitude] andLng:[NSString stringWithFormat:@"%0.9f",markerUserLocation.position.longitude] andLat2:[NSString stringWithFormat:@"%0.9f",[[[notification.userInfo objectForKey:@"savedLoc"]objectAtIndex:0]doubleValue]] andLng2:[NSString stringWithFormat:@"%f",[[[notification.userInfo objectForKey:@"savedLoc"]objectAtIndex:1]doubleValue]]];

}
-(void)liberer:(NSNotification*)notification{
    
    NSDictionary *tmp = notification.userInfo;
    NSLog(@"Automate a detecté liberer-------:%@", tmp);
    if (appDelegate == nil) {
        appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    }
    leavePosition =[notification.userInfo objectForKey:@"savedLoc"];
    if(leavePosition.count != 0)
    [appDelegate.serverWebSocket Leave:[NSString stringWithFormat:@"%0.9f",[[[notification.userInfo objectForKey:@"savedLoc"]objectAtIndex:0]doubleValue]] andLng:[NSString stringWithFormat:@"%0.9f",[[[notification.userInfo objectForKey:@"savedLoc"]objectAtIndex:1] doubleValue]]];
}
-(void)getMyLocation:(NSNotification*)notification{
    
    NSDictionary *tmp = notification.userInfo;
    if(markerUserLocation == nil)
    {
       markerUserLocation = [[GMSMarker alloc] init];
     
    }
    //markerUserLocation.icon = [UIImage imageNamed:@"pinJeMarche.png"];
    markerUserLocation.snippet = @"MOI";
   markerUserLocation.position =CLLocationCoordinate2DMake([[[notification.userInfo objectForKey:@"myLocation"]objectAtIndex:0] doubleValue], [[[notification.userInfo objectForKey:@"myLocation"]objectAtIndex:1] doubleValue]);
    //NSLog(@"marker position: %f, %f",markerUserLocation.position.latitude,markerUserLocation.position.longitude);
    markerUserLocation.map= self.mapGoogle;
    SKCoordinateRegion region;
    NSLog(@"%f,%f",markerUserLocation.position.latitude,markerUserLocation.position.longitude);
   // region.center = CLLocationCoordinate2DMake(markerUserLocation.position.latitude, markerUserLocation.position.longitude);
    //region.zoomLevel = 15;
    //skMap.visibleRegion = region;
    //Annotation with view
    //create our view
   

}
- (void) viewDidAppear:(BOOL)animated
{
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentViewController" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self, @"lastViewController", nil]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyLocation:) name:@"MYLOCATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rien:) name:@"RIEN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rouler:) name:@"ROULER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(marcher:) name:@"MARCHER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(arretPied:) name:@"ARRETPIED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stationner:) name:@"STATIONNER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(revenir:) name:@"REVENIR" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liberer:) name:@"LIBERER" object:nil];

     NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(adjustFrame:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(adjustFrame:) name:UIKeyboardWillHideNotification object:nil];
    self.isVisible = 1;
    if(appDelegate.WTP == NO){
        //[self.homeView setHidden:YES];
    }
    [appDelegate.serverWebSocket setDelegate:self];
    
    if(appeared == 0)
    {
        // pour vérifier si l'utilisateur se gare ou s'en va
        //[self performSelector:@selector(verifStationnement) withObject:self afterDelay:DELAYFORPARKING];
        appeared = 1;
        
        // assuming your controller has identifier "privacy" in the Storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LogScreen1ViewController *privacy = (LogScreen1ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"LogScreen1ViewController"];
        
        // This is where you wrap the view up nicely in a navigation controller
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:privacy];
        
        navigationController.navigationBarHidden = YES;
        
        // And now you want to present the view in a modal fashion
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    
    //alertePleaseWaitViewController.view.alpha = 0.0;
    
    [alertePleaseWaitViewController.view removeFromSuperview];
    alertePleaseWaitViewController.view.userInteractionEnabled = NO;
    alertePleaseWaitViewController.view=nil;

    /*if (alertChooseNavigationViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        alertChooseNavigationViewController = (AlertChooseNavigationViewController*)[storyboard instantiateViewControllerWithIdentifier:@"AlertChooseNavigationViewController"];
        alertChooseNavigationViewController.view.alpha = 0.0;
    }*/
    [[SKRoutingService sharedInstance]stopNavigation];
    [[SKRoutingService sharedInstance] clearCurrentRoutes];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
     location =[locations lastObject];
    UIImageView *coloredView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 40, 45)];
    coloredView.image = [UIImage imageNamed:pinName];
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
   /* SKRouteSettings* route = [[SKRouteSettings alloc]init];
    route.startCoordinate=CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
    route.destinationCoordinate=CLLocationCoordinate2DMake(48.825583,2.3836126);
    
    [[SKRoutingService sharedInstance] calculateRoute:route];
  */
}

#pragma mark -
#pragma mark UITableViewDelegate


- (void)dismissSearchControllerWhileStayingActive {
    // Animate out the table view.
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.searchDisplayController.searchResultsTableView.alpha = 0.0;
    [UIView commitAnimations];
    [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchDisplayController.searchBar resignFirstResponder];
    [self.searchDisplayController setActive:NO animated:YES];
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView != autocompleteTableView){
    SPGooglePlacesAutocompletePlace *place = [self placeAtIndexPath:indexPath];
     NSLog(@"PLACE: %@",place);
    NSLog(@"PLACE: %@",place.name);
    destinationLocation = place.name;
   self.searchDisplayController.searchBar.frame = CGRectMake ( self.searchDisplayController.searchBar.frame.origin.x,
                                                                   self.searchDisplayController.searchBar.frame.origin.y,
                                                                   250,
                                                                   self.searchDisplayController.searchBar.frame.size.height);
        [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
        if (error) {
            SPPresentAlertViewWithErrorAndTitle(error, @"Could not map selected Place");
        } else if (placemark) {
            //[self addPlacemarkAnnotationToMap:placemark addressString:addressString];
            //[self recenterMapToPlacemark:placemark];
            [self dismissSearchControllerWhileStayingActive];
            [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
            //[self jeNavigueAction:destinationLocation];
            // on affiche l'alerte
            //self.searchDisplayController.searchBar.text = place.name;
           
            if (skobblerNavigation == nil)
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                skobblerNavigation = (SkobblerNavigationViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SkobblerNavigationViewController"];
            }
            
            //[self presentViewController:navigationMap animated:YES completion:nil];
            //[ navigationMap NavigationDeMerdre:parking.position];
            
            
            CGRect frame = skobblerNavigation.view.frame;
            frame.origin.x = frame.size.width;
            skobblerNavigation.view.frame = frame;
            
            NSLog(@"frame:%f",skobblerNavigation.view.frame.origin.x);
            if(skobblerNavigation.view.frame.origin.x  == +320)
            {
                [UIView animateWithDuration:0.4 animations:^{
                    CGRect frame = skobblerNavigation.view.frame;
                    frame.origin.x = frame.origin.x - frame.size.width;
                    skobblerNavigation.view.frame = frame;
                } completion:nil];
            }
            [self.view addSubview:skobblerNavigation.view];
            [skobblerNavigation initWithAddress:place.name];
            //if(appDelegate.navigChoice == -1){
          /*  alertChooseNavigationViewController = nil;
            if (alertChooseNavigationViewController == nil)
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    alertChooseNavigationViewController = (AlertChooseNavigationViewController*)[storyboard instantiateViewControllerWithIdentifier:@"AlertChooseNavigationViewController"];
                    alertChooseNavigationViewController.view.alpha = 0.0;
                    [alertChooseNavigationViewController.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    //self.parentController.searchDisplayController.searchBar.alpha =1.0;
                }
                alertChooseNavigationViewController.MotherController = self;
                [ alertChooseNavigationViewController initWithDestLoc:destinationLocation];
                
                //[self presentViewController:alertChooseNavigationViewController animated:YES completion:nil];
                
                // [self jeNavigueAction:destinationLocation];
                [UIView animateWithDuration:0.0
                                 animations:^{
                                     [self.view addSubview:alertChooseNavigationViewController.view];
                                     alertChooseNavigationViewController.view.alpha = 1.0;
                                     
                                 } completion:nil];
     */
        }
           
    }];
           
    }
    else{
        
    }
}
// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    MKPlacemark * myPlacemark = placemark;
    // with the placemark you can now retrieve the city name
    //  NSString *city = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
    userAddress = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
}

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
}


#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString {
    searchQuery.location = locationManager.location.coordinate;
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            SPPresentAlertViewWithErrorAndTitle(error, @"Vérifiez votre connexion internet");
        } else {
            searchResultPlaces = places;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self handleSearchForSearchString:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar isFirstResponder]) {
        // User tapped the 'clear' button.
        shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
        //[self.mapView removeAnnotation:selectedPlaceAnnotation];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    searchBar.alpha =1;
    NSLog(@"search bar taille:%f",self.searchDisplayController.searchBar.frame.size.width);
    if (shouldBeginEditing) {
        // Animate in the table view.
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        self.searchDisplayController.searchResultsTableView.alpha = 1.0;
        [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
        [UIView commitAnimations];
        //[self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    }
    NSLog(@"search bar taille after :%f",self.searchDisplayController.searchBar.frame.size.width);
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
   /* self.searchDisplayController.searchBar.frame = CGRectMake ( self.searchDisplayController.searchBar.frame.origin.x,
                                                               self.searchDisplayController.searchBar.frame.origin.y,
                                                               250,
                                                               self.searchDisplayController.searchBar.frame.size.height);*/
    [self.searchDisplayController.searchBar setFrame:CGRectMake ( self.searchDisplayController.searchBar.frame.origin.x,
                                                                 self.searchDisplayController.searchBar.frame.origin.y,
                                                                 250,
                                                                 self.searchDisplayController.searchBar.frame.size.height)];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
   
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [self.searchDisplayController.searchBar setFrame:CGRectMake ( self.searchDisplayController.searchBar.frame.origin.x,
                                                                 self.searchDisplayController.searchBar.frame.origin.y,
                                                                 250,
                                                                 self.searchDisplayController.searchBar.frame.size.height)];
    [UIView commitAnimations];

}
- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(tableView == autocompleteTableView){
        return predictions.count;
    }
    return [searchResultPlaces count];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 50;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = nil;
  
        static NSString *     cellIdentifier = @"SPGooglePlacesAutocompleteCell";
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
        cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:16.0];
        cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
        
    

    
    return cell;

}


- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    //////////// TEST debug
    [markerUserLocation setPosition:coordinate];
}


- (void)mapPannedByTouch:(UIGestureRecognizer*)gestureRecognizer {
    
    //NSLog(@"map panned by touch!");
    mapMoved = YES;
}

- (void)mapPinchedByTouch:(UIGestureRecognizer*)gestureRecognizer {
    
    //NSLog(@"map pinched by touch!");
}

- (IBAction)menuAction:(id)sender
{
    if (menuView == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        menuView = (MenuModalViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MenuModalViewController"];
        menuView.view.backgroundColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.0 alpha:0.0];
        // [menuView.closeMenuButton addTarget:self action:@selector(closeMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        //[menuView.myTableView setDelegate:self];
        //[menuView.myTableView setDataSource:self];
        
        CGRect frame = menuView.view.frame;
        frame.origin.x = frame.origin.x - frame.size.width;
        menuView.view.frame = frame;
        
        [self.view addSubview:menuView.view];
        
        //[menuView.myTableView reloadData];
    }
    
    if(menuView.view.frame.origin.x == -320)
    {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame = menuView.view.frame;
            frame.origin.x = frame.origin.x + frame.size.width;
            menuView.view.frame = frame;
        } completion:nil];
    }
}

- (IBAction)closeMenuAction:(id)sender
{
    if(menuView.view.frame.origin.x == 0)
    {
        //NSLog(@"MENU POS : %f",menuView.view.frame.origin.x);
        [UIView animateWithDuration:0.4
                         animations:^{
                             CGRect frame = menuView.view.frame;
                             frame.origin.x = frame.origin.x - frame.size.width;
                             menuView.view.frame = frame;
                         } completion:nil];
        //NSLog(@"MENU POS : %f",menuView.view.frame.origin.x);
    }
}




#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    @try
    {
        
        NSLog(@"Websocket Connected");
        
        NSString * message = [NSString stringWithFormat:@"{\"fct\" : \"join\", \"arg\" : { \"id\" : %i, \"sid\" : \"%@\" }}",appDelegate.user_id,appDelegate.user_sid];
        
        // test
        //NSString * message = [NSString stringWithFormat:@"{\"newId\" : \"foo@apila\", \"pass\" : \"bar\" }"];
        
        ////////NSString * message = [NSString stringWithFormat:@"{\"myId\" : \"foo@apila\", \"pass\" : \"bar\" }"];
        
        NSLog(@"%@",message);
        
        [webSocket send:message];
        
    }
    @catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    @finally
    {
        // Cleanup, in both success and fail cases
        //NSLog( @"In finally block");
    }
}

- (void)webSocket:(SRWebSocket *)webSocket2 didFailWithError:(NSError *)error;
{
    //[appDelegate showPleaseWait];
    
    NSLog(@":( Websocket Failed With Error %@", error);
    
    if(mode != MODENULL) [self validerAbandon:nil];
    
    //webSocket = nil;
    
    webSocket.delegate = nil;
    [webSocket close];
    
    if([self connectedToInternet])
    {
        
        /*webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://prod.apila.fr:3001"]]];
         webSocket.delegate = self;
         
         [webSocket open];*/
        
        [appDelegate.serverWebSocket connectWebSocket];
        
        
        
    }
    else
    {
        [self performSelector:@selector(reco) withObject:nil afterDelay:5];
    }
}


- (void) reco
{
    NSLog(@"RECO ");
    
    if([self connectedToInternet])
    {
        
        //webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://prod.apila.fr:3001"]]];
        //webSocket.delegate = self;
        
        //[webSocket open];
        
        [appDelegate.serverWebSocket connectWebSocket];
    }
    else
    {
        [self performSelector:@selector(reco) withObject:nil afterDelay:5];
    }
}

- (BOOL) connectedToInternet
{
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]];
    return ( URLString != NULL ) ? YES : NO;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{

}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed : %@",reason);
    //webSocket = nil;
    
    [appDelegate.serverWebSocket connectWebSocket];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1987) {
        
        if (buttonIndex ==0) {
            
            [appDelegate.serverWebSocket connectWebSocket:@"9000"];
            
        }
        if (buttonIndex ==1) {
            
            [appDelegate.serverWebSocket connectWebSocket:@"9900"];
            
        }
    }

    if(alertView.tag == 10)
    {
        //[appDelegate showPleaseWait];
        if (buttonIndex == 0)
        {
            NSLog(@"USER 0"); //////////////////////
            appDelegate.user_id = 0;
            appDelegate.user_sid = @"eb7379bc61c7f424b6c7e241a2e6c6ce";
            appDelegate.img_name = @"njk_707ee959a7da1a621ffea0942fbb9a3d.jpg";
            appDelegate.user_name = @"MATTMARA";
            
            
            /*appDelegate.user_id = 3;
             appDelegate.user_sid = @"a836d0a646ba93a7ce5f2035b9d08eec";
             appDelegate.img_name = @"njk_707ee959a7da1a621ffea0942fbb9a3d.jpg";
             appDelegate.user_name = @"TESTMATTMARA";*/
        }
        else
        {
            NSLog(@"USER 1"); //////////////////
            appDelegate.user_id = 1;
            appDelegate.user_sid = @"aa166d165e131ce10ae7b7435cb2e039";
            appDelegate.img_name = @"njk_a3b6eeb7a9edd81ef3db77bb9dbc1f7d.jpg";
            appDelegate.user_name = @"AZERTY";
        }
        
        webSocket.delegate = nil;
        [webSocket close];
        
        webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://prod.apila.fr:3001"]]];
        //webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://prod.apila.fr:9999"]]];
        
        /////////webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://37.187.144.147:9000"]]];
        webSocket.delegate = self;
        
        [webSocket open];
    }
    else if (alertView.tag == 20)
    {
        if (buttonIndex == 0)
        {
            // For error information
            NSError *error;
            
            // Create file manager
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            
            // Point to Document directory
            NSString *documentsDirectory = [NSHomeDirectory()
                                            stringByAppendingPathComponent:@"Documents"];
            // Attempt to delete the file at filePath2
            if ([fileMgr removeItemAtPath:[NSString stringWithFormat:@"%@/LOGS/logsAlgoStationnement.txt", documentsDirectory] error:&error] != YES)
                NSLog(@"Unable to delete file: %@", [error localizedDescription]);
            
            // Show contents of Documents directory
            NSLog(@"Documents directory: %@",
                  [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
            
            [appDelegate showNotif:@"LE FICHIER DES LOGS A BIEN ÉTÉ EFFACÉ" duringSec:5];
        }
    }
}

- (IBAction)showParkingList:(id)sender{
    
    
    if(apiparkView == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        apiparkView = (ApiParkViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ApiParkViewController"];
        // apiparkView.view.alpha = 0.0;
    }
    CLLocation *userLoc = [[CLLocation alloc]initWithLatitude:appDelegate.markerUserLocation.position.latitude longitude:appDelegate.markerUserLocation.position.longitude];
    if(savedParkingsArray) [apiparkView initWithParkingList:savedParkingsArray andApiway:routesApiway userLocation:userLoc ];
      CGRect frame = apiparkView.view.frame;
    frame.origin.x = frame.size.width;
    apiparkView.view.frame = frame;
    
    NSLog(@"frame:%f",apiparkView.view.frame.origin.x);
    if(apiparkView.view.frame.origin.x  == +320)
    {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame = apiparkView.view.frame;
            frame.origin.x = frame.origin.x - frame.size.width;
            apiparkView.view.frame = frame;
        } completion:nil];
    }
    [self.view addSubview:apiparkView.view];

    [apiparkView->map zoomToPolyLine];
    }


//- (NSString*) parkoEncodeThis:NS

- (NSString *)md5:(NSString*)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d
{
    if(connection == connectionAddress){
        
        responseStringAddress = [NSString stringWithFormat:@"%@%@",responseStringAddress,[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]];
        
    }
    if(([connection isEqual:parkopediaConnection])||([connection isEqual:apiwayConnection]))
    {
        [dataParko appendData:d];
    }
    if([connection isEqual:Placeconnection])
    {
        responseString = [NSString stringWithFormat:@"%@%@",responseString,[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]];

        
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    }

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   
    if(connection == connectionAddress){
        NSLog(@"RECEIVED POI : %@",responseStringAddress);
        
        @try
        {
            
            NSString* bar = [responseStringAddress stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            NSLog(@"%@", bar);
            
            NSData * data = [bar dataUsingEncoding:NSUTF8StringEncoding];
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * entries = [jsonObjects objectForKey:@"results"];
            
            NSLog(@"---- RESULT : %@",[[[[entries objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"]);
            float destLat = [[[[[entries objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] floatValue];
            float  destLng = [[[[[entries objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];
            savedDestination = [[CLLocation alloc]initWithLatitude:destLat longitude:destLng];
            appDelegate.savedDestination = savedDestination;
        }
        @catch (NSException *exception)
        {
            NSLog(@"ERROR ADRESSE INCONNUE");
            
            [appDelegate showNotif:@"ADRESSE INCONNUE, VEUILLEZ RECOMMENCER EN DONNANT PLUS DE PRÉCISIONS" duringSec:3];
        }
        
        responseStringAddress = @"";
    }
    if([connection isEqual:Placeconnection]){
        NSString* bar = [responseString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        NSLog(@"%@", bar);
        
        NSData * data = [bar dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        predictions = [jsonObjects objectForKey:@"predictions"];
        
   
       }
}

- (void)focusMapToShowApiway
{
    if(waypointsApiway.count > 0)
    {
        CLLocationCoordinate2D myLocation = ((GMSMarker *)waypointsApiway.firstObject).position;
        GMSCoordinateBounds * bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:myLocation coordinate:myLocation];
        
        for (GMSMarker * marker in waypointsApiway)
            bounds = [bounds includingCoordinate:marker.position];
        
        [self.mapGoogle animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:70.0f]];
    }
    [self.mapGoogle animateToLocation:markerUserLocation.position];
    mapMoved = NO;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:self.searchText])
    {
        [self.searchText resignFirstResponder];
        
    }
    
    return YES;
}
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        [self configureTextField:self.remoteHostStatusField imageView:self.remoteHostImageView reachability:reachability];
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];
        
        self.summaryLabel.hidden = (netStatus != ReachableViaWWAN);
        NSString* baseLabelText = @"";
        
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
        self.summaryLabel.text = baseLabelText;
    }
    
    if (reachability == self.internetReachability)
    {
        [self configureTextField:self.internetConnectionStatusField imageView:self.internetConnectionImageView reachability:reachability];
    }
    
    if (reachability == self.wifiReachability)
    {
        [self configureTextField:self.localWiFiConnectionStatusField imageView:self.localWiFiConnectionImageView reachability:reachability];
    }
}


- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            imageView.image = [UIImage imageNamed:@"stop-32.png"] ;
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            NSLog(@"net not reachable");
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            //[appDelegate hidePleaseWait];
            NSLog(@"net is reachable");
            break;
            
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            imageView.image = [UIImage imageNamed:@"Airport.png"];
             NSLog(@"net is reachable via wifi ");
            //[appDelegate showPleaseWait];
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    textField.text= statusString;
}


@end
