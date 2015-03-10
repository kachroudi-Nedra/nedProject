//
//  MenuModalViewController.m
//  Apila
//
//  Created by Vincenzo GALATI on 19/02/2014.
//  Copyright (c) 2014 1CPARABLE SARL. All rights reserved.
//

#import "MenuModalViewController.h"

@interface MenuModalViewController ()

@end

@implementation MenuModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSomething)];
    
    [mSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [[self view] addGestureRecognizer:mSwipeUpRecognizer];
    UISwipeGestureRecognizer *mSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(justClick)];
    
    
    [[self view] addGestureRecognizer:mSwipe];
    [imageview setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [imageview addGestureRecognizer:singleTap];
    appDelegate = (AppDelegate * )[[UIApplication sharedApplication] delegate];
    NSLog(@"Voiture : %@,%@,%@",appDelegate.user_car_marque,appDelegate.user_car_modele,appDelegate.user_car_couleur);
    _userPseudo.text = appDelegate.user_pseudo;
    _userCar.text= appDelegate.user_car_marque;
}
-(void)justClick{
    
    NSLog(@"click on view");
}
- (void) doSomething
{
    NSLog(@"FERMER MENU");
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.x = frame.origin.x - frame.size.width;
                         self.view.frame = frame;
                     } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        
        case 0:
            return @"MES OPTIONS";
            break;
        case 1:
            return @"AUTRES";
            break;
        default:
            break;
    }
    return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        
        case 0:
            return 3;
            break;
        case 1:
            return 4;
            break;
        default:
            break;
    }
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   /* switch (indexPath.section) {
        case 0:
            return 80;
            break;
            
        default:
            return 60;
            break;
    }
    */
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellMenu";
    /*cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
     */
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell2) {
        cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
        
    }
    
    //cell.contentView.backgroundColor = [UIColor lightGrayColor];
    
    NSMutableArray *OptionsSections =  [[NSMutableArray alloc]initWithObjects:@"Options de recherche",@"Options Navigation",@"Amis",@"Parler d'Apila",@"Parler avec Apila",@"FAQ",@"A propos", nil];
     NSMutableArray *OtherSections =  [[NSMutableArray alloc]initWithObjects:@"Parler d'Apila",@"Parler avec Apila",@"FAQ",@"A propos", nil];
    /*if(indexPath.section == 0)
    {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(100.0, 100.0, 100.0, 100.0)];
        [imageview setImage:[UIImage imageNamed:@"image.png"]];
        
        //cell.userImage setImage:<#(UIImage *)#> imageview
        [cell.userImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
        [singleTap setNumberOfTapsRequired:1];
        [cell.userImage addGestureRecognizer:singleTap];
        return cell;
     
    }
    else{*/
        
    if(indexPath.section == 0){
        
        cell2.textLabel.text =[NSString stringWithFormat:@"%@",[OptionsSections objectAtIndex:indexPath.row]];
        
    }
    if(indexPath.section == 1){
        
        cell2.textLabel.text =[NSString stringWithFormat:@"%@",[OtherSections objectAtIndex:indexPath.row]];
        
    }
        return cell2;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == _myTableView){
        
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    
}
- (IBAction) singleTapping:(id)sender
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self;
    [self presentModalViewController:pickerController animated:YES];
}
- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    
    imageview.image = image;
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    _CanvasView.alpha =0.60;
}

- (void)viewDidDisappear:(BOOL)animated
{
    _CanvasView.alpha =0.0;
}


@end
