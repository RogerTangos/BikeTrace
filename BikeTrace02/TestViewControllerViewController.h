//
//  TestViewControllerViewController.h
//  BikeTrace02
//
//  Created by Al Carter on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewControllerViewController : UIViewController{
    UITextView * testView;
    UIView * mainView;
}

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UITextView *testView;

@end
