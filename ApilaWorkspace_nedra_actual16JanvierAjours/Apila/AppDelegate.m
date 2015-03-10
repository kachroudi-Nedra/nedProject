//
//  AppDelegate.m
//  Apila
//
//  Created by Vincenzo GALATI on 18/02/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterSmokeStyle.h"
#import "JCNotificationBannerPresenterIOSStyle.h"
#import "JCNotificationBannerPresenterIOS7Style.h"
#import "AuthentificationViewController.h"
#import "AGPushNoteView.h"
#define kSocialAccountTypeKey @"SOCIAL_ACCOUNT_TYPE"

@implementation AppDelegate
 id lastViewController;
@synthesize user_id,user_sid,device_id,img_name,user_name,user_car_couleur,user_car_marque,user_car_modele,user_age,user_sexe,serverWebSocket,user_email,user_pseudo,user_pass,logScreen1,user_fb_token,user_fb_id,user_ldi_id;
- (UIViewController*) topMostController {
    UIViewController *topController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if(launch == NO){
        
        launch = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCurrentViewController:) name:@"CurrentViewController" object:nil];

    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"notification");
    }
    [FBLoginView class];
        [GMSServices provideAPIKey:@"AIzaSyDOVPivtOq32heKcyRlFCwWGy4eKGRGxDw"];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.apple.com";
    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    self.remoteHostLabel.text = [NSString stringWithFormat:remoteHostLabelFormatString, remoteHostName];
    self.navigChoice = -1;
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self updateInterfaceWithReachability:self.wifiReachability];
    pleaseWait = [[UIAlertView alloc] initWithTitle:@"Veuillez patienter..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    pleaseWaitCnx = [[UIAlertView alloc] initWithTitle:@"Pas de connexion internet" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    chooseServer =[[UIAlertView alloc] initWithTitle:@"Server" message:@"choisisez le serveur" delegate:self cancelButtonTitle:@"Apiway" otherButtonTitles: @"Appli", nil];
    chooseServer.tag=1987;
    //[chooseServer show];
    [[SKMapsService sharedInstance] initializeSKMapsWithAPIKey:@"939ce613bb99335e1661671950d95a9a1cb00a2ae1fa59e06e37d0b5d49724ad" settings:nil];
    serverWebSocket = [[ServerViewController alloc] init];
    [serverWebSocket connectWebSocket:@"9000"];
     self.detect = [[DetectEvent alloc]init];
    [self.detect detectAcceleration];
    //[serverWebSocket connectWebSocket:@"9000"];
    //[serverWebSocket connectWebSocket:@"9500"];
   /* UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SplashScreenViewController *privacy = (SplashScreenViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SplashScreenViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:privacy];
    navController.navigationBar.hidden = YES;
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    */
    /*locationManager = [[CLLocationManager alloc]init];
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
       // [locationManager requestAlwaysAuthorization];
    }
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
     // on affiche l'icône user
    self.carLocation = [[CLLocation alloc]init];
    if(self.firstViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.firstViewController = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
    }
    //self.map = [[GMSMapView alloc]init];
    //self.map.delegate = self;
    if(self.markerUserLocation == nil)
    {
        self.markerUserLocation = [[GMSMarker alloc] init];
        self.markerUserLocation.icon = [UIImage imageNamed:@"pinJeMarche.png"];
       self. markerUserLocation.snippet = @"-1234";
    }
    if(self.CarMarker == nil)
    {
        self.CarMarker = [[GMSMarker alloc] init];
        self.CarMarker.icon = [UIImage imageNamed:@"pinEmplacementPlace.png"];
    }
   
    self.detect = [[DetectEvent alloc]init];
    self.detect.delegate =self;
    [self.detect detectAcceleration];
    self.debugText=@"init";
    if(self.firstViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.firstViewController = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
    }
     */
    //self.navController = [[UINavigationController alloc] initWithRootViewController:self.firstViewController];
    
    // set the navController property:
    //[self setNavController: self.navController];
    
    
    // add the Navigation Controller's view to the window:
    return YES;
}
- (void)handleCurrentViewController:(NSNotification *)notification {
    if([[notification userInfo] objectForKey:@"lastViewController"]) {
        lastViewController = [[notification userInfo] objectForKey:@"lastViewController"];
        NSLog(@"current view: %@",[lastViewController class]);
    
    }
}
/*!
 * Called by Reachability whenever status changes.
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView == notificationAlert){
        
        NSLog(@"click alert");
        if (navigationMap == nil)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            navigationMap = (NavigationMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationMapViewController"];
        }
        [self.window addSubview:navigationMap.view];
        [navigationMap parkNowToDestination:self.savedDestination];

    }
    if (alertView == chooseServer) {
        
        if (buttonIndex == 0) {
            
            [serverWebSocket connectWebSocket:@"9000"];

        }
        if (buttonIndex == 1) {
            
            [serverWebSocket connectWebSocket:@"9900"];
            
        }
    }
    
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
            //[self showPleaseWait];
             //NSLog(@"net not reachable");
             [pleaseWaitCnx show];
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            imageView.image = [UIImage imageNamed:@"WWAN5.png"];
             //[self hidePleaseWait];
              //NSLog(@"net is reachable");
            [pleaseWaitCnx dismissWithClickedButtonIndex:0 animated:NO];
            break;

        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            imageView.image = [UIImage imageNamed:@"Airport.png"];
             //[self showPleaseWait];
              NSLog(@"net is reachable");
            [pleaseWaitCnx dismissWithClickedButtonIndex:0 animated:NO];

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


- (void) updateMapCenter
{
    NSLog(@"CHECK LOCATION");
    NSLog(@"CHECK : %@",[locationManager location]);
    
    if([locationManager location].coordinate.latitude == 0 && [locationManager location].coordinate.longitude == 0)
    {
        [self performSelector:@selector(updateMapCenter) withObject:nil afterDelay:0.1];
    }
    else
    {
        NSLog(@"USER LOCATION OK");
        [self.map animateToLocation:[locationManager location].coordinate];
        [self.map animateToZoom:14];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    application.applicationIconBadgeNumber = 0;
    
    self.device_id = [NSString stringWithFormat:@"%@",deviceToken];
    self.device_id = [[[[self.device_id stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@"-"] uppercaseString];
    
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@",self.device_id);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", err]; NSLog(@"%@", str);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    notificationAlert = [[UIAlertView alloc] initWithTitle:@"APILA"    message:notification.alertBody
                                                               delegate:self cancelButtonTitle:@"Trouvez moi une place!" otherButtonTitles:nil, nil];
    if (isAppResumingFromBackground) {
        
         [notificationAlert show];
    }
    if ( application.applicationState == UIApplicationStateBackground )
    
        [notificationAlert show];

   // if (application.applicationState == UIApplicationStateInactive) {
    
   //}
   
    }
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( application.applicationState == UIApplicationStateActive ){
        
    }
        // app was already in the foreground
       
 else {
    
     
     /*[AGPushNoteView showWithNotificationMessage:[NSString stringWithFormat:@"%d", pushCounter++]];
     [AGPushNoteView setMessageAction:^(NSString *message) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PUSH"
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"Close"
                                               otherButtonTitles:nil];
         [alert show];
     }];
         [JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterIOSStyle new];
            [JCNotificationCenter
             enqueueNotificationWithTitle:@"APILA"
             message:@"GO BACK TO APILA"
             tapHandler:^{
                 UIAlertView* alert = [[UIAlertView alloc]
                                       initWithTitle:@"Tapped notification"
                                       message:@"Perform some custom action on notification tap event..."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
                 [alert show];
             }];
     
*/
     
    
        }
           
            // app was just brought from background to foreground
    }
