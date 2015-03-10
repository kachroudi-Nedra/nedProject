//
//  ApiParkViewController.h
//  Apila
//
//  Created by Nedra Kachroudi on 11/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingCell.h"
#import "Parking.h"
#import "ViewController.h"
#import "GoogleMapViewController.h"
#import "NavigationMapViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AlertChooseNavigationViewController.h"
#import <MapKit/MapKit.h>
@class ViewController;
@class NavigationViewController;
@class NavigationMapViewController;
@class GoogleMapViewController;
@class AlertChooseNavigationViewController;

@interface ApiParkViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MKReverseGeocoderDelegate>{
   
    @public
    NSArray *parkings;
    NSArray *sortedParkings;
    Parking *parking;
     Parking *parking1;
     Parking *parking2;
     Parking *parking3;
    CLLocation *UserLocation;
    GoogleMapViewController *map;
    NavigationViewController *navigView;
    NavigationMapViewController *mapNavig;
    CLLocation *destLocation;
    NSString * destAddress;
    NSMutableArray *apiwayArray;
  AlertChooseNavigationViewController*  alertChooseNavigationViewController;
    NavigationMapViewController *navigationMap;

}
@property (strong, nonatomic) IBOutlet UILabel *troisieme_p;
@property (strong, nonatomic) IBOutlet UILabel *deuxieme_p;
@property (strong, nonatomic) IBOutlet UILabel *premier_p;
@property (strong, nonatomic) IBOutlet UIButton *troisiemeButton;
@property (strong, nonatomic) IBOutlet UIButton *deuxiemeButton;
@property (strong, nonatomic) IBOutlet UIButton *premierButton;
@property (strong, nonatomic) IBOutlet UIView *troisiemeView;
@property (strong, nonatomic) IBOutlet UIView *deuxiemeView;
@property (strong, nonatomic) IBOutlet UIView *premierView;
@property (strong, nonatomic) IBOutlet UILabel *troisieme;
@property (strong, nonatomic) IBOutlet UILabel *deuxieme;
@property (strong, nonatomic) IBOutlet UILabel *premier;
@property (strong, nonatomic) IBOutlet UIView *parkingMap;
@property (strong, nonatomic) IBOutlet UITableView *parkingListTable;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;
@property (nonatomic, retain) ViewController * parentController;
-(void)initWithParkingList:(NSMutableArray*)parkingList andApiway:(NSMutableArray*)apiwayArray userLocation:(CLLocation*)userLocation;
@end
