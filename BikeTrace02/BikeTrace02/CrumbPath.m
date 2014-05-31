//
//  CrumbPath.m
//  BikeTrace02
//
//  Created by Al Carter on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CrumbPath.h"

#define INITIAL_POINT_SPACE 1000
#define MINIMUM_DELTA_METERS 10.0

@implementation CrumbPath
@synthesize points;
@synthesize pointCount;

- (id)initWithCenterCoordinate:(CLLocationCoordinate2D)coord{
    self = [super init];
    if(self){
    // initialize point storage and place this first coordinate in it
    pointSpace = INITIAL_POINT_SPACE;
    points = malloc(sizeof(MKMapPoint) * pointSpace);
    points[0] = MKMapPointForCoordinate(coord);
    pointCount = 1;
    
    // bite off up to 1/4 of the world to draw into.
    MKMapPoint origin = points[0];
    origin.x -= MKMapSizeWorld.width / 8.0;
    origin.y -= MKMapSizeWorld.height / 8.0;
    MKMapSize size = MKMapSizeWorld;
    size.width /= 4.0;
    size.height /= 4.0;
    boundingMapRect = (MKMapRect) { origin, size };
    MKMapRect worldRect = MKMapRectMake(0, 0, MKMapSizeWorld.width, MKMapSizeWorld.height);
    boundingMapRect = MKMapRectIntersection(boundingMapRect, worldRect);
    
    // initialize read-write lock for drawing and updates
    pthread_rwlock_init(&rwLock, NULL);
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate{
    return MKCoordinateForMapPoint(points[0]);}

- (MKMapRect)boundingMapRect{
    return boundingMapRect;
}

- (void) lockForReading {
    pthread_rwlock_rdlock(&rwLock);
}

- (void) unlockForReading {
    pthread_rwlock_unlock(&rwLock);
}

- (MKMapRect)addCoordinate:(CLLocationCoordinate2D)coord{
    pthread_rwlock_wrlock(&rwLock);
    
    MKMapPoint newPoint = MKMapPointForCoordinate(coord);
    MKMapPoint prevPoint = points[pointCount - 1];
    
    CLLocationDistance metersApart = MKMetersBetweenMapPoints(newPoint, prevPoint);
    
    MKMapRect updateRect = MKMapRectNull;
    
    if(metersApart > MINIMUM_DELTA_METERS)
       {
           if (pointSpace == pointCount){
               pointSpace *= 2;
               points = realloc(points, sizeof(MKMapPoint) * pointSpace);
           }
           points[pointCount] = newPoint;
           pointCount ++;
           
           double minX = MIN(newPoint.x, newPoint.y);
           double minY = MIN(newPoint.y, newPoint.x);
           double maxX = MAX(newPoint.x, newPoint.y);
           double maxY = MAX(newPoint.y, newPoint.x);
           
           updateRect = MKMapRectMake(minX, minY, maxX-minX, maxY-minY);
           
        }
    pthread_rwlock_unlock(&rwLock);

    return updateRect;
}

       
       
       
       
       
@end
