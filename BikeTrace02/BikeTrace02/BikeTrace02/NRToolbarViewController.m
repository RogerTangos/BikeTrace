//
//  NRToolbarViewController.m
//  BikeTrace02
//
//  Created by Al Carter on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NRToolbarViewController.h"

@interface NRToolbarViewController ()

@end

@implementation NRToolbarViewController
@synthesize nrToolbar;
@synthesize switchButton;

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
    nrToolbar = [[UIToolbar alloc] init];
    [self.view addSubview:nrToolbar];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNrToolbar:nil];
    [self setSwitchButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)swithButtonPressed:(id)sender {
    
    if (switchButton.selectedSegmentIndex == 0) { 
        NSLog(@"Stop-Save Pressed.");
        //for now, this should take us back to the map.
    }
    else {
        NSLog(@"Play-Pause Pressed.");
    }
}
@end
