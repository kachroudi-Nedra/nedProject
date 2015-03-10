//
//  GoogleMapViewController.m
//  Apila
//
//  Created by Nedra Kachroudi on 19/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "GoogleMapViewController.h"

@interface GoogleMapViewController ()

@end

@implementation GoogleMapViewController
- (void)mapPannedByTouch:(UIGestureRecognizer*)gestureRecognizer {
    
    //NSLog(@"map panned by touch!");
}

- (void)mapPinchedByTouch:(UIGestureRecognizer*)gestureRecognizer {
    
    //NSLog(@"map pinched by touch!");
    //mapMoved = YES;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationTracker = [[LocationTracker alloc]init];
    self.locationTracker.delegate=self;
    [self.locationTracker startLocationTracking];
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_= [[NSMutableArray alloc]init];
    diffDistance = [[NSMutableArray alloc] init];
    CLLocationManager *locationm = [LocationTracker sharedLocationManager];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationm.location.coordinate.latitude
                                                            longitude:locationm.location.coordinate.longitude
                                                                 zoom:13];
    self.title = @"Google Maps in iOS";
    
    //Controls whether the My Location dot and accuracy circle is enabled.
    //self.mapView.myLocationEnabled = YES;
    
    //Controls the type of map tiles that should be displayed.
    self.mapView.mapType = kGMSTypeNormal;
    
    //Shows the compass button on the map
    //self.mapView.settings.compassButton = YES;
    [self.mapView setUserInteractionEnabled:YES];
    [self.mapView setMultipleTouchEnabled:YES];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mapPannedByTouch:)];
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(mapPinchedByTouch:)];
    [self.mapView addGestureRecognizer:panGestureRecognizer];
    [self.mapView addGestureRecognizer:pinchGestureRecognizer];

    //Shows the my location button on the map
   //self.mapView.settings.myLocationButton = YES;
    [self.mapView setCamera:camera];
    
    //Sets the view controller to be the GMSMapView delegate
    self.mapView.delegate = self;
    GMSmap =[[GMSMapView alloc]init];

   }

