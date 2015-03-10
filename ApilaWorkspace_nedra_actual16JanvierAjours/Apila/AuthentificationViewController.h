//
//  AuthentificationViewController.h
//  Inscription
//
//  Created by Cyril Hersch on 11/08/2014.
//  Copyright (c) 2014 Apila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKImagePickerViewController.h"
#import "LooginVoitureViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "UserInformationData.h"

@class AppDelegate;
@class LooginVoitureViewController;

typedef enum SocialAccountType  {
    SocialAccountTypeFacebook = 1,
    SocialAccountTypeTwitter = 2
} SocialAccountType;

@interface AuthentificationViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,PKImagePickerViewControllerDelegate>
{
    AppDelegate * appDelegate;
    LooginVoitureViewController * loginProfil;
    BOOL emailvalide;
    UserInformationData *userInformation;
}
@property (atomic) BOOL userDataLoaded;
@property (atomic) BOOL timelineDataLoaded;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property(nonatomic) NSString *pictureProfile;
@property(nonatomic) NSString *Nom;
@property(nonatomic) NSString *Prenom;
@property(nonatomic) NSString *Age;
@property(nonatomic) NSString *emailadress;
@property(nonatomic) int isEmail;
- (id)initWithSocialAccountType:(SocialAccountType)socialAccountType;

- (IBAction)ValiderAction:(id)sender;
- (IBAction)retourAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImageView;

- (IBAction)takePic:(id)sender;
- (IBAction)LoadPic:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *oklEmail;
@property (weak, nonatomic) IBOutlet UIImageView *oklSexe;
@property (weak, nonatomic) IBOutlet UIImageView *oklAge;
@property (weak, nonatomic) IBOutlet UITextField *textMotDePasse;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPseudo;
@property (weak, nonatomic) IBOutlet UIButton *validButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonage;
@property (weak, nonatomic) IBOutlet UIImageView *facebookphoto;

@property (weak, nonatomic) IBOutlet UILabel *labelCGU;
@property (weak, nonatomic) IBOutlet UISwitch *switchCGU;
@property (strong, nonatomic) NSArray * ageNames;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

- (IBAction)clickSWitch:(id)sender;

- (IBAction)selectSexe:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerviewage;
- (IBAction)selectMasc:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *infolabel;


@property (weak, nonatomic) IBOutlet UIButton *sexefemme;
@property (weak, nonatomic) IBOutlet UIButton *sexehomme;
@property (weak, nonatomic) IBOutlet UIButton *sexenone;
- (IBAction)clickMasculin:(id)sender;
- (IBAction)clickFeminin:(id)sender;
- (IBAction)showpassword:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *fondMotDePasse;
@property (strong, nonatomic) IBOutlet UIButton *boutonI;

@end
