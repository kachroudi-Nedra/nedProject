//
//  Geocoding.m
//  Apila
//
//  Created by Nedra Kachroudi on 20/01/2015.
//  Copyright (c) 2015 1CPARABLE SARL. All rights reserved.
//

#import "Geocoding.h"

@implementation Geocoding

- (void) startNavigRequest:(NSString*)destinationLocation
{
    //destinationLocation=@"6 Rue Neuve Tolbiac 75013‎,Paris,France";
    NSString* dest = [destinationLocation stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *post2 = [NSString stringWithFormat:@"address=%@&sensor=true",[dest urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"REQUEST ADRESSE : %@",post2);
    
    NSMutableURLRequest * request2 = [[NSMutableURLRequest alloc] init];
    [request2 setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true",[dest urlEncodeUsingEncoding:NSUTF8StringEncoding]]]];
    [request2 setHTTPMethod:@"GET"];
    
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request2 delegate:self];
    
    [connection start];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d
{
    responseString = [NSString stringWithFormat:@"%@%@",responseString,[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:@"Il y a eu une coupure de connexion, l'opération a été annulée."/*[error localizedDescription]*/
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
    
    
    
}

-(NSString *) stringByStrippingHTML:(NSString *)s
{
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"RECEIVED POI : %@",responseString);
    
    @try
    {
        NSData * data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * entries = [jsonObjects objectForKey:@"results"];
        
        NSLog(@"---- RESULT : %@",[[[[entries objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"]);
        destLat = [[[[[entries objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] floatValue];
        destLng = [[[[[entries objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];
        
        if(markerDestination == nil)
        {
            markerDestination = [[GMSMarker alloc] init];
            markerDestination.icon = [UIImage imageNamed:@"pinArriver.png"];
            //markerDestination.map = self.mapGoogle;
        }
        
        [markerDestination setPosition:CLLocationCoordinate2DMake(destLat, destLng)];
        [self.delegate SendResponse:markerDestination];
        }
    @catch (NSException *exception)
    {
        NSLog(@"ERROR ADRESSE INCONNUE");
        
    }
    
    responseString = @"";
}

@end
