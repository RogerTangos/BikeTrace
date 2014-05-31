//
//  DetailViewController.h
//  BikeTrace02
//
//  Created by Al Carter on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CrumbPath.h"
#import "CrumbPathView.h"
#import "Ride.h"
#import "DataPoint.h"

@interface DetailViewController : UIViewController <MKMapViewDelegate>{
    CrumbPath *crumbs;
    CrumbPathView *crumbView;
    Ride * ride;
    
    //google search
//    UISearchBar * searchBar;
//    CLLocationCoordinate2D currentCentre;
//    int currenDist;
//    BOOL triedGooglePlaces;

}

@property (strong, nonatomic) IBOutlet MKMapView *mkMapView;
@property (nonatomic, retain) CrumbPath * crumbs;
@property (nonatomic, retain) CrumbPathView * crumbView;
@property (nonatomic, retain) Ride * ride;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *geoButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UILabel *rideTitle;
@property (strong, nonatomic) IBOutlet UILabel *avgSpeedLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;


-(void) displayRide:(Ride* ) rideToDisplay;
- (IBAction)findCurrentLocation:(id)sender;
- (IBAction)goBack:(id)sender;


@end
