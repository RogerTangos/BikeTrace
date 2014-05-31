//
//  MainViewController.h
//  BikeTrace02
//
//  Created by Al Carter on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewRideViewController.h"
#import "MapViewController.h"
#import <UIKit/UIKit.h>

#import "CrumbPath.h"
#import "CrumbPathView.h"

#import "RideDirectory.h"
#import "OldRideTableViewController.h"


@interface MainViewController : UIViewController<UIActionSheetDelegate>{
    
    UIView * viewContainer;
    MKMapView *mapView;
    UIBarButtonItem *geoLocateButton;
    UISegmentedControl * switchButton;
    UIBarButtonItem *addRideButton;
    
    UIView * toolbarView;
    UIToolbar * initialToolbar;
    UIToolbar * nrToolbar;
    
    //thse two viewControllers are place in viewContainer
    MapViewController * mapViewController;
    OldRideTableViewController * oldRideTableViewController;
    
    //The MainViewController gets the rideDirectory.  To save on memory space, it isn't actually initialized unless the user opens the OldRideViewController, or presses the new Ride button.
    RideDirectory * rideDirectory;
    

}
//viewControllers to load
@property (strong, nonatomic) MapViewController * mapViewController;
@property (strong, nonatomic) UITableViewController * oldRideTableViewController;

//View Container which will hold OldRideViewController and MapViewController
@property (strong, nonatomic) IBOutlet UIView *viewContainer;

//toolbars
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (strong, nonatomic) IBOutlet UIToolbar *initialToolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *nrToolbar;

//init toolbar buttons
@property (strong, nonatomic) IBOutlet UIBarButtonItem *geoLocateButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *switchButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addRideButton;

//nr toolbar buttons
@property (strong, nonatomic) IBOutlet UISegmentedControl *nrSwitchButton;

//the RideDirectory
@property (strong, nonatomic) RideDirectory * rideDirectory;


//ini toolbarButton Actions
- (IBAction)addRide:(id)sender;
- (IBAction)switchView:(id)sender;
- (IBAction)geoLocate:(id)sender;

//nr toolbar button actions
- (IBAction)nrChangeSettings:(id)sender;

//this is here incase the app is about to be terminated:
- (void) saveTheRide:(int)seconds;

@end
