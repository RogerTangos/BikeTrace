//
//  FlipsideViewController.m
//  BikeTrace02
//
//  Created by Al Carter on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

@synthesize delegate = _delegate;
@synthesize autoLocateButton = _autoLocateButton;
@synthesize bikeRouteButton = _bikeRouteButton;
@synthesize backgroundButton = _backgroundButton;
@synthesize networkButton = _networkButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setAutoLocateButton:self.autoLocateButton];
    [self setBikeRouteButton:self.bikeRouteButton];
    [self setBackgroundButton:nil];
    [self setNetworkButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)autoLocate:(id)sender {
    if(self.autoLocateButton.on){
        [self.delegate turnOnAutolocate:YES];
    } else {
        [self.delegate turnOnAutolocate:NO];
    }
}

- (IBAction)bikeRoute:(id)sender {
    if(self.bikeRouteButton.on){
        [self.delegate turnOnBikeRoute:YES];
    } else {
        [self.delegate turnOnBikeRoute:NO];
    }
}

- (IBAction)backroundEnabling:(id)sender {
    if(self.backgroundButton.on){
        [self.delegate turnOnBackgroundUpdates:YES];
    } else {
        [self.delegate turnOnBackgroundUpdates:NO];
    }
}

- (IBAction)networkDisplay:(id)sender {
    if(self.networkButton.on){
        NSLog(@"turn button on");
        [self.delegate callMapVcNetworking:YES];
    } else {
        NSLog(@"turn button off");
        [self.delegate callMapVcNetworking:NO];
    }
}




@end
