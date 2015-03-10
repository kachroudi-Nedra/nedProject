//
//  Alert1JLViewController.h
//  Apila
//
//  Created by Vincenzo GALATI on 19/02/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Alert1JLViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *alertView;
@property (strong, nonatomic) IBOutlet UIButton *yesButton;
@property (strong, nonatomic) IBOutlet UIButton *noButton;
- (IBAction)okAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@end
