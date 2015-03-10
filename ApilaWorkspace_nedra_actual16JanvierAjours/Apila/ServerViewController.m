//
//  ServerViewController.m
//  Apila
//
//  Created by Vincenzo GALATI on 06/10/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "ServerViewController.h"

@interface ServerViewController ()

@end

@implementation ServerViewController

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
    
    [self connectWebSocket];
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

- (void)connectWebSocket
{
    webSocket.delegate = nil;
    webSocket = nil;
     NSString *urlString = [NSString stringWithFormat:@"ws://37.187.144.147:9000"];
    //NSString *urlString = @"ws://37.187.144.147:9000";
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;
    
    [newWebSocket open];
}
- (void)connectWebSocket:(NSString*)port
{
    webSocket.delegate = nil;
    webSocket = nil;
    self.Port = port;
    NSString *urlString = [NSString stringWithFormat:@"ws://37.187.144.147:%@",port];
    //NSString *urlString = @"ws://37.187.144.147:9000";
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;
    
    [newWebSocket open];
}
- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket
{
    webSocket = newWebSocket;
    NSLog(@"WebSocket Did Open");
}

- (void) registerNewUserWithID : (NSString *) myId andPass : (NSString *) myPass andSource : (NSString *) source
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{\"newId\" : \"%@@%@\", \"pass\" : \"%@\" }",[myId lowercaseString],source,myPass];
        NSLog(@"%@",message);
        [webSocket send:message];
        
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) loginKnownUserWithID : (NSString *) myId andPass : (NSString *) myPass andSource : (NSString *) source
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{\"myId\" : \"%@@%@\", \"pass\" : \"%@\" }",[myId lowercaseString],source,myPass];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) getCarBaseVersionMajor : (NSString *) major andMinor : (NSString *) minor
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{\"carBaseVersion\" : [%@, %@] }",major,minor];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) registerCar : (NSString *) myCar andBrand : (NSString *) brand andType : (NSString *) type andColor : (NSString *) color
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{\"myCar\" : \"%@\", \"brand\" : \"%@\", \"type\" : \"%@\", \"color\" : \"%@\", }",myCar,brand,type,color];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) wantToPark : (NSString *) username andWhen : (NSString *) when andPos1 : (NSString *) pos1 andPos2 : (NSString *) pos2 andTo1 : (NSString *) to1 andTo2 : (NSString *) to2 andHow : (NSString *) how andPass : (NSString *) pass andDist : (NSString *) dist
{
    // - when : "now" ou une date sous la forme "J-M-A h:m:s"
    // - how : "any" -> renvoie la route et les parkings à proximité, sinon "street" ou "parking"
    // - pos : lat, lng de la position actuelle
    // - to : lat,lng de l'endroit ou on veut se rendre pour se garer
    
    
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{\"wantToPark\" : \"%@\", \"when\" : \"%@\",  \"pos\" : [%@, %@], \"to\" : [%@, %@], \"how\" : \"%@\", \"pass\" : \"%@\", \"dist\": %@}",username,when,pos1,pos2,to1,to2,how,pass,dist];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}
- (void) wantToPark : (NSString *) username andWhen : (NSString *) when andPos1 : (NSString *) pos1 andPos2 : (NSString *) pos2 andTo1 : (NSString *) to1 andTo2 : (NSString *) to2 andHow : (NSString *) how andPass : (NSString *) pass andDist : (NSString *) dist andHeading:(float)heading
{
    // - when : "now" ou une date sous la forme "J-M-A h:m:s"
    // - how : "any" -> renvoie la route et les parkings à proximité, sinon "street" ou "parking"
    // - pos : lat, lng de la position actuelle
    // - to : lat,lng de l'endroit ou on veut se rendre pour se garer
    
    
    @try //"{ "myreq": "{\"wantToPark\" : \"Nedra\", \"when\" : \"now\",  \"pos\" : [48.824923, 2.383642], \"to\" : [48.824923, 2.383642], \"how\" : \"any\", \"pass\" : \"apila\", \"dist\":2000\",\"orient\":0.000000}"}"
    {
        NSString * message = [NSString stringWithFormat:@"{\"wantToPark\" : \"%@\", \"when\" : \"%@\",  \"pos\" : [%@, %@], \"to\" : [%@, %@], \"how\" : \"%@\", \"pass\" : \"%@\", \"dist\":%@,\"orient\":%f}",username,when,pos1,pos2,to1,to2,how,pass,dist,heading];
       //NSString * message = [NSString stringWithFormat:@"{\"wantToPark\" : \"%@\", \"when\" : \"%@\",  \"pos\" : [%@, %@], \"to\" : [%@, %@], \"how\" : \"%@\", \"pass\" : \"%@\", \"dist\": %@}",username,when,pos1,pos2,to1,to2,how,pass,dist];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) parkOptions : (NSString *) options andPID : (NSString *) pid andPosLat : (NSString *) posLat andPosLng : (NSString *) posLng andPrice : (NSString *) price andPromos : (NSString *) promos andStreetName : (NSString *) name andStreetPosLat : (NSString *) splat andStreetPosLng : (NSString *) splng andStreetSince: (NSString *) delay andStreetPrice: (NSString *) streetPrice andRouteLat : (NSString *) rlat andRouteLng : (NSString *) rlng andPrediction : (NSString *) prediction
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{\"parkOptions\" : \"%@\" , \"pos\" : [ { \"pid\" : \"%@\", \"pos\" : [%@,%@], \"price\" : \"%@\", \"promos\" : \"%@\" }],  \"street\" : [ { \"name\" : \"%@\", \"pos\" : [%@,%@], \"since\" : \"%@\", \"price\" : \"%@\" }] , \"route\": [[%@,%@]], \"prediction\": \"%@\"} ",options,pid,posLat,posLng,price,promos,name,splat,splng,delay,streetPrice,rlat,rlng,prediction];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) parking : (NSString *) park andToLat : (NSString *) toLat andToLng : (NSString *) toLng andDuration: (NSString *) duration
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"parking\" : \"%@\", \"to\" : [%@,%@], \"duration\" : \"%@\" }",park,toLat,toLng,duration];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) streetPseudo : (NSString *) pseudo
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"street\" : \"%@\"}",pseudo];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) apiway : (NSString *) maxDistance
{
    // maxDistance : 0 / distance max en m
    
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"apiway\" : \"%@\"}",maxDistance];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) moveToParkLat : (NSString *) posLat andLng : (NSString *) posLng
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"moveToPark\" : [%@,%@] }",posLat,posLng];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) joinPosLat : (NSString *) posLat andPosLng :(NSString *) posLng andToLat : (NSString *) toLat andToLng :(NSString *) toLng
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"join\" : [%@,%@], \"to\": [%@,%@] } ",posLat,posLng,toLat,toLng];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) notFound : (NSString *) pseudo
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"notFound\" : \"%@\" } ",pseudo];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) frustratedBecause : (NSString *) because
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"frustrated\" : \"%@\" }",because];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) parkevolPeriod : (NSString *) period andSelect :(NSString *) select andLocationLat : (NSString *) lat andLocationLng :(NSString *) lng andPass : (NSString *) cryptedPass
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"parkevol\": \"%@\",  \"select\": \"%@\",  \"location\": [%@,%@],\"pass\": \"%@\" }",period,select,lat,lng,cryptedPass];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) reserveDate : (NSString *) date andSelect :(NSString *) select andLocationLat : (NSString *) lat andLocationLng :(NSString *) lng andPass : (NSString *) cryptedPass andDuration: (NSString *) duration andPtoken : (NSString *) ptoken
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"reserve\": \"%@\",  \"select\": \"%@\", \"location\": [%@,%@], \"pass\": \"%@\", \"duration\": \"%@\", \"ptoken\": \"%@\"}",date,select,lat,lng,cryptedPass,duration,ptoken];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) enterType : (NSString *) type andPtoken :(NSString *) ptoken andPass : (NSString *) cryptedPass
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"enter\": \"%@\", \"ptoken\" : \"%@\" , \"pass\": \"%@\"}",type,ptoken,cryptedPass];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) exitType : (NSString *) type andPtoken :(NSString *) ptoken andPass : (NSString *) cryptedPass
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"exit\": \"%@\", \"ptoken\" : \"%@\" , \"pass\": \"%@\"}",type,ptoken,cryptedPass];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) leaveLat1 : (NSString *) lat1 andLng1 :(NSString *) lng1 andLat2 : (NSString *) lat2 andLng2 :(NSString *) lng2
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"leave\" : [%@,%@],  \"to\": [%@,%@]}",lat1,lng1,lat2,lng2];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) moveToLeave : (NSString *) lat andLng :(NSString *) lng andLat2 : (NSString *) lat2 andLng2 :(NSString *) lng2
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"moveToLeave\" : [%@,%@] ,  \"to\": [%@,%@]}",lat,lng,lat2,lng2];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}
- (void) Leave : (NSString *) lat andLng :(NSString *) lng
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"leave\" : [%@,%@]}",lat,lng];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) cancelWhy : (NSString *) because
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"cancel\" : \"%@\"}",because];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) didNotShowUp : (NSString *) pseudo
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"didNotShowUp\" : \"%@\"}",pseudo];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) leftAPlace : (NSString *) pseudo andEval :(NSString *) evaluation
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"leftAPlace\" : \"%@\", \"evaluation\" : \"%@\" }",pseudo,evaluation];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) cameToMe : (NSString *) pseudo andEval :(NSString *) evaluation
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"cameToMe\" : \"%@\", \"evaluation\" : \"%@\" }",pseudo,evaluation];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) gotAPlace : (NSString *) lat andLng :(NSString *) lng
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"gotAPlace\" : [%@,%@] }",lat,lng];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) see : (NSString *) what
{
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"see\" : \"%@\" }",what];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void) ack : (NSString *) pseudo andState :(NSString *) state
{
    // { "ack": "<pseudo>": "state": "<too late>|<left>|<ok>|<waiting>|<canceled>" }
    
    @try
    {
        NSString * message = [NSString stringWithFormat:@"{ \"ack\" : \"%@\" , \"state\" : \"%@\" }",pseudo,state];
        NSLog(@"%@",message);
        [webSocket send:message];
    }
    @catch (NSException *exception)
    {
        NSLog( @"NSException caught" );
        NSLog( @"Name : %@", exception.name);
        NSLog( @"Reason : %@", exception.reason );
    }
    @finally
    {
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    //[self connectWebSocket];
    NSLog(@"FAIL ServerViewControll");
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    [self connectWebSocket];
    NSLog(@"CLOSE");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSString *str = [NSString stringWithFormat:@"RECEIVED (ServerViewController) \n%@", message];
    NSLog(str);
}

- (void) setDelegate:(id) theDelegate
{
    webSocket.delegate = theDelegate;
}

@end
