//
//  LogScreen1ViewController.m
//  Apila
//
//  Created by Vincenzo GALATI on 16/06/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "LogScreen1ViewController.h"
#import "LIALinkedInApplication.h"
#import "LIALinkedInHttpClient.h"
#import "AFHTTPRequestOperation.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>
#pragma mark - HomeViewController Exte
@interface LogScreen1ViewController ()

@end

@implementation LogScreen1ViewController{
    LIALinkedInHttpClient *_client;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _client = [self client];
    appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    appDelegate.logScreen1 = self;
    [appDelegate.serverWebSocket setDelegate:self];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Se Connecter"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    _label_seconecter.attributedText=[attributeString copy];
    
   // _imagelogo.layer.borderWidth = 3.0f;
   //_imagelogo.layer.cornerRadius = 10.0f;
   // _imagelogo.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.loginViewFB = [[FBLoginView alloc] init];
    self.loginViewFB = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_birthday",@"user_location"]];
    self.loginViewFB.delegate = self;

    self.loginViewFB.frame = CGRectOffset(self.loginViewFB.frame, (self.view.center.x - (self.loginViewFB.frame.size.width / 2)), 320);
    [self.view addSubview:self.loginViewFB];
}

- (void) viewWillAppear:(BOOL)animated
{
    if (FBSession.activeSession.isOpen)
    {
        NSLog(@"FB AUTO LOG");
        self.fb_auto_log = 1;
    }
    else
    {
        NSLog(@"FB NOT LOGGED");
        self.fb_auto_log = 0;
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/LOGS/autoLlog",documentsDirectory];
    NSString * userautolog = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    
    fileName = [NSString stringWithFormat:@"%@/LOGS/autoLlogP",documentsDirectory];
    NSString * userautopass = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"AUTOLOG : %@ | %@",userautolog,userautopass);
    
    // si des credentials ont déjà été enregistré, on fait l'autolog
    if ((userautolog != nil)&&(userautolog != nil)&&(![userautopass isEqualToString:@""])&&(![userautolog isEqualToString:@""]))
    {
        NSLog(@"AUTOLOG");
        appDelegate.user_pseudo = userautolog;
        appDelegate.user_name = userautolog;
        appDelegate.user_pass = userautopass;
        
        [[appDelegate serverWebSocket] loginKnownUserWithID:appDelegate.user_pseudo andPass:appDelegate.user_pass andSource:@"apila"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)connectAction:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if(logScreen2 == nil)
    {
        logScreen2 = (LogScreen2ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LogScreen2ViewController"];
    }
    
    [self.navigationController pushViewController:logScreen2 animated:YES];
}

- (IBAction)registerAction:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if(logScreenAuthentif == nil)
    {
        logScreenAuthentif = (AuthentificationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AuthentificationViewController"];
        logScreenAuthentif.isEmail=0;
    }
    
    [self.navigationController pushViewController:logScreenAuthentif animated:YES];
}

- (IBAction)linkedInAction:(id)sender
{
    NSLog(@"LINKEDIN");
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
    
    
    
}
//Pragma Linkedin
- (LIALinkedInHttpClient *)client
{
    NSLog(@"LINKEDIN CLIENT");
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.apila.fr/"
                                                                                    clientId:@"77ac7bo3039qwi"
                                                                                clientSecret:@"qeJzbA4igifU9FKI"
                                                                                       state:@"DCEIUYTPO12IUZ1324"
                                                                               grantedAccess:@[@"r_emailaddress",@"r_fullprofile"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:self];
}

- (void)requestMeWithToken:(NSString *)accessToken
{
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,date-of-birth)?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        NSLog(@"current user %@", result);
        NSString *email=[result objectForKey:@"emailAddress"];
        NSString *firstname=[result objectForKey:@"firstName"];
        NSString *lastname=[result objectForKey:@"lastName"];
        NSString *picture=[result objectForKey:@"pictureUrl"];
        NSDictionary *date=[result objectForKey:@"dateOfBirth"];
        NSString *day,*month,*year;
        day=[date objectForKey:@"day"];
        month=[date objectForKey:@"month"];
        year=[date objectForKey:@"year"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if(logScreenAuthentif == nil)
        {
            logScreenAuthentif = (AuthentificationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AuthentificationViewController"];
            logScreenAuthentif.Nom=lastname;
            logScreenAuthentif.Prenom=firstname;
            logScreenAuthentif.pictureProfile=picture;
            logScreenAuthentif.emailadress=email;
            logScreenAuthentif.Age=year;
            logScreenAuthentif.isEmail=2;
        }
        
        appDelegate.user_pseudo = [NSString stringWithFormat:@"%@.%@",lastname,firstname];
        appDelegate.user_ldi_id = [result objectForKey:@"id"];
        appDelegate.user_pass = [result objectForKey:@"id"];
        appDelegate.user_name = [NSString stringWithFormat:@"%@.%@",lastname,firstname];;
        appDelegate.user_email = email;
        
        NSLog(@"PUSHLINKEDIN");
        [self.navigationController pushViewController:logScreenAuthentif animated:YES];
    }        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
    }];
    
    
}

/*- (IBAction)facebookAction:(id)sender
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openFacebookSession];
}*/

- (IBAction)closeTestAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog( @"%@", user );
    
    NSLog(user.objectID);
    NSLog(user.name);
    NSLog([user objectForKey:@"birthday"]);
    NSLog([user objectForKey:@"email"]);
    NSLog([user objectForKey:@"gender"]);
    
    appDelegate.user_fb_id = user.objectID;
    appDelegate.user_pseudo = user.name;
    appDelegate.user_sexe = [user objectForKey:@"gender"];
    appDelegate.user_email = [user objectForKey:@"email"];
    appDelegate.user_fb_birthday = [user objectForKey:@"birthday"];
    appDelegate.user_pass = user.objectID;
    
    if(self.fb_auto_log == 0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if(logScreenAuthentif == nil)
        {
            logScreenAuthentif = (AuthentificationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AuthentificationViewController"];
            logScreenAuthentif.isEmail=0;
        }
        
        if(![self.navigationController.topViewController isKindOfClass:[logScreenAuthentif class]]) [self.navigationController pushViewController:logScreenAuthentif animated:YES];
    }
    else if(self.fb_auto_log == 1)
    {
        NSLog(@"AUTOCO FB");
        
        // on se connecte direct à Apila avec pseudo et id fb
        [[appDelegate serverWebSocket] loginKnownUserWithID:appDelegate.user_pseudo andPass:appDelegate.user_pass andSource:@"facebook"];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"FAIL (logscreenFB)");
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"CLOSE (logscreenFB)");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSString *str = [NSString stringWithFormat:@"RECEIVED (logscreenFB) \n%@", message];
    NSLog(str);
    
    NSString *jsonString = message;
    NSDictionary * sampleInfo = [jsonString objectFromJSONString];
    
    if([[sampleInfo objectForKey:@"recognizedId"] isEqualToString:[NSString stringWithFormat:@"%@@apila",[appDelegate.user_pseudo lowercaseString]]]||[[sampleInfo objectForKey:@"recognizedId"] isEqualToString:[NSString stringWithFormat:@"%@@facebook",[appDelegate.user_pseudo lowercaseString]]])
    {
        NSLog(@"LOGIN OK");
        [appDelegate showPleaseWait];
        [self performSelector:@selector(dismissLoginView) withObject:nil afterDelay:2.0];
    }
}

- (void) dismissLoginView
{
    [appDelegate hidePleaseWait];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
