//
//  DetectEvent.m
//  AutomateV4
//
//  Created by Nedra Kachroudi on 12/11/2014.
//  Copyright (c) 2014 Nedra Kachroudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetectEvent.h"
#import "AppDelegate.h"
@implementation DetectEvent

- (id)init {
    self = [super init];
    if (self) {
        mvgauArray = [[NSMutableArray alloc] init];
        mvgauArray1 = [[NSMutableArray alloc] init];
        //self.locationTracker = [[LocationTracker alloc]init];
        //self.locationTracker.delegate=self;
        self.locationManager = [[CLLocationManager alloc]init];
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
             //[self.locationManager requestAlwaysAuthorization];
        }
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
        //appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];

        //[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(WhatActionToDoit) userInfo:nil repeats:YES];
        i=0;
        counter=0;
        eventArray = [[NSMutableArray alloc]initWithCapacity:3];
        /************************* CHECK OF LAST CONNECTION OF USER ********************/
        dateFormat = [[NSDateFormatter alloc] init];
        NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Europe/Budapest"];
        [dateFormat setDateFormat:@"yyyy-MM-d HH:mm:ss Z"];
        [dateFormat setTimeZone:tz];
        //[self getLastDate];
        //[self saveDate];
        yesterday = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
        NSString *dateString = [dateFormat stringFromDate:yesterday];
        NSDate *yesterday1 = [dateFormat dateFromString:dateString];
        NSLog(@"date hier:  %@",yesterday1);

        userInformation =[[UserInformationData alloc]init];
         NSDate *today=[NSDate date];
         NSString *theDate = [dateFormat stringFromDate:today];
         NSLog(@"date derniere connexion: %@",[dateFormat dateFromString:[userInformation readForKey:@"connectionDate"]]);

        if([userInformation readForKey:@"connectionDate"]){
       
            lastConnectionDate = [dateFormat dateFromString:[userInformation readForKey:@"connectionDate"]];
            if(lastConnectionDate && [lastConnectionDate earlierDate:yesterday]){
               
                if([userInformation readForKey:@"savedCarLocation"]){
                    
                    
                    NSArray *coordinates = [[userInformation readForKey:@"savedCarLocation"] componentsSeparatedByString: @","];
                    
                    //savedLoc = [[CLLocation alloc]initWithLatitude:[ coordinates[0] floatValue] longitude:[ coordinates[1] floatValue]];
                    //[self DoIt:ac_init];
                }
            }
            else {
                
                //savedLoc = nil;
                
            }
            
       }

        [userInformation writeForKey:@"connectionDate" andValue:theDate];

        init_motor(s_demarrage);
        //[self detectAcceleration];
        Apied = YES;
        
        NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dirName = [docDir stringByAppendingPathComponent:@"LOGS"];
        
        BOOL isDir;
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:dirName isDirectory:&isDir])
        {
            if([fm createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:nil])
                NSLog(@"Directory Created");
            else
                NSLog(@"Directory Creation Failed");
        }
        else
            NSLog(@"Directory Already Exist");
        [self writeToTextFile:@"START AUTOMATE --------->\n"];
        
    }
    return self;
}
/*- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //alertePleaseWaitViewController.view.alpha = 0.0;
    myCurrentLocation = [[CLLocation alloc] initWithCoordinate: manager.location.coordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
    }
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
    
}*/
- (void)wantToPark:(NSNotification *)notification {
    NSDictionary *tmp = notification.userInfo;
    NSLog(@"------WTP handled");
    
}
-(void)saveDate{
    
    NSString *docDir1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dirName1 = [docDir1 stringByAppendingPathComponent:@"Date"];
    
    BOOL isDir1;
    NSFileManager *fm1 = [NSFileManager defaultManager];
    if(![fm1 fileExistsAtPath:dirName1 isDirectory:&isDir1])
    {
        if([fm1 createDirectoryAtPath:dirName1 withIntermediateDirectories:YES attributes:nil error:nil])
            NSLog(@"Directory Created");
        else
            NSLog(@"Directory Creation Failed");
    }
    else
        NSLog(@"Directory Already Exist");
    
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/Date/Date.txt",documentsDirectory];
    
    //create content - four lines of text
    // Convert string to date object
    NSDate* today = [[NSDate alloc] init];;
    today=[NSDate date];
    NSString *theDate = [dateFormat stringFromDate:today];
    
    NSString *content;
    content = [NSString stringWithFormat:@"%@",theDate];
    
    //save content to the documents directory
    [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
}
-(void)getLastDate{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/Date/Date.txt",documentsDirectory];
    date = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    
    // NSLog(@"DATE : %@ ",date);
    
    // si des credentials ont déjà été enregistré, on fait l'autolog
    if ((date != nil)&&(![date isEqualToString:@""]))
    {
        // Convert string to date object
        
        
        lastConnectionDate = [dateFormat dateFromString:date];
        //NSLog(@"LAST CONENCTION DATE : %@ ",lastConnectionDate);
        
    }
}

-(void) writeToTextFile:(NSString*) line
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/LOGS/logsAlgoStationnement.txt",documentsDirectory];
    
    //create content - four lines of text
    NSString *content = line;
    content = [NSString stringWithFormat:@"%@\n%@ ----- %@",[self displayContent],[NSDate date],content];
    
    //save content to the documents directory
    [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
}

- (NSString *) displayContent
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/LOGS/logsAlgoStationnement.txt", documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    
    return content;
}
- (NSString *) displayContentDate
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/Date/Date.txt", documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    
    return content;
}
/******************************** METHODES DE TEST: EVENT PAR CLICK SUR UN BOUTON **********************************/