- (void)applicationWillEnterForeground:(UIApplication *)application
{
  
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  /*  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  self.firstViewController= (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    UIViewController * thisView = [self topMostController];
    [ thisView presentViewController:self.firstViewController animated:YES completion:nil];///if (self.navigChoice != -1) {
    [self.firstViewController parkHere:nil];
   */
   /*if(self.firstViewController == nil)
     {
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     self.firstViewController = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
     
     }
    if([[lastViewController class] isSubclassOfClass:[NavigationMapViewController class]]){
       
        NSLog(@"-------yes it is navigation map view controller");
       
        if (navigationMap == nil)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            navigationMap = (NavigationMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationMapViewController"];
        }
        [navigationMap cancelAction:nil];
        [self.navController pushViewController: self.firstViewController animated:NO];
    }
     */
    isAppResumingFromBackground = YES;

    /*[UIView animateWithDuration:0.0
                         animations:^{
                             //[self.window addSubview:self.firstViewController->alertChooseNavigationViewController.view];
                             self.firstViewController->alertChooseNavigationViewController.view.alpha = 0.0;
                             
                         } completion:nil];
    //}
    
   /* if(self.firstViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.firstViewController = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
    }
   // UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    [self.navController pushViewController: self.firstViewController animated:NO];
  */
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"visible: %d",self.firstViewController.isVisible);
    /*if (self.firstViewController.isVisible == 0) {
    
        [self.window addSubview:[ self.navController view]];
        [ self.navController pushViewController:self.firstViewController animated:YES];

    }
    if (navigationMap == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        navigationMap = (NavigationMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationMapViewController"];
    }
    if (navigationMap.isVisible == 0) {
    [self.window addSubview:navigationMap.view];
    [navigationMap parkNow];
    }
     */
   //[navigationMap cancelAction:nil];
    

    
    //[self.window addSubview:self.firstViewController.view];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (CMMotionManager *)motionManager
{
    if (!motionManager)
    {
        //motionManager = [[CMMotionManager alloc] init];
    }
    
    return motionManager;
}

