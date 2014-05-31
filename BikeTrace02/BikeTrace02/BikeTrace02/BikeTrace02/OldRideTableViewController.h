//
//  OldRideTableViewController.h
//  BikeTrace02
//
//  Created by Al Carter on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RideDirectory.h"
#import "MapViewController.h"
#import "DetailViewController.h"


@interface OldRideTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>{
    
    RideDirectory * rideDirectory;
    RideDirectory * filteredRideDirectory;
    
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    
    //detail view
    DetailViewController * detailViewController;

}

@property (nonatomic, retain) RideDirectory * rideDirectory;
@property (nonatomic, retain) RideDirectory * filteredRideDirectory;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property (nonatomic, retain) IBOutlet UINavigationController * navigationController;

@end