-(void)showApiway:(NSMutableArray*)apiwayArray{
    
    NSLog(@"show apiway please!");
}
-(void)showMarkers:(NSMutableArray*)markerArray{
    
    NSLog(@"show Markers please!");
}
-(void)showFakeMarkers:(NSMutableArray*)apiwayPointsArray andMap:(GMSMapView*)mapToShow{
    
    if(mapToShow){
        GMSmap=mapToShow;

    }
    else
        GMSmap =self.mapView;
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
    NSMutableArray *colorArray = [[NSMutableArray alloc]initWithObjects:[UIColor orangeColor],[UIColor blueColor],[UIColor redColor],[UIColor greenColor],[UIColor brownColor],[UIColor yellowColor],[UIColor blackColor], nil];

    for(int i=0;i<apiwayPointsArray.count;i++){
        
        NSLog(@"APIWAY: %@",[apiwayPointsArray objectAtIndex:i]);
        CLLocation  *posLocation = [[CLLocation alloc] initWithLatitude:[[apiwayPointsArray objectAtIndex:i][0]doubleValue] longitude:[[apiwayPointsArray objectAtIndex:i][1]doubleValue]];
        GMSMarker  *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(posLocation.coordinate.latitude,posLocation.coordinate.longitude);
        //marker.icon = [GMSMarker markerImageWithColor:[colorArray objectAtIndex:i]];
        marker.title = [NSString stringWithFormat:@"Point %d",i];
        marker.snippet = [NSString stringWithFormat:@"%f,%f", marker.position.latitude,marker.position.longitude];;
       // marker.map =mapToShow;
        //[apiwayPoints insertObject:marker atIndex:i];
        [apiwayLocations insertObject:posLocation atIndex:i];
        
   
    }
    //[self getRouteFromGoogleApiWithPoints:apiwayLocations andMode:@"driving" error:nil];
    
    /*GMSMarker  *marker1 = [[GMSMarker alloc] init];
    GMSMarker  *marker2 = [[GMSMarker alloc] init];
    GMSMarker  *marker3 = [[GMSMarker alloc] init];
    GMSMarker  *marker4 = [[GMSMarker alloc] init];
    GMSMarker  *marker5 = [[GMSMarker alloc] init];
    GMSMarker  *marker6 = [[GMSMarker alloc] init];
    GMSMarker  *marker7 = [[GMSMarker alloc] init];
    CLLocation  *pos1 = [[CLLocation alloc] initWithLatitude:48.8253 longitude:2.38382];
    CLLocation  *pos2 = [[CLLocation alloc] initWithLatitude:48.827 longitude:2.38605];
    CLLocation  *pos3 = [[CLLocation alloc] initWithLatitude:48.8251 longitude:2.38882];
    CLLocation  *pos4 = [[CLLocation alloc] initWithLatitude:48.8275 longitude:2.38558];
    CLLocation  *pos5 = [[CLLocation alloc] initWithLatitude:48.8261 longitude:2.38745];
    CLLocation  *pos6 = [[CLLocation alloc] initWithLatitude:48.8207 longitude:2.37786];
    CLLocation  *pos7 = [[CLLocation alloc] initWithLatitude:48.8207 longitude:2.37786];
    GMSMarker  *markerUserLocation = [[GMSMarker alloc] init];
    marker1.position = CLLocationCoordinate2DMake(48.8253,2.38382);
    marker1.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
    marker2.position = CLLocationCoordinate2DMake(48.827,2.38605);
    marker2.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    marker3.position = CLLocationCoordinate2DMake(48.8251,2.38882);
    marker3.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    marker4.position = CLLocationCoordinate2DMake(48.8275,2.38558);
    marker4.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    marker5.position = CLLocationCoordinate2DMake(48.8261,2.38745);
    marker5.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
    marker6.position = CLLocationCoordinate2DMake(48.8207,2.37786);
    marker6.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
    marker7.position = CLLocationCoordinate2DMake(48.8207,2.37786);
    marker7.icon = [GMSMarker markerImageWithColor:[UIColor brownColor]];
    [self.mapView clear];
    markerUserLocation.position = marker.position;
    marker1.map = self.mapView;
    marker2.map = self.mapView;
    marker3.map = self.mapView;
    marker4.map = self.mapView;
    marker5.map = self.mapView;
    marker6.map = self.mapView;
    marker7.map = self.mapView;
     */
   
    /*
     GMSMutablePath *path = [GMSMutablePath path];
     
     [path addCoordinate:marker1.position];
     [path addCoordinate:marker2.position];
     [path addCoordinate:marker3.position];
     [path addCoordinate:marker4.position];
     [path addCoordinate:marker5.position];
     [path addCoordinate:marker6.position];
     [path addCoordinate:marker7.position];
    
     GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
     rectangle.strokeWidth = 2.f;
     GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
     
     GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
     
     [ self.mapView moveCamera:update];
     rectangle.map =  self.mapView;
     */
    
   // [path addCoordinate:CLLocationCoordinate2DMake([[pathApiway objectAtIndex:0]doubleValue],[[pathApiway objectAtIndex:1]doubleValue])];

    
    //apiwayPoints= [[NSMutableArray alloc]initWithObjects:marker1,marker2,marker3,marker4,marker5,marker6,marker7, nil];
   
    /*for(int i=0;i<apiwayPoints.count;i++){
        
        CLLocationCoordinate2D* routeCoord  = (__bridge CLLocationCoordinate2D *)([apiwayPoints objectAtIndex:i]);
        CLLocation *routeLoc = [[CLLocation alloc]  initWithLatitude:routeCoord->latitude longitude:routeCoord->longitude];
        [apiwayLocations insertObject:routeLoc atIndex:i];
    }*/
    /* [apiwayLocations insertObject:pos1 atIndex:0];
     [apiwayLocations insertObject:pos2 atIndex:1];
     [apiwayLocations insertObject:pos3 atIndex:2];
     [apiwayLocations insertObject:pos4 atIndex:3];
     [apiwayLocations insertObject:pos5 atIndex:4];
     [apiwayLocations insertObject:pos6 atIndex:5];
     [apiwayLocations insertObject:pos7 atIndex:6];
*/
    
}
-(void)showFakeMarkers:(NSMutableArray*)apiwayPointsArray andMap:(GMSMapView*)mapToShow andRecalcul:(bool)recalcul{
    
    self.recalcul = recalcul;
    if(mapToShow){
        GMSmap=mapToShow;
        
    }
    else
        GMSmap =self.mapView;
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
    NSMutableArray *colorArray = [[NSMutableArray alloc]initWithObjects:[UIColor orangeColor],[UIColor blueColor],[UIColor redColor],[UIColor greenColor],[UIColor brownColor],[UIColor yellowColor],[UIColor blackColor], nil];
    
    for(int i=0;i<apiwayPointsArray.count;i++){
        
        NSLog(@"APIWAY: %@",[apiwayPointsArray objectAtIndex:i]);
        CLLocation  *posLocation = [[CLLocation alloc] initWithLatitude:[[apiwayPointsArray objectAtIndex:i][0]doubleValue] longitude:[[apiwayPointsArray objectAtIndex:i][1]doubleValue]];
        GMSMarker  *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(posLocation.coordinate.latitude,posLocation.coordinate.longitude);
        //marker.icon = [GMSMarker markerImageWithColor:[colorArray objectAtIndex:i]];
        marker.title = [NSString stringWithFormat:@"Point %d",i];
        marker.snippet = [NSString stringWithFormat:@"%f,%f", marker.position.latitude,marker.position.longitude];;
        // marker.map =mapToShow;
        //[apiwayPoints insertObject:marker atIndex:i];
        [apiwayLocations insertObject:posLocation atIndex:i];
        
        
    }
    [self getRouteFromGoogleApiWithPoints:apiwayLocations andMode:@"driving" error:nil];
    
    
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
                
                waypoints = [waypoints stringByAppendingString:[NSString stringWithFormat:@"%f,%f%%7C",current.coordinate.latitude,current.coordinate.longitude]];
            }
            
        }
        else{
            origin = [arrayOfPoints objectAtIndex:0];
            destination = [arrayOfPoints objectAtIndex:arrayOfPoints.count - 1];
            
            // Create the waypoints
            for(int i = 1; i < arrayOfPoints.count - 2; i++)
            {
                CLLocation* current = [arrayOfPoints objectAtIndex:i];
                
                waypoints = [waypoints stringByAppendingString:[NSString stringWithFormat:@"%f,%f%%7C",current.coordinate.latitude,current.coordinate.longitude]];
            }
        }

    CLLocation* lastWaypoint = [arrayOfPoints objectAtIndex:arrayOfPoints.count - 2];
    waypoints = [waypoints stringByAppendingString:[NSString stringWithFormat:@"%f,%f",lastWaypoint.coordinate.latitude,lastWaypoint.coordinate.longitude]];
    
    NSString *urlString =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&waypoints=%@&sensor=true&mode=%@",origin.coordinate.latitude,origin.coordinate.longitude,destination.coordinate.latitude,destination.coordinate.longitude,waypoints,mode];
    
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

- (IBAction)takeMeThere:(CLLocation*)destLoc {
    
    GMSmap =self.mapView;
    //GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:18.5203 longitude:73.8567 zoom:12];
    //_mapView =[GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
    GMSMarker *marker=[[GMSMarker alloc]init];
    CLLocationManager *locationm = [LocationTracker sharedLocationManager];
   CLLocation*  myLocation = [[CLLocation alloc] initWithCoordinate: locationm.location.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];

    marker.position=CLLocationCoordinate2DMake(myLocation.coordinate.latitude,myLocation.coordinate.longitude);
    // marker.icon=[UIImage imageNamed:@"aaa.png"] ;
    marker.groundAnchor=CGPointMake(0.5,0.5);
    GMSMarker  *markerDestination = [[GMSMarker alloc] init];
    GMSMarker  *markerUserLocation = [[GMSMarker alloc] init];
    CLLocation*  destination = [[CLLocation alloc] initWithCoordinate: destLoc.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];

    markerDestination.position = CLLocationCoordinate2DMake(destination.coordinate.latitude,destLoc.coordinate.longitude);
   // markerDestination.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
    //[self.mapView clear];
    markerUserLocation.position = marker.position;
    markerUserLocation.icon = [UIImage imageNamed:@"user_buddy.png"];
    //markerDestination.map = self.mapView;
    markerUserLocation.map=self.mapView;
    
    [waypoints_ removeAllObjects];
    [waypointStrings_ removeAllObjects];
    
    [waypoints_ addObject:markerUserLocation];
    NSString * positionString = [NSString stringWithFormat:@"%f,%f",markerUserLocation.position.latitude,markerUserLocation.position.longitude];  //
    [waypointStrings_ addObject:positionString];
    [waypoints_ addObject:markerDestination];
    NSString * positionString2 = [NSString stringWithFormat:@"%f,%f",markerDestination.position.latitude,markerDestination.position.longitude];
    [waypointStrings_ addObject:positionString2];
    NSString *sensor = @"false";
    NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
    NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters forKeys:keys];
    mds=[[MDDirectionService alloc] init];
    SEL selector = @selector(addDirections:);
    [mds setDirectionsQuery:query withSelector:selector withDelegate:self];
    
   }
