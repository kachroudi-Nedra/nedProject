//
//  Parking.h
//  Apila
//
//  Created by Nedra Kachroudi on 11/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Parking : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) CLLocation *position;
@property  int distance;

@end
