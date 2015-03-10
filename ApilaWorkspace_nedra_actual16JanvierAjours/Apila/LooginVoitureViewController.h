//
//  LooginVoitureViewController.h
//  Apila
//
//  Created by Vincenzo GALATI on 16/06/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"
#import "AppDelegate.h"
#import "SRWebSocket.h"

@class AppDelegate;

@interface LooginVoitureViewController : UIViewController <SRWebSocketDelegate>
{
    int lastSelected; // 1 = marque, 2 = model, 3 = couleur
    SRWebSocket *webSocket;
    
    AppDelegate * appDelegate;
}
@property (weak, nonatomic) IBOutlet UILabel *marqueLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *couleurLabel;
@property (weak, nonatomic) IBOutlet UIButton *boutonRetour;
- (IBAction)actionRetour:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *validerBouton;
- (IBAction)actionValider:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *okImgMarque;
@property (weak, nonatomic) IBOutlet UIImageView *okImgModel;
@property (weak, nonatomic) IBOutlet UIImageView *okImgCouleur;
- (IBAction)marqueAction:(id)sender;
- (IBAction)modelAction:(id)sender;
- (IBAction)colorAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerMarque;
@property (strong, nonatomic) NSArray * marquesNames;
@property (strong, nonatomic) NSArray * modelNames;
@property (strong, nonatomic) NSArray * couleurNames;

@end
