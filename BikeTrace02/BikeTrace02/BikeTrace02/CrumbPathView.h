//
//  CrumbPathView.h
//  BikeTrace02
//
//  Created by Al Carter on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CrumbPathView : MKOverlayView
{
    float red;
    float green;
    float blue;
    float alpha;
}

@property float red;
@property float green;
@property float blue;
@property float alpha;

@end
