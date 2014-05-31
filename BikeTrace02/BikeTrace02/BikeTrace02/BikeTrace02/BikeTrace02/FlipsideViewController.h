//
//  FlipsideViewController.h
//  BikeTrace02
//
//  Created by Al Carter on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void) turnOnAutolocate:(BOOL)autolocateSent;
- (void) turnOnBikeRoute:(BOOL)bikeRouteSent;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISwitch *autoLocateButton;
@property (strong, nonatomic) IBOutlet UISwitch *bikeRouteButton;

- (IBAction)done:(id)sender;
- (IBAction)autoLocate:(id)sender;
- (IBAction)bikeRoute:(id)sender;

@end
