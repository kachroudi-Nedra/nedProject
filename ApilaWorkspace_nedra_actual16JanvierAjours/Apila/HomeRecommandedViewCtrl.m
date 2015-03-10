//
//  HomeRecommandedViewCtrl.m
//  Apila
//
//  Created by Nedra Kachroudi on 12/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "HomeRecommandedViewCtrl.h"

@interface HomeRecommandedViewCtrl ()

@end

@implementation HomeRecommandedViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    //self->isVisible = 1;
}

- (void)viewDidDisappear:(BOOL)animated
{
   // self->isVisible = 0;
}
-(IBAction)cancelAction:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)initWithParkings:(NSMutableArray*)parkingList andApiway:(NSMutableArray*)apiwayRoute userLocation:(CLLocation*)userLocation {
    
    parkings = parkingList;
    UserLocation = userLocation;
    apiwayArray= apiwayRoute;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _recommandedListTable.delegate=self;
    _recommandedListTable.dataSource=self;
    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSomething)];
    
    [mSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [[self view] addGestureRecognizer:mSwipeUpRecognizer];
    
    for (int i=0;i<parkings.count;i++)
    {
        //NSLog(@"---- RESULT : %@",[infoParko objectAtIndex:i]);
        
        parking = [[Parking alloc]init];
        parking =[parkings objectAtIndex:i];
        CLLocation *parkLoc = [[CLLocation alloc]initWithLatitude:parking.position.coordinate.latitude longitude:parking.position.coordinate.longitude];
        parking.distance = (int)[UserLocation distanceFromLocation:parkLoc];
        
    }
    
    sortedParkings = [parkings sortedArrayUsingComparator:^NSComparisonResult(Parking *a, Parking *b) {
        if ( a.distance < b.distance) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( a.distance > b.distance) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];

}

- (void) doSomething
{
    NSLog(@"FERMER MENU");
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.x = frame.origin.x + frame.size.width;
                         self.view.frame = frame;
                     } completion:nil];
    [self.parentController ZoomToApiway];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 0;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *simpleTableIdentifier = @"HomeRecommanded";
    
    HomeRecommanded *cell = (HomeRecommanded *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UIImage *btnImage = [UIImage imageNamed:@""];

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeRecommanded" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    switch (indexPath.row) {
        case 0:
            cell.recommandedName.text =@"LULU";
            cell.recommandedDistance.text =@"200 m";
            cell.recommandedAddress.text =@"1 rue de la victoire ";
            [ cell.recommandedButton setTitle:@"Réserver" forState:UIControlStateNormal];
            btnImage = [UIImage imageNamed:@"menuButtonLiberer.png"];
            cell.recommandedImage.image= btnImage;
            break;
        case 1:
            cell.recommandedName.text =@"Apiway";
            cell.recommandedDistance.text =self.parentController->apiwayDistance;
            cell.recommandedAddress.text =@" ";
            [ cell.recommandedButton setTitle:@"GO" forState:UIControlStateNormal];
            btnImage = [UIImage imageNamed:@"way.png"];
            cell.recommandedImage.image =  btnImage;
            break;
            
        case 2:
            
            
            parking = [[Parking alloc]init];
            parking = [sortedParkings objectAtIndex:0];
            cell.recommandedName.text =[NSString stringWithFormat:@"Parking %@",parking.name];
            cell.recommandedDistance.text = [NSString stringWithFormat:@"%d m ",parking.distance];//[NSString stringWithFormat:@"%d m ",(int)[UserLocation distanceFromLocation:parkLoc]];
            cell.recommandedAddress.text = [NSString stringWithFormat:@"%@",parking.address];
            btnImage = [UIImage imageNamed:@"pinJeLiberePublic@2x.png"];
            cell.recommandedImage.image =  btnImage;
            [cell.recommandedButton addTarget:self
                                       action:@selector(navigateToParking:)
                      forControlEvents:UIControlEventTouchUpInside];

            break;
        default:
            break;
    }
      // cell.parkName.text =[NSString stringWithFormat:@"Parking %@",parking.name];
      // cell.parkDistance.text = [NSString stringWithFormat:@"%d m ",parking.distance];//[NSString stringWithFormat:@"%d m ",(int)[UserLocation distanceFromLocation:parkLoc]];
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   

    HomeRecommanded *cell = (HomeRecommanded *)[tableView cellForRowAtIndexPath:indexPath];
   
    if(indexPath.row == 2){
        
        cell.contentView.backgroundColor = [UIColor orangeColor];
        cell.backgroundColor = [UIColor orangeColor];;
        cell.recommandedButton.backgroundColor =[UIColor blueColor];
        self.parentController->HomeList = NO;
         self.parentController->ApiwayList = YES;
        [self.parentController showParkingList:nil];


    }
    if(indexPath.row == 1){
        //self.parentController->ApiwayList = NO;
         //[self.parentController showApiway];
        parking = [[Parking alloc]init];
        parking = [sortedParkings objectAtIndex:0];
        if (navigationMap == nil)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            navigationMap = (NavigationMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationMapViewController"];
        }
        
        [self presentViewController:navigationMap animated:YES completion:nil];
        //[ navigationMap NavigationDeMerdre:parking.position];
        [navigationMap parkNow];

        
    }
    [self doSomething];
}
- (IBAction)apiShare:(id)sender {
}
- (IBAction)apiWay:(id)sender {
    }
- (IBAction)apiPark:(id)sender {
   
    self.parentController->HomeList = NO;
    self.parentController->ApiwayList = YES;
    [self.parentController showParkingList:nil];
}

-(void)navigateToParking:(UIButton*)sender{
    
    
    NSLog(@"JE VEUX NAVIGUER");
    
    
    Parking* parkToGo = [[Parking alloc]init];
    parkToGo =[sortedParkings objectAtIndex:0];
    NSLog(@"addresse parking: %@",parkToGo.address);
    
    //[navigView startNavigation];
    
    //[self jeNavigueAction:destLocation];
    alertChooseNavigationViewController = nil;
    if (alertChooseNavigationViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        alertChooseNavigationViewController = (AlertChooseNavigationViewController*)[storyboard instantiateViewControllerWithIdentifier:@"AlertChooseNavigationViewController"];
        alertChooseNavigationViewController.view.alpha = 0.0;
        [alertChooseNavigationViewController.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //self.parentController.searchDisplayController.searchBar.alpha =1.0;
    }
   // [self doSomething];
    alertChooseNavigationViewController.MotherController = self;
    [ alertChooseNavigationViewController initWithDestLoc:parkToGo.address];
    
    //[self presentViewController:alertChooseNavigationViewController animated:YES completion:nil];
    
    // [self jeNavigueAction:destinationLocation];
    [UIView animateWithDuration:0.0
                     animations:^{
                         [self.view addSubview:alertChooseNavigationViewController.view];
                         alertChooseNavigationViewController.view.alpha = 1.0;
                         
                     } completion:nil];
    

  
    
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
- (IBAction)closeMenuAction:(id)sender
{
    if(self.view.frame.origin.x == 0)
    {
        //NSLog(@"MENU POS : %f",menuView.view.frame.origin.x);
        [UIView animateWithDuration:0.4
                         animations:^{
                             CGRect frame = self.view.frame;
                             frame.origin.x = frame.origin.x - frame.size.width;
                             self.view.frame = frame;
                         } completion:nil];
        //NSLog(@"MENU POS : %f",menuView.view.frame.origin.x);
    }
    
}
@end
