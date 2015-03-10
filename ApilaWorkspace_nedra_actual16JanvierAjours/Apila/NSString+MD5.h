//
//  MD5.h
//  FunTour
//
//  Created by Vincenzo GALATI on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NSString(MD5)

- (NSString *)MD5;
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

@end