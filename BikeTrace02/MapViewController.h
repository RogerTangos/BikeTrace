//
//  MapViewController.h
//  BikeTrace02
//
//  Created by Al Carter on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreMotion/CoreMotion.h>
#import "FlipsideViewController.h"
#import "FormViewController.h"
#import "CrumbPath.h"
#import "CrumbPathView.h"
#import "Ride.h"
#import "DataPoint.h"
#import "RideDirectory.h"
#import "SearchResultDirectory.h"


@class MapViewController;

#define kGOOGLE_API_KEY @"AIzaSyD_CI6YanVsgqjLz1kOxCad92A7b_mmKNA"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MapViewController : UIViewController <FlipsideViewControllerDelegate, FormViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UIAlertViewDelegate> {
    
    //this is for location tracking
    CrumbPath *crumbs;
    CrumbPathView *crumbView;
    Ride * ride;
    RideDirectory * rideDirectory;
    
    //tracking
    BOOL tracking;
    BOOL autoLocate;
    BOOL bikeRoute;
    NSDate *startTrackingDate;
    
    BOOL backgroundUpdate;
    
    //crumbOverlays are an array of all the rides being displayed when you view all rides. I need to add them to a list, so that I can removeOverlays: later.
    NSMutableArray * localCrumbOverlays;
    NSMutableArray * networkCrumbOverlays;
    
    
    CMMotionManager * motionManager;
    CLLocationManager *locationManager;
    
    BOOL plotMultipleOverlays;
    
    //google search
    UISearchBar * searchBar;
    CLLocationCoordinate2D currentCentre;
    int currentDistance;
    BOOL triedGooglePlaces; //here so that we can try google maps for an address before reverting to places.
    
}


@property (strong, nonatomic) IBOutlet MKMapView *mkMapView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *formButton;

@property BOOL autoLocateExecuted;
//autoLocateExecuted is just for the very first autolocation when location updates.
@property BOOL autoLocate;
//autoLocate is for updating map location every time the locate loop is hit.

@property BOOL tracking;
@property BOOL bikeRoute;
@property (nonatomic,retain) NSDate * startTrackingDate;

@property (nonatomic, retain) NSMutableArray * localCrumbOverlays;
@property (nonatomic, retain) NSMutableArray * networkCrumbOverlays;
@property BOOL plotMultipleOverlays;

@property (nonatomic, retain) CMMotionManager *motionManager;
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) CrumbPath * crumbs;
@property (nonatomic, retain) CrumbPathView * crumbView;
@property (nonatomic, retain) Ride * ride;
@property (nonatomic, retain) RideDirectory * rideDirectory;


- (IBAction)infoButtonPressed:(id)sender;
- (IBAction)formButtonPressed:(id)sender;

- (void) findCurrentLocation;
- (void) turnOffTrackingAndRemoveCrumbs:(double)seconds;
- (void) turnOnTracking;
- (void) switchToBackgroundMode:(BOOL)background;

- (void) turnOnAutolocate:(BOOL)autolocateSent;
- (void) turnOnBikeRoute:(BOOL)bikeRouteSent;

- (void) queryGoogleMaps: (NSString *) googleType;
- (void) queryGooglePlaces;

- (void) callMapVcNetworking:(BOOL)network;

@end
