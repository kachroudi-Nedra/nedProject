//
//  ServerResponseViewController.m
//  Apila
//
//  Created by Nedra Kachroudi on 24/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "ServerResponseViewController.h"

@interface ServerResponseViewController ()

@end

@implementation ServerResponseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(void)getResponse:(CLLocation*)myLocation andResponseOption:(ResponseOption)Resoption andHeading:(float)currenHeading{
    
    appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    [appDelegate.serverWebSocket setDelegate:self];
    NSLog(@"loc: %@", myLocation);
  
    [appDelegate.serverWebSocket wantToPark:[NSString stringWithFormat:@"%@",appDelegate.user_pseudo] andWhen:@"now" andPos1:[NSString stringWithFormat:@"%0.9f",myLocation.coordinate.latitude] andPos2:[NSString stringWithFormat:@"%0.9f",myLocation.coordinate.longitude] andTo1:[NSString stringWithFormat:@"%0.9f",myLocation.coordinate.latitude] andTo2:[NSString stringWithFormat:@"%0.9f",myLocation.coordinate.longitude] andHow:@"any" andPass:@"apila" andDist:@"1000" andHeading:(currenHeading+180.0)];
   
    self->responseOption = Resoption;
}
-(void)getResponse:(CLLocation*)myLocation andDestination:(CLLocation*)myDestination andResponseOption:(ResponseOption)Resoption andHeading:(float)currenHeading{
    
    appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    [appDelegate.serverWebSocket setDelegate:self];
    NSLog(@"loc: %@", myLocation);
    
    [appDelegate.serverWebSocket wantToPark:[NSString stringWithFormat:@"%@",appDelegate.user_pseudo] andWhen:@"now" andPos1:[NSString stringWithFormat:@"%0.9f",myLocation.coordinate.latitude] andPos2:[NSString stringWithFormat:@"%0.9f",myLocation.coordinate.longitude] andTo1:[NSString stringWithFormat:@"%0.9f",myDestination.coordinate.latitude] andTo2:[NSString stringWithFormat:@"%0.9f",myDestination.coordinate.longitude] andHow:@"any" andPass:@"apila" andDist:@"1000"  andHeading:(currenHeading+180.0)];
    self->responseOption = Resoption;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received server response \"%@\"", message);
    
    NSMutableArray* parkingArray = [[NSMutableArray alloc]init];
    NSMutableArray *routesApiway =[[NSMutableArray alloc]init];
    NSMutableArray *infoParko =[[NSMutableArray alloc]init];
    NSString *jsonString = message;
    NSMutableDictionary * sampleInfo = [jsonString objectFromJSONString];
    
    if(([sampleInfo objectForKey:@"ackError"]!=nil)||(![[sampleInfo objectForKey:@"ackError"] isEqualToString:@""])){
        
        if ([[sampleInfo objectForKey:@"code"] isEqual:@"1140854783"]) {
            
            //[appDelegate showNotif:@"Vous êtes dejà garé!" duringSec:3.0];
        } else {
            //[appDelegate showNotif:[sampleInfo objectForKey:@"ackError"] duringSec:3.0];
        }
        if ([[sampleInfo objectForKey:@"ackError"] rangeOfString:@"Warning: searching while not in your car"].location != NSNotFound) {
           
            //[appDelegate showNotif:@"VOUS ETES DEJA GARE" duringSec:3.0];
            //[appDelegate hidePleaseWait];
        } else {
            //[appDelegate showNotif:[sampleInfo objectForKey:@"ackError"] duringSec:3.0];
        }
    }
    if(([sampleInfo objectForKey:@"parkOptions"]!=nil)||(![[sampleInfo objectForKey:@"parkOptions"] isEqualToString:@""]))
    {
        // si on reçoit tout :
        
        NSLog(@"%@",[sampleInfo objectForKey:@"parkOptions"]);
        
        
        if([[sampleInfo objectForKey:@"parkOptions"] isEqualToString:@"any"])
        {
            // ajout des parking publics
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            // APIWAY
            
            if(responseOption == PARKNOW){
                
                routesApiway =[jsonObjects objectForKey:@"route"];
                infoParko = [jsonObjects objectForKey:@"parking"];
                NSString* distance=  [NSString stringWithFormat:@"%lld m ",[[jsonObjects objectForKey:@"prediction"]longLongValue]];
                [self.delegate sendApiwayResults:routesApiway andDistance:distance];
                
                
                for (int i=0;i<infoParko.count;i++)
                {
                    //NSLog(@"---- RESULT : %@",[infoParko objectAtIndex:i]);
                    
                    Parking *parking = [[Parking alloc]init];
                    parking.name=[[infoParko objectAtIndex:i] objectForKey:@"pid"];
                    parking.address=[[infoParko objectAtIndex:i] objectForKey:@"where"];
                    parking.position= [[ CLLocation alloc]initWithLatitude:[[[[infoParko objectAtIndex:i] objectForKey:@"pos"] objectAtIndex:0] floatValue] longitude:[[[[infoParko objectAtIndex:i] objectForKey:@"pos"] objectAtIndex:1] floatValue]];
                    
                    [parkingArray insertObject:parking atIndex:i];
                    
                }
                [self.delegate sendParkingResults:parkingArray andApiway:routesApiway];
            }
            
        }
    }
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"FAIL (Server Response)");
}


- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed : %@",reason);
    //webSocket = nil;
    
    [appDelegate.serverWebSocket connectWebSocket];
}
-(NSMutableArray*)parseResults:(ResponseOption)option{
    
    return nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