- (void)showNotif:(NSString *)message duringSec : (float) sec
{
    if([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground)
    {
        if(notifIsShowing != 1)
        {
            notifIsShowing = 1;
            
            if(notifView == nil)
            {
                notifView = [[UIView alloc] init];
                backNotif = [[UIImageView alloc] init];
                backNotif.backgroundColor = [UIColor colorWithRed:250.0 green:250.0 blue:250.0 alpha:0.95];
                CGRect frameBackNotif = backNotif.frame;
                frameBackNotif.size.width = self.window.frame.size.width;
                frameBackNotif.size.height = 100;
                
                CGRect frameLabel = frameBackNotif;
                frameLabel.size.width = frameLabel.size.width - 20;
                frameLabel.size.height = frameLabel.size.height - 30;
                frameLabel.origin.x = frameLabel.origin.x + 10;
                frameLabel.origin.y = frameLabel.origin.y + 20;
                
                CGRect frameNotif = notifView.frame;
                frameNotif.size.width = self.window.frame.size.width;
                frameNotif.size.height = 100;
                frameNotif.origin.y = frameNotif.origin.y - frameNotif.size.height;
                
                backNotif.frame = frameBackNotif;
                notifView.frame = frameNotif;
                
                notifMessage = [[UILabel alloc] initWithFrame:frameLabel];
                notifMessage.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
                notifMessage.textColor = [UIColor colorWithRed:28/255.0 green:30/255.0 blue:58/255.0 alpha:1.0];
                notifMessage.numberOfLines = 4;
                notifMessage.textAlignment = NSTextAlignmentCenter;
                
                [notifView addSubview:backNotif];
                [notifView addSubview:notifMessage];
                [self.window addSubview:notifView];
            }
            
            notifMessage.text = message;
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 CGRect frameNotif = notifView.frame;
                                 frameNotif.origin.y = frameNotif.origin.y + frameNotif.size.height;
                                 notifView.frame = frameNotif;
                             } completion:nil];
            
            [self performSelector:@selector(hideNotif) withObject:nil afterDelay:sec];
        }
    }
    else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
    {
        
        UILocalNotification *howLongCanANotificationLast = [[UILocalNotification alloc]init];
        howLongCanANotificationLast.alertBody=message;
        [[UIApplication sharedApplication] scheduleLocalNotification:howLongCanANotificationLast];
    
         }
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

- (void) showPleaseWait
{
    if (pleaseWaitShown == 0)
    {
        pleaseWaitShown = 1;
        [pleaseWait show];
    }
}

- (void) hidePleaseWait
{
    if (pleaseWaitShown == 1)
    {
        pleaseWaitShown = 0;
        [pleaseWait dismissWithClickedButtonIndex:0 animated:YES];
    }
}

#pragma mark - Other
- (void)restoreLastSessionIfExists {
    SocialAccountType lastActiveSocialAccountType = [[NSUserDefaults standardUserDefaults] integerForKey:kSocialAccountTypeKey];
    if(lastActiveSocialAccountType == SocialAccountTypeFacebook) {
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            //The session has not expired so this will not create any visible UI activity.
            [self openFacebookSession];
        }
    }
}

#pragma mark - URL handler
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"FB HANDLE");
    
    bool handler = [FBSession.activeSession handleOpenURL:url];
    
    if(handler) NSLog(@"HANDLER OK");
    else NSLog(@"HANDLER NO");
    
    //NSLog(@"%@",;
    
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark - Facebook SDK
- (void)openFacebookSession
{
    NSLog(@"FB OPEN APPDELEGATE");
    NSArray *facebookPermissions = [NSArray arrayWithObjects:@"public_profile", @"user_birthday",@"email", nil];
    
    
    [FBSession openActiveSessionWithReadPermissions:facebookPermissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState status,
                                                      NSError *error) {
                                      if (error) {
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                          message:error.localizedDescription
                                                                                         delegate:nil
                                                                                cancelButtonTitle:@"OK"
                                                                                otherButtonTitles:nil];
                                          [alert show];
                                          
                                      }else{
                                          [self sessionStateChanged:session state:status error:error];
                                      }
                                  }];
    
}

