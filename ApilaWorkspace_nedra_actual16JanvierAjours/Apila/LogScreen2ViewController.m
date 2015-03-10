//
//  LogScreen2ViewController.m
//  Apila
//
//  Created by Vincenzo GALATI on 16/06/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "LogScreen2ViewController.h"

@interface LogScreen2ViewController ()

@end

@implementation LogScreen2ViewController

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
    
    UIColor *color = [UIColor whiteColor];
    self.pseudoField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PSEUDO" attributes:@{NSForegroundColorAttributeName: color}];
    self.passeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"MOT DE PASSE" attributes:@{NSForegroundColorAttributeName: color}];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [appDelegate.serverWebSocket setDelegate:self];
}

-(void)dismissKeyboard
{
    [self.pseudoField resignFirstResponder];
    [self.passeField resignFirstResponder];
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

- (IBAction)Connexion_Click:(id)sender
{
    appDelegate.user_pseudo = self.pseudoField.text;
    appDelegate.user_pass = self.passeField.text;
    
    [[appDelegate serverWebSocket] loginKnownUserWithID:appDelegate.user_pseudo andPass:appDelegate.user_pass andSource:@"apila"];
}

- (IBAction)click_Retour:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"FAIL (logscreen2)");
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"CLOSE (logscreen2)");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSString *str = [NSString stringWithFormat:@"RECEIVED (logscreen2) \n%@", message];
    NSLog(str);
    
    NSString *jsonString = message;
    NSDictionary * sampleInfo = [jsonString objectFromJSONString];
    
    if([[sampleInfo objectForKey:@"recognizedId"] isEqualToString:[NSString stringWithFormat:@"%@@apila",[appDelegate.user_pseudo lowercaseString]]])
    {
        NSLog(@"LOGIN OK");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if([[sampleInfo objectForKey:@"unknownId"] isEqualToString:[NSString stringWithFormat:@"%@@apila",[appDelegate.user_pseudo lowercaseString]]])
    {
        NSLog(@"LOGIN FAILED");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Le login a échoué" message:@"Merci de vérifier vos informations" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
@end
