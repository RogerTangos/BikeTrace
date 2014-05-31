//
//  Ride.h
//  BikeTrace02
//
//  Created by Al Carter on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataPoint.h"
#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class CoreMotion;
@class CoreLocation;

@interface Ride : NSObject { 
    NSString * title;
    NSMutableArray * dataPointList;
    int idNum;
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSMutableArray * dataPointList;
@property int idNum;

- (id) initialize;
- (void) newDataPoint:(CLLocation *)location andDeviceMotion:(CMDeviceMotion *) deviceMotion;
- (Ride *) removeDataAfterRideEnded:(double)seconds;

//bi
- (double) averageSpeed;
- (double) distance;
- (NSDate *) startTime;
//- (double) duration;

//db
- (NSString *) getDBPath;
- (void) getInitialDataToDisplay:(NSString *)dbPath;
-(void) insertIntoSQL:(NSString *)dbPath;
-(void) deleteFromSQL:(NSString *)dbPath andDataPoint:(DataPoint *)dp;

@end
