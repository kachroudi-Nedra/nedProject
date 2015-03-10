//
//  MDDirectionService.h
//  Esplorea Light
//
//  Created by Vincenzo GALATI on 18/09/13.
//  Copyright (c) 2013 1CPARABLE SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MDDirectionService : NSObject{
    UIAlertView * pleaseWait;
    int pleaseWaitShown;
}
- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector
       withDelegate:(id)delegate;
@end