//
//  ServerResponseViewController.h
//  Apila
//
//  Created by Nedra Kachroudi on 24/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"
#import "AppDelegate.h"
#import "Parking.h"
@class AppDelegate;
@protocol ServerResponseDelegate <NSObject>
@required

-(void)sendApiwayResults:(NSMutableArray*)apiwayArray andDistance:(NSString*)distance;
-(void)sendParkingResults:(NSMutableArray*)parkingArray andApiway:(NSMutableArray*)apiwayArray;

@end
typedef enum ResponseOption
{
    PARKNOW
} ResponseOption;

@interface ServerResponseViewController : UIViewController<SRWebSocketDelegate>
{
    AppDelegate  *appDelegate;
    ResponseOption responseOption;
    NSArray *colorsOfApiway;
    
}
@property id <ServerResponseDelegate> delegate;
-(void)getResponse:(CLLocation*)myLocation andResponseOption:(ResponseOption)Resoption andHeading:(float)currenHeading;
-(void)getResponse:(CLLocation*)myLocation andDestination:(CLLocation*)myDestination andResponseOption:(ResponseOption)Resoption andHeading:(float)currenHeading;
@end
