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
    NSMutableArray * networkRideList;
}

@property (readwrite, strong) NSMutableArray * rideList;
@property (readwrite, strong) NSMutableArray * networkRideList;

-(id) initializeArray: (NSArray *) array;
-(id) initialize;
-(Ride *) newRide;
-(Ride *) newRideWithoutAdd;

-(id) searchWithRange:(NSString *)searchTerm;

// network and json management
- (void) loadNetworkRides:(CLLocation *)currentLocation;
- (NSArray *) arrayFromData:(NSData *) data;
- (NSArray *) reverseEngineerPointDataToArr:(NSArray *)oldArr;
//- (void) populateNetworkRidesFromArrayOfPoints:(NSArray *)oldArr;
- (NSArray *) reverseRegex:(NSArray *)matches andString:(NSString *)str;

// processing
-(void) createRidesFromNetworkReturnArray:(NSArray *)arr;
//-(void) populateRidesWithDataFromNetworkReturnArray:(NSArray *)arr;

//db
- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;
- (void) getInitialDataToDisplay:(NSString *)dbPath;
-(void) insertIntoSQL:(NSString *)dbPath andRide:(Ride *)r;
-(void) deleteFromSQL:(NSString *)dbPath andRide:(Ride *)r;
-(int) getMostRecentInsertKey:(NSString *)dbPath;
-(void) updateRideTitleInSQL:(NSString *)dbPath andRide:(Ride *)r;




@end
