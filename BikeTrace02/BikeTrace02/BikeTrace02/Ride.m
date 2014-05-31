//
//  Ride.m
//  BikeTrace02
//
//  Created by Al Carter on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ride.h"

@implementation Ride
@synthesize dataPointList;
@synthesize title;

-(id) initialize {
    if(self){
        self.dataPointList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id) initializeArray: (NSArray *) array {    
    if(self){
        self.dataPointList = [[NSMutableArray alloc] initWithArray:array];
    } 
    return self;    
}

- (void) newDataPoint:(CLLocation *)location andDeviceMotion:(CMDeviceMotion *)deviceMotion{
    
    DataPoint * data = [[DataPoint alloc] initWithData:location andDeviceMotion:deviceMotion];
    
    [dataPointList addObject:data];
}

- (void) removeDataAfterRideEnded:(double)seconds{
    NSDate * currentDate = [[NSDate alloc] init];
    
    seconds = (seconds * -1);
    
    NSTimeInterval * timeInterval = &seconds;
    
    //the error is here.  
    NSDate * cutoffTime = [currentDate dateByAddingTimeInterval:*timeInterval];
    
    for (DataPoint * dp in dataPointList){
        
        if ([dp.date compare:cutoffTime] == NSOrderedDescending){
            int startRemovalInt = [dataPointList indexOfObject:dp];
            int lengthForRemovalInt = ([dataPointList count]-startRemovalInt);
            
            NSRange removalRange = {startRemovalInt, lengthForRemovalInt};
            
            [dataPointList removeObjectsInRange:removalRange];
            return;
        }
        
        
    }
}


@end
