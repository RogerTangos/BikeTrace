//
//  MapViewController.m
//  BikeTrace02
//
//  Created by Al Carter on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize crumbs;
@synthesize crumbView;
@synthesize ride;
@synthesize rideDirectory;

@synthesize tracking;
@synthesize autoLocate;
@synthesize bikeRoute;
@synthesize crumbOverlays;

@synthesize startTrackingDate;
@synthesize motionManager;
@synthesize locationManager;

@synthesize searchBar;
@synthesize mkMapView;

@synthesize infoButton;
@synthesize autoLocateExecuted;



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
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    mkMapView.showsUserLocation = YES;
    autoLocateExecuted = NO;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMkMapView:nil];
    [self setSearchBar:nil];
    [self setInfoButton:nil];
//    [self setTracking:NO];
//    [self setBikeRoute:NO];
    
    // need to fill in everything here before submitting.  For MM.
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - breadcrumbs
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
        
    // auto-locate when the MapView is first created
    if(self.autoLocateExecuted == NO & newLocation.horizontalAccuracy < 10){
        MKCoordinateRegion mapRegion;   
        mapRegion.center = newLocation.coordinate;
        mapRegion.span.latitudeDelta = .01;
        mapRegion.span.longitudeDelta = .01;
        self.autoLocateExecuted = YES;
        
        [self.mkMapView setRegion:mapRegion animated: YES];
    }
    
    
    if ((oldLocation.coordinate.latitude != newLocation.coordinate.latitude) &&
        (oldLocation.coordinate.longitude != newLocation.coordinate.longitude))
    { 
        [self autoCenterLocation];
        
        //if the tracking is on
        if (tracking){
        //create crumbs and add them to the map if they weren't there already
        if(!crumbs) {
            self.crumbs = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
            
            [mkMapView addOverlay:crumbs];
            
            
            self.ride = [rideDirectory newRide];
            
            self.motionManager = [[CMMotionManager alloc] init];
            [motionManager startDeviceMotionUpdates];
            motionManager.showsDeviceMovementDisplay = YES;
            motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
            
            }
        else {
            
            // unfortuantely CMDeviceMotion is always nil in the simulator.  Will need to test this on an actual device :-/
            CMDeviceMotion *dm =motionManager.deviceMotion;
            DataPoint *dp = [[DataPoint alloc] initWithData:newLocation andDeviceMotion:dm];
            [self.ride.dataPointList addObject:dp];
            
            MKMapRect updateRect = [crumbs addCoordinate:newLocation.coordinate];
            
            if (!MKMapRectIsNull(updateRect)){
                
                //get the current map's zoom
                MKZoomScale currentZoomScale = (CGFloat)(mkMapView.bounds.size.width / mkMapView.visibleMapRect.size.width);
                
                //get the current lineWidth at the zoom
                CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                
                //have the overlay update *just* the updated area
                [crumbView setNeedsDisplayInMapRect:updateRect];
            }
        }
        }
    
    }
    
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if (!crumbView)
    {
        crumbView = [[CrumbPathView alloc] initWithOverlay:overlay];
    }
    return crumbView;
}


- (void) findCurrentLocation{
    MKCoordinateRegion mapRegion;   
    mapRegion.center = self.mkMapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = .01;
    mapRegion.span.longitudeDelta = .01;
    
    [mkMapView setRegion:mapRegion animated: YES];
}


#pragma mark - Search Bar

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    
    NSString * noSpace = [[self.searchBar.text componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString: @"+"];
    
    [self queryGoogleMaps:noSpace];
    //first, we try google maps, and then we try google places.
}

#pragma mark - Google Queries

-(void)queryGoogleMaps: (NSString *) googleType {
    //this url is for google maps.
    triedGooglePlaces = NO;
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&location=%f,%f&radius=%@&sensor=true", googleType, self.mkMapView.userLocation.coordinate.latitude, self.mkMapView.userLocation.coordinate.longitude, [NSString stringWithFormat:@"%i", currentDistance]];
            
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
}