-(void)startGPS
{
    /* self.locationTracker = [[LocationTracker alloc]init];
     
     self.locationTracker.delegate=self;
     */
    //[LocationTracker sharedLocationManager].pausesLocationUpdatesAutomatically = NO;
    [self.locationTracker startLocationTracking];
    transition = @"GPS is ON";
    //[self detectAcceleration];
    
    //gps_on=YES;
}
-(void)setGPSTimer:(double)timerGPS{
    
    GPSTimer = timerGPS;
    
}
-(void)stopGPSByTimer
{
    
    // self.locationTracker.pausesLocationUpdatesAutomatically = YES;
    [self.locationTracker stopLocationDelayBySeconds];
    [self.locationTracker startLocationByDelay:GPSTimer];
    
    transition = [NSString stringWithFormat:@"GPS is started every %f",GPSTimer] ;
    //[self startGPSWithTimer];
    
    //CLLocationManager* locationManager = [LocationTracker sharedLocationManager];
    //CLLocation *Loc = locationManager.location;
    
    //if(Loc.horizontalAccuracy < 16)
    // [self.locationTracker stopLocationTracking];
    //[NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(startGPS) userInfo:nil repeats:NO];
    
    //[self startGPS];
    ///gps_on=NO;
    
}
-(void)stopGPS{
    
    [self.locationTracker  stopLocationTracking];
    transition = [NSString stringWithFormat:@"GPS is stopped now"] ;
}
-(void)openGPS{
    
    [self.locationTracker startLocationByDelay:GPSTimer];
    transition = [NSString stringWithFormat:@"GPS is started every %f",GPSTimer] ;
}
-(void)drive {
    
    calculatedSpeed = 15;
    MGAU = 1.3;
    //VMAU = 3;
    /* if(myCurrentLocation)
     {
     myCarLocation = myCurrentLocation;
     }*/
}
-(void)stop{
    
    calculatedSpeed = 0.0;
    MGAU = 2;
    VMAU = 1;
}
-(void)walk{
    
    calculatedSpeed = 1.0;
    MGAU= 3.2;
    VMAU = 2;
}
- (void)moyen {
    ancienneDistance = nouvelleDistance;
    nouvelleDistance = nouvelleDistance+20;;

}
- (void)proche {
    ancienneDistance = nouvelleDistance;
    nouvelleDistance = nouvelleDistance-20;;
}


