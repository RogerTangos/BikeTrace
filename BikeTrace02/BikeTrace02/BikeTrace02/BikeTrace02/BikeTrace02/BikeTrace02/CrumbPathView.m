//
//  CrumbPathView.m
//  BikeTrace02
//
//  Created by Al Carter on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CrumbPathView.h"
#import "CrumbPath.h"

@interface CrumbPathView (FileInternal)
- (CGPathRef)newPathForPoints:(MKMapPoint *)points
pointCount:(NSUInteger)pointCount
clipRect:(MKMapRect)mapRect
zoomScale:(MKZoomScale)zoomScale;
@end

@implementation CrumbPathView


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

//sets the line attributes
- (void) drawMapRect:(MKMapRect)mapRect
            zoomScale:(MKZoomScale)zoomScale
           inContext:(CGContextRef)context {
    
    CrumbPath *crumbs = (CrumbPath *)(self.overlay);
    
    CGFloat lineWidth = MKRoadWidthAtZoomScale(zoomScale);
    
    MKMapRect clipRect = MKMapRectInset(mapRect, -lineWidth, -lineWidth);
    
    [crumbs lockForReading];
    CGPathRef path = [self newPathForPoints:crumbs.points pointCount:crumbs.pointCount clipRect:clipRect zoomScale:zoomScale];
    [crumbs unlockForReading];
    
    if (path !=nil){
        CGContextAddPath(context, path);
        CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 1.0f, 0.5f);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, lineWidth);
        CGContextStrokePath(context);
        CGPathRelease(path);
    }
}

@end

@implementation CrumbPathView (FileInternal)

static BOOL lineIntersectsRect(MKMapPoint p0, MKMapPoint p1, MKMapRect r) {
    double minX = MIN(p0.x, p1.x);
    double minY = MIN(p0.y, p1.y);
    double maxX = MAX(p0.x, p1.x);
    double maxY = MAX(p0.y, p1.y);
    
    MKMapRect r2 = MKMapRectMake(minX, minY, maxX-minX, maxY-minY);
    
    return MKMapRectIntersectsRect(r, r2);
}

#define MIN_POINT_DELTA 5.0

- (CGPathRef)newPathForPoints:(MKMapPoint *)points pointCount:(NSUInteger)pointCount clipRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    //draw the path on the screen quickly by excluding points that are too close to gether to show.  It's faster to do this than to let coreGraphics take care of it.  Esp considering that I want this to work on a 3GS...
    
    if (pointCount <2){
        return NULL;
    }
    
    CGMutablePathRef path = NULL;
    
    BOOL needsMove = YES;
    
#define POW2(a) ((a) * (a))
    
    //calculate min distance that will be relevant to us to display
    double minPointDelta = MIN_POINT_DELTA / zoomScale;
    double c2 = POW2(minPointDelta);
    
    MKMapPoint point, lastPoint = points[0];
    NSUInteger i;
    for(i=1; i<pointCount-1; i++){
        point = points[i];
        double a2b2 = POW2(point.x - lastPoint.x) + POW2(point.y - lastPoint.y);
        if (a2b2 >= c2) {
            if (lineIntersectsRect(point, lastPoint, mapRect))
            {
                if (!path) 
                    path = CGPathCreateMutable();
                if (needsMove)
                {
                    CGPoint lastCGPoint = [self pointForMapPoint:lastPoint];
                    CGPathMoveToPoint(path, NULL, lastCGPoint.x, lastCGPoint.y);
                }
                CGPoint cgPoint = [self pointForMapPoint:point];
                CGPathAddLineToPoint(path, NULL, cgPoint.x, cgPoint.y);
            }
            else
            {
                // lift the pen, because this is discontinuous.
                needsMove = YES;
            }
            lastPoint = point;
        }
    }
    
#undef POW2
    //if the last line segment interstects mapRect at all, add it no matter what.
    point = points[pointCount -1];  //point is the last point.
    
    if (lineIntersectsRect(lastPoint, point, mapRect)){
        if (!path){
            path = CGPathCreateMutable();
        }
        if (needsMove){
            CGPoint lastCGPoint = [self pointForMapPoint:lastPoint];
            CGPathMoveToPoint(path, NULL, lastCGPoint.x, lastCGPoint.y);
        }
        CGPoint cgPoint = [self pointForMapPoint:point];
        CGPathAddLineToPoint(path, NULL, cgPoint.x, cgPoint.y);
    }
    return path;
    
}

@end