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
    
    //load the database
    [self.rideDirectory copyDatabaseIfNeeded];
    self.rideDirectory.rideList = [[NSMutableArray alloc] init];
    [self.rideDirectory  getInitialDataToDisplay:[rideDirectory getDBPath]];
    
    
    
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
    return interfaceOrientation == UIInterfaceOrientationPortrait;
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

#pragma mark - map view handling (not recording)

- (IBAction)switchView:(id)sender {
    if (switchButton.selectedSegmentIndex == 0) {
        
        [oldRideTableViewController removeFromParentViewController];
        
        [self.view addSubview:[mapViewController view]];        
    }
    else{
        [mapViewController removeFromParentViewController];
        
        //here for memory management if we had to clear out the ORTVC
        if(!oldRideTableViewController){
        oldRideTableViewController = [[OldRideTableViewController alloc] initWithNibName:@"OldRideTableViewController" bundle:nil];
        
        //save rideDirectories
        oldRideTableViewController.rideDirectory = self.rideDirectory;
        }
        
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



#pragma mark - Ride sheet handling.


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

//        working on a delete method.
//        [actionSheet addButtonWithTitle:@"Delete Ride Without Saving"];
//        actionSheet.firstOtherButtonIndex = cancelButtonIndex;
//        cancelButtonIndex ++;
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = cancelButtonIndex;
        
        [actionSheet showInView:self.view]; 
        
        
    } else {
        
        //this will pause the map update.
        if (self.mapViewController.tracking){
            self.mapViewController.tracking = NO;
            
            //might try switching out images for play/pause in the future.
            
            //NSLog(@"Tracking turned off");
        } else {
            self.mapViewController.tracking = YES;
            //NSLog(@"Tracking turned back on");
        }
    }
    self.nrSwitchButton.selectedSegmentIndex = -1;

}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex ==actionSheet.cancelButtonIndex){
        return;
    }
    
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        //NSLog(@"Destructive Button Clicked");
        [self saveTheRide:0.0];
    } else if (buttonIndex == 1) {
        //NSLog(@"2 minutes ago");
        [self saveTheRide:(2.0*60)];
    } else if (buttonIndex == 2) {
        //NSLog(@"5 minutes ago");
        [self saveTheRide:(5.0*60)];
    } else if (buttonIndex == 3) {
        //NSLog(@"10 minutes ago");
        [self saveTheRide:(10.0*60)];
    } else if (buttonIndex == 4) {
        //NSLog(@"20 minutes ago");
        [self saveTheRide:(20.0*60)];
    } else if (buttonIndex == actionSheet.cancelButtonIndex -1){
        //delete the ride without saving.
    }
    
    
}

-(void) saveTheRide:(int)seconds{    
    
    //this is what actually saves the damn thing...
    [self.mapViewController turnOffTrackingAndRemoveCrumbs:seconds];
    
    //remove the old toolbar and set up the new one
    [self.nrToolbar removeFromSuperview];
    if(initialToolbar==nil){
        initialToolbar = [[UIToolbar alloc] init];
    }
    
    [self.toolbarView addSubview:initialToolbar];
    self.switchButton.selectedSegmentIndex = 1;
    
    
    // this is here in case we received a memory warning, and had to clear the ORTVC
    if (!oldRideTableViewController){
        self.oldRideTableViewController = [[OldRideTableViewController alloc] initWithNibName:@"OldRideTableViewController" bundle:nil];
        
        //save rideDirectories
        oldRideTableViewController.rideDirectory = self.rideDirectory;
    }
    
    //move to oldRideTableView
    [self.view addSubview:[oldRideTableViewController view]];
    [oldRideTableViewController viewWillAppear:TRUE];
    
}



@end
