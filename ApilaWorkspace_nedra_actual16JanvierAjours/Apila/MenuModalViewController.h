//
//  MenuModalViewController.h
//  Apila
//
//  Created by Vincenzo GALATI on 19/02/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuCell.h"
#import "AppDelegate.h"
@class AppDelegate;
@interface MenuModalViewController : UIViewController <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
   IBOutlet  UIImageView *imageview;
    MenuCell *cell;
    AppDelegate * appDelegate;
}

- (IBAction)closeMenuAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userPseudo;
@property (strong, nonatomic) IBOutlet UILabel *userCar;
@property (strong, nonatomic) IBOutlet UIButton *closeMenuButton;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *CanvasView;

@end
