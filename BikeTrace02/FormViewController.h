//
//  FormViewController.h
//  BikeTrace02
//
//  Created by Albert Carter on 6/2/14.
//
//

#import <UIKit/UIKit.h>
@class FormViewController;

@protocol FormViewControllerDelegate
- (void)formViewControllerDidFinish:(FormViewController *)controller;
@end


@interface FormViewController : UIViewController
@property (weak, nonatomic) id <FormViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
