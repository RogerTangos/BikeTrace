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
@property (weak, nonatomic) IBOutlet UITextField *latitudeLabel;
@property (weak, nonatomic) IBOutlet UITextField *longitudeLabel;
@property (weak, nonatomic) IBOutlet UITextField *degreeLabel;
@property (weak, nonatomic) IBOutlet UITextView *resultView;

- (IBAction)done:(id)sender;
- (IBAction)submit:(id)sender;

@end
