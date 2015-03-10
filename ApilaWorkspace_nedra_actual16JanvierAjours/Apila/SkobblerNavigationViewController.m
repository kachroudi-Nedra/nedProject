//
//  SkobblerNavigationViewController.m
//  Apila
//
//  Created by Nedra Kachroudi on 04/03/2015.
//  Copyright (c) 2015 1CPARABLE SARL. All rights reserved.
//

#import "SkobblerNavigationViewController.h"
#import <GPX/GPX.h>
@interface SkobblerNavigationViewController ()

@end

@implementation SkobblerNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
- (void) viewDidAppear:(BOOL)animated
{
    [self.backView setHidden:NO];
    [self.goView setHidden:NO];
    [self.InstructionView setHidden:YES];
    [self.cancelView setHidden:YES];
}
-(void)initWithAddress:(NSString*)address{
    
    if (self) {
        // Custom initialization
        userAddress = address;
        startGeocoding =YES;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    if(appDelegate.detect == NULL){
        
        appDelegate.detect = [[DetectEvent alloc]init];
    }
    appDelegate.detect.locationManager.delegate =self ;

    self.skMap = [[SKMapView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f,  CGRectGetWidth(self.skMapView.frame), CGRectGetHeight(self.skMapView.frame) )];
    //set the map region
    [self.skMapView addSubview:self.skMap];
    [SKRoutingService sharedInstance].routingDelegate = self; // set for receiving routing callbacks
    [SKRoutingService sharedInstance].navigationDelegate = self;// set for receiving navigation callbacks
    [SKRoutingService sharedInstance].mapView = self.skMap; // use the map view for route rendering
   /* GPXRoot *root = [GPXRoot rootWithCreator:@"Apiway route"];
    GPXWaypoint *waypoint0 = [root newWaypointWithLatitude:48.8265952 longitude:2.3806259];//15 avenue de france
    GPXWaypoint *waypoint1 = [root newWaypointWithLatitude:48.8293885 longitude:2.3786979];//30  rue thomas mann
    waypoint0.name = @"avenue de france";
    waypoint1.name = @"thomas mann";
   */
    /*[self.backView setHidden:NO];
    [self.goView setHidden:NO];
    [self.InstructionView setHidden:YES];
    [self.cancelView setHidden:YES];
*/

    // Do any additional setup after loading the view.
}
/***************************************** Calculating Route to destination **************************************/
-(void)geocodeAddress:(NSString*)address{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark* aPlacemark in placemarks)
        {
            // Process the placemark.
            NSString *latDest1 = [NSString stringWithFormat:@"%.9f",aPlacemark.location.coordinate.latitude];
            NSString *lngDest1 = [NSString stringWithFormat:@"%.9f",aPlacemark.location.coordinate.longitude];
            self.addressLat =aPlacemark.location.coordinate.latitude;
            self.addressLng = aPlacemark.location.coordinate.longitude;
            NSLog(@"dest lat: %@, dest long: %@",latDest1,lngDest1);
            NSLog(@"user lat: %0.9f, user long: %0.9f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
            // je lance la navigation vers cette destination
            route = [[SKRouteSettings alloc]init];
            route.startCoordinate=CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
            route.destinationCoordinate=CLLocationCoordinate2DMake(self.addressLat,self.addressLng);
            route.shouldBeRendered = YES; // If NO, the route will not be rendered.
            route.routeMode = SKRouteCarFastest;
            route.numberOfRoutes = 1;
            route.requestAdvices = YES;
            route.requestCountryCodes =YES;
            route.requestExtendedRoutePointsInfo=YES;
            SKAdvisorSettings *adviceSettings = [[SKAdvisorSettings alloc]init];
            adviceSettings.advisorType = SKAdvisorTypeTextToSpeech;
            adviceSettings.language  = SKAdvisorLanguageFR;
            [[SKRoutingService sharedInstance] setAdvisorConfigurationSettings:adviceSettings];
            [[SKRoutingService sharedInstance] calculateRoute:route];
            [self writeToTextFile:[NSString stringWithFormat:@"calcul route from %@ to %f,%f \n",userLocation,self.addressLat,self.addressLng]];
        
        }
    }];

}
/***************************************** Calculating Route to destination via Apiway **************************************/
-(void)geocodeAddressApiway:(NSString*)address andLocations:(NSMutableArray*)apiwayArray{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark* aPlacemark in placemarks)
        {
            // Process the placemark.
            NSString *latDest1 = [NSString stringWithFormat:@"%.9f",aPlacemark.location.coordinate.latitude];
            NSString *lngDest1 = [NSString stringWithFormat:@"%.9f",aPlacemark.location.coordinate.longitude];
            self.addressLat =aPlacemark.location.coordinate.latitude;
            self.addressLng = aPlacemark.location.coordinate.longitude;
            NSLog(@"dest lat: %@, dest long: %@",latDest1,lngDest1);
            NSLog(@"user lat: %0.9f, user long: %0.9f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
            // je lance la navigation vers cette destination
            route = [[SKRouteSettings alloc]init];
            route.startCoordinate=CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
            route.destinationCoordinate=CLLocationCoordinate2DMake(self.addressLat,self.addressLng);
            route.shouldBeRendered = YES; // If NO, the route will not be rendered.
            route.routeMode = SKRouteCarFastest;
            route.numberOfRoutes = 1;
            route.requestAdvices = YES;
            route.requestCountryCodes =YES;
            route.requestExtendedRoutePointsInfo=YES;
            SKAdvisorSettings *adviceSettings = [[SKAdvisorSettings alloc]init];
            adviceSettings.advisorType = SKAdvisorTypeTextToSpeech;
            adviceSettings.language  = SKAdvisorLanguageFR;
            [[SKRoutingService sharedInstance] setAdvisorConfigurationSettings:adviceSettings];
            [[SKRoutingService sharedInstance] calculateRoute:route];
            
            
            /************ Waypoints pour Apiway *******/
            /*CLLocation *loc1 = [[CLLocation alloc]initWithLatitude:48.8265952 longitude:2.3806259];
             CLLocation *loc2 = [[CLLocation alloc]initWithLatitude:48.8293885 longitude:2.3786979];
             CLLocation *loc3 = [[CLLocation alloc]initWithLatitude:48.825583 longitude:2.3836126];
             
             CLLocation *destLoc = [[CLLocation alloc]initWithLatitude:self.addressLat longitude:self.addressLng];
             locationArray = [[NSMutableArray alloc]init];
             [locationArray addObject:loc3];
             [locationArray addObject:loc1];
             [locationArray addObject:loc2];
             [locationArray addObject:destLoc]; //last location
             //[[SKRoutingService sharedInstance] calculateRouteWithSettings:route customLocations:locationArray];
             */
            [self writeToTextFile:[NSString stringWithFormat:@"calcul route from %@ to %f,%f \n",userLocation,self.addressLat,self.addressLng]];
            /*SKRouteAdvice *routeAdvice =[[SKRouteAdvice alloc]init];
             NSLog(@"route: %@",route);
             SKAdvisorSettings *adviceSettings = [[SKAdvisorSettings alloc]init];
             [SKRoutingService sharedInstance].advisorConfigurationSettings = adviceSettings;
             NSLog(@"advice settings : %@",adviceSettings);
             NSArray* listAdvice =[[SKRoutingService sharedInstance]routeAdviceListWithDistanceFormat:SKDistanceFormatMetric];
             */
        }
    }];
    
}
- (NSString *) displayContent
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/LOGS/logsSkobblerNavig.txt", documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    
    return content;
}
-(void) writeToTextFile:(NSString*) line
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/LOGS/logsSkobblerNavig.txt",documentsDirectory];
    
    //create content - four lines of text
    NSString *content = line;
    content = [NSString stringWithFormat:@"%@\n%@ ----- %@",[self displayContent],[NSDate date],content];
    
    //save content to the documents directory
    [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
}
- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [UIView animateWithDuration:0.4
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.x = frame.size.width;
                         self.view.frame = frame;
                     } completion:nil];
    [[SKRoutingService sharedInstance]stopNavigation];
    [[SKRoutingService sharedInstance] clearCurrentRoutes];
    [self.backView setHidden:NO];
    [self.goView setHidden:NO];
    [self.InstructionView setHidden:YES];
    [self.cancelView setHidden:YES];


}
- (IBAction)startNavigation:(id)sender {
    
     SKNavigationSettings* navSettings = [SKNavigationSettings navigationSettings];
     navSettings.navigationType=SKNavigationTypeSimulation;
     navSettings.distanceFormat=SKDistanceFormatMetric;
     [SKRoutingService sharedInstance].mapView.settings.displayMode = SKMapDisplayMode3D;
     [[SKRoutingService sharedInstance]startNavigationWithSettings:navSettings];

    [self.backView setHidden:YES];
    [self.goView setHidden:YES];
    [self.InstructionView setHidden:NO];
    [self.cancelView setHidden:NO];
    
    
}
/************************ Navig instructions ******************/
-(void)checkInstructions:(int)distance andInstruction:(NSString*)instruction{
    
   // NSLog(@"----- distance:%d, instruction:%@",distance,instruction);
    
    if(distance >= 480 && distance <= 500){
            [self speakPlease:instruction];
            NSLog(@"speak 500:%@",instruction);
    }
     if(distance >= 180 && distance <= 200){
         [self speakPlease:instruction];
             NSLog(@"speak 200:%@",instruction);
     }
         if(distance >= 80 && distance <= 100){
            [self speakPlease:instruction];
             NSLog(@"speak 100:%@",instruction);
    }
        if(distance >= 30 && distance <= 50){
            [self speakPlease:instruction];
             NSLog(@"speak 50:%@",instruction);
        }
    if(distance >= 5 && distance <= 10){
            [self speakPlease:instruction];
             NSLog(@"speak 10:%@",instruction);
        
    }
}
/******** VOICE SPEAK ********/