- (void)redirectNSLogToDocuments
{
    NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [allPaths objectAtIndex:0];
    NSString *pathForLog = [documentsDirectory stringByAppendingPathComponent:@"xcodeLog.txt"];
    
    freopen([pathForLog cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}
/******************************************** DETECTION DES EVENTS *****************************************************/

/* Cette methode doit retourner l'action à executer pour l'appli mais pour le moment pour test je retourne une string pour tester l'event
 - (action)detectEvent: (event)eventComingFromApp // Syntaxe originale
 */
- (NSString*)detectEvent {
    
   // NSLog(@"detect evennnnnnnnnnnntnntnntnnntnntntntntnt");
    lastEvent = currentEvent;
    
    //NSLog(@"DETECT EVENT");
    
    if(myCurrentLocation )
    {
        gps_stable = YES;
    }
    else
    {
        gps_stable = NO;
    }
    if(calculatedSpeed == -1)
        //[self DoITOther:ac_gps_on];
    
    
    /******************************************** DEMARRAGE *******************************************************/
    
    /*if ((!lastConnectionDate || (lastConnectionDate == yesterday)) && !gps_stable) {
        currentEvent = e_init_usageVieux_gpsN;
    }
    if ((!lastConnectionDate || (lastConnectionDate == yesterday))  && gps_stable) {
        currentEvent = e_init_usageVieux_gpsS; // event 1
    }
    if ((lastConnectionDate && (lastConnectionDate < yesterday))  && !gps_stable) {
        currentEvent = e_init_usageCourt_gpsN;
    }
    if ((lastConnectionDate || (lastConnectionDate < yesterday))  && savedLoc && !gps_stable ) {
        currentEvent = e_init_usageCourt_voit_def_gpsN;
    }
    if ((lastConnectionDate || (lastConnectionDate < yesterday))  && (OldDistance_me_car != 0) && (OldDistance_me_car > DISTANCE_MAX_ME_CAR) && gps_stable ) {
        currentEvent = e_init_usageCourt_voit_loin_gpsS;
    }
    
    if ((lastConnectionDate || (lastConnectionDate < yesterday))  && (OldDistance_me_car != 0) && (OldDistance_me_car < DISTANCE_MAX_ME_CAR) && gps_stable ) {
        currentEvent = e_init_usageCourt_voit_proche_gpsS;
    }
    
    if ((lastConnectionDate || (lastConnectionDate < yesterday))  && !myCarLocation && gps_stable ) {
        currentEvent = e_init_usageCourt_voit_indef_gpsS;
    }
     */
    /* if(gps_on) {
     currentEvent = e_gps_on;
     }
     if (!gps_on) {
     currentEvent = e_gps_off;
     }
     */
    /***************************************** GESTION DES EVENTS DE L'APPLI  ************************************/
    
    if (apiguide) {
        currentEvent = e_apiguide;
    }
    if (apiway) {
        currentEvent = e_apiway;
    }
    if (apipark) {
        currentEvent = e_apipark;
    }
    if (apipark) {
        currentEvent = e_apipark;
    }
    if (apifind) {
        currentEvent = e_apifind;
    }
    
    if(savedLoc){
        
        
        /************* ***************** ***************** ********************** TRANSITIONS    ****** ***************** ***************** *******************************/
        if(  ancienneDistance > 0 && nouvelleDistance > 0 && ancienneDistance <= DIST_PROCHE && nouvelleDistance <= DIST_PROCHE)
        {
            //NSLog(@"EGALITE.....");
            
            [self DoITOther:ac_arret_proche_voiture];
            
            
            //currentEvent =e_marche_proche_voit;
        }
        if( ancienneDistance > 0 && nouvelleDistance > 0 && ancienneDistance > DIST_PROCHE && nouvelleDistance > DIST_PROCHE && ancienneDistance <= DIST_LOIN && nouvelleDistance <= DIST_LOIN)
        {
            //NSLog(@"EGALITE.....");
            
            
            [self DoITOther:ac_arret_moyen_voiture];
            //[self DoIt:ac_marche_moyen_voiture];
            
        }
        
        if(ancienneDistance > 0 && nouvelleDistance > 0 && ancienneDistance > DIST_LOIN && nouvelleDistance > DIST_LOIN)
        {
            //NSLog(@"EGALITE.....");
            
            [self DoITOther:ac_arret_loin_voiture];
            
            //[self DoIt:ac_marche_loin_voiture];
            //currentEvent =e_marche_loin_voit;
            
        }
        
        
        // de proche à loin
        if(ancienneDistance <= DIST_PROCHE && nouvelleDistance > DIST_PROCHE && nouvelleDistance <= DIST_LOIN)
        {
            //currentEvent = e_transition_proche_moyen;
            [self DoITOther:ac_transition_proche_moyen];
        }
        if(ancienneDistance > DIST_PROCHE && ancienneDistance <= DIST_LOIN && nouvelleDistance >DIST_LOIN)
        {
            //currentEvent = e_transition_moyen_loin;
            [self DoITOther:ac_transition_moyen_loin];
            
        }
        if(ancienneDistance <= DIST_PROCHE && nouvelleDistance >DIST_LOIN)
        {
            //currentEvent = e_transition_proche_loin;
            [self DoITOther:ac_transition_proche_loin];
            
        }
        
        // de loin à proche
        
        if(ancienneDistance > DIST_LOIN && nouvelleDistance <=DIST_LOIN && nouvelleDistance > DIST_PROCHE)
        {
            //currentEvent = e_transition_loin_moyen;
            [self DoITOther:ac_transition_loin_moyen];
            
        }
        if(ancienneDistance <= DIST_LOIN && ancienneDistance > DIST_PROCHE && nouvelleDistance <=DIST_PROCHE)
        {
            //currentEvent = e_transition__moyen_proche;
            [self DoITOther:ac_transition__moyen_proche];
            
        }
        if(ancienneDistance > DIST_LOIN && nouvelleDistance <= DIST_PROCHE)
        {
            //currentEvent = e_transition_loin_proche;
            [self DoITOther:ac_transition_loin_proche];
        }
        
    }

    /***************************************** ARRET  ***************************************************************/
    
    if(MGAU < Sm && VMAU < Sa && (calculatedSpeed == 0)  && ((lastEvent != e_roule)||(lastEvent != e_arret_voit)))
    {
        currentEvent = e_arret; // event numero 20 arret
        myCarLocation=nil;
        
    }
    
    if(MGAU < Sm && VMAU < Sa && (calculatedSpeed == 0)  && ((lastEvent == e_roule) ||(lastEvent == e_arret_voit) ))
    {
        currentEvent = e_arret_voit;
        CLLocationManager* locationManager = [LocationTracker sharedLocationManager];
        savedLoc =  locationManager.location;
        
    }
    
    /***************************************** MARCHE  ***************************************************************/
    
    if(calculatedSpeed > Vss && calculatedSpeed < Vs  && MGAU > Sm && VMAU >Sa) {
        currentEvent = e_marche;
        myCarLocation=nil;
        Apied = YES;
      
    }
    
    
    /***************************************** ROULE  ***************************************************************/
    
    // il conduit lentement = vitesse entre 0,.. et 2
    if (calculatedSpeed < Vs && calculatedSpeed > 0 && MGAU < Sm && ((lastEvent == e_roule) ||(lastEvent == e_arret_voit))){
        
        currentEvent =e_roule;
        savedLoc=nil;
        
    }
    //On a enlevé MGAU < Sm parce que quand le MGAU et VMAU sont tres grandes et la vitesse > 2, il croit qu'on est entrain de marcher
    if ((calculatedSpeed> Vs)) {
        currentEvent =e_roule;
        savedLoc=nil;
    }
    /***************************************** APIWAY IMPLICITE  ****************************************************/
    
    if (calculatedSpeed> Vs && MGAU < Sm && (Distance_car_dest != 0)&& Distance_car_dest < DISTANCE_APIWAY_CAR_DEST)
    {
        currentEvent =e_apiway_implicite;
    }
    /********************************** TIMER : pour plus tard ***********************************************/
    
    /*if(calculatedSpeed> Vss && calculatedSpeed < Vs && MGAU > Sm && VMAU >Sa && (OldDistance_me_car != 0) &&  OldDistance_me_car > DIST_LOIN) {
     currentEvent = e_timer;
     }*/
    currentState= next_motor(currentEvent);
    while ((currentAction = todo_motor())!= A_DONE) {
        //if(savedLoc) [self.delegate sendDistance:nouvelleDistance];
       // if(lastAction != currentAction)
            [self DoIt:currentAction];
    }
    /************* SEND EVENT TO ACTION IF EVENT IS ALWAYS THE SAME FOR 3 SECONDS ************/
    
    /*[eventArray insertObject:[NSNumber numberWithInt:currentEvent] atIndex:i];

    if(i==2){
        
        NSLog(@"-----------AFTER 3 SECONDSS-----------");
        if(eventArray.count == 3){
            for (int j=0;j<eventArray.count;j++) {
                
                NSLog(@"EVENT TAB AT %d:%@ ",j,[eventArray objectAtIndex:j]);
            }
            if(([[eventArray objectAtIndex:0] isEqualToNumber:[eventArray objectAtIndex:1]])
               && ([[eventArray objectAtIndex:0] isEqualToNumber:[eventArray objectAtIndex:2]])
               && ([[eventArray objectAtIndex:1] isEqualToNumber:[eventArray objectAtIndex:2]])){
                while ((currentAction = todo_motor())!= A_DONE) {
                   if(savedLoc) [self.delegate sendDistance:nouvelleDistance];
                    if(lastAction != currentAction)
                    [self DoIt:currentAction];
                    NSLog(@"THE SAME ACTION ");
                }
            }
            
        }
        [eventArray  removeAllObjects ];
        i=0;
    }else{
        i++;
    }
     */
    /************* FIN ************/

    
    return [NSString stringWithFormat:@"%u", currentEvent] ;
}
-(void)WhatActionToDoit:(action)ThisAction{
    

    
    [actionArray insertObject:[NSNumber numberWithInt:ThisAction] atIndex:k];
    
    for (int j=0;j<actionArray.count;j++) {
        
        NSLog(@"Array TAB AT %d:%@ ",j,[actionArray objectAtIndex:j]);
    }
    if(k==2){
        
        NSLog(@"-----------AFTER 3 SECONDSS ACTION -----------");

    if(actionArray.count == 3){
        if(([actionArray objectAtIndex:0] == [actionArray objectAtIndex:1])
           && ([actionArray objectAtIndex:0] == [actionArray objectAtIndex:2])
           && ([actionArray objectAtIndex:1] == [actionArray objectAtIndex:2])){
            [self DoIt:ThisAction];
            
        }
    }
    [actionArray  removeAllObjects ];
    k=0;
  }else
    k++;
   
}

/****************** THE ALGORITHM OF GPS  ********************/

- (void)updateCounter:(NSTimer *)theTimer {
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft %3600) % 60;
        // NSLog(@"TIMER _______ %@",[NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds]);
        
    }
    else{
        secondsLeft = 120;
    }
}
-(void)countdownTimer{
    
    secondsLeft = hours = minutes = seconds = 0;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}
