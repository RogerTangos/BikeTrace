//
//  CrumbPath.h
//  BikeTrace02
//
//  Created by Al Carter on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <pthread.h>



@interface CrumbPath : NSObject <MKOverlay>{
    MKMapPoint *points;
    NSUInteger pointCount;
    NSUInteger pointSpace;

    
    MKMapRect boundingMapRect;
    
    pthread_rwlock_t rwLock;
}

@property (readonly) MKMapPoint *points;
@property (readonly) NSUInteger pointCount;

- (id)initWithCenterCoordinate:(CLLocationCoordinate2D)coord;
- (MKMapRect)addCoordinate:(CLLocationCoordinate2D)coord;
- (void)lockForReading;
- (void)unlockForReading;

@end
