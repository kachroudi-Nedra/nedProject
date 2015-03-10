//
//  SplashScreenViewController.m
//  Apila
//
//  Created by Nedra Kachroudi on 18/02/2015.
//  Copyright (c) 2015 1CPARABLE SARL. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

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
    
    self.serverWebSocket = [[ServerViewController alloc] init];
    
    [self.serverWebSocket connectWebSocket];
     [self.serverWebSocket setDelegate:self];
    userInformation =[[UserInformationData alloc]init];
    NSLog(@"pseudo: %@",[userInformation readForKey:@"pseudo"]);
     NSLog(@"pwd: %@",[userInformation readForKey:@"password"]);
    //[appDelegate.serverWebSocket loginKnownUserWithID: [userInformation readForKey:@"pseudo"] andPass:[userInformation readForKey:@"password"] andSource:@"apila"];

     //[self autoLog];
    //[serverWebSocket connectWebSocket:@"9500"];
    
}

-(void)autoLog{
   
     userInformation =[[UserInformationData alloc]init];
    //[userInformation readForKey:@"pseudo"];
    //[userInformation readForKey:@"password"];

    [self.serverWebSocket loginKnownUserWithID: [userInformation readForKey:@"pseudo"] andPass:[userInformation readForKey:@"password"] andSource:@"apila"];

}
#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    @try
    {
        
        NSLog(@"Websocket Connected");
        
        NSString * message = [NSString stringWithFormat:@"{\"fct\" : \"join\", \"arg\" : { \"id\" : %i, \"sid\" : \"%@\" }}",appDelegate.user_id,appDelegate.user_sid];
        
        // test
        //NSString * message = [NSString stringWithFormat:@"{\"newId\" : \"foo@apila\", \"pass\" : \"bar\" }"];
        
        ////////NSString * message = [NSString stringWithFormat:@"{\"myId\" : \"foo@apila\", \"pass\" : \"bar\" }"];
        
        NSLog(@"%@",message);
        
        [webSocket send:message];
        
    }
    @catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    @finally
    {
        // Cleanup, in both success and fail cases
        //NSLog( @"In finally block");
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"FAIL (logscreenFB)");
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"CLOSE (logscreenFB)");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSString *str = [NSString stringWithFormat:@"RECEIVED (logscreenFB) \n%@", message];
    NSLog(@"%@",str);
    
    NSString *jsonString = message;
    NSDictionary * sampleInfo = [jsonString objectFromJSONString];
    
    if([[sampleInfo objectForKey:@"recognizedId"] isEqualToString:[NSString stringWithFormat:@"%@@apila",[[userInformation readForKey:@"pseudo"] lowercaseString]]]||[[sampleInfo objectForKey:@"recognizedId"] isEqualToString:[NSString stringWithFormat:@"%@@facebook",[[userInformation readForKey:@"password"] lowercaseString]]])
    {
        NSLog(@"LOGIN OK");
       // [appDelegate showPleaseWait];
       // [self performSelector:@selector(dismissLoginView) withObject:nil afterDelay:2.0];
    }
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

@end