/****************** CALCULATE THE TIME OF STARTING THE GPS  ********************/

-(void)calculateStartGPS{
    
    int timerk = (nouvelleDistance - DIST_PROCHE) / 2;
    [NSTimer scheduledTimerWithTimeInterval:timerk target:self selector:@selector(startGPS) userInfo:nil repeats:NO];
    transition = [NSString stringWithFormat:@"GPS is started every %d seconds",timerk] ;
    
}
/****** detect motion ***/
-(void) detectMovement{
    
    //NSLog(@"Detect Movement");
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.5;
    
    /****************** ACCELEROMETER DETECTION  ********************/
    
    if ([self.motionManager isAccelerometerAvailable])
    {
        //NSLog(@"Accelerometer is active and available");
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [self.motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error)
         
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 acc_x = motion.userAcceleration.x;
                 acc_y = motion.userAcceleration.y;
                 acc_z = motion.userAcceleration.z;
             });
         }];
    }
    else
        NSLog(@"not active");
    
    AU = sqrt((acc_x*acc_x)+(acc_y*acc_y)+(acc_z*acc_z)) * 9.81;
    
    
    if (mvgauArray.count > 15) [mvgauArray removeObjectAtIndex:0];
    [mvgauArray addObject:[NSNumber numberWithFloat:AU]];
    
    MGAU = [self moyenneVitesse];
    VMAU = [self varianceVitesse];
    
   // NSLog(@"MOYENNE GLISSANTE : %f",MGAU);
    //NSLog(@"VARIANCE GLISSANTE : %f",VMAU);
    
}

/****************************** ACCELERATION + LOCATION  *******************************************/