- (void)addDirections:(NSDictionary *)json
{
    NSLog(@"ADD POLYLINE");
    if([[json objectForKey:@"routes"] count] > 0)
    {
        polyline.map = nil;
        polyline = nil;
        
        NSDictionary *routes = [json objectForKey:@"routes"][0];
        
        NSDictionary *route = [routes objectForKey:@"overview_polyline"];
        NSDictionary *legsApiway = [routes objectForKey:@"legs"][0];
        NSDictionary *distance = [legsApiway objectForKey:@"distance"];
        NSString* duree =[distance objectForKey:@"value"];;
        NSString* dist =[distance objectForKey:@"text"];
        _ApiwayLab.text =[NSString stringWithFormat:@"Apiway dans %lld minutes à %d m",[duree longLongValue]/60,(int)[dist doubleValue]*1000 ];
        NSString *overview_route = [route objectForKey:@"points"];
        path = [GMSPath pathFromEncodedPath:overview_route];
        
        NSLog(@"Route: %@",overview_route);
        NSLog(@"GMS PATH : %@",path);
        for(int i=0;i<path.count;i++)
        {
            NSLog(@"path %d is %f",i,[path coordinateAtIndex:i]);
            
        }
        if(path.count > 0){
            polyline = [GMSPolyline polylineWithPath:path];
            if(self.recalcul == NO){
                polyline.strokeWidth = 5.f;
                polyline.strokeColor = [UIColor colorWithRed:(135/255.0) green:(171/255.0) blue:(21/255.0) alpha:1.0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    polyline.map = GMSmap;
                });
                
                
            }
            
            [self zoomToPolyLine:path];
            // on récupère les indications avec leurs coordonnées :
            NSArray * legs = [routes objectForKey:@"legs"];
            etapes = [[legs objectAtIndex:0] objectForKey:@"steps"];
            [self.delegate  sendSteps:etapes andPolyline:polyline];
            NSLog(@"LEGS : %@",[[legs objectAtIndex:0] objectForKey:@"duration"]);
            

        }
                // self.tempsLabel.text = [NSString stringWithFormat:@"TEMPS : %@",[[[legs objectAtIndex:0] objectForKey:@"duration"] objectForKey:@"text"]];
        // self.distanceLabel.text = [NSString stringWithFormat:@"DISTANCE : %@",[[[legs objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"text"]];
        
        /*for (int i = 0; i<[etapes count]; i++)
         {
         NSLog(@"Steps : %@",[[etapes objectAtIndex:i] objectForKey:@"html_instructions"]);
         }*/
    }
    
    //[self focusMapToShowAllMarkers];
}
/********* CALL NAVIGATION MODE ****/

