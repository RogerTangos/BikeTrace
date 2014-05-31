//
//  NewRideViewController.h
//  BikeTrace02
//
//  Created by Al Carter on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NewRideViewController : UIViewController <MKMapViewDelegate, FlipsideViewControllerDelegate> {

    
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