-(void) detectAcceleration{
    
     //[self redirectNSLogToDocuments];
    //NSLog(@"detect  acceleration");
    if(savedLoc){
        if(nouvelleDistance<DIST_PROCHE && MGAU < 0.3){
            
            self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
            
        }
        else
        {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            
        }
    }
    //[self.locationTracker setAccuracy:kCLLocationAccuracyBestForNavigation];
    //[self.locationTracker startLocationTracking];
    //CLLocationManager *locationm = [LocationTracker sharedLocationManager];
   // NSLog(@"Accuracy: %f",locationm.desiredAccuracy);
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager startUpdatingLocation];
    myCurrentLocation =  self.locationManager.location;
    calculatedSpeed =self.locationManager.location.speed;
    
    /****************** IF USER WAS IN DRIVE STATE : WE SAVE ITS LOCATION ********************/
    if(savedLoc)
    {
        ancienneDistance = nouvelleDistance;
       // CLLocationManager *locationm = [LocationTracker sharedLocationManager];
         distance = [savedLoc distanceFromLocation:self.locationManager.location];
         nouvelleDistance = distance;
        
    }
    
    /****************** IF USER IS IN DRIVE STATE  ********************/
    
    if( currentEvent == e_roule){
        //CLLocationManager* locationManager = [LocationTracker sharedLocationManager];
        myCarLocation =  self.locationManager.location;
        nouvelleDistance =0;
        ancienneDistance=0;
    }
    
   // NSLog(@"LOC: %@", myCurrentLocation);
    //NSLog(@"SPEED: %f", calculatedSpeed);
    //NSLog(@"CAR: %@", myCarLocation);
    
    
    if(myCarLocation){
        //CLLocationManager* locationManager = [LocationTracker sharedLocationManager];
        myCarLocation =  self.locationManager.location;
        
        double lat1 = myCurrentLocation.coordinate.latitude;
        double lon1 = myCurrentLocation.coordinate.longitude;
        double lat2 = myCarLocation.coordinate.latitude;
        double lon2 = myCarLocation.coordinate.longitude;
        
        Distance_me_car = [self distance: lat1 lon1: lon1 lat2: lat2   lon2: lon2 unit:'K'];
        // NSLog(@"DIST: %f", Distance_me_car); // Wrong formatting may show wrong value!
    }
    
    /****************** WRITE LOG  ********************/
    [self detectMovement];
    [self detectEvent];
    [self writeToTextFile:[NSString stringWithFormat:@"Ma Position: %0.6f, %0.6f ;VoiturePos: %0.6f, %0.6f ;DernierePosVoit: %0.6f, %0.6f ; MGAU: %0.6f;VMAU: %0.6f;Speed: %0.6f;AncienneDist: %0.6f; NouvelleDist: %f;Event: %u;State: %u;Message: %@; Alerte : %@;\n",myCurrentLocation.coordinate.latitude,myCurrentLocation.coordinate.longitude,myCarLocation.coordinate.latitude,myCarLocation.coordinate.longitude,savedLoc.coordinate.latitude,savedLoc.coordinate.longitude, MGAU,VMAU,calculatedSpeed,ancienneDistance,nouvelleDistance,currentEvent,currentState, Message?Message:@"Pas de Message",transition?transition:@"Pas d alerte"]];
    
    [self.locationManager stopUpdatingLocation];
    //
    [NSTimer scheduledTimerWithTimeInterval:[self getDetections] target:self selector:@selector(detectAcceleration) userInfo:nil repeats:NO];
    
}
-(double)getDetections{
    

    
    if(savedLoc){
        
    if(nouvelleDistance == 0){
        
        return 1.0;
    }
    
    if(nouvelleDistance < DIST_PROCHE)
    
        return 1.0;
    if(nouvelleDistance > DIST_PROCHE  && nouvelleDistance < DIST_LOIN ){
        
       return 20.0;
    }
    

    return ((nouvelleDistance -20)/2)+20.0;
}
  
         return  1.0;
   
}
-(void)writeInFile:(NSString*)msg{
    
    [self writeToTextFile:msg];
}
/*************************** TRAITEMENT DES ACTIONS RETOURNÉES PAR L'AUTOMATE ******************************/

