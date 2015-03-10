//
//  SkobblerNavigationViewController.h
//  Apila
//
//  Created by Nedra Kachroudi on 04/03/2015.
//  Copyright (c) 2015 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <SKMaps/SKMaps.h>
#import <SKMaps/SKRouteInformation.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@interface SkobblerNavigationViewController : UIViewController<CLLocationManagerDelegate,SKRoutingDelegate,SKNavigationDelegate>
{
    AppDelegate *appDelegate;
    CLLocation *userLocation;
    NSString *userAddress;
    SKRouteSettings* route;
    AVAudioPlayer *_audioPlayer;
    bool startGeocoding;
    NSString* filePath;
    NSMutableArray *locationArray;
    bool lastAdvice;
    int distanceForAdvice;
}
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIView *goView;
@property (strong, nonatomic) IBOutlet UIView *cancelView;
@property (strong, nonatomic) IBOutlet UIView *InstructionView;
@property (strong, nonatomic) IBOutlet UIImageView *flecheView;
@property (strong, nonatomic) IBOutlet UILabel *leg_time_label;
@property (strong, nonatomic) IBOutlet UIView *skMapView;
@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) SKMapView *skMap;
@property  float addressLat;
@property  float addressLng;
-(void)initWithAddress:(NSString*)address;
@end
