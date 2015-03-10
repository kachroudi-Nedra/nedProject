//
//  HomeRecommanded.h
//  Apila
//
//  Created by Nedra Kachroudi on 12/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeRecommanded : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *recommandedImage;
@property (strong, nonatomic) IBOutlet UILabel *recommandedName;
@property (strong, nonatomic) IBOutlet UIButton *recommandedButton;
@property (strong, nonatomic) IBOutlet UILabel *recommandedDistance;
@property (strong, nonatomic) IBOutlet UILabel *recommandedAddress;
@end
