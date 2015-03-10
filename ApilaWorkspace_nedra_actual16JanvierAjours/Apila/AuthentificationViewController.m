//
//  AuthentificationViewController.m
//  Inscription
//
//  Created by Cyril Hersch on 11/08/2014.
//  Copyright (c) 2014 Apila. All rights reserved.
//

#import "AuthentificationViewController.h"
#import "PAImageView.h"

@interface AuthentificationViewController ()
@property (nonatomic) SocialAccountType socialAccountType;
@end

@implementation AuthentificationViewController
@synthesize socialAccountType = _socialAccountType;
@synthesize userDataLoaded = _userDataLoaded;
@synthesize timelineDataLoaded = _timelineDataLoaded;
@synthesize ProfileImageView,oklAge,oklEmail,oklSexe,textEmail,textMotDePasse,textPseudo,validButton,ageLabel,sexefemme,sexehomme,sexenone,isEmail;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Texfield Pseudo
    
    appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    
    UIColor *color = [UIColor whiteColor];
    self.textPseudo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PSEUDO" attributes:@{NSForegroundColorAttributeName: color}];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    self.textPseudo.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    //Texfield Mot de passe
    self.textMotDePasse.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"MOT DE PASSE" attributes:@{NSForegroundColorAttributeName: color}];
    self.textMotDePasse.delegate = self;
    
    //Textfield Image
    self.textEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{NSForegroundColorAttributeName: color}];
    self.textEmail.delegate = self;
    
    //Iniialisation des NSarray
    _ageNames = @[@"18-25", @"25-35", @"35-60", @"60-100", ];
     oklSexe.hidden=true;
    

    if(isEmail==2 || isEmail==1){
        
        //on cache l'autre image
        ProfileImageView.hidden=true;
        textEmail.text=_emailadress;
        textEmail.enabled=false;
        
        if(isEmail==2){
            
            _profilePictureView.hidden=true;
            PAImageView *avatarView = [[PAImageView alloc] initWithFrame:CGRectMake(25, 72, 95, 98) backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor lightGrayColor]];
            [self.view addSubview:avatarView];
            NSURL *url = [NSURL URLWithString:_pictureProfile];
            [avatarView setImageURL:url];
            textPseudo.text=[NSString stringWithFormat:@"%@.%@",_Nom,_Prenom];
           
        }
        else if(isEmail==1){
            
             [self loadUserDetails];
            //Image Ronde
            self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2;
            self.profilePictureView.layer.borderWidth = 3.0f;
            self.profilePictureView.layer.borderColor = [UIColor whiteColor].CGColor;
            self.profilePictureView.clipsToBounds = YES;
            

        }
       
        
        
        if(_Age){
        
        self.pickerviewage.hidden=YES;
        _buttonage.enabled=false;
        oklAge.hidden=false;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger year = [components year];
        
        int ActuelAge=(int)year - (int)[_Age intValue];
        if(ActuelAge>18 && ActuelAge<25){
            ageLabel.text=@"18-25";
        }
        else if (ActuelAge>25 && ActuelAge<40){
             ageLabel.text=@"25-40";
        }else if (ActuelAge>40 && ActuelAge<60){
             ageLabel.text=@"40-60";
        }else{
            ageLabel.text=@"60-100";
        }
            
        
        }else{
            self.pickerviewage.hidden=YES;
            oklAge.hidden=true;
        }
        
        }else if(isEmail==0){
    
        
        _profilePictureView.hidden=true;
        self.oklSexe.hidden = YES;
        self.oklEmail.hidden = YES;
        self.oklAge.hidden = YES;
        self.pickerviewage.hidden=YES;
        
        
        //Image Ronde
        self.ProfileImageView.layer.cornerRadius = self.ProfileImageView.frame.size.width / 2;
        self.ProfileImageView.layer.borderWidth = 3.0f;
        self.ProfileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.ProfileImageView.clipsToBounds = YES;
        
        self.validButton.enabled = false;
        [validButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
         emailvalide=false;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    if (((![appDelegate.user_fb_id isEqualToString:@""]&&appDelegate.user_fb_id!=nil))
        ||((![appDelegate.user_ldi_id isEqualToString:@""]&&appDelegate.user_ldi_id!=nil)))
    {
        isEmail = 1;
        if([FBSession.activeSession isOpen]) NSLog(@"FBSESSION OPENED");
        NSLog(@"FB INFO : %@",appDelegate.user_sexe);
        self.fondMotDePasse.alpha = 0;
        self.textMotDePasse.hidden = YES;
        self.textMotDePasse.enabled = NO;
        self.boutonI.hidden = YES;
        if ((![appDelegate.user_fb_id isEqualToString:@""]&&appDelegate.user_fb_id!=nil)) self.textMotDePasse.text = appDelegate.user_fb_id;
        else self.textMotDePasse.text = appDelegate.user_ldi_id;
        
        [self loadUserDetails];
        
        if ([appDelegate.user_sexe isEqualToString:@"male"])
        {
            [self clickMasculin:self.sexehomme];
            self.sexehomme.selected = YES;
            self.sexehomme.alpha = 1.0;
            
            NSLog(self.sexehomme.selected ? @"SELECTED Yes" : @"SELECTED No");
            
        }
        if ([appDelegate.user_sexe isEqualToString:@"female"])
        {
            [self clickFeminin:self.sexefemme];
            self.sexefemme.selected = YES;
        }
        
        NSString *imageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", appDelegate.user_fb_id];
        [self.ProfileImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]]];
        
        if(!([appDelegate.user_email isEqualToString:@""]))
        {
            self.oklEmail.hidden = NO;
            emailvalide=true;
        }
    }
}