- (IBAction)navigateTo:(CLLocation*)destLoc {
    
    //GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:18.5203 longitude:73.8567 zoom:12];
    //_mapView =[GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
    GMSMarker *marker=[[GMSMarker alloc]init];
    CLLocationManager *locationm = [LocationTracker sharedLocationManager];
    marker.position=CLLocationCoordinate2DMake(locationm.location.coordinate.latitude,locationm.location.coordinate.longitude);
    // marker.icon=[UIImage imageNamed:@"aaa.png"] ;
    marker.groundAnchor=CGPointMake(0.5,0.5);
    GMSMarker  *markerDestination = [[GMSMarker alloc] init];
    GMSMarker  *markerUserLocation = [[GMSMarker alloc] init];
    markerDestination.position = CLLocationCoordinate2DMake(destLoc.coordinate.latitude,destLoc.coordinate.longitude);
    // markerDestination.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
    //[self.mapView clear];
    markerUserLocation.position = marker.position;
    //markerDestination.map = self.mapView;
    //markerUserLocation.map=self.mapView;
    
    [waypoints_ removeAllObjects];
    [waypointStrings_ removeAllObjects];
    
    [waypoints_ addObject:markerUserLocation];
    NSString * positionString = [NSString stringWithFormat:@"%f,%f",markerUserLocation.position.latitude,markerUserLocation.position.longitude];  //
    [waypointStrings_ addObject:positionString];
    [waypoints_ addObject:markerDestination];
    NSString * positionString2 = [NSString stringWithFormat:@"%f,%f",markerDestination.position.latitude,markerDestination.position.longitude];
    [waypointStrings_ addObject:positionString2];
    NSString *sensor = @"false";
    NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
    NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters forKeys:keys];
    mds=[[MDDirectionService alloc] init];
    SEL selector = @selector(addNavigation:);
    [mds setDirectionsQuery:query withSelector:selector withDelegate:self];
    
}
/********* START NAVIGATION  ****/
-(NSString *) stringByStrippingHTML:(NSString *)s
{
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (BOOL) isOnLineLat1:(double) lat1 andLng1 : (double) lng1 andLat2 : (double) lat2 andLng2 : (double) lng2 andLatP : (double) latP andLngP : (double) lngP
{
    double distance1P = sqrt(  pow((lat1 - latP), 2)   +   pow((lng1 - lngP), 2)  );
    double distance2P = sqrt(  pow((lat2 - latP), 2)   +   pow((lng2 - lngP), 2)  );
    double distance12 = sqrt(  pow((lat1 - lat2), 2)   +   pow((lng1 - lng2), 2)  );
    
    //NSLog(@"\n\n1 <-> P + 2 <-> P = %f\n1 <-> 2 = %f\n",distance1P+distance2P,distance12);
    
    if ((distance12 < ((distance1P+distance2P)+0.001))&&(distance12 > ((distance1P+distance2P)-0.001)))
    {
        NSLog(@"YES");
        return YES;
    }
    else return NO;
    NSLog(@"NO");
}


- (void)addNavigation:(NSDictionary *)json
{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    NSLog(@"ADD POLYLINE");
    GMSMarker  *markerUserLocation = [[GMSMarker alloc] init];
    markerUserLocation.position = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude);
    [locationManager startUpdatingHeading];
    // markerDestination.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
    //[self.mapView clear];
    if([[json objectForKey:@"routes"] count] > 0)
    {
        polyline.map = nil;
        polyline = nil;
        // on met la prochaine étape à 0
        prochaineEtape = 0;
        etapefounded = 0;

        NSDictionary *routes = [json objectForKey:@"routes"][0];
        
        // on récupère les indications avec leurs coordonnées :
        [GMSmap animateToLocation:locationManager.location.coordinate];
        [GMSmap animateToViewingAngle:50];
        [GMSmap animateToZoom:17.5];
        
    
        NSDictionary *route = [routes objectForKey:@"overview_polyline"];
        NSString *overview_route = [route objectForKey:@"points"];
        GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
        
        // on construit la nouvelle polyline
        polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeWidth = 10.f;
        polyline.strokeColor = [UIColor blackColor];
        polyline.map = GMSmap;
        
        // on récupère les indications avec leurs coordonnées :
        NSArray * legs = [routes objectForKey:@"legs"];
        etapes = [[legs objectAtIndex:0] objectForKey:@"steps"];
        
        // on regarde à quel niveau se trouve l'user (sur quel segment)
        
        int segmentIndex = 0;
        BOOL onLine = NO;
        
        for(segmentIndex = 0; segmentIndex < polyline.path.count-1; segmentIndex++)
        {
            if([self isOnLineLat1:[polyline.path coordinateAtIndex:segmentIndex].latitude andLng1:[polyline.path coordinateAtIndex:segmentIndex].longitude andLat2:[polyline.path coordinateAtIndex:segmentIndex+1].latitude andLng2:[polyline.path coordinateAtIndex:segmentIndex+1].longitude andLatP:[locationManager location].coordinate.latitude andLngP:[locationManager location].coordinate.longitude])
            {
                onLine = YES;
                break;
            }
        }
        
        // s'il est sur un segment
        if(onLine == YES)
        {
            // on efface les segments précédents
            int effaceIndex = 0;
            
            GMSMutablePath* newPath = [[GMSMutablePath alloc] initWithPath:polyline.path];
            
            for(effaceIndex = 0; effaceIndex<segmentIndex; effaceIndex++)
            {
                [newPath removeCoordinateAtIndex:effaceIndex];
            }
            
            polyline.map = nil;
            polyline = nil;
            polyline = [GMSPolyline polylineWithPath:newPath];
            polyline.strokeWidth = 10.f;
            polyline.strokeColor = [UIColor blackColor];
            polyline.map =GMSmap;
        }
        
        NSLog(@"PROCHAINE ETAPE : %i",prochaineEtape);
        
        // on positionne la carte dans le sens du premier segment
        double lat1 = [polyline.path coordinateAtIndex:0].latitude;
        double lng1 = [polyline.path coordinateAtIndex:0].longitude;
        double lat2 = [polyline.path coordinateAtIndex:1].latitude;
        double lng2 = [polyline.path coordinateAtIndex:1].longitude;
        double dLon = (lng2-lng1);
        double y = sin(dLon) * cos(lat2);
        double x = cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(dLon);
        double brng = RADIANS_TO_DEGREES(atan2(y, x));
        [GMSmap animateToBearing:brng];
        
        // on affiche la première instruction
        indicationNavig = [self stringByStrippingHTML:[[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"html_instructions"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""]];
        [self.delegate sendInstructions:indicationNavig];
        // on affiche la distance à la prochaine étape
        CLLocation * newLocation = [[CLLocation alloc] initWithLatitude:markerUserLocation.position.latitude longitude:markerUserLocation.position.longitude];
        CLLocation * oldLocation = [[CLLocation alloc] initWithLatitude:[[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"start_location"] objectForKey:@"lat"] floatValue] longitude:[[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"start_location"] objectForKey:@"lng"] floatValue]];
        if ([newLocation distanceFromLocation:oldLocation] < 1000) indicationNavig = [NSString stringWithFormat:@"%i m",(int)[newLocation distanceFromLocation:oldLocation]];
        else indicationNavig = [NSString stringWithFormat:@"%0.2f km",((float)[newLocation distanceFromLocation:oldLocation])/1000];
        //[self.delegate sendInstructions:indicationNavig];
        // on affiche les prochaines indications
        //self.navigIndicationView.hidden = NO;
        
        [GMSmap animateToLocation:markerUserLocation.position];
        //mapMoved = NO;
        [GMSmap animateToViewingAngle:50];
        [GMSmap animateToZoom:17.5];
    }
