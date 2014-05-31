//
//  MapViewController.m
//  BikeTrace02
//
//  Created by Al Carter on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OldMapViewController.h"

@interface OldMapViewController ()

@end

@implementation OldMapViewController
@synthesize mapView;
@synthesize infoButton;
@synthesize searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.showsUserLocation = YES;
    
//    CGRect butRect = {0, -44, 320, 44};
    [self.view addSubview:searchBar];
//    searchBar.frame = butRect;
        
    CGRect newButRect = {290, 340, 18, 19};
    [self.view addSubview:infoButton];
    infoButton.frame =  newButRect;
    
    //sets the initial number of lookups to 0
    numberOfTimesUserLocated = 0;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setInfoButton:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - zooming to location
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation 
{
    //executes every time the location is updated
    
    //for the first few times, I zoom to where they are.
    if (numberOfTimesUserLocated > 3 && numberOfTimesUserLocated < 6){
        MKCoordinateRegion mapRegion;   
        mapRegion.center = self.mapView.userLocation.coordinate;
        mapRegion.span = MKCoordinateSpanMake(0.2, 0.2);
        [self.mapView setRegion:mapRegion animated: YES];
    }
    numberOfTimesUserLocated ++;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    // Do this when the map has finished loading.
    
}

-(void)updateUserLocation{
//    MKCoordinateRegion mapRegion;   
//    mapRegion.center = self.mapView.userLocation.coordinate;
//    mapRegion.span = MKCoordinateSpanMake(0.2, 0.2);
//    [self.mapView setRegion:mapRegion animated: YES];
}


#pragma mark - flipsideViewController
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
    [self viewDidLoad];
    
}

- (IBAction)showInfo:(id)sender {
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}
@end
