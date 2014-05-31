//
//  DetailViewController.m
//  BikeTrace02
//
//  Created by Al Carter on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"



@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize mkMapView;
@synthesize crumbs;
@synthesize crumbView;
@synthesize ride;
@synthesize geoButton;
@synthesize backButton;



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
    
    
    
//    CGRect frame = self.parentViewController.view.frame;
//    NSLog(@"viewDidLoad: %@", NSStringFromCGRect(frame));
    
    [self displayRide:self.ride];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
//    CGRect frame = self.parentViewController.view.frame;
//    NSLog(@"viewDidUnload: %@", NSStringFromCGRect(frame));
    [self setGeoButton:nil];
    [self setBackButton:nil];
    [self setMkMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//

- (IBAction)findCurrentLocation:(id)sender {
    
    mkMapView.showsUserLocation = YES;
    
    MKCoordinateRegion mapRegion;   
    mapRegion.center = self.mkMapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = .01;
    mapRegion.span.longitudeDelta = .01;
    
    [mkMapView setRegion:mapRegion animated: YES];
}

# pragma mark - overlay

- (void) displayRide:(Ride *)rideToDisplay{
    for(DataPoint * dp in rideToDisplay.dataPointList){
        
        if(!crumbs) {
            self.crumbs = [[CrumbPath alloc] initWithCenterCoordinate:dp.location.coordinate];
            
            [self.mkMapView addOverlay:crumbs];
        }
        
        MKMapRect updateRect = [crumbs addCoordinate:dp.location.coordinate];
        if (!MKMapRectIsNull(updateRect)){
            
            //get the current map's zoom
            MKZoomScale currentZoomScale = (CGFloat)(mkMapView.bounds.size.width / mkMapView.visibleMapRect.size.width);
            
            //get the current lineWidth at the zoom
            CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
            updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
            
            //have the overlay update *just* the updated area
            [self.crumbView setNeedsDisplayInMapRect:updateRect];
        }
        
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if (!self.crumbView)
    {
        self.crumbView = [[CrumbPathView alloc] initWithOverlay:overlay];
    }
    return self.crumbView;
}

#pragma mark - nav
- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
//    CGRect frame = self.parentViewController.view;
//    NSLog(@"goBack: %@", NSStringFromCGRect(frame));
}

@end
