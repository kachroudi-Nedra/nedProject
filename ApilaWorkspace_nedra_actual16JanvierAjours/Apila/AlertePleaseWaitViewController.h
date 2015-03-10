//
//  AlertePleaseWaitViewController.h
//  Apila
//
//  Created by Vincenzo GALATI on 02/03/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertePleaseWaitViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *pleaseWaitLabel;
@property (strong, nonatomic) IBOutlet UIView *alertView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@end
