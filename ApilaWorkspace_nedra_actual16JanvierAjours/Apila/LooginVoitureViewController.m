//
//  LooginVoitureViewController.m
//  Apila
//
//  Created by Vincenzo GALATI on 16/06/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "LooginVoitureViewController.h"
#import "MMPickerView.h"

@interface LooginVoitureViewController ()

@end

@implementation LooginVoitureViewController

@synthesize marquesNames,modelNames,couleurNames;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    
    self.okImgCouleur.hidden = YES;
    self.okImgMarque.hidden = YES;
    self.okImgModel.hidden = YES;
    
    self.validerBouton.hidden = YES;
    self.pickerMarque.hidden = YES;
    
    self.marquesNames = @[@"Alfa Romeo", @"BMW", @"Citroën", @"Ford", @"Toyota"];
    self.modelNames = @[@"Model 1", @"Model 2", @"Model 3", @"Model 4", @"Model 5"];
    self.couleurNames = @[@"Bleu", @"Gris", @"Jaune", @"Orange", @"Noir", @"Rouge"];
}

- (void) viewDidAppear:(BOOL)animated
{
    [appDelegate.serverWebSocket setDelegate:self];
    
    [appDelegate.serverWebSocket getCarBaseVersionMajor:@"0" andMinor:@"0"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionRetour:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionValider:(id)sender
{
    if ((appDelegate.user_fb_id != nil)&&(![appDelegate.user_fb_id isEqualToString:@""]))
        [[appDelegate serverWebSocket] registerNewUserWithID:appDelegate.user_pseudo andPass:appDelegate.user_pass andSource:@"facebook"];
    else [[appDelegate serverWebSocket] registerNewUserWithID:appDelegate.user_pseudo andPass:appDelegate.user_pass andSource:@"apila"];
}

- (IBAction)marqueAction:(id)sender
{
    lastSelected = 1;
    self.infoLabel.hidden = YES;
    self.validerBouton.hidden=YES;
    self.pickerMarque.hidden = NO;
    [MMPickerView showPickerViewInView:self.view
                           withStrings:self.marquesNames
                           withOptions:nil
                            completion:^(NSString *selectedString) {
                                //selectedString is the return value which you can use as you wish
                                _marqueLabel.text = selectedString;
                              
                                self.okImgMarque.hidden = NO;
                           
                                
                            }];
    
}

- (IBAction)modelAction:(id)sender
{
    lastSelected = 2;
    self.infoLabel.hidden = YES;
     self.validerBouton.hidden=YES;
    self.pickerMarque.hidden = NO;
    [MMPickerView showPickerViewInView:self.view
                           withStrings:self.modelNames
                           withOptions:nil
                            completion:^(NSString *selectedString) {
                                //selectedString is the return value which you can use as you wish
                                _modelLabel.text = selectedString;
                         
                                self.okImgModel.hidden = NO;
                            }];
    
}

- (IBAction)colorAction:(id)sender
{
    lastSelected = 3;
    self.infoLabel.hidden = YES;
 self.validerBouton.hidden=YES;
    self.pickerMarque.hidden = NO;
    
    [MMPickerView showPickerViewInView:self.view
                           withStrings:self.couleurNames
                           withOptions:nil
                            completion:^(NSString *selectedString) {
                                //selectedString is the return value which you can use as you wish
                                _couleurLabel.text = selectedString;
                                self.okImgCouleur.hidden = NO;
                                self.validerBouton.hidden=NO;
                              
                            }];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"FAIL (logscreenVoiture)");
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"CLOSE (logscreenVoiture)");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSString *str = [NSString stringWithFormat:@"RECEIVED (logscreenVoiture) \n%@", message];
    NSLog(str);
    
    NSString *jsonString = [message stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
    NSDictionary * sampleInfo = [jsonString objectFromJSONString];
    NSLog(@"DICTO : %@",sampleInfo);
    
    
    
    if([[sampleInfo objectForKey:@"recognizedId"] isEqualToString:[NSString stringWithFormat:@"%@@apila",[appDelegate.user_pseudo lowercaseString]]]||[[sampleInfo objectForKey:@"recognizedId"] isEqualToString:[NSString stringWithFormat:@"%@@facebook",[appDelegate.user_pseudo lowercaseString]]])
    {
        NSLog(@"LOGIN OK, CAR : %@ %@ %@",self.marqueLabel.text,self.modelLabel.text,self.couleurLabel.text);
        
        // s'il ne s'agit pas d'une connexion FB on save les info pour l'autolog
        if((appDelegate.user_fb_id == nil)||([appDelegate.user_fb_id isEqualToString:@""]))
        {
            // on écrit les pseudos et path de l'user :
            NSArray *paths = NSSearchPathForDirectoriesInDomains
            (NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *fileName = [NSString stringWithFormat:@"%@/LOGS/autoLlog",documentsDirectory];
            
            NSString *content = appDelegate.user_pseudo;
            [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
            
            fileName = [NSString stringWithFormat:@"%@/LOGS/autoLlogP",documentsDirectory];
            content = appDelegate.user_pass;
            [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        }
        
        [appDelegate.serverWebSocket registerCar:@"firstcar" andBrand:self.marqueLabel.text andType:self.modelLabel.text andColor:self.couleurLabel.text];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if([sampleInfo objectForKey:@"carBaseUpdate"] != nil)
    {
        NSLog (@"CAR BASE");
        self.marquesNames = [sampleInfo objectForKey:@"brands"];
        self.couleurNames = [sampleInfo objectForKey:@"colors"];
        self.modelNames = [sampleInfo objectForKey:@"types"];
        
        [self.pickerMarque reloadAllComponents];
    }
}


@end