/*}
else
{
    // on met la prochaine étape à 0
    prochaineEtape = 0;
    etapefounded = 0;
    
    // on efface les polylines
    polyline.map = nil;
    polyline = nil;
    
    //NSDictionary *routes = [json objectForKey:@"routes"][0];
    
    //NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    //NSString *overview_route = [route objectForKey:@"points"];
    //GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    
    // on construit la nouvelle polyline
    polyline = [apiwayPolylines firstObject];
    polyline.strokeWidth = 10.f;
    polyline.strokeColor = [UIColor blackColor];
    polyline.map = self->map.mapView;
    
    // on récupère les indications avec leurs coordonnées :
    //NSArray * legs = [routes objectForKey:@"legs"];
    //etapes = [[legs objectAtIndex:0] objectForKey:@"steps"];
    
    // on regarde à quel niveau se trouve l'user (sur quel segment)
    
    int segmentIndex = 0;
    BOOL onLine = NO;
    
    for(segmentIndex = 0; segmentIndex < polyline.path.count-1; segmentIndex++)
    {
        if([self isOnLineLat1:[polyline.path coordinateAtIndex:segmentIndex].latitude andLng1:[polyline.path coordinateAtIndex:segmentIndex].longitude andLat2:[polyline.path coordinateAtIndex:segmentIndex+1].latitude andLng2:[polyline.path coordinateAtIndex:segmentIndex+1].longitude andLatP:[locationManager location].coordinate.latitude andLngP:[locationManager location].coordinate.longitude])
        {
            onLine = YES;
            break;
        }
    }
    
    // s'il est sur un segment
    if(onLine == YES)
    {
        // on efface les segments précédents
        int effaceIndex = 0;
        
        GMSMutablePath* newPath = [[GMSMutablePath alloc] initWithPath:polyline.path];
        
        for(effaceIndex = 0; effaceIndex<segmentIndex; effaceIndex++)
        {
            [newPath removeCoordinateAtIndex:effaceIndex];
        }
        
        polyline.map = nil;
        polyline = nil;
        polyline = [GMSPolyline polylineWithPath:newPath];
        polyline.strokeWidth = 10.f;
        polyline.strokeColor = [UIColor blackColor];
        polyline.map = self->map.mapView;
    }
    
    NSLog(@"PROCHAINE ETAPE : %i",prochaineEtape);
    
    // on positionne la carte dans le sens du premier segment
    double lat1 = [polyline.path coordinateAtIndex:0].latitude;
    double lng1 = [polyline.path coordinateAtIndex:0].longitude;
    double lat2 = [polyline.path coordinateAtIndex:1].latitude;
    double lng2 = [polyline.path coordinateAtIndex:1].longitude;
    double dLon = (lng2-lng1);
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(dLon);
    double brng = RADIANS_TO_DEGREES(atan2(y, x));
    [self->map.mapView animateToBearing:brng];
    
    // on affiche la première instruction
    self.navigIndicationLabel1.text = [self stringByStrippingHTML:[[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"html_instructions"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""]];
    
    // on affiche la distance à la prochaine étape
    CLLocation * newLocation = [[CLLocation alloc] initWithLatitude:markerUserLocation.position.latitude longitude:markerUserLocation.position.longitude];
    CLLocation * oldLocation = [[CLLocation alloc] initWithLatitude:[[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"start_location"] objectForKey:@"lat"] floatValue] longitude:[[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"start_location"] objectForKey:@"lng"] floatValue]];
    if ([newLocation distanceFromLocation:oldLocation] < 1000) self.navigIndicationLabelM.text = [NSString stringWithFormat:@"%i m",(int)[newLocation distanceFromLocation:oldLocation]];
    else self.navigIndicationLabelM.text = [NSString stringWithFormat:@"%0.2f km",((float)[newLocation distanceFromLocation:oldLocation])/1000];
    
    // on affiche les prochaines indications
    self.navigIndicationView.hidden = NO;
    
    [self->map.mapView animateToLocation:markerUserLocation.position];
    mapMoved = NO;
    [self->map.mapView animateToViewingAngle:50];
    [self->map.mapView animateToZoom:17.5];
}
*/


}

-(void)zoomToPolyLine
{
    
    //[self focusMapToShowAllMarkers:apiwayPoints];

    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    
    [GMSmap animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:50.0f]];

  }
-(void)zoomToPolyLine:(GMSPath*)path
{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [GMSmap moveCamera:update];
    
}
- (void)focusMapToShowAllMarkers:(NSMutableArray*)markerArray
{
    //NSMutableArray * markerArray = [[NSMutableArray alloc] init];
    //    [markerArray insertObject:markerUserLocation atIndex:0];
    //  [markerArray insertObject:markerDestination atIndex:1];
    
    if(markerArray.count > 0)
    {
        CLLocationCoordinate2D myLocation = ((GMSMarker *)markerArray.firstObject).position;
        GMSCoordinateBounds * bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:myLocation coordinate:myLocation];
        
        for (GMSMarker * marker in markerArray)
            bounds = [bounds includingCoordinate:marker.position];
        
        [GMSmap animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:50.0f]];
    }
    
    // mapMoved = NO;
}


