//
//  AlertChooseNavigationViewController.m
//  Apila
//
//  Created by Nedra Kachroudi on 09/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "AlertChooseNavigationViewController.h"
#import "NavigationRecommanded.h"
@interface AlertChooseNavigationViewController ()

@end

@implementation AlertChooseNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initWithDestLoc:(NSString*)destLoc{
    
   
        destinationLoc =destLoc;
    
}
-(IBAction)cancelAction:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIView animateWithDuration:0.0
                     animations:^{
                         self.view.alpha = 0.0;
                         
                     } completion:nil];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _navigationList.delegate=self;
    _navigationList.dataSource=self;
    appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];

    // Do any additional setup after loading the view.
    //[_ApilaButton addTarget:self action:@selector(yourButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (IBAction)switchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        NSLog(@"its on!");
       // appDelegate.navigChoice = self.indexNavig;
    } else {
        NSLog(@"its off!");
        //appDelegate.navigChoice = -1;

    }
}

- (void) yourButtonPressed:(id)sender {
    //NavigationViewController * otherVC = [NavigationViewController alloc];
    // [otherVC ApilaNavigation:sender];
    //NSLog(@"bjjhhfhfhfhfgfgfg");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 65;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *simpleTableIdentifier = @"HomeRecommanded";
    
    NavigationRecommanded *cell = (NavigationRecommanded *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UIImage *btnImage = [UIImage imageNamed:@""];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationRecommanded" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    switch (indexPath.row) {
        /*case 0:
            cell.recommandedName.text =@"Apila";
            btnImage = [UIImage imageNamed:@"logo.png"];
            cell.recommandedImage.image= btnImage;
            break;
        */
        case 0:
            cell.recommandedName.text =@"Google Map";
            btnImage = [UIImage imageNamed:@"google.jpeg"];
            cell.recommandedImage.image =  btnImage;
            break;
            
        case 1:
            
            cell.recommandedName.text =@"Waze";
            btnImage = [UIImage imageNamed:@"waze.png"];
            cell.recommandedImage.image =  btnImage;
            break;
        case 2:
            
            cell.recommandedName.text =@"Maps";
            btnImage = [UIImage imageNamed:@"apple.jpeg"];
            cell.recommandedImage.image =  btnImage;
            break;
        default:
            break;
    }
    // cell.parkName.text =[NSString stringWithFormat:@"Parking %@",parking.name];
    // cell.parkDistance.text = [NSString stringWithFormat:@"%d m ",parking.distance];//[NSString stringWithFormat:@"%d m ",(int)[UserLocation distanceFromLocation:parkLoc]];
    
    
    return cell;
    
}
-(IBAction)navigateToGoole:(id)sender{
    
    appDelegate.navigChoice = 0;
    if (navigationMap == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        navigationMap = (NavigationMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationMapViewController"];
    }
    
    [self presentViewController:navigationMap animated:YES completion:nil];
    [navigationMap navigatetoAddress:destinationLoc];
}
-(IBAction)navigateToWaze:(id)sender{
    
    appDelegate.navigChoice = 1;
    if (navigationMap == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        navigationMap = (NavigationMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationMapViewController"];
    }
    
    [self presentViewController:navigationMap animated:YES completion:nil];
    [navigationMap navigatetoAddress:destinationLoc];
}
-(IBAction)navigateToMaps:(id)sender{
   
    appDelegate.navigChoice = 2;
    if (navigationMap == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        navigationMap = (NavigationMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationMapViewController"];
    }
    
    [self presentViewController:navigationMap animated:YES completion:nil];
    [navigationMap navigatetoAddress:destinationLoc];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self.view removeFromSuperview];
   /* if(self.chooseSwitch.isOn){
        
        appDelegate.navigChoice = indexPath.row;
        
    }else
        appDelegate.navigChoice = -1;
    */
   
    appDelegate.navigChoice = indexPath.row;
    if (navigationMap == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        navigationMap = (NavigationMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationMapViewController"];
    }
    
    [self presentViewController:navigationMap animated:YES completion:nil];
    [navigationMap navigatetoAddress:destinationLoc];
    

  /*  switch (indexPath.row) {
       // case 0:
            //[self.MotherController ApilaNavigation:nil];
         
            
            break;
        case 0:
            [self.MotherController GoogleMapNavigation:nil];
            break;
            
        case 1:
            [self.MotherController WazeNavigation:nil];
            break;
        case 2:
            
            [self.MotherController AppleNavigation:nil];
            break;
        default:
            break;
    }
*/
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

@end
