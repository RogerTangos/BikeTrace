//
//  RideList.h
//  BikeTrace02
//
//  Created by Al Carter on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Ride.h"


@interface RideDirectory : NSObject {
    NSMutableArray * rideList;
}

@property (readwrite, strong) NSMutableArray * rideList;

-(id) initializeArray: (NSArray *) array;
-(id) initialize;
-(Ride *) newRide;
-(Ride *) newRideWithoutAdd;

-(id) searchWithRange:(NSString *)searchTerm;

//db
- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;
- (void) getInitialDataToDisplay:(NSString *)dbPath;
-(void) insertIntoSQL:(NSString *)dbPath andRide:(Ride *)r;
-(void) deleteFromSQL:(NSString *)dbPath andRide:(Ride *)r;
-(int) getMostRecentInsertKey:(NSString *)dbPath;
-(void) updateRideTitleInSQL:(NSString *)dbPath andRide:(Ride *)r;




@end