-(void) queryGooglePlaces{
    NSString * googleType = [[self.searchBar.text componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString: @"+"];
    
    
    // Build the url string to send to Google. NOTE: The kGOOGLE_API_KEY is a constant that should contain your own API key that you obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    
    
    //this is for google places
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?location=%f,%f&radius=%@&query=%@&sensor=true&key=%@", self.mkMapView.userLocation.coordinate.latitude, self.mkMapView.userLocation.coordinate.longitude, [NSString stringWithFormat:@"%i", currentDistance], googleType, kGOOGLE_API_KEY];
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData 
                          
                          options:kNilOptions 
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"]; 
    NSString *status = [json objectForKey:@"status"];
    
    if (triedGooglePlaces == NO){
        if ([places count]>3 || [status compare:@"OK"]!=NSOrderedSame){
            triedGooglePlaces = YES;
            [self queryGooglePlaces];
        }
    }
    
    //Write out the data to the console.
//    NSLog(@"Google Data: %@", places);
    [self plotPositions:places];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //calls this every time the map moves, and updates the region that we'll be searching in.
    [self.searchBar resignFirstResponder];
    
    //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mkMapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set your current distance instance variable.
    currentDistance = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set your current center point on the map instance variable.
    currentCentre = self.mkMapView.centerCoordinate;
}

-(void)plotPositions:(NSArray *)data {
    // 1 - Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in mkMapView.annotations) {
        if ([annotation isKindOfClass:[SearchResult class]]) {
            [mkMapView removeAnnotation:annotation];
        }
    }
    // 2 - Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++) {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        // 3 - There is a specific NSDictionary object that gives us the location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        // Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        // 4 - Get your name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        // Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        // Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        // 5 - Create a new annotation.
        SearchResult *placeObject = [[SearchResult alloc] initWithName:name address:vicinity coordinate:placeCoord];
        [mkMapView addAnnotation:placeObject];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // Define your reuse identifier.
    static NSString *identifier = @"MapPoint";   
    
    if ([annotation isKindOfClass:[SearchResult class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mkMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;    
}


#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
    CGRect viewRect = {0, 0, 320, 416};    
    self.view.frame =  viewRect;

}

- (IBAction)infoButtonPressed:(id)sender {
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    //set the buttons so that they're the appropriate values.
    controller.bikeRouteButton.on = bikeRoute;
    controller.autoLocateButton.on = autoLocate;
}

- (void) turnOnAutolocate:(BOOL)autolocateSent{
    NSLog(@"turnOnAutoLocate in MapViewController!");
    if(autolocateSent){
        self.autoLocate = YES;
    } else {
        self.autoLocate = NO;
    }
}

- (void) turnOnBikeRoute:(BOOL)bikeRouteSent{

    if(bikeRouteSent){
        self.bikeRoute = YES;
        [self overlayAllRides];
    } else {
        self.bikeRoute = NO;
        NSLog(@"no bike routes");
        [self.mkMapView removeOverlays:crumbOverlays];
        crumbOverlays = nil;
    }
}

#pragma mark - autoLocate

- (void) autoCenterLocation{
    if (autoLocate){
        MKCoordinateRegion newMapRegion; 
        newMapRegion.center = mkMapView.userLocation.coordinate;
        newMapRegion.span =  mkMapView.region.span;
        
        [mkMapView setRegion:newMapRegion animated: YES];
    }
    
}

# pragma mark - overlayAllRides (MuaHaHa!)

- (void) overlayAllRides{
    crumbOverlays = [[NSMutableArray alloc] init];
    
for (Ride * r in self.rideDirectory.rideList) {
    for(DataPoint * dp in r.dataPointList){
        if(!crumbs) {
            self.crumbs = [[CrumbPath alloc] initWithCenterCoordinate:dp.location.coordinate];
            [crumbOverlays addObject:crumbs];
//          [self.mkMapView addOverlay:crumbs];
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
    [self.mkMapView addOverlays:crumbOverlays];
}



#pragma mark - Tracking
- (void) turnOnTracking{
    self.tracking = YES;
    startTrackingDate = [[NSDate alloc] init];
}

- (void) turnOffTrackingAndRemoveCrumbs:(double)seconds {
    tracking = NO;
    
    [mkMapView removeOverlay:crumbs];
    
    [ride removeDataAfterRideEnded:seconds];
    
    self.crumbs = nil;
    self.crumbView = nil;
}



@end
