//
//  Map2ViewController.h
//  BikeTrace02
//
//  Created by Al Carter on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface Map2ViewController : UIViewController {
    MKMapView * mkMapView;
    UISearchBar * searchBar;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet MKMapView *mkMapView;
@end
