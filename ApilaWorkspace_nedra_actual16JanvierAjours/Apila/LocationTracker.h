//
//  LocationTracker.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"
#import <UIKit/UIKit.h>


@protocol DetectionnProtocolDelegate <NSObject>
@required
- (void) updatePlace;

@end;


@interface LocationTracker : NSObject <CLLocationManagerDelegate>{
    
    id <DetectionnProtocolDelegate> _delegate;
    float marcheLat;                    // lat GPS du point d'arrèt
    float marcheLng;
    double timerGPS;
    int count;
    double wantedAccuracy;
}

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (strong,nonatomic) NSString * accountStatus;
@property (strong,nonatomic) NSString * authKey;
@property (strong,nonatomic) NSString * device;
@property (strong,nonatomic) NSString * name;
@property (strong,nonatomic) NSString * profilePicURL;
@property (strong,nonatomic) NSNumber * userid;

@property (nonatomic,strong) id delegate;
@property (strong,nonatomic) LocationShareModel * shareModel;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (CLLocationCoordinate2D )getBestLocation;
-(void)startLocationByDelay :(double )time;
-(void)stopLocationDelayBySeconds;
-(void)setAccuracy:(double)accuracy;
@end
