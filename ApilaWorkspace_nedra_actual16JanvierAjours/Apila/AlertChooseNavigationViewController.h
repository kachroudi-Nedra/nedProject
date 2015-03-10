//
//  AlertChooseNavigationViewController.h
//  Apila
//
//  Created by Nedra Kachroudi on 09/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationMapViewController.h"
#import "AppDelegate.h"
@class NavigationViewController;
@class ViewController;
@class NavigationMapViewController;
@interface AlertChooseNavigationViewController : UIViewController<UITableViewDataSource,UITabBarDelegate>
{
   NavigationMapViewController* navigationMap;
    NSString* destinationLoc;
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UISwitch *chooseSwitch;
@property int indexNavig;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *ApilaButton;
@property (strong, nonatomic) IBOutlet UIButton *GoogleMapButton;
@property (strong, nonatomic) IBOutlet UIButton *WazeButton;
@property (strong, nonatomic) IBOutlet UIButton *AppleButton;
@property (strong, nonatomic) IBOutlet UITableView *navigationList;
@property (nonatomic, retain) NavigationViewController * parentController;
@property (nonatomic, retain) ViewController * MotherController;
-(void)initWithDestLoc:(NSString*)destLoc;

@end
