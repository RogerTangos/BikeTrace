//
//  RideList.h
//  BikeTrace02
//
//  Created by Al Carter on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ride.h"

@interface RideDirectory : NSObject {
    NSMutableArray * rideList;
}

@property (readwrite, strong) NSMutableArray * rideList;

-(id) initializeArray: (NSArray *) array;
-(id) initialize;
-(Ride *) newRide;
-(id) addRide:(Ride *)ride;

-(id) searchWithRange:(NSString *)searchTerm;


@end
