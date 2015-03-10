//
//  MenuCell.h
//  Apila
//
//  Created by Nedra Kachroudi on 02/01/2015.
//  Copyright (c) 2015 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userPseudo;
@property (strong, nonatomic) IBOutlet UILabel *userCar;

@end
