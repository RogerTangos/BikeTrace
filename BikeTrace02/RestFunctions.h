//
//  RestFunctions.h
//  BikeTrace02
//
//  Created by Albert Carter on 5/31/14.
//
//

#import "AppDelegate.h"

@interface RestFunctions : AppDelegate <NSURLConnectionDataDelegate> {
    NSMutableData* _receivedData;
}

//- (void) turnOffTrackingAndRemoveCrumbs:(double)seconds;
- (void) postRideData;


@end
