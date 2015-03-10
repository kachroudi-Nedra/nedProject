//
//  Leg.m
//  Apila
//
//  Created by Nedra Kachroudi on 08/01/2015.
//  Copyright (c) 2015 1CPARABLE SARL. All rights reserved.
//

#import "Leg.h"

@implementation Leg

-(id)initWith:(CLLocation*)startLocation EndLocation:(CLLocation*)endLocation HtmlInstruction:(NSString*)HtmlInstruction Distance:(double)Distance Duration:(double)Duration Polyline:(GMSPolyline*)Polyline{
    
    if(!self){
        
        self.startLoc= startLocation;
        self.endLoc= endLocation;
        self.htmlInstruction= HtmlInstruction ;
        self.distance= Distance;
        self.duration= Duration;
        self.polyline= Polyline;
    }
    return self;
}
@end
