//
//  ParkingCell.h
//  Apila
//
//  Created by Nedra Kachroudi on 11/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *parkImage;
@property (strong, nonatomic) IBOutlet UILabel *parkName;
@property (strong, nonatomic) IBOutlet UIButton *parkButton;
@property (strong, nonatomic) IBOutlet UILabel *parkDistance;
@property (strong, nonatomic) IBOutlet UILabel *parkAddress;

@end
