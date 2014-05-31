//
//  DetailViewController.m
//  BikeTrace02
//
//  Created by Al Carter on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController2.h"
#import "Ride.h"
#import "DataPoint.h"


@interface DetailViewController2 ()

@end

@implementation DetailViewController2
@synthesize crumbs;
@synthesize crumbView;
@synthesize ride;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//
//- (void) displayRide:(Ride *)rideToDisplay{
//    
//    for(DataPoint * dp in rideToDisplay.dataPointList){
//        
//        if(!crumbs) {
//            self.crumbs = [[CrumbPath alloc] initWithCenterCoordinate:dp.location.coordinate];
//            [mkMapView addOverlay:crumbs];
//        }
//        
//        MKMapRect updateRect = [crumbs addCoordinate:dp.location.coordinate];
//        if (!MKMapRectIsNull(updateRect)){
//            
//            //get the current map's zoom
//            MKZoomScale currentZoomScale = (CGFloat)(mkMapView.bounds.size.width / mkMapView.visibleMapRect.size.width);
//            
//            //get the current lineWidth at the zoom
//            CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
//            updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
//            
//            //have the overlay update *just* the updated area
//            [crumbView setNeedsDisplayInMapRect:updateRect];
//        }
//        
//    }
//}


@end
