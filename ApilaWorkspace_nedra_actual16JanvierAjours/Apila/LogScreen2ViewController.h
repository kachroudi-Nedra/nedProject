//
//  LogScreen2ViewController.h
//  Apila
//
//  Created by Vincenzo GALATI on 16/06/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SRWebSocket.h"

@class AppDelegate;

@interface LogScreen2ViewController : UIViewController <SRWebSocketDelegate>
{
    AppDelegate * appDelegate;
}

@property (weak, nonatomic) IBOutlet UITextField *pseudoField;
@property (weak, nonatomic) IBOutlet UITextField *passeField;
- (IBAction)Connexion_Click:(id)sender;
- (IBAction)click_Retour:(id)sender;

@end