-(void)DoITOther:(action)thisAction
{
    
    NSArray *keys;
    NSArray *objects;
    NSDictionary *dict;
     //NSLog(@"detect  Action Other : %u  ancienne distance : %d nouvelle distance: %d",thisAction,(int)ancienneDistance,(int)nouvelleDistance);
    switch (thisAction) {
          
        case ac_arret_proche_voiture:
            transition = @"Vous etes proche ";
            //[self.delegate arretProche:ancienneDistance nouvelleDist:nouvelleDistance];

            break;
        case ac_arret_moyen_voiture:
            transition = @"Vous etes moyen ";
            //[self.delegate arretMoyen:ancienneDistance nouvelleDist:nouvelleDistance];
            break;
        case ac_arret_loin_voiture:
            transition = @"Vous etes loin ";
            //[self.delegate arretLoin:ancienneDistance nouvelleDist:nouvelleDistance];
            break;
        case ac_marche_moyen_voiture:
            
            Message = @"Vous marchez moyen de la voiture";
            //[self.delegate marcheMoyen];
            
            break;
        case ac_marche_proche_voiture:
            
            Message = @"Vous marchez proche de la voiture ";
            //[self.delegate marcheProche];
            break;
        case ac_marche_loin_voiture :
            
            //[NSTimer scheduledTimerWithTimeInterval:600.0 target:self selector:@selector(stopGPS) userInfo:nil repeats:NO];
            Message = @"Vous marchez Loin:STOP GPS";
            
            break;
            case ac_transition_loin_moyen :
                transition = @"loin --> moyen :apifind";
                //[self.delegate apifindImplicite:savedLoc ancienneDist:ancienneDistance nouvelleDist:nouvelleDistance];
             keys = [[NSArray alloc]initWithObjects:@"savedLoc", nil];
             objects = [[NSArray alloc]initWithObjects:savedLoc, nil];
             dict = [NSDictionary dictionaryWithObjectsAndKeys: objects,keys, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"APIFIND" object:nil userInfo:dict];

                break;
            case ac_transition__moyen_proche:
                transition = @"moyen --> proche :retour ";
               // [self.delegate revenirVersVoiture:savedLoc ancienneDist:ancienneDistance nouvelleDist:nouvelleDistance];
            objects = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%0.9f",savedLoc.coordinate.latitude],[NSString stringWithFormat:@"%0.9f",savedLoc.coordinate.longitude], nil];
            dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,@"savedLoc", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REVENIR" object:nil userInfo:dict];
                break;
            case ac_transition_loin_proche:
                transition = @"loin --> proche :retour ";
                //[self.delegate revenirVersVoiture:savedLoc ancienneDist:ancienneDistance nouvelleDist:nouvelleDistance];
            objects = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%0.9f",savedLoc.coordinate.latitude],[NSString stringWithFormat:@"%0.9f",savedLoc.coordinate.longitude], nil];
            dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,@"savedLoc", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REVENIR" object:nil userInfo:dict];

                break;
            case ac_transition_proche_moyen :
                transition = @"proche --> moyen :stationnement";
                //[self.delegate stationner:savedLoc ancienneDist:ancienneDistance nouvelleDist:nouvelleDistance];
            [userInformation writeForKey:@"savedCarLocation" andValue:[NSString stringWithFormat:@"%f,%f",savedLoc.coordinate.latitude,savedLoc.coordinate.longitude]];
            objects = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%0.9f",savedLoc.coordinate.latitude],[NSString stringWithFormat:@"%0.9f",savedLoc.coordinate.longitude], nil];
            dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,@"savedLoc", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"STATIONNER" object:nil userInfo:dict];

                break;
            case ac_transition_moyen_loin :
                transition = @"moyen --> loin: GPS/1minute ";
                //[self.delegate eloigner:savedLoc ancienneDist:ancienneDistance nouvelleDist:nouvelleDistance];
            keys = [[NSArray alloc]initWithObjects:@"savedLoc", nil];
            objects = [[NSArray alloc]initWithObjects:savedLoc, nil];
            dict = [NSDictionary dictionaryWithObjectsAndKeys: objects,keys, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ELOIGNER" object:nil userInfo:dict];

                break;
            case ac_transition_proche_loin :
                transition = @"proche --> loin : stationnement ";
                //[self.delegate stationner:savedLoc ancienneDist:ancienneDistance nouvelleDist:nouvelleDistance];
            [userInformation writeForKey:@"savedCarLocation" andValue:[NSString stringWithFormat:@"%f,%f",savedLoc.coordinate.latitude,savedLoc.coordinate.longitude]];
            objects = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%0.9f",savedLoc.coordinate.latitude],[NSString stringWithFormat:@"%0.9f",savedLoc.coordinate.longitude], nil];
            dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,@"savedLoc", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"STATIONNER" object:nil userInfo:dict];
                break;
            case ac_gps_on:
                transition =@"GPS is ON";
                //[self.delegate RIENOTHER];
                break;
                

            default:
                
                break;
    }
}

