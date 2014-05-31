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
@class Ride;

@interface DetailViewController2 : UIViewController <MKMapViewDelegate>{
    CrumbPath *crumbs;
    CrumbPathView *crumbView;
    Ride * ride;

}

@property (nonatomic, retain) CrumbPath * crumbs;
@property (nonatomic, retain) CrumbPathView * crumbView;
@property (nonatomic, retain) Ride * ride;


-(void) displayRide:(Ride* ) rideToDisplay;

@end
