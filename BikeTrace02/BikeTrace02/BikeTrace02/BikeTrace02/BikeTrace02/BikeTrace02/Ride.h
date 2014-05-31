//
//  Ride.h
//  BikeTrace02
//
//  Created by Al Carter on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataPoint.h"
#import <Foundation/Foundation.h>
@class CoreMotion;
@class CoreLocation;

@interface Ride : NSObject { 
    NSString * title;
    NSMutableArray * dataPointList;
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSMutableArray * dataPointList;

- (id) initialize;
- (void) newDataPoint:(CLLocation *)location andDeviceMotion:(CMDeviceMotion *) deviceMotion;
- (void) removeDataAfterRideEnded:(double)seconds;
@end