-(void)DoIt:(action)thisAction
{
    //NSLog(@"detect  Action  : %u  ancienne distance : %d nouvelle distance: %d",thisAction,(int)ancienneDistance,(int)nouvelleDistance);
   
    lastAction = thisAction;
        switch (thisAction) {
            
          case ac_init:
          case NO_ACTION:
                //[self.delegate Rien:savedLoc];
                keys = [[NSArray alloc]initWithObjects:@"myLocation", nil];
                objects = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%0.9f",myCurrentLocation.coordinate.latitude],[NSString stringWithFormat:@"%0.9f",myCurrentLocation.coordinate.longitude], nil];
                dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,@"myLocation", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RIEN" object:nil userInfo:dict];
                NSLog(@"myLat :%@",[[dict objectForKey:@"myLocation"]objectAtIndex:0]);
                
                break;
                case ac_roule_simple_apres_marcher:
        case ac_roule_simple_apres_arret:
              Message = @"Vous etes entrain de rouler";
              //[self.delegate rouler];
            transition = @"Vous avez libere une place ";
            //[self.delegate liberer:savedLoc];
            objects = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%0.9f",myCurrentLocation.coordinate.latitude],[NSString stringWithFormat:@"%0.9f",myCurrentLocation.coordinate.longitude], nil];

            dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,@"savedLoc", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LIBERER" object:nil userInfo:dict];
        
                
            break;
            
        case ac_arret_simple:
            
            Message = @"Vous etes en arret a pied ";
            //[self.delegate arretPied:nouvelleDistance];
                keys = [[NSArray alloc]initWithObjects:@"myLoc", nil];
                objects = [[NSArray alloc]initWithObjects:myCurrentLocation, nil];
                dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,keys, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ARRETPIED" object:nil userInfo:dict];

            break;
        case ac_marche:
            
            Message = @"Vous marchez";
            //[self.delegate marche];
            keys = [[NSArray alloc]initWithObjects:@"myLoc", nil];
            objects = [[NSArray alloc]initWithObjects:myCurrentLocation, nil];
            dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,keys, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MARCHER" object:nil userInfo:dict];
            break;
            
            
        case ac_roule_simple:
            
            Message = @"Vous etes entrain de rouler";
              //[self.delegate rouler:myCarLocation];
            keys = [[NSArray alloc]initWithObjects:@"myCarLoc", nil];
            objects = [[NSArray alloc]initWithObjects:myCarLocation, nil];
            dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,keys, nil];
           [[NSNotificationCenter defaultCenter] postNotificationName:@"ROULER" object:nil userInfo:dict];

            
            break;
        case ac_arret_en_voiture :
            
            
            Message = @"Vous etes en arret  voiture";
            //[self.delegate arretVoiture:savedLoc];
                keys = [[NSArray alloc]initWithObjects:@"savedLoc", nil];
                objects = [[NSArray alloc]initWithObjects:savedLoc, nil];
                dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,keys, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ARRETVOITURE" object:nil userInfo:dict];

            break;
            
        case ac_arret_apres_roule:
            
            Message = @"Vous etes arrete apres avoir rouler";
            //[self stopGPS];
            if(savedLoc == nil)
            {
                //CLLocationManager* locationManager = [LocationTracker sharedLocationManager];
                savedLoc =  self.locationManager.location;
            }
            break;
            
        case ac_marche_apres_arret_voiture:
            Message = @"vous marchez apres arret voiture ";
            transition = @"vous etes stationne ";
            Apied = YES;
            if(savedLoc == nil)
            {
                //CLLocationManager* locationManager = [LocationTracker sharedLocationManager];
                savedLoc =  self.locationManager.location;
            }
            
            //[self.delegate stationner:savedLoc ancienneDist:ancienneDistance nouvelleDist:nouvelleDistance];
        [userInformation writeForKey:@"savedCarLocation" andValue:[NSString stringWithFormat:@"%f,%f",savedLoc.coordinate.latitude,savedLoc.coordinate.longitude]];
                objects = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%0.9f",savedLoc.coordinate.latitude],[NSString stringWithFormat:@"%0.9f",savedLoc.coordinate.longitude], nil];
                dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,@"savedLoc", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"STATIONNER" object:nil userInfo:dict];

            break;
            
        case ac_marche_apres_roule:
              Message = @"Vous marchez";
              //[self.delegate marche];
            transition = @"vous etes stationne ";
            Apied = YES;
            if(savedLoc == nil)
            {
                //CLLocationManager* locationManager = [LocationTracker sharedLocationManager];
                savedLoc =  self.locationManager.location;
            }
                //[self.delegate stationner:savedLoc ancienneDist:ancienneDistance nouvelleDist:nouvelleDistance];
                objects = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%0.9f",savedLoc.coordinate.latitude],[NSString stringWithFormat:@"%0.9f",savedLoc.coordinate.longitude], nil];
                dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,@"savedLoc", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"STATIONNER" object:nil userInfo:dict];
                [userInformation writeForKey:@"savedCarLocation" andValue:[NSString stringWithFormat:@"%f,%f",savedLoc.coordinate.latitude,savedLoc.coordinate.longitude]];
            
            break;
            
                case ac_arret_en_voiture_destInc:
            
            Message = @"Vous etes en arret voiture";
            //[self.delegate arretVoiture:savedLoc];
            
            break;
        case ac_arret_More50VoitDestInc:
            Message = @"Vous etes à 50m de la voiture";
            
            
        case ac_timer_start:
            
            //[NSTimer scheduledTimerWithTimeInterval:0.0 target:self.delegate selector:@selector(stopGPS) userInfo:nil repeats:NO];
            
                break;
            case ac_stabilite :
            Message = @"Vous etes au bureau/chez Vous ";
            //[self.delegate stabiliser:savedLoc distanceFromCar:nouvelleDistance];
            
            break;
        case ac_non_stabilite :
            Message = @"Vous avez bouge le telephone ";
            //[self.delegate stabiliser:savedLoc distanceFromCar:nouvelleDistance];
            
            break;
        case ac_Usage_Court:
            //transition =[NSString stringWithFormat:@"Usage Court: %@",date];
            //[self.delegate usageCourt:date];
            break;
        case ac_Usage_Vieux:
            transition =[NSString stringWithFormat:@"Usage Vieux: %@",date];
            //[self.delegate usageVieux:date];
            break;
        case ac_gps_off:
            transition =@"GPS is OFF";
            break;
        case ac_speed_non_stable:
            //Message =@"Vitesse non stable";
            break;
        case ac_roule_lent:
            
            transition=@"Vous roulez lentement";
            break;
        default:
            
            //Message = @"Chargement... ";
            //transition = @"Chargement... ";
            break;
    }
    
}

/************************************** FIN *********************************************/



/***************************************** GMAU + VMAU **********************************/

