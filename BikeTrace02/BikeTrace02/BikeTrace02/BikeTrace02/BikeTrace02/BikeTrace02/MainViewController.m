//
//  MainViewController.m
//  BikeTrace02
//
//  Created by Al Carter on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "MapViewController.h"
#import "OldRideTableViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize nrSwitchButton;
@synthesize switchButton;
@synthesize addRideButton;
@synthesize viewContainer;
@synthesize geoLocateButton;
@synthesize toolbarView;
@synthesize initialToolbar;
@synthesize nrToolbar;
@synthesize mapViewController;
@synthesize oldRideTableViewController;
@synthesize rideDirectory;
//@synthesize reverseGeocoder; was added, but depreciated


- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // toolbar should be placed before the mapVC, so that layering of the map and the flipVC is correct.f
    [self.view addSubview:toolbarView];
    [toolbarView addSubview:initialToolbar];
    
    [self.view addSubview:toolbarView];
    [toolbarView addSubview:initialToolbar];

       //and initialize the RideDirectory
    self.rideDirectory = [[RideDirectory alloc] init];
    rideDirectory.rideList = [[NSMutableArray alloc] init];
    
    //initializeViews
    mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    oldRideTableViewController = [[OldRideTableViewController alloc] initWithNibName:@"OldRideTableViewController" bundle:nil];
    
    //save rideDirectories
    oldRideTableViewController.rideDirectory = self.rideDirectory;
    mapViewController.rideDirectory = self.rideDirectory;

    
    [self.view addSubview:[mapViewController view]]; 

}

- (void)viewDidUnload
{
    [self setGeoLocateButton:nil];
    [self setSwitchButton:nil];
    [self setSwitchButton:nil];
    [self setViewContainer:nil];
    [self setToolbarView:nil];
    [self setAddRideButton:nil];
    [self setMapViewController:nil];
    [self setInitialToolbar:nil];
    [self setNrToolbar:nil];
    [self setNrSwitchButton:nil];
    [self setNrSwitchButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Add Ride

- (IBAction)addRide:(id)sender {
    //set this to keep track of when we started recording.  
    [mapViewController turnOnTracking];

    [initialToolbar removeFromSuperview];
    if(nrToolbar==nil){
        nrToolbar = [[UIToolbar alloc] init];
    }
    [self.toolbarView addSubview:nrToolbar];
    
    
    [oldRideTableViewController removeFromParentViewController];
    [self.view addSubview:[mapViewController view]];  
    
    
    }

#pragma mark - swithView

- (IBAction)switchView:(id)sender {
    if (switchButton.selectedSegmentIndex == 0) {
        
        [oldRideTableViewController removeFromParentViewController];
        
        [self.view addSubview:[mapViewController view]];        
    }
    else{
        [mapViewController removeFromParentViewController];
        
        [self.view addSubview:[oldRideTableViewController view]];
    }
}

#pragma mark - MapViewControllerDelegate Protocol
-(void) findCurrentLocation {
    [self.mapViewController findCurrentLocation];
}

#pragma mark - Reverse Geolocation
- (IBAction)geoLocate:(id)sender {
    [self findCurrentLocation];
    
}


#pragma mark - action sheet handling.



- (IBAction)nrChangeSettings:(id)sender {
    if (nrSwitchButton.selectedSegmentIndex == 0) {
    // open a dialog with two custom buttons
        
        
        
        NSDate * currentDate = [[NSDate alloc] init];
        NSDate * startDate = mapViewController.startTrackingDate;
        
        NSTimeInterval timeDifference = [currentDate timeIntervalSinceDate:startDate];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                initWithTitle:@"When did you finish riding?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Just Now!" otherButtonTitles:nil, nil];
        
        
        int cancelButtonIndex = 1; //start with one b/c of destructiveButton
        
        
        //add buttons based on time traveled
        if (timeDifference > 120){
            [actionSheet addButtonWithTitle:@"2 Minutes Ago"];
            cancelButtonIndex ++;
        }
        
        if (timeDifference > 300){
            [actionSheet addButtonWithTitle:@"5 Minutes Ago"]; 
            cancelButtonIndex ++;
        }
        
        if(timeDifference > 600){
            [actionSheet addButtonWithTitle:@"10 Minutes Ago"];
            cancelButtonIndex ++;
        }
        
        if(timeDifference > 1200){
            [actionSheet addButtonWithTitle:@"20 Minutes Ago"];
            cancelButtonIndex ++;
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = cancelButtonIndex;
        
        [actionSheet showInView:self.view]; 
        
        
    } else {
        // pause recording here.
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex ==actionSheet.cancelButtonIndex){
        nrSwitchButton.selectedSegmentIndex = 1;
        return;
    }
    
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        NSLog(@"Destructive Button Clicked");
        [self saveTheRide:0.0];
    } else if (buttonIndex == 1) {
        NSLog(@"2 minutes ago");
        [self saveTheRide:(2.0*60)];
    } else if (buttonIndex == 2) {
        NSLog(@"5 minutes ago");
        [self saveTheRide:(5.0*60)];
    } else if (buttonIndex == 3) {
        NSLog(@"10 minutes ago");
        [self saveTheRide:(10.0*60)];
    } else if (buttonIndex == 4) {
        NSLog(@"20 minutes ago");
        [self saveTheRide:(20.0*60)];
    } 
    
    
}

-(void) saveTheRide:(int)seconds{    
    
    [self.mapViewController turnOffTrackingAndRemoveCrumbs:seconds];
    
    //remove the old toolbar and set up the new one
    self.nrSwitchButton.selectedSegmentIndex = 1;
    [self.nrToolbar removeFromSuperview];
    if(initialToolbar==nil){
        initialToolbar = [[UIToolbar alloc] init];
    }
    
    [self.toolbarView addSubview:initialToolbar];
    self.switchButton.selectedSegmentIndex = 1;
    
    //move to oldRideTableView
    [self.view addSubview:[oldRideTableViewController view]];
    [oldRideTableViewController viewWillAppear:TRUE];
    
    
    
}


@end
