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
@synthesize latitudeString;
@synthesize longitudeString;
@synthesize motion;
@synthesize date;


- (id) initWithData:(CLLocation *)dLocation andDeviceMotion:(CMDeviceMotion *)dMotion {
    self.location = dLocation;
    self.motion = dMotion;
    self.date = [NSDate date];
    self.latitudeString = [[NSString alloc] init];
    self.longitudeString = [[NSString alloc] init];
    
    return self;
}

- (NSMutableDictionary *)toNSDictionaryWithStrings
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSString *latitudeString = [NSString stringWithFormat:@"%.9lf", location.coordinate.latitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%.9lf", location.coordinate.longitude];
    NSString *altitudeString = [NSString stringWithFormat:@"%.9lf", location.altitude];
    NSString *horizontalAccuracyString = [NSString stringWithFormat:@"%.9lf", location.horizontalAccuracy];
    NSString *verticalAccuracyString = [NSString stringWithFormat:@"%.9lf", location.verticalAccuracy];
    NSString *dateString = [NSString stringWithFormat:@"%lf", date.timeIntervalSinceReferenceDate];
    NSString *speedString = [NSString stringWithFormat:@"%lf", location.speed];
    NSString *courseString = [NSString stringWithFormat:@"%lf", location.course];
    
    [dictionary setValue:latitudeString forKey:@"latitude"];
    [dictionary setValue:longitudeString forKey:@"longitude"];
    [dictionary setValue:altitudeString forKey:@"altitude"];
    [dictionary setValue:horizontalAccuracyString forKey:@"horizontalAccuracy"];
    [dictionary setValue:verticalAccuracyString forKey:@"verticalAccuracy"];
    [dictionary setValue:dateString forKey:@"date"];
    [dictionary setValue:speedString forKey:@"speed"];
    [dictionary setValue:courseString forKey:@"course"];
    
    return dictionary;
}

- (void) setLatLongStrings{
//    doubles don't have enough precision. To use the JSON serializer, we need to cast to string.
    self.latitudeString = [NSString stringWithFormat:@"%.9lf", self.location.coordinate.latitude];
    self.longitudeString = [NSString stringWithFormat:@"%.9lf", self.location.coordinate.longitude];
}



@end
