//
//  HomeRecommandedViewCtrl.h
//  Apila
//
//  Created by Nedra Kachroudi on 12/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "HomeRecommanded.h"
#import "NavigationMapViewController.h"
#import "Parking.h"
@class ViewController;
@class NavigationViewController;
@class NavigationMapViewController;
@class AlertChooseNavigationViewController;
@interface HomeRecommandedViewCtrl : UIViewController
{
    NSArray *parkings;
    NSArray *sortedParkings;
    Parking *parking;
    CLLocation *UserLocation;
    NSMutableArray * apiwayArray;
    NavigationViewController *navigView;
    NavigationMapViewController *navigationMap;
    @public
    BOOL isVisible;
    AlertChooseNavigationViewController * alertChooseNavigationViewController;

}
@property (strong, nonatomic) IBOutlet UITableView *recommandedListTable;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) ViewController * parentController;
-(void)initWithParkings:(NSMutableArray*)parkingList andApiway:(NSMutableArray*)apiwayRoute userLocation:(CLLocation*)userLocation ;
- (IBAction)apiShare:(id)sender;
- (IBAction)apiWay:(id)sender ;
- (IBAction)apiPark:(id)sender;

@end
