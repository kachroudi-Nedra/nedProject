//
//  UserInformationData.m
//  Apila
//
//  Created by Nedra Kachroudi on 21/01/2015.
//  Copyright (c) 2015 1CPARABLE SARL. All rights reserved.
//

#import "UserInformationData.h"

@implementation UserInformationData

-(id)initFirst{
    
    if (!self) {
       
       paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
       documentsDirectory = [paths objectAtIndex:0]; //2
       path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; //3
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath: path]) //4
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]; //5
            
            [fileManager copyItemAtPath:bundle toPath: path error:nil]; //6
        }
        

        return self;
    }
    return nil;
}
-(void)writeForKey:(NSString*)key andValue:(NSString*)value{
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    documentsDirectory = [paths objectAtIndex:0]; //2
    path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:nil]; //6
    }
    

    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    //here add elements to data file and write data to file
    
    [data setObject:value forKey:key];
    
    [data writeToFile: path atomically:YES];
}
-(NSString*)readForKey:(NSString*)key {
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    documentsDirectory = [paths objectAtIndex:0]; //2
    path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:nil]; //6
    }
    

    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    //load from savedStock example int value
    NSString* value = [savedStock objectForKey:key] ;
    
    return value;
}
@end