- (void) makeRequestForUserData
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            
            NSString *email=[result objectForKey:@"email"];
            
            textEmail.text=email;
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"error %@", error.description);
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if(!([self.textEmail.text isEqualToString:@""]))
    {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if  ([emailTest evaluateWithObject:textEmail.text] != YES && [textEmail.text length]!=0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Merci de saisir un email valide" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
         textEmail.text=@"";
      
    }else{
        self.oklEmail.hidden = NO;
        emailvalide=true;
    }
    }
    
    if((![self.textPseudo.text isEqualToString:@""])&&(![self.textMotDePasse.text isEqualToString:@""])&& emailvalide ){
        
        self.validButton.enabled=YES;
        [validButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
       
        
    }
    else
    {
          if(isEmail==0){
        self.validButton.enabled = NO;
        [validButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // If there is text in the text field
    if (textField.text.length + (string.length - range.length) > 0) {
        // Set textfield font
        textField.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
          textField.textColor = [UIColor whiteColor];
        
    } else {
        // Set textfield placeholder font (or so it appears)
        //textField.font = [UIFont fontWithName:@"PlaceholderFont" size:15];
        textField.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:15];
   
    }
    
    return YES;
}
-(void)dismissKeyboard
{
    [self.textPseudo resignFirstResponder];
    [self.textMotDePasse resignFirstResponder];
    [self.textEmail resignFirstResponder];
    
    if(!([self.textEmail.text isEqualToString:@""]))
    {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if  ([emailTest evaluateWithObject:textEmail.text] != YES && [textEmail.text length]!=0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Merci de saisir un email valide" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        textEmail.text=@"";
        return;
    }else{
        self.oklEmail.hidden = NO;
        emailvalide=true;
    }
    }
    if(![ageLabel.text isEqualToString:@"AGE"]){
        oklAge.hidden=false;
    }
    if((![self.textPseudo.text isEqualToString:@""])&&(![self.textMotDePasse.text isEqualToString:@""])&& emailvalide){
        
        self.validButton.enabled=YES;
        [validButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }
    else
    {
        if(isEmail==0){
        self.validButton.enabled = NO;
        [validButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
       
    }
    self.pickerviewage.hidden=YES;
    ageLabel.hidden=NO;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.ProfileImageView.image = image;
    [self dismissModalViewControllerAnimated:YES];
    //self.validButton.hidden = NO;
}



- (IBAction)actionRetour:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)imageSelected:(UIImage*)img{
    
    self.ProfileImageView.image = img;
   // self.validButton.hidden = NO;
}
-(void)imageSelectionCancelled{
    
}


#pragma mark - PKImageViewController Delegates

- (IBAction)takePic:(id)sender {
    PKImagePickerViewController *imagePicker = [[PKImagePickerViewController alloc]init];
    imagePicker.delegate=self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)LoadPic:(id)sender {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}



- (IBAction)selectAge:(id)sender {
   
   

}
#pragma mark -
#pragma mark PickerView DataSource
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *retval = (id)view;
    if (!retval) {
        retval= [[UILabel alloc] initWithFrame:CGRectMake(100, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] ;
    }
    

    retval.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    retval.textColor=[UIColor whiteColor];
    retval.textAlignment=NSTextAlignmentCenter;
    retval.text=_ageNames[row];
    return retval;
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
  
  return 1;

}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _ageNames.count;

}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
     return _ageNames[row];
 
    
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title =_ageNames[row]
    ;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSLog(@"Successfully selected rows: %ld", (long)row);
  
   
    self.ageLabel.text = [_ageNames[row] uppercaseString];
    
    if(![ageLabel.text isEqualToString:@"AGE"]) self.oklAge.hidden = NO;
    
   

}
-(void)afficherlabelinfo{
    _infolabel.hidden=false;

}
- (IBAction)clickSWitch:(id)sender {
    
    if(!_switchCGU.isOn){
       
        [UIView animateWithDuration:0.3
                              delay:0.3
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             validButton.frame=CGRectMake(validButton.frame.origin.x,511, validButton.frame.size.width, validButton.frame.size.height);
                             [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(afficherlabelinfo) userInfo:nil repeats:NO];
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];
        
        
    
    }else{
        _infolabel.hidden=true;
        
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             validButton.frame=CGRectMake(validButton.frame.origin.x, 511-60, validButton.frame.size.width, validButton.frame.size.height);
                             
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];

        
    }
}

- (IBAction)selectSexe:(id)sender {
   
    ageLabel.hidden=YES;
    self.pickerviewage.hidden=NO;
    ageLabel.text=@"18-25";
  
}
- (IBAction)selectMasc:(id)sender {
    if(sexenone.frame.origin.x==147){
        [UIView animateWithDuration:0.3
                              delay:0.3
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             self.oklSexe.hidden = YES;
                             sexenone.frame=CGRectMake(207, 298, 45, 45);
                             if(sexehomme.frame.origin.x==207)
                                 sexehomme.frame=CGRectMake(147, 298, 45, 45);
                             if(sexefemme.frame.origin.x==207)
                                 sexefemme.frame=CGRectMake(147, 298, 45, 45);
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];
    }
    else if(sexenone.frame.origin.x==268){
        [UIView animateWithDuration:0.3
                              delay:0.3
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             self.oklSexe.hidden = YES;
                             sexenone.frame=CGRectMake(207, 298, 45, 45);
                             if(sexehomme.frame.origin.x==207)
                                 sexehomme.frame=CGRectMake(268, 298, 45, 45);
                             if(sexefemme.frame.origin.x==207)
                                 sexefemme.frame=CGRectMake(268, 298, 45, 45);
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];
    }

}


- (IBAction)clickMasculin:(id)sender
{
    NSLog(@"CLICK MASC");
    oklSexe.hidden=false;
    if(!sexefemme.highlighted){
        
        sexefemme.highlighted=true;
        
    }
 
}

- (IBAction)clickFeminin:(id)sender
{
    NSLog(@"CLICK FEMM");
    oklSexe.hidden=false;
    if(!sexehomme.highlighted){
        
        sexehomme.highlighted=true;
       
    }
}

- (IBAction)showpassword:(id)sender {
    if(textMotDePasse.secureTextEntry==true)
    textMotDePasse.secureTextEntry=false;
    else{
        textMotDePasse.secureTextEntry=true;
    }
}
- (IBAction)ValiderAction:(id)sender
{
    NSLog(@"VALIDER ACTION");
    if(!([self.textEmail.text isEqualToString:@""]))
    {
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        if  ([emailTest evaluateWithObject:textEmail.text] != YES && [textEmail.text length]!=0 )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Merci de saisir un email valide" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            textEmail.text=@"";
            emailvalide=false;
        }
        else
        {
            self.oklEmail.hidden = NO;
            emailvalide=true;
        }
    }
    
    if((![self.textPseudo.text isEqualToString:@""])&&(![self.textMotDePasse.text isEqualToString:@""])&& emailvalide && self.switchCGU.isOn)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if(loginProfil == nil)
        {
            loginProfil = (LooginVoitureViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LooginVoitureViewController"];
        }
        
        appDelegate.user_pseudo = self.textPseudo.text;
        appDelegate.user_pass = self.textMotDePasse.text;
        appDelegate.user_email = self.textEmail.text;
        userInformation =[[UserInformationData alloc]init];
        [userInformation writeForKey:@"pseudo" andValue:self.textPseudo.text];
        [userInformation writeForKey:@"password" andValue:self.textMotDePasse.text];
        //[self saveInformations:appDelegate.user_pseudo andPassword:appDelegate.user_pass];
        [self.navigationController pushViewController:loginProfil animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oups" message:@"Merci de saisir toute les informations. Vous devez aussi accepter les CGU" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}
-(void)saveInformations:(NSString*)userPseudo andPassword:(NSString*)userPassword{
    
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dirName = [docDir stringByAppendingPathComponent:@"LOGS"];
    
    BOOL isDir;
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dirName isDirectory:&isDir])
    {
        if([fm createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:nil])
            NSLog(@"Directory Created");
        else
            NSLog(@"Directory Creation Failed");
    }
    else
        NSLog(@"Directory Already Exist");
   
    
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/LOGS/autoLlog.txt",documentsDirectory];
    
    //create content - four lines of text
    // Convert string to date object
 
    NSString *content;
    content = [NSString stringWithFormat:@"%@\n%@",userPseudo,userPassword];
    
    //save content to the documents directory
    [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];

}
- (IBAction)retourAction:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Other
- (void)displayUserDetails {
    //If the loading of the user details has finished.
    if(self.userDataLoaded && self.timelineDataLoaded) {
       // Pseudo.text = self.name;
   
    } 
}

- (void)displayErrorMessage {
    NSString *socialNetworkName = nil;
    switch (isEmail) {
        case 0:
            socialNetworkName = @"Email";
            break;
        case 1:
            socialNetworkName = @"Facebook";
            break;
        case 2:
            socialNetworkName = @"Twitter";
            break;
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ error", socialNetworkName]
                                                    message:[NSString stringWithFormat:@"There was an error talking to %@. Please try again later.", socialNetworkName]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark IBActions


- (IBAction)refreshUserData:(id)sender {
    //[SVProgressHUD showWithStatus:@"Loading..."];
    self.userDataLoaded = NO;
    self.timelineDataLoaded = NO;
    [self loadUserDetails];
    [self displayUserDetails];
}

#pragma mark Account Data
- (void)loadUserDetails {
    //If the user is logged in using Twitter
    if(![appDelegate.user_fb_id isEqualToString:@""]&&appDelegate.user_fb_id!=nil){
        //If the user is logged in using Facebook
        
        //Check whether the current Facebook session is open.
        if([FBSession.activeSession isOpen]) {
            //Request the users information.
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                  
                 } else {
                     [self displayErrorMessage];
                 }
                 self.userDataLoaded = YES;
             }];
            //Request the users wall feed.
            [[FBRequest requestForGraphPath:@"me"] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary *data,
               NSError *error) {
                 if (!error) {
                     //Get the last wall message of the user.
                       //self.Email.text = [data objectForKey:@"email"] ;
                     self.textPseudo.text=[data objectForKey:@"name"];
                     self.textEmail.text=[data objectForKey:@"email"];
                     self.profilePictureView.profileID = [data objectForKey:@"id"];

                     
                 } else {
                     [self displayErrorMessage];
                 }
                 //Store the loaded data in the properties
                 self.timelineDataLoaded = YES;
             }];
        }
    }
}






@end
