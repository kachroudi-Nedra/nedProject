//
//  Road.h
//  Apila
//
//  Created by Nedra Kachroudi on 20/01/2015.
//  Copyright (c) 2015 1CPARABLE SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Road : NSObject
@property(nonatomic,retain) NSDictionary *overviewPolyline;
@property(nonatomic,retain) NSArray *legs;
@property(nonatomic,retain) NSMutableArray * steps;
@property(nonatomic,retain)CLLocation *startLoc;

@end
