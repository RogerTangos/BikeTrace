//
//  NRToolbarViewController.h
//  BikeTrace02
//
//  Created by Al Carter on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRToolbarViewController : UIViewController {
    UIToolbar * nrToolbar;
    UISegmentedControl * switchButton;
}


@property (strong, nonatomic) IBOutlet UIToolbar *nrToolbar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *switchButton;

- (IBAction)swithButtonPressed:(id)sender;

@end