- (void) updatePlace{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getResponse:(NSString*)url{
    
    //NSString *post2 = [NSString stringWithFormat:@"address=%@&sensor=true",[[destinationLocation stringByReplacingOccurrencesOfString:@" " withString:@"+"] urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"REQUEST ADRESSE : %@",post2);
    
    NSMutableURLRequest * request2 = [[NSMutableURLRequest alloc] init];
    [request2 setURL:[NSURL URLWithString:url]];
    [request2 setHTTPMethod:@"GET"];
    
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request2 delegate:self];
    
    [connection start];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d
{
    responseString = [NSString stringWithFormat:@"%@%@",responseString,[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]];

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
    NSLog(@"RECEIVED POI : %@",responseString);
    
    
    NSString* bar = [responseString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    NSLog(@"%@", bar);
    
    NSData * data = [bar dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"JSON DIct: %@", jsonObjects);

        [self addDirections:jsonObjects];

        
       responseString = @"";
   }

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    // on affiche l'icône user
    if(markerUserLocation == nil)
    {
        markerUserLocation = [[GMSMarker alloc] init];
        markerUserLocation.icon = [UIImage imageNamed:@"pinEmplacementPlace.png"];
        markerUserLocation.map = GMSmap;
    }
    
 
        if(etapes.count > 0)
        {
            // on enregistre la distance par rapport à la dernière étape
            if(prochaineEtape > 1)
            {
                CLLocationCoordinate2D nextCoordEtape;
                nextCoordEtape.latitude = lastEtapeLat;
                nextCoordEtape.longitude = lastEtapeLng;
                CLLocation * userLoc = [[CLLocation alloc] initWithCoordinate:markerUserLocation.position altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                CLLocation * lastEtapeLoc = [[CLLocation alloc] initWithCoordinate:nextCoordEtape altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                
                distLastEtape = [userLoc distanceFromLocation:lastEtapeLoc];
            }
            
            NSLog(@"ALGO 1");
            /* algo 1
             
             On regarde le premier segment de la polyline.
             Si l'user n'est pas dessus, on supprime ce premier segment de la polyline.
             Donc le segment suivant devient le premier segment.
             
             Ex : si je suis sur le 3 ème segment.
             - permier mesure : le 1er segment est supprimé
             - deuxième mesure : le 2 ème segment est supprimé
             - 3 ème mesure : on est sur le troisième segment, on le laisse
             */
            
            // si l'user n'est plus sur le premier segment, on supprime le segment
            if([self isOnLineLat1:[polyline.path coordinateAtIndex:0].latitude andLng1:[polyline.path coordinateAtIndex:0].longitude andLat2:[polyline.path coordinateAtIndex:1].latitude andLng2:[polyline.path coordinateAtIndex:1].longitude andLatP:markerUserLocation.position.latitude andLngP:markerUserLocation.position.longitude]==NO)
            {
                NSLog(@"REMOVE SEGMENT");
                GMSMutablePath* newPath = [[GMSMutablePath alloc] initWithPath:polyline.path];
                [newPath removeCoordinateAtIndex:0];
                
                polyline.map = nil;
                polyline = nil;
                polyline = [GMSPolyline polylineWithPath:newPath];
                polyline.strokeWidth = 10.f;
                polyline.strokeColor = [UIColor blackColor];
                polyline.map = GMSmap;
            }
            
            NSLog(@"ALGO 2");
            /* Algo 2 :
             
             On regarde si on est sur la polyline.
             On parcours tous les segments de la polyline et on regarde si on est au moins proche de l'un d'entre eux
             Si on est proche d'aucun segment, on recalcule le chemin
             
             */
            
            // on regarde si l'user se trouve sur la ligne
            BOOL onLine = NO;
            for (int i = 0; i < polyline.path.count-1; i++)
            {
                if([self isOnLineLat1:[polyline.path coordinateAtIndex:i].latitude andLng1:[polyline.path coordinateAtIndex:i].longitude andLat2:[polyline.path coordinateAtIndex:i+1].latitude andLng2:[polyline.path coordinateAtIndex:i+1].longitude andLatP:markerUserLocation.position.latitude andLngP:markerUserLocation.position.longitude])
                {
                    onLine = YES;
                    
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
                    
                    [GMSmap animateToBearing:[self getHeadingForDirectionFromCoordinate:loc1 toCoordinate:loc2]];
                    
                    NSLog(@"BEARING 1 : %f, BEARING 2 : %f, SEGMENT %i, POLYCOUNT : %i",brng,[self getHeadingForDirectionFromCoordinate:loc1 toCoordinate:loc2],i,polyline.path.count);
                    
                    break;
                }
            }
            
            NSLog(@"ONLINE : %hhd",onLine);
            
            if(!onLine)
            {
                // on affiche l'alerte
                if (alertePleaseWaitViewController == nil)
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    alertePleaseWaitViewController = (AlertePleaseWaitViewController*)[storyboard instantiateViewControllerWithIdentifier:@"AlertePleaseWaitViewController"];
                    alertePleaseWaitViewController.view.alpha = 0.0;
                }
                
                [UIView animateWithDuration:0.4
                                 animations:^{
                                     [self.view addSubview:alertePleaseWaitViewController.view];
                                     alertePleaseWaitViewController.view.alpha = 1.0;
                                 } completion:nil];
                
                [self performSelector:@selector(recalculerItineraire) withObject:nil afterDelay:1.0];
            }
        }
        
        NSLog(@"ALGO 3");
        /* Algo 3 :
         
         Si la distance avec les dernières coordonnées enregistrée est > à 10 m
         On utilise les dernieres coordonnées et les coordonnées actuelles pour diriger la carte
         
         */
        
        CLLocationCoordinate2D nextCoord;
        nextCoord.latitude = lastLat;
        nextCoord.longitude = lastLng;
        CLLocation * newLocation = [[CLLocation alloc] initWithCoordinate:markerUserLocation.position altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
        CLLocation * oldLocation = [[CLLocation alloc] initWithCoordinate:nextCoord altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
        
        // Direction de la map en fonction des coordonnées tous les 10 metres
        if(([newLocation distanceFromLocation:oldLocation]) > 10)
        {
            double lat1 = lastLat;
            double lng1 = lastLng;
            
            double lat2 = location.coordinate.latitude;
            double lng2 = location.coordinate.longitude;
            
            double dLon = (lng2-lng1);
            double y = sin(dLon) * cos(lat2);
            double x = cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(dLon);
            double brng = RADIANS_TO_DEGREES(atan2(y, x));
            //brng = (360 - (fmod((brng + 360), 360)));
            
            NSLog(@"BEARING : %f",brng);
            //[appDelegate showNotif:[NSString stringWithFormat:@"BEARING DIST : %f",[newLocation distanceFromLocation:oldLocation]] duringSec:3.0];
            
            ///[self.mapGoogle animateToBearing:brng];
            
            lastLat = location.coordinate.latitude;
            lastLng = location.coordinate.longitude;
        }
        
        NSLog(@"ALGO 4");
        /* Algo 4 :
         
         On regarde si l'user est proche de l'une des 5 prochaines étapes
         Si c'est le cas, "prochaineEtape" devient l'étape par rapport à laquelle l'user est le plus proche + 1
         
         */
        
        // chargement de la prochaine etape
        if(etapes.count > 0)
        {
            // on regarde si on est proche de l'une des 5 prochaines étapes
            for(int i = prochaineEtape; i < prochaineEtape+5; i++)
            {
                if(etapes.count > i)
                {
                    CLLocationCoordinate2D nextCoord;
                    nextCoord.latitude = [[[[etapes objectAtIndex:i] objectForKey:@"start_location"] objectForKey:@"lat"] floatValue];
                    nextCoord.longitude = [[[[etapes objectAtIndex:i] objectForKey:@"start_location"] objectForKey:@"lng"] floatValue];
                    
                    CLLocationCoordinate2D nextCoordEnd;
                    double lat1 = [polyline.path coordinateAtIndex:polyline.path.count-1].latitude;
                    double lng1 = [polyline.path coordinateAtIndex:polyline.path.count-1].longitude;
                    nextCoordEnd.latitude = lat1;
                    nextCoordEnd.longitude = lng1;
                    
                    CLLocation * newLocation = [[CLLocation alloc] initWithCoordinate:markerUserLocation.position altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                    CLLocation * oldLocation = [[CLLocation alloc] initWithCoordinate:nextCoord altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                    CLLocation * oldLocationEND = [[CLLocation alloc] initWithCoordinate:nextCoordEnd altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                    
                    NSLog(@"\n\nETAPE : %i \nETAPE COUNT : %i \nDISTANCE LASR : %f metres\n\n",i,etapes.count,distLastEtape);
                    
                    // si on est à moins de 25 m de la prochaine étape
                    /////////////////////////
                    if([newLocation distanceFromLocation:oldLocation] <= 25)/*||((lastDist < [newLocation distanceFromLocation:oldLocation])&&((prochaineEtape == 0))))*/
                    {
                        lastEtapeLat = [[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"start_location"] objectForKey:@"lat"] floatValue]; /////////
                        lastEtapeLng = [[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"start_location"] objectForKey:@"lng"] floatValue]; /////////
                        
                        prochaineEtape = i+1;
                        
                        if(etapes.count > prochaineEtape) indicationNavig = [[self stringByStrippingHTML:[[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"html_instructions"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""]] stringByReplacingOccurrencesOfString:@"Traverser le rond-point" withString:@""];
                    }
                    
                    
                    // si on vient de dépassé la dernière étape de plus de 25 m /////////////
                    /*if ((distLastEtape != 0)&&(distLastEtape > 25))
                     {
                     if(etapes.count > prochaineEtape) self.indicationLabel.text = [[self stringByStrippingHTML:[[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"html_instructions"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""]] stringByReplacingOccurrencesOfString:@"Traverser le rond-point" withString:@""];
                     
                     distLastEtape = 0;
                     }*/
                }
                else /////////// PROBLEME ICI ////////////
                {
                    CLLocationCoordinate2D nextCoordEnd;
                    double lat1 = [polyline.path coordinateAtIndex:polyline.path.count-1].latitude;
                    double lng1 = [polyline.path coordinateAtIndex:polyline.path.count-1].longitude;
                    nextCoordEnd.latitude = lat1;
                    nextCoordEnd.longitude = lng1;
                    CLLocation * oldLocationEND = [[CLLocation alloc] initWithCoordinate:nextCoordEnd altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                    
                    //self.indicationLabel.text = @"Vous approchez de votre destination.";
                    //self.indicationLabel.text = [self stringByStrippingHTML:[[[[etapes lastObject] objectForKey:@"html_instructions"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""]];
                    
                    if ( [newLocation distanceFromLocation:oldLocationEND] < 1000) indicationNavig = [NSString stringWithFormat:@"%i m",(int)[newLocation distanceFromLocation:oldLocationEND]];
                    else indicationNavig = [NSString stringWithFormat:@"%0.2f km",((float)[newLocation distanceFromLocation:oldLocationEND])/1000];
                    
                    //self.arrowImg.hidden = YES;
                    
                    NSLog(@"DISTANCE END : %f m",[newLocation distanceFromLocation:oldLocationEND]);
                    if([newLocation distanceFromLocation:oldLocationEND] <= 50)
                    {
                        indicationNavig = @"Vous êtes arrivé";
                        
                        /*AVSpeechSynthesizer * synthesizer = [[AVSpeechSynthesizer alloc]init];
                         AVSpeechUtterance * utterance;
                         
                         utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"%@",self.indicationLabel.text]];
                         
                         [utterance setRate:0.25f];
                         [synthesizer speakUtterance:utterance];*/
                        
                        //roule = 0;
                        
                        /*self.chercherNotifView.userInteractionEnabled = YES;
                        [UIView animateWithDuration:0.4
                                         animations:^{
                                             self.chercherNotifView.alpha = 1.0;
                                         } completion:nil];
                         
                        
                        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
                        {
                            [appDelegate showNotif:[NSString stringWithFormat:@"Vous êtes proche de votre destination."] duringSec:3];
                        }
                        
                        self.boutonChercher.alpha = 1.0;
                        self.boutonChercher.userInteractionEnabled = YES;
                        
                        [self performSelector:@selector(hideNotifView) withObject:nil afterDelay:10.0];
                        
                        
                         */
                        ////////// TEST DEMARRAGE JC
                        //[self actionJeCherche:nil];
                        //self.parentController.navigIndicationView.alpha = 0.0;
                    }
                }
            }
            
            NSLog(@"ALGO 5");
            /* Algo 5 :
             
             On regarde les 5 dernières distances par rapport à la prochaine étape augmente.
             
             Si elle augmente 5 fois de suite, on considère qu'on s'éloigne et que la bonne prochaine étape est la suivante
             
             */
            if(etapes.count > prochaineEtape)
            {
                CLLocationCoordinate2D nextCoord;
                nextCoord.latitude = [[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"start_location"] objectForKey:@"lat"] floatValue];
                
                nextCoord.longitude = [[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"start_location"] objectForKey:@"lng"] floatValue];
                
                CLLocation * newLocation = [[CLLocation alloc] initWithCoordinate:markerUserLocation.position altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                CLLocation * oldLocation = [[CLLocation alloc] initWithCoordinate:nextCoord altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                
                // on regarde si on a enregstré les 5 dernières distances vers la prochaine étape, et si on est au début du parcours
                if ((diffDistance.count > 5)&&(prochaineEtape < 5))
                {
                    BOOL positive = YES;
                    
                    // on parcours le tableau des 5 dernières distances
                    for (int j = 0; j < diffDistance.count-1; j++)
                    {
                        NSLog(@"COUNT : %i, DIFF DISTANCE : %f",[diffDistance count],[[diffDistance objectAtIndex:j+1] floatValue] - [[diffDistance objectAtIndex:j] floatValue]);
                        
                        // si l'un des intervales entre les 5 dernières distances est négatif c'est qu'on ne s'éloigne pas de la prochaine étapes
                        if([[diffDistance objectAtIndex:j+1] floatValue] - [[diffDistance objectAtIndex:j] floatValue] < 0.500)
                        {
                            positive = NO;
                            break;
                        }
                    }
                    
                    // si il n'y a que des valeurs positives, c'est que la distance n'a fait qu'augmenter, on passe à l'étape suivante
                    // si la distance augmente 5 fois de suite, on passe à l'étape suivante
                    if(positive == YES)
                    {
                        lastEtapeLat = [[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"start_location"] objectForKey:@"lat"] floatValue]; /////////
                        lastEtapeLng = [[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"start_location"] objectForKey:@"lng"] floatValue]; /////////
                        
                        prochaineEtape = prochaineEtape + 1;
                        
                        nextCoord.latitude = [[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"start_location"] objectForKey:@"lat"] floatValue];
                        
                        nextCoord.longitude = [[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"start_location"] objectForKey:@"lng"] floatValue];
                        
                        newLocation = [[CLLocation alloc] initWithCoordinate:markerUserLocation.position altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                        oldLocation = [[CLLocation alloc] initWithCoordinate:nextCoord altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                        
                        /*GMSMarker * markerGuides = [[GMSMarker alloc] init];
                         markerGuides.position = nextCoord;
                         markerGuides.title = [NSString stringWithFormat:@"Etape %i",prochaineEtape];
                         markerGuides.map = self.mapGoogle;*/
                        
                        if(etapes.count-1 > prochaineEtape)
                        {
                            indicationNavig = [[self stringByStrippingHTML:[[[[etapes objectAtIndex:prochaineEtape] objectForKey:@"html_instructions"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""]] stringByReplacingOccurrencesOfString:@"Traverser le rond-point" withString:@""];
                            
                            if ( [newLocation distanceFromLocation:oldLocation] < 1000) indicationNavig = [NSString stringWithFormat:@"%i m",(int)[newLocation distanceFromLocation:oldLocation]];
                            else indicationNavig = [NSString stringWithFormat:@"%0.2f km",((float)[newLocation distanceFromLocation:oldLocation])/1000];
                        }
                        else
                        {///////////////// TEST Vous êtes arrivé 1
                            
                            CLLocationCoordinate2D nextCoordEnd;
                            double lat1 = [polyline.path coordinateAtIndex:polyline.path.count-1].latitude;
                            double lng1 = [polyline.path coordinateAtIndex:polyline.path.count-1].longitude;
                            nextCoordEnd.latitude = lat1;
                            nextCoordEnd.longitude = lng1;
                            CLLocation * oldLocationEND = [[CLLocation alloc] initWithCoordinate:nextCoordEnd altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                            
                            //self.indicationLabel.text = @"Vous approchez de votre destination.";
                            //self.indicationLabel.text = [self stringByStrippingHTML:[[[[etapes lastObject] objectForKey:@"html_instructions"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""]];
                            
                            if ( [newLocation distanceFromLocation:oldLocationEND] < 1000) indicationNavig = [NSString stringWithFormat:@"%i m",(int)[newLocation distanceFromLocation:oldLocationEND]];
                            else indicationNavig = [NSString stringWithFormat:@"%0.2f km",((float)[newLocation distanceFromLocation:oldLocationEND])/1000];
                            
                            NSLog(@"DISTANCE END : %f m",[newLocation distanceFromLocation:oldLocationEND]);
                            if([newLocation distanceFromLocation:oldLocationEND] <= 50)
                            {
                                indicationNavig = @"Vous êtes arrivé";
                                
                                //roule = 0;
                                
                               /* self.chercherNotifView.userInteractionEnabled = YES;
                                [UIView animateWithDuration:0.4
                                                 animations:^{
                                                     self.chercherNotifView.alpha = 1.0;
                                                 } completion:nil];
                                */
                                
                                if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
                                {
                                    //[appDelegate showNotif:[NSString stringWithFormat:@"Vous êtes proche de votre destination."] duringSec:3];
                                }
                                
                                //self.boutonChercher.alpha = 1.0;
                                //self.boutonChercher.userInteractionEnabled = YES;
                                
                               // [self performSelector:@selector(hideNotifView) withObject:nil afterDelay:7.0];
                                
                                
                                ////////// TEST DEMARRAGE JC
                                //[self actionJeCherche:nil];
                                //self.parentController.navigIndicationView.alpha = 0.0;
                            }
                        }
                    }
                    
                    [diffDistance removeAllObjects];
                }
                else if (prochaineEtape < 5)
                {
                    NSLog(@"INSERT DISTANCE");
                    // sinon on insère la dernière distance
                    [diffDistance insertObject:[NSNumber numberWithFloat:[newLocation distanceFromLocation:oldLocation]] atIndex:diffDistance.count];
                }
                
                if ([indicationNavig rangeOfString:NSLocalizedString(@"gauche", nil)].location != NSNotFound)
                {
                    //self.arrowImg.image = [UIImage imageNamed:@"turn_left.png"];
                }
                else if ([indicationNavig rangeOfString:NSLocalizedString(@"droite", nil)].location != NSNotFound)
                {
                    //self.arrowImg.image = [UIImage imageNamed:@"turn_right.png"];
                }
                else if ([indicationNavig rangeOfString:NSLocalizedString(@"rond-point", nil)].location != NSNotFound)
                {
                    //self.arrowImg.image = [UIImage imageNamed:@"rond_point.png"];
                }
                else
                {
                   // self.arrowImg.image = [UIImage imageNamed:@"go.png"];
                }
                
                if ( [newLocation distanceFromLocation:oldLocation] < 1000) indicationNavig = [NSString stringWithFormat:@"%i m",(int)[newLocation distanceFromLocation:oldLocation]];
                else indicationNavig = [NSString stringWithFormat:@"%0.2f km",((float)[newLocation distanceFromLocation:oldLocation])/1000];
                //lastDist = [newLocation distanceFromLocation:oldLocation];
            }
            
            NSLog(@"ALGO 6");
            /* Algo 6 :
             
             si on s'approche de la prochaine étape on l'annonce avec la synthèse vocale
             
             */
            
            if ((((self.speed > 100/3.6) && ([newLocation distanceFromLocation:oldLocation] < 1500) && (hasSpoken2 != prochaineEtape))))
            {
                AVSpeechSynthesizer * synthesizer = [[AVSpeechSynthesizer alloc]init];
                AVSpeechUtterance * utterance;
                
                /*if ( [newLocation distanceFromLocation:oldLocation] < 1000)
                 {
                 utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"Dans %@, %@",[NSString stringWithFormat:@"%i m",(int)[newLocation distanceFromLocation:oldLocation]],self.indicationLabel.text]];
                 }
                 else
                 {
                 utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"Dans %@, %@",[NSString stringWithFormat:@"%0.2f km",((float)[newLocation distanceFromLocation:oldLocation])/1000],self.indicationLabel.text]];
                 }*/
                
                utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"Dans %@, %@",indicationNavig,indicationNavig]];
                
                [utterance setRate:0.25f];
                [synthesizer speakUtterance:utterance];
                hasSpoken2 = prochaineEtape;
            }
            
            if ((((self.speed > 100/3.6) && ([newLocation distanceFromLocation:oldLocation] < 500) && (hasSpoken != prochaineEtape)))
                ||(((self.speed > 50/3.6) && ([newLocation distanceFromLocation:oldLocation] < 200) && (hasSpoken != prochaineEtape)))
                ||(((self.speed > 10/3.6) && ([newLocation distanceFromLocation:oldLocation] < 60) && (hasSpoken != prochaineEtape)))
                ||((hasSpoken != prochaineEtape) && (hasSpoken < 1)))
            {
                AVSpeechSynthesizer * synthesizer = [[AVSpeechSynthesizer alloc]init];
                AVSpeechUtterance * utterance;
                
                utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"Dans %@, %@",indicationNavig,indicationNavig]];
                
                [utterance setRate:0.25f];
                [synthesizer speakUtterance:utterance];
                hasSpoken = prochaineEtape;
            }
        }
    }
    


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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)dealloc {
       _mapView = nil;
}
@end
