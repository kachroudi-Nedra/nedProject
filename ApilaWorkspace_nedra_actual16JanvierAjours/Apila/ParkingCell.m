//
//  ParkingCell.m
//  Apila
//
//  Created by Nedra Kachroudi on 11/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "ParkingCell.h"

@implementation ParkingCell


- (void)awakeFromNib
{
    // Initialization code
    self.parkName.numberOfLines = 0;
    CGSize labelSize = [self.parkName.text sizeWithFont:self.parkName.font
                              constrainedToSize:self.parkName.frame.size
                                  lineBreakMode:self.parkName.lineBreakMode];
    self.parkName.frame = CGRectMake(
                             self.parkName.frame.origin.x, self.parkName.frame.origin.y,
                             self.parkName.frame.size.width, labelSize.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
