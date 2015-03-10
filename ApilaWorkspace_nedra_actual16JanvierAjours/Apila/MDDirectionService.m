//
//  MDDirectionService.m
//  Esplorea Light
//
//  Created by Vincenzo GALATI on 18/09/13.
//  Copyright (c) 2013 1CPARABLE SARL. All rights reserved.
//

#import "MDDirectionService.h"
#import "Reachability.h"
@implementation MDDirectionService{
@private
    BOOL _sensor;
    BOOL _alternatives;
    NSURL *_directionsURL;
    NSArray *_waypoints;
}

static NSString *kMDDirectionsURL = @"https://maps.googleapis.com/maps/api/directions/json?";

- (void)setDirectionsQuery:(NSDictionary *)query withSelector:(SEL)selector
              withDelegate:(id)delegate{
   //AppDelegate* appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    pleaseWait = [[UIAlertView alloc] initWithTitle:@"Pas de connexion internet" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];

    NSArray *waypoints = [query objectForKey:@"waypoints"];
    NSString *origin = [waypoints objectAtIndex:0];
    int waypointCount = [waypoints count];
    int destinationPos = waypointCount -1;
    NSString *destination = [waypoints objectAtIndex:destinationPos];
    NSString *mode = [query objectForKey:@"mode"];
    NSString *sensor = [query objectForKey:@"sensor"];
     NSString *alternative = [query objectForKey:@"alternatives"];
    NSMutableString *url =
    [NSMutableString stringWithFormat:@"%@&origin=%@&destination=%@&sensor=%@&mode=%@&alternatives=%@&key=AIzaSyAvkTwe5NnXl_RHy4UzLhFdAX19JMTyZGk",
     kMDDirectionsURL,origin,destination,sensor,mode,alternative];
    if(waypointCount>4) {
        [url appendString:@"&waypoints=optimize:true"];
        int wpCount = waypointCount-2;
        for(int i=1;i<wpCount;i++){
            [url appendString: @"|"];
            [url appendString:[waypoints objectAtIndex:i]];
        }
    }
    url = [url stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    _directionsURL = [NSURL URLWithString:url];
    
    NSLog(@"URL : %@",url);
        [self retrieveDirections:selector withDelegate:delegate];

}
- (void)retrieveDirections:(SEL)selector withDelegate:(id)delegate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data =
        [NSData dataWithContentsOfURL:_directionsURL];
        [self fetchedData:data withSelector:selector withDelegate:delegate];
    });
}

- (void)fetchedData:(NSData *)data
       withSelector:(SEL)selector
       withDelegate:(id)delegate{
    
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    [delegate performSelector:selector withObject:json];
}
- (void) showPleaseWait
{
    if (pleaseWaitShown == 0)
    {
        pleaseWaitShown = 1;
        [pleaseWait show];
    }
}

- (void) hidePleaseWait
{
    if (pleaseWaitShown == 1)
    {
        [pleaseWait dismissWithClickedButtonIndex:0 animated:YES];
    }
}

@end