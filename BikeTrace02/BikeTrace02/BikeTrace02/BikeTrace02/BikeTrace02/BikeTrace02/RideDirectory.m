//
//  RideList.m
//  BikeTrace02
//
//  Created by Al Carter on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RideDirectory.h"

@implementation RideDirectory
@synthesize rideList;

-(id) initializeArray: (NSArray *) array {    
    if(self){
        self.rideList = [[NSMutableArray alloc] initWithArray:array];
    } 
    return self;    
}

-(id) initialize {
    if(self){
        self.rideList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(Ride *) newRide {
    Ride *r = [[Ride alloc] init];
    
    //default date/time.
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd 'at' HH:mm" ];
    NSDate *now = [[NSDate alloc] init];
    r.title = [dateFormat stringFromDate:now];
    r.dataPointList = [[NSMutableArray alloc] init];
    
    
    [self.rideList addObject:r];
    return r;
}

-(id) addRide:(Ride *)ride{
    [rideList addObject:ride];
    return ride;
}

-(id) returnAllRides {
    return rideList;
}

#pragma mark - SearchWithRange


-(id) searchWithRange:(NSString *)searchTerm {
    // returns a list of people match the search term
    NSMutableArray *tempList = [[NSMutableArray alloc] init ];
    
    for(Ride *r in self.rideList) {

        if ([r.title rangeOfString:searchTerm].location == NSNotFound) {
            NSLog(@"string does not contain bla");
        } else {
            [tempList addObject:r];
        }
    }
        return tempList;
}
    
@end