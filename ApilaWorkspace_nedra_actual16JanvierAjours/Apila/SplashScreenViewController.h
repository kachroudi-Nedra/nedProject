//
//  SplashScreenViewController.h
//  Apila
//
//  Created by Nedra Kachroudi on 18/02/2015.
//  Copyright (c) 2015 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformationData.h"
#import "ServerViewController.h"
#import "NSString+MD5.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "SRWebSocket.h"
@interface SplashScreenViewController : UIViewController<SRWebSocketDelegate>
{
    
    UserInformationData *userInformation;
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) ServerViewController * serverWebSocket;

@end
