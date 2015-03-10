//
//  LogScreen1ViewController.h
//  Apila
//
//  Created by Vincenzo GALATI on 16/06/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogScreen2ViewController.h"
#import "LooginVoitureViewController.h"
#import "AuthentificationViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "SRWebSocket.h"

@class LooginVoitureViewController,AuthentificationViewController,LogScreen2ViewController,AppDelegate;

@interface LogScreen1ViewController : UIViewController <FBLoginViewDelegate,SRWebSocketDelegate>
{
    LogScreen2ViewController * logScreen2;
    LooginVoitureViewController * logScreenVoiture;
    AuthentificationViewController *logScreenAuthentif;
    AppDelegate * appDelegate;
    SRWebSocket *webSocket;
}

@property (strong,nonatomic) IBOutlet FBProfilePictureView *profilePictureiew;
- (IBAction)connectAction:(id)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)linkedInAction:(id)sender;
- (IBAction)facebookAction:(id)sender;
- (IBAction)closeTestAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *seconecter;
@property (weak, nonatomic) IBOutlet UILabel *label_seconecter;
@property (weak, nonatomic) IBOutlet UIImageView *imagelogo;
@property (strong, nonatomic) FBLoginView *loginViewFB;
@property (readwrite, nonatomic) int fb_auto_log;

@end
