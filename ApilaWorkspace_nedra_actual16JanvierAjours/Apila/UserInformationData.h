//
//  UserInformationData.h
//  Apila
//
//  Created by Nedra Kachroudi on 21/01/2015.
//  Copyright (c) 2015 1CPARABLE SARL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformationData : NSObject
{
    NSError *error;
    NSArray *paths ; //1
    NSString *documentsDirectory ; //2
    NSString *path; //3
    
}
-(id)initFirst;
-(void)writeForKey:(NSString*)key andValue:(NSString*)value;
-(NSString*)readForKey:(NSString*)key ;
@end
