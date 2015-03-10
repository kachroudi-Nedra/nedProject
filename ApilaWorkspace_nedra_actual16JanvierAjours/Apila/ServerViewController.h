//
//  ServerViewController.h
//  Apila
//
//  Created by Vincenzo GALATI on 06/10/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"

@interface ServerViewController : UIViewController <SRWebSocketDelegate>
{
    SRWebSocket * webSocket;
}

// Requetes login
- (void) registerNewUserWithID : (NSString *) myId andPass : (NSString *) myPass andSource : (NSString *) source;
- (void) loginKnownUserWithID : (NSString *) myId andPass : (NSString *) myPass andSource : (NSString *) source;

// Requetes voitures
- (void) getCarBaseVersionMajor : (NSString *) major andMinor : (NSString *) minor;
- (void) registerCar : (NSString *) myCar andBrand : (NSString *) brand andType : (NSString *) type andColor : (NSString *) color;

// Requetes JC
- (void) wantToPark : (NSString *) username andWhen : (NSString *) when andPos1 : (NSString *) pos1 andPos2 : (NSString *) pos2 andTo1 : (NSString *) to1 andTo2 : (NSString *) to2 andHow : (NSString *) how andPass : (NSString *) pass andDist : (NSString *) dist;
- (void) wantToPark : (NSString *) username andWhen : (NSString *) when andPos1 : (NSString *) pos1 andPos2 : (NSString *) pos2 andTo1 : (NSString *) to1 andTo2 : (NSString *) to2 andHow : (NSString *) how andPass : (NSString *) pass andDist : (NSString *) dist  andHeading:(float)heading;

- (void) parkOptions : (NSString *) options andPID : (NSString *) pid andPosLat : (NSString *) posLat andPosLng : (NSString *) posLng andPrice : (NSString *) price andPromos : (NSString *) promos andStreetName : (NSString *) name andStreetPosLat : (NSString *) splat andStreetPosLng : (NSString *) splng andStreetSince: (NSString *) delay andStreetPrice: (NSString *) streetPrice andRouteLat : (NSString *) rlat andRouteLng : (NSString *) rlng andPrediction : (NSString *) prediction;

- (void) parking : (NSString *) park andToLat : (NSString *) toLat andToLng : (NSString *) toLng andDuration: (NSString *) duration;

- (void) streetPseudo : (NSString *) pseudo;



- (void) apiway : (NSString *) maxDistance;

- (void) moveToParkLat : (NSString *) posLat andLng : (NSString *) posLng;

- (void) joinPosLat : (NSString *) posLat andPosLng :(NSString *) posLng andToLat : (NSString *) toLat andToLng :(NSString *) toLng;

- (void) notFound : (NSString *) pseudo;

- (void) frustratedBecause : (NSString *) because;

- (void) parkevolPeriod : (NSString *) period andSelect :(NSString *) select andLocationLat : (NSString *) lat andLocationLng :(NSString *) lng andPass : (NSString *) cryptedPass;

- (void) reserveDate : (NSString *) date andSelect :(NSString *) select andLocationLat : (NSString *) lat andLocationLng :(NSString *) lng andPass : (NSString *) cryptedPass andDuration: (NSString *) duration andPtoken : (NSString *) ptoken;

- (void) enterType : (NSString *) type andPtoken :(NSString *) ptoken andPass : (NSString *) cryptedPass;

- (void) exitType : (NSString *) type andPtoken :(NSString *) ptoken andPass : (NSString *) cryptedPass;


// Requetes JL
- (void) leaveLat1 : (NSString *) lat1 andLng1 :(NSString *) lng1 andLat2 : (NSString *) lat2 andLng2 :(NSString *) lng2;

- (void) moveToLeave : (NSString *) lat andLng :(NSString *) lng andLat2 : (NSString *) lat2 andLng2 :(NSString *) lng2;

- (void) Leave : (NSString *) lat andLng :(NSString *) lng;

- (void) cancelWhy : (NSString *) because;

- (void) didNotShowUp : (NSString *) pseudo;

- (void) leftAPlace : (NSString *) pseudo andEval :(NSString *) evaluation;

- (void) cameToMe : (NSString *) pseudo andEval :(NSString *) evaluation;

- (void) gotAPlace : (NSString *) lat andLng :(NSString *) lng;

- (void) see : (NSString *) what;

- (void) ack : (NSString *) pseudo andState :(NSString *) state;

@property (strong, nonatomic) NSString * Port;

// Autres
- (void) connectWebSocket;
- (void)connectWebSocket:(NSString*)port;
- (void) setDelegate:(id) theDelegate;
@end
