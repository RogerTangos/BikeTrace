//
//  MapViewController.h
//  BikeTrace02
//
//  Created by Al Carter on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipsideViewController.h"
#import <MapKit/MapKit.h>


@interface DumbMapViewController : UIViewController <MKMapViewDelegate, FlipsideViewControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
    
    MKMapView * mapView;
    UIButton * infoButton;
    UISearchBar * searchBar;
    int numberOfTimesUserLocated;
    
}


@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property int numberOfTimesUserLocated;




- (IBAction)showInfo:(id)sender;
- (void)updateUserLocation;

@end
