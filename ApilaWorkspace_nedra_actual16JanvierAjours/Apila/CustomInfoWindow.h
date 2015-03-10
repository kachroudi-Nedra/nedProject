//
//  CustomInfoWindow.h
//  Esplorea Light
//
//  Created by Vincenzo GALATI on 16/09/13.
//  Copyright (c) 2013 1CPARABLE SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInfoWindow : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imagePoi;
@property (strong, nonatomic) IBOutlet UIButton *consultButton;
@property (strong, nonatomic) IBOutlet UILabel *titreLabel;
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *marqueLabel;
@property (strong, nonatomic) IBOutlet UILabel *couleurLabel;
@property (strong, nonatomic) IBOutlet UILabel *profilTitreLabel;

@end
