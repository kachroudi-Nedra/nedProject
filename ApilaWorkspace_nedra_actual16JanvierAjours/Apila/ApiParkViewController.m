//
//  ApiParkViewController.m
//  Apila
//
//  Created by Nedra Kachroudi on 11/12/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "ApiParkViewController.h"

@interface ApiParkViewController ()

@end

@implementation ApiParkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}
-(void)initWithParkingList:(NSMutableArray*)parkingList andApiway:(NSMutableArray*)ApiwayArray userLocation:(CLLocation*)userLocation {
    
    parkings = parkingList;
    UserLocation = userLocation;
    apiwayArray = ApiwayArray;
    sortedParkings = [parkings sortedArrayUsingComparator:^NSComparisonResult(Parking *a, Parking *b) {
        if ( a.distance < b.distance) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( a.distance > b.distance) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    
}
int compare(const void *first, const void *second)
{
    return *(const int *)first - *(const int *)second;
}

- (void)sortArray:(int *)array ofSize:(size_t)sz
{
    qsort(array, sz, sizeof(*array), compare);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    map = (GoogleMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"GoogleMapViewController"];
    [_parkingMap addSubview:map.view];
    /*if(self.view.frame.origin.y == +0)
    {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect newFrame = map.view.frame;
            newFrame.size.width = 320;
            newFrame.size.height = 360;
            [map.view setFrame:newFrame];
            
        } completion:nil];
        
    }*/
   // _parkingListTable.delegate=self;
    //_parkingListTable.dataSource=self;
    //[self showParkingsOnMap:nil];
    NSMutableArray *pathApiway = [[NSMutableArray alloc]init];
    for (int i=0;i<apiwayArray.count;i++)
    {
        pathApiway =[apiwayArray objectAtIndex:0];
        //NSLog(@"apiway: %@",[pathApiway objectAtIndex:i]);
        
        GMSMutablePath * path = [GMSMutablePath path];
        GMSPolyline* polyline2 = [[GMSPolyline alloc] init];
        
        CLLocationManager *locationm = [LocationTracker sharedLocationManager];
        
        // si on est à - de 25 m du drapeau destination
        CLLocation * locUser = [[CLLocation alloc] initWithLatitude:locationm.location.coordinate.latitude longitude:locationm.location.coordinate.longitude];
        CLLocation * locDest = [[CLLocation alloc]  initWithLatitude:locationm.location.coordinate.latitude longitude:locationm.location.coordinate.longitude];
        
        [path addCoordinate:CLLocationCoordinate2DMake(locationm.location.coordinate.latitude,locationm.location.coordinate.longitude)];
        // double lat = [[pathApiway objectAtIndex:0]doubleValue];
        [path addCoordinate:CLLocationCoordinate2DMake([[pathApiway objectAtIndex:0]doubleValue],[[pathApiway objectAtIndex:1]doubleValue])];
        
        polyline2.strokeColor = [UIColor redColor];
        polyline2.strokeWidth = 4;
        polyline2.path = path;
        polyline2.map = map.mapView;
        
    }
    for (int i=0;i<parkings.count;i++)
    {
        //NSLog(@"---- RESULT : %@",[infoParko objectAtIndex:i]);
        
        parking = [[Parking alloc]init];
        parking =[parkings objectAtIndex:i];
        CLLocation *parkLoc = [[CLLocation alloc]initWithLatitude:parking.position.coordinate.latitude longitude:parking.position.coordinate.longitude];
        parking.distance = (int)[UserLocation distanceFromLocation:parkLoc];
        
    }
    if(sortedParkings.count >=1){
         [self premierParking];
    }
    if(sortedParkings.count >=2){
        [self deuxiemeParking];
    }
    if(sortedParkings.count >=3){
        [self troisiemeParking];
    }
    //[self premierParking];
    //[self deuxiemeParking];
    //[self troisiemeParking];
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
    
    if(tableView == _parkingListTable)
    {
        return 3;
        //return [sortedParkings count];
    }
    return 500;
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
   
       // Add your Colour.
    ParkingCell *cell = (ParkingCell *)[tableView cellForRowAtIndexPath:indexPath];
    //[self setCellColor:[UIColor orangeColor] ForCell:cell];  //highlight colour
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reset Colour.
    ParkingCell *cell = (ParkingCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor colorWithWhite:0.961 alpha:1.000] ForCell:cell]; //normal color
    
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)navigate1{
    
   /* if (navigationMap == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        navigationMap = (NavigationMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationMapViewController"];
    }
    
    [self presentViewController:navigationMap animated:YES completion:nil];
    //[ navigationMap NavigationDeMerdre:parking.position];
    [navigationMap navigatetoAddress:parking1.address];
    
    // [navigView changeDestLoc:parkToGo.address];
    //[ alertChooseNavigationViewController initWithDestLoc:parkToGo.address];
    */
}
-(void)takeMe1{
   
    GMSMarker * markerUser = [[GMSMarker alloc] init];
   
    markerUser.position = parking1.position.coordinate;
    
    markerUser.icon = [UIImage imageNamed:@"pin_parking_small.png"];
    
    markerUser.map = self->map.mapView;
    
    markerUser.snippet = [NSString stringWithFormat:@"%@",parking1.name];
    
    [map takeMeThere:parking1.position];
    self.premier_p.text =@"GO";
    [self.premierButton addTarget:self
                            action:@selector(navigate1)
                  forControlEvents:UIControlEventTouchUpInside];

}
-(void)takeMe2{
    
    GMSMarker * markerUser = [[GMSMarker alloc] init];
    
    markerUser.position = parking2.position.coordinate;
    
    markerUser.icon = [UIImage imageNamed:@"pin_parking_small.png"];
    
    markerUser.map = self->map.mapView;
    
    markerUser.snippet = [NSString stringWithFormat:@"%@",parking2.name];
    
    [map takeMeThere:parking2.position];
    self.deuxieme_p.text =@"GO";
    [self.deuxiemeButton addTarget:self
                             action:@selector(navigate2)
                   forControlEvents:UIControlEventTouchUpInside];
}
-(void)takeMe3{
    GMSMarker * markerUser = [[GMSMarker alloc] init];
    
    markerUser.position = parking3.position.coordinate;
    
    markerUser.icon = [UIImage imageNamed:@"pin_parking_small.png"];
    
    markerUser.map = self->map.mapView;
    
    markerUser.snippet = [NSString stringWithFormat:@"%@",parking3.name];
    
    [map takeMeThere:parking3.position];
    self.troisieme_p.text =@"GO";
    [self.troisiemeButton addTarget:self
                            action:@selector(navigate3)
                  forControlEvents:UIControlEventTouchUpInside];

}
-(void)premierParking{
    
    parking1 = [[Parking alloc]init];
    parking1 = [sortedParkings objectAtIndex:0];
    destLocation = parking1.position;
    self.premier.text = [NSString stringWithFormat:@"%d m ",parking1.distance];//[NSString stringWithFormat:@"%d m ",(int)[UserLocation distanceFromLocation:parkLoc]];
    [self.premierButton addTarget:self
                        action:@selector(takeMe1)
              forControlEvents:UIControlEventTouchUpInside];

}
-(void)deuxiemeParking{
    
    parking2 = [[Parking alloc]init];
    parking2 = [sortedParkings objectAtIndex:1];
    destLocation = parking2.position;
    self.deuxieme.text = [NSString stringWithFormat:@"%d m ",parking2.distance];//[NSString stringWithFormat:@"%d m ",(int)[UserLocation distanceFromLocation:parkLoc]];
    [self.deuxiemeButton addTarget:self
                           action:@selector(takeMe2)
                 forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)troisiemeParking{
    
    parking3 = [[Parking alloc]init];
    parking3 = [sortedParkings objectAtIndex:2];
    destLocation = parking3.position;
    self.troisieme.text = [NSString stringWithFormat:@"%d m ",parking3.distance];//[NSString stringWithFormat:@"%d m ",(int)[UserLocation distanceFromLocation:parkLoc]];
    [self.troisiemeButton addTarget:self
                           action:@selector(takeMe3)
                 forControlEvents:UIControlEventTouchUpInside];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *simpleTableIdentifier = @"ParkingCell";
    
    ParkingCell *cell = (ParkingCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ParkingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    parking = [[Parking alloc]init];
    parking = [sortedParkings objectAtIndex:indexPath.row];
    destLocation = parking.position;
    cell.parkName.text =[NSString stringWithFormat:@"Parking %@",parking.name];
    cell.parkAddress.text=[NSString stringWithFormat:@"%@",parking.address];
    cell.parkDistance.text = [NSString stringWithFormat:@"%d m ",parking.distance];//[NSString stringWithFormat:@"%d m ",(int)[UserLocation distanceFromLocation:parkLoc]];
    cell.parkButton.tag = indexPath.row;
    [cell.parkButton addTarget:self
                        action:@selector(navigateToParking:)
              forControlEvents:UIControlEventTouchUpInside];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
       ParkingCell *cell = (ParkingCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor orangeColor];
        cell.backgroundColor = [UIColor orangeColor];;
        cell.parkButton.backgroundColor =[UIColor blueColor];
        parking = [[Parking alloc]init];
        parking = [sortedParkings objectAtIndex:indexPath.row];
        [map takeMeThere:parking.position];
    
}
-(void)navigateToParking:(UIButton*)sender{
    
   
    NSLog(@"JE VEUX NAVIGUE");
    
    if (alertChooseNavigationViewController == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        alertChooseNavigationViewController = (AlertChooseNavigationViewController*)[storyboard instantiateViewControllerWithIdentifier:@"AlertChooseNavigationViewController"];
        alertChooseNavigationViewController.view.alpha = 0.0;
        [alertChooseNavigationViewController.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //self.parentController.searchDisplayController.searchBar.alpha =1.0;
    }
    //alertChooseNavigationViewController.MotherController = self;
    

    
   // navigView->Apila = YES;
    //navigView->Navig = YES;
    Parking* parkToGo = [[Parking alloc]init];
    parkToGo =[sortedParkings objectAtIndex:sender.tag];
    NSLog(@"addresse parking: %@",parkToGo.address);
    if (navigationMap == nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        navigationMap = (NavigationMapViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationMapViewController"];
    }
    
    [self presentViewController:navigationMap animated:YES completion:nil];
    //[ navigationMap NavigationDeMerdre:parking.position];
    [navigationMap navigatetoAddress:parkToGo.address];

   // [navigView changeDestLoc:parkToGo.address];
    [ alertChooseNavigationViewController initWithDestLoc:parkToGo.address];
    /*[UIView animateWithDuration:0.0
                     animations:^{
                         [self.view addSubview:alertChooseNavigationViewController.view];
                         alertChooseNavigationViewController.view.alpha = 1.0;
                         
                     } completion:nil];
*/
    //[navigView startNavigation];
   // navigView.arrowImg.hidden = NO;
    //[self presentViewController:navigView animated:YES completion:nil];

    //[self jeNavigueAction:destLocation];

    
    
}

- (void)jeNavigueAction :(CLLocation*)destLocation
{
   }

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
}
-(IBAction)showParkingsOnMap:(id)sender{
    
    
    // ajout des places parkopedia
    if(sortedParkings.count!= 0){
        for (int i=0;i<3;i++)
        {
            
            GMSMarker * markerUser = [[GMSMarker alloc] init];
            Parking *park =[[Parking alloc]init];
            park = [sortedParkings objectAtIndex:i];
            markerUser.position = park.position.coordinate;
            
            markerUser.icon = [UIImage imageNamed:@"pinJeLiberePublic.png"];
            
            markerUser.map = self->map.mapView;
            
            markerUser.snippet = [NSString stringWithFormat:@"parkopedia%i",i];
            
            // [markersParkoArray insertObject:markerUser atIndex:i];
            //[parkings insertObject:parking atIndex:i];
            
        }
        
    }
    
    
    
}
-(void)showPArk{
    
    [self.parentController jeChercheAction:nil];
    self.parentController->parkingList = NO;
    
}
-(IBAction)cancelAction:(id)sender{
    
    //[self dismissViewControllerAnimated:YES completion:NULL];
    [UIView animateWithDuration:0.4
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.x = frame.size.width;
                         self.view.frame = frame;
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

@end