-(void)speakPlease:(NSString*)speech{
    
    NSLog(@"speech:%@",speech);
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:speech];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    AVSpeechSynthesizer *syn = [[AVSpeechSynthesizer alloc] init];
    [syn speakUtterance:utterance];
}

/******************************************* SKMAP delegates ******************************************/

- (void)routingService:(SKRoutingService *)routingService didChangeFirstVisualAdvice:(BOOL)isFirstVisualAdviceChanged withSecondVisualAdvice:(BOOL)isSecondaryAdviceChanged lastAdvice:(BOOL)isLastAdvice currentAdvice:(SKRouteAdvice *)currentAdvice nextAdvice:(SKRouteAdvice *)nextAdvice secondAdvice:(SKRouteAdvice *)secondAdvice{
    
   // NSLog(@"current street name:%@, current time leg: %d",currentAdvice.streetName, currentAdvice.timeToAdvice);
    //NSLog(@"next street name:%@, next time leg: %d",nextAdvice.streetName, nextAdvice.timeToAdvice);

}
- (void)routingService:(SKRoutingService *)routingService didChangeCurrentVisualAdviceDistance:(int)distance withFormattedDistance:(NSString *)formattedDistance{
    
    self.leg_time_label.text = [NSString stringWithFormat:@"%d m",distance];
    distanceForAdvice=distance;
    
}
- (void)routingService:(SKRoutingService *)routingService didChangeCurrentAdviceImage:(UIImage *)adviceImage withLastAdvice:(BOOL)isLastAdvice{
    
    NSLog(@"image changed:%@ ",adviceImage);
    self.flecheView.image = adviceImage;
    if(adviceImage.images.count>0)
    [self writeToTextFile:[NSString stringWithFormat:@"current image:%@\n",adviceImage.images[0]]];
    NSLog(@"is last advice:%hhd",isLastAdvice);
    if(isLastAdvice == YES){
        
        self.instructionLabel.text =[NSString stringWithFormat:@"Votre destination se trouve à %@",self.leg_time_label.text ];
    }

}
- (void)routingService:(SKRoutingService *)routingService didChangeAdviceID:(int)adviceID{
    
    
}
- (void)routingService:(SKRoutingService *)routingService didChangeCurrentAdviceInstruction:(NSString *)currentAdviceInstruction nextAdviceInstruction:(NSString *)nextAdviceInstruction{
    
    NSLog(@"current instruction: %@,%@",currentAdviceInstruction,nextAdviceInstruction);
    //[self speakPlease:currentAdviceInstruction];
    [self checkInstructions:distanceForAdvice andInstruction:currentAdviceInstruction];
    [self writeToTextFile:[NSString stringWithFormat:@"current advice:%@, next advice:%@\n",currentAdviceInstruction,nextAdviceInstruction]];

}
- (void)routingService:(SKRoutingService *)routingService didChangeCurrentSpeed:(double)speed{
    
    NSLog(@"speed: %f",speed);
    [self writeToTextFile:[NSString stringWithFormat:@"speed:%f\n",speed]];

}
- (void)routingService:(SKRoutingService *)routingService didChangeNextStreetName:(NSString *)nextStreetName streetType:(SKStreetType)streetType countryCode:(NSString *)countryCode{
    
    NSLog(@"next street name: %@",nextStreetName);
    self.instructionLabel.text=nextStreetName;
    
}
- (void)routingService:(SKRoutingService *)routingService didChangeCurrentStreetName:(NSString *)currentStreetName streetType:(SKStreetType)streetType countryCode:(NSString *)countryCode{
    
    NSLog(@"street name: %@,%d,%@",currentStreetName,streetType,countryCode );

    // NSLog(@"routing service array: %@",routingService.visualAdviceConfigurations);
    [self writeToTextFile:[NSString stringWithFormat:@"street name:%@, street type:%d, country code:%@\n",currentStreetName,streetType,countryCode]];
    

}
- (void)routingService:(SKRoutingService *)routingService didChangeEstimatedTimeToDestination:(int)time{
    
    self.timeLabel.text = [NSString stringWithFormat:@"%d min",time/60];
    [self writeToTextFile:[NSString stringWithFormat:@"time estimated:%d\n",time]];


}
- (void)routingService:(SKRoutingService *)routingService didChangeDistanceToDestination:(int)distance withFormattedDistance:(NSString *)formattedDistance{
    
    NSLog(@"distance: %@",formattedDistance);
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ m",formattedDistance];
    [self writeToTextFile:[NSString stringWithFormat:@"distance:%d\n",distance]];

}
- (void)routingServiceDidReachDestination:(SKRoutingService *)routingService{
    
    NSLog(@"destination reached");
    self.instructionLabel.text = @"Vous êtes Arrivé";
    [self speakPlease:@"Vous êtes arrivé"];
    [self writeToTextFile:[NSString stringWithFormat:@"reached destination\n"]];
    [self cancelAction:nil];

}
- (void)routingServiceDidStartRerouting:(SKRoutingService *)routingService{
    
    [self writeToTextFile:[NSString stringWithFormat:@"route recalculated \n"]];

}
- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
- (void)routingService:(SKRoutingService *)routingService didFinishRouteCalculationWithInfo:(SKRouteInformation*)routeInformation{
    NSLog(@"Route is calculated.");
    
       SKRouteAdvice *routeAdvice =[[SKRouteAdvice alloc]init];
     NSLog(@"route: %@",route);
    // SKAdvisorSettings *adviceSettings = [[SKAdvisorSettings alloc]init];
    //NSLog(@"advice settings : %@", routingService.advisorConfigurationSettings);
    // NSArray* listAdvice =[routingService routeAdviceListWithDistanceFormat:SKDistanceFormatMetric];
    //routeAdvice =listAdvice[0];
    NSLog(@"route advice: %@,%d,%@,%@",routeAdvice.streetName,routeAdvice.timeToAdvice,routeAdvice.adviceInstruction,routeAdvice.visualAdviceFile);
    //self.instructionLabel.text = routeAdvice.adviceInstruction;
    [self speakPlease:routeAdvice.adviceInstruction];
    //self.leg_time_label.text = [NSString stringWithFormat:@"%d m",routeAdvice.timeToAdvice];
    //self.flecheView.image = [UIImage imageWithContentsOfFile:routeAdvice.visualAdviceFile];
    //NSMutableArray * audioList = routeAdvice.audioFilePlaylist;
    //NSLog(@"audio list:%@",audioList[0]);
    // Construct URL to sound file
    //NSString *path = [NSString stringWithFormat:@"%@/drum01.mp3", [[NSBundle mainBundle] resourcePath]];
    //NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    //_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [self writeToTextFile:[NSString stringWithFormat:@"route is calculated with distance :%d and time %d \n",routeInformation.distance,routeInformation.estimatedTime / 60]];
    NSLog(@"route id: %d",routeInformation.routeID);
    [routingService zoomToRouteWithInsets:UIEdgeInsetsZero]; // zooming to currrent route
    //NSArray *adviceList = [routingService routeAdviceListWithDistanceFormat:SKDistanceFormatMetric]; // array of SKRouteAdvice
    NSLog(@"routing distance : %d",routeInformation.distance);
    self.distanceLabel.text = [NSString stringWithFormat:@"%d m",routeInformation.distance];
    self.timeLabel.text=[NSString stringWithFormat:@"%d min",routeInformation.estimatedTime / 60];
    
     UIImageView *coloredView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 40, 45)];
    coloredView.image = [UIImage imageNamed:@"pinJeMarche.png"];
    //create the SKAnnotationView
    
    SKAnnotation *mapAnnotation = [SKAnnotation annotation];
    mapAnnotation.identifier = 1;
    mapAnnotation.minZoomLevel = 5;
    //mapAnnotation.annotationView= view;
    mapAnnotation.annotationType = SKAnnotationTypeRed;
    mapAnnotation.location = CLLocationCoordinate2DMake(self.addressLat, self.addressLng);
    
    [self.skMap addAnnotation:mapAnnotation withAnimationSettings:nil];

    /*SKMapCustomPOI *destinationPOI = [[SKMapCustomPOI alloc]init];
    destinationPOI.identifier = 2;
    destinationPOI .coordinate =CLLocationCoordinate2DMake(self.addressLat, self.addressLng);
    */
}
/******* Location delegates ****/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    userLocation =[locations lastObject];
    if(startGeocoding == YES){
    [self geocodeAddress:userAddress];
        startGeocoding = NO;
    }
    UIImageView *coloredView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 40, 45)];
    coloredView.image = [UIImage imageNamed:@""];
    //create the SKAnnotationView
    SKAnnotationView *view = [[SKAnnotationView alloc] initWithView:coloredView reuseIdentifier:@"viewID"];
    
    //create the annotation
    SKAnnotation *viewAnnotation = [SKAnnotation annotation];
    //set the custom view
    viewAnnotation.annotationView = view;
    viewAnnotation.identifier = 100;
    viewAnnotation.location = CLLocationCoordinate2DMake( userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    [self.skMap addAnnotation:viewAnnotation withAnimationSettings:nil];
   }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
