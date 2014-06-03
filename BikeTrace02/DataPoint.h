//
//  DataPoint.h
//  BikeTrace02
//
//  Created by Al Carter on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>


@interface DataPoint : NSObject {
    CLLocation * location;
    CMDeviceMotion * motion;
    NSDate * date;
}

@property (nonatomic, retain) CLLocation * location;
@property (nonatomic, retain) CMDeviceMotion * motion;

//create latitude and longitude strings to avoid json serialization problems...
@property (nonatomic, retain) NSString * latitudeString;
@property (nonatomic, retain) NSString * longitudeString;
@property NSDate * date;

-(id) initWithData:(CLLocation *)dLocation andDeviceMotion:(CMDeviceMotion *)dMotion;
- (NSMutableDictionary *)toNSDictionaryWithStrings;
- (void) setLatLongStrings;



@end
