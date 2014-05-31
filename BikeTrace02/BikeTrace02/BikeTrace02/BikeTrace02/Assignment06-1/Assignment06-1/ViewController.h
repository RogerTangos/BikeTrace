//
//  ViewController.h
//  Assignment06-1
//
//  Created by Al Carter on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonDirectory;
@class CityDirectory;

@interface ViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
    
    CityDirectory * cityDirectory;
    PersonDirectory * filteredPD;
        
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
}

@property (nonatomic, retain) CityDirectory * cityDirectory;
@property (nonatomic, retain) PersonDirectory* filteredPD;

/// old stuff
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@end