- (void)closeFacebookSession
{
    NSLog(@"FB CLOSE APPDELEGATE");
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    NSLog(@"FB CHANGE APPDELEGATE");
    
    switch (state) {
        case FBSessionStateOpen: {
            //Save the used SocialAccountType so it can be retrieved the next time the app is started.
            [[NSUserDefaults standardUserDefaults] setInteger:SocialAccountTypeFacebook forKey:kSocialAccountTypeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //Go to the HomeViewController
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            AuthentificationViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"AuthentificationViewController"];
            
            mainViewController.isEmail=1;
            //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            //self.window.rootViewController = mainViewController;
            
            self.user_fb_token = [FBSession activeSession].accessTokenData.accessToken;
            NSLog([FBSession activeSession].accessTokenData.accessToken);
            
            [self.logScreen1.navigationController pushViewController:mainViewController animated:YES];
            //[self.window makeKeyAndVisible];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged out, we want them to be looking at the root view.
            //[self.navigationController popToRootViewControllerAnimated:YES];
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Facebook Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}
/*********** AUTOMATE RESPONSE ****/
/*- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.userLocation = [locations lastObject];
    self. markerUserLocation.position =self.userLocation.coordinate;
    if(self.carLocation)self.CarMarker.position= self.carLocation.coordinate;
    //NSLog(@"heading new : %d",manager.headingOrientation);

    // Quand on arrive à 250m de destination
    if(self.savedDestination){
        
        double distance =[self.savedDestination distanceFromLocation:self.userLocation];
         //NSLog(@"loc: %@",self.userLocation);
         //NSLog(@"saved loc: %@",self.savedDestination);
        //NSLog(@"Distance: %f",distance);

        if([self.savedDestination distanceFromLocation:self.userLocation] <= 120){
            
            if(self.arrived == NO){
                //[self showNotif:@"Apila s'occupe de vous" duringSec:5.0];
                UILocalNotification *howLongCanANotificationLast = [[UILocalNotification alloc]init];
                howLongCanANotificationLast.alertBody=@"Apila vous trouve une place!";
                howLongCanANotificationLast.hasAction = YES;
                [[UIApplication sharedApplication] scheduleLocalNotification:howLongCanANotificationLast];
                self.arrived =YES;
            }
        }
    }
}
 
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    if (newHeading.headingAccuracy < 0)
        return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    
    self.currenHeading = theHeading;
    NSLog(@"head: %f",self.currenHeading);
    //[map.mapView animateToBearing:currenHeading];
    
    
}
*/
/*
-(void)RIENOTHER{
    
    [self showNotif:@"GPS IS ON" duringSec:5];
      NSLog(@"GPS IS ON");
    
}
-(void)Rien:(CLLocation*)savedCarLocation{
    
    //NSLog(@"RIEN à traiter");
    if(self.firstViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.firstViewController = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
    }
    self.ETAT = @"RIEN";
    if(savedCarLocation){
        
        self.carLocation =[[CLLocation alloc]initWithLatitude:savedCarLocation.coordinate.latitude longitude:savedCarLocation.coordinate.longitude];
        [self.CarMarker setPosition:CLLocationCoordinate2DMake(savedCarLocation.coordinate.latitude, savedCarLocation.coordinate.longitude)];
        [self.firstViewController showPinCar:@"pinEmplacementPlace.png"];
        
    }
    //[self.firstViewController showMessage:@"Rien"];
    //[self.firstViewController showPin:@"nothing.png"];

}
- (void) sendDistance:(double)distance{

   

}

- (void) arretPied:(double)distance
{
    
      //[self.firstViewController showMessage:@"Arret pied"];
    if(self.firstViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.firstViewController = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
    }

    [self.firstViewController showPin:@"pinJeMarche.png"];
     self.ETAT = @"ARRET_PIED";
}

- (void) arretProche:(double)ancienneDist nouvelleDist:(double)nouvelleDist
{
   }

- (void) arretMoyen:(double)ancienneDist nouvelleDist:(double)nouvelleDist
{
    
}

- (void) arretLoin:(double)ancienneDist nouvelleDist:(double)nouvelleDist
{
    
   }

- (void) marche
{
    
    if(self.firstViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.firstViewController = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
    }

   self.ETAT = @"MARCHE";
    [self.firstViewController showPin:@"pinJeMarche.png"];}


- (void) marcheProche
{
    // Je propose navigation à piéton vers la voiture
    markerUserLocation.icon = [UIImage imageNamed:@"pinJeMarche.png"];
    markerUserLocation.map=map.mapView;
    
    debugTextView.text = [NSString stringWithFormat:@"\nDETECTION : marche proche \n%@",debugTextView.text];
 
}



- (void) marcheMoyen
{
    // Je propose navigation à piéton vers la voiture
    markerUserLocation.icon = [UIImage imageNamed:@"pinJeMarche.png"];
    markerUserLocation.map=map.mapView;
    
    debugTextView.text = [NSString stringWithFormat:@"\nDETECTION : marche moyen \n%@",debugTextView.text];
 
}


- (void) marcheLoin
{
    // Je propose navigation à piéton vers la voiture
    markerUserLocation.icon = [UIImage imageNamed:@"pinJeMarche.png"];
    markerUserLocation.map=map.mapView;
    
    debugTextView.text = [NSString stringWithFormat:@"\nDETECTION : marche loin \n%@",debugTextView.text];

}

- (void) liberer:(CLLocation*)savedCarLocation
{
    
    [self.serverWebSocket Leave:[NSString stringWithFormat:@"%f",savedCarLocation.coordinate.latitude] andLng:[NSString stringWithFormat:@"%f",savedCarLocation.coordinate.longitude]];
     self.ETAT = @"LIBERE";
}

- (void) rouler:(CLLocation*)myCarLocation
{
   
    if(self.firstViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.firstViewController = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
    }

    [self.firstViewController showPin:@"pinEmplacementPlace.png"];
    self.ETAT = @"ROULE";
    self.carLocation = nil;
    self.CarMarker.map=nil;
    
}

- (void) arretVoiture:(CLLocation*)savedCarLocation
{
    
    //[self.firstViewController showMessage:@"Arret voiture"];
     self.ETAT = @"ARRET_VOITURE";

}
 
-(void)stopApiway{
    
    if (navigationMap == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        navigationMap = (NavigationMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationMapViewController"];
    }
    
    [navigationMap cancelAction:nil];

}
- (void) stationner:(CLLocation*)savedCarLocation ancienneDist:(double)ancienneDist nouvelleDist:(double)nouvelleDist
{
   
    if(self.firstViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.firstViewController = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
    }

    NSLog(@"Vous etes stationné");
    self.carLocation =[[CLLocation alloc]initWithLatitude:savedCarLocation.coordinate.latitude longitude:savedCarLocation.coordinate.longitude];
    [self.CarMarker setPosition:CLLocationCoordinate2DMake(savedCarLocation.coordinate.latitude, savedCarLocation.coordinate.longitude)];
    [self.firstViewController showPinCar:@"pinEmplacementPlace.png"];
    [self.serverWebSocket gotAPlace:[NSString stringWithFormat:@"%f",savedCarLocation.coordinate.latitude] andLng :[NSString stringWithFormat:@"%f",savedCarLocation.coordinate.longitude]];
    self.savedCarLocation = savedCarLocation;
     self.ETAT = @"STATIONNE";
   // [self stopApiway];
}



- (void) eloigner:(CLLocation*)savedCarLocation ancienneDist:(double)ancienneDist nouvelleDist:(double)nouvelleDist
{
    
    // Je propose navigation à piéton vers sa destination
    //debugTextView.text = [NSString stringWithFormat:@"\nDETECTION : eloignement \n%@",debugTextView.text];
     self.ETAT = @"ELOIGNE";
   

}



- (void) stabiliser:(CLLocation*)savedCarLocation distanceFromCar: (double)distance;
{

}



- (void) revenirVersVoiture:(CLLocation*)savedCarLocation ancienneDist:(double)ancienneDist nouvelleDist:(double)nouvelleDist
{
    
  
    //debugTextView.text = [NSString stringWithFormat:@"\nDETECTION : revenir à la voiture \n%@",debugTextView.text];
    [self.serverWebSocket moveToLeave:[NSString stringWithFormat:@"%f",self.userLocation.coordinate.latitude] andLng:[NSString stringWithFormat:@"%f",self.userLocation.coordinate.longitude] andLat2:[NSString stringWithFormat:@"%f",savedCarLocation.coordinate.latitude] andLng2:[NSString stringWithFormat:@"%f",savedCarLocation.coordinate.longitude]];
     self.ETAT = @"RETOUR";
}

- (void) apifindImplicite:(CLLocation*)savedCarLocation ancienneDist:(double)ancienneDist nouvelleDist:(double)nouvelleDist{
   
   // debugTextView.text = [NSString stringWithFormat:@"\nDETECTION : Apifind \n%@",debugTextView.text];
    
}
*/
@end
