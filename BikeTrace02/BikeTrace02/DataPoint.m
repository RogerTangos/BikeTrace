//
//  DataPoint.m
//  BikeTrace02
//
//  Created by Al Carter on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataPoint.h"

@implementation DataPoint
@synthesize location;
@synthesize motion;
@synthesize date;


- (id) initWithData:(CLLocation *)dLocation andDeviceMotion:(CMDeviceMotion *)dMotion {
    self.location = dLocation;
    self.motion = dMotion;
    self.date = [NSDate date];
    
    return self;
}



@end