- (float) moyenneVitesse
{
    // si le tableau possede moins de 15 valeurs on renvoie la moyenne normale
    float somme = 0;
    
    for(int i = 0; i < mvgauArray.count; i++)
    {
        somme = somme + [[mvgauArray objectAtIndex:i] floatValue];
    }
    
    return somme/mvgauArray.count;
}

- (float) varianceVitesse
{
    // si le tableau possede moins de 15 valeurs on renvoie la moyenne normale
    float somme = 0;
    
    for(int i = 0; i < mvgauArray.count; i++)
    {
        somme = somme + (([[mvgauArray objectAtIndex:i] floatValue] - [self moyenneVitesse])*([[mvgauArray objectAtIndex:i] floatValue] - [self moyenneVitesse]));
    }
    
    return somme/mvgauArray.count;
}
/***************************************** FIN **********************************/

/***************************************** CALCUL DE DISTANCE ENTRE DEUX LOCATIONS  **********************************/

-(double)deg2rad:(double) deg {
    return (deg * pi / 180);
    
}

-(double)rad2deg:(double) rad {
    return (rad * 180 / pi);
}
-(double )distance: (double) lat1 lon1: (double) lon1 lat2: (double) lat2  lon2: (double) lon2 unit: (char) unit {
    
    double theta, dist;
    theta = lon1 - lon2;
    dist = sin([self deg2rad:lat1]) * sin([self deg2rad:lat2]) + cos([self deg2rad:lat1]) * cos([self deg2rad:lat2]) * cos([self deg2rad:theta]);
    dist = acos(dist);
    dist = [self rad2deg:dist];
    dist = dist * 60 * 1.1515;
    switch(unit) {
        case 'M':          break;
            
        case 'K':
            dist = dist * 1.609344 * 1000;// metre
            break;
        case 'N':
            dist = dist * 0.8684;
            break;
    }
    return (dist);
}

/***************************************** FIN  **********************************/

/***************************************** GET CURRENT DATE  **********************************/

-(NSString*)getCurrentDate
{
    NSDate* dateC = [NSDate date];
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    // NSLog(@"%@",[DateFormatter stringFromDate:[NSDate date]]);
    
    return [DateFormatter stringFromDate:[NSDate date]];
}
/***************************************** FIN  **********************************/

/*********** AUTOMATE RESPONSE ****/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    myCurrentLocation = [locations lastObject];
    keys = [[NSArray alloc]initWithObjects:@"myLocation", nil];
    objects = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%0.9f",myCurrentLocation.coordinate.latitude],[NSString stringWithFormat:@"%0.9f",myCurrentLocation.coordinate.longitude], nil];
    dict = [NSDictionary dictionaryWithObjectsAndKeys:objects,@"myLocation", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MYLOCATION" object:nil userInfo:dict];
    
}
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

- (void) updatePlace{
    
    
    
    
}



-(void) stopLocationDelayBy10Seconds{
    [self.locationTracker stopLocationTracking];
}

/********************************** LES MÉTHODES DÉLÉGUÉES POUR L'APPLI ****************************************/

-(void)Rien{
    
    
}
- (void) arretPied:(double)distance{
    
    //j'envoi la distance par rapport à la voiture si existe
}
- (void) arretProche:(double)ancienneDist nouvelleDist:(double)nouvelleDist{
    
    //j'envoi la distance par rapport à la voiture si existe
}
- (void) arretMoyen :(double)ancienneDist nouvelleDist:(double)nouvelleDist{
    
    //j'envoi la distance par rapport à la voiture si existe
}
- (void) arretLoin:(double)ancienneDist nouvelleDist:(double)nouvelleDist{
    
    //j'envoi la distance par rapport à la voiture si existe
}
- (void) marche{
    
    //marche proche
}
- (void) marcheProche {
    
    //marche proche
}
- (void) marcheMoyen{
    
    //marche moyen
}
- (void) marcheLoin{
    
    //marche loin
}
- (void) liberer:(CLLocation*)savedCarLocation{
    
    // on a besoin de la position qui vient d'être libérée
}
- (void) rouler{
    //rien
}
- (void) arretVoiture:(CLLocation*)savedCarLocation{
    // j'envoie savedLoc
    
}
- (void) stationner:(CLLocation*)savedCarLocation ancienneDist:(double)ancienneDist nouvelleDist:(double)nouvelleDist{
    //savedLoc
}
- (void) eloigner:(CLLocation*)savedCarLocation ancienneDist:(double)ancienneDist nouvelleDist:(double)nouvelleDist{
    //savedLoc et distance
}
- (void) stabiliser:(CLLocation*)savedCarLocation distanceFromCar: (double)distance{
    //savedLoc et distance
}
- (void) revenirVersVoiture:(CLLocation*)savedCarLocation ancienneDist:(double)ancienneDist nouvelleDist:(double)nouvelleDist{
    //savedLoc et distance
}
- (void) apifindImplicite:(CLLocation*)savedCarLocation ancienneDist:(double)ancienneDist nouvelleDist:(double)nouvelleDist{
    //savedLoc et distance
}
-(void)usageCourt:(NSString *)ConnectionDate{
    
}
-(void)usageVieux:(NSString *)ConnectionDate{
    
}

- (void) activelocation{
    
}
- (void) desactivelocation{
    
}
@end
