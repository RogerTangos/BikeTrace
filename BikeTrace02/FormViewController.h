//
//  FormViewController.h
//  BikeTrace02
//
//  Created by Albert Carter on 6/2/14.
//
//

#import <UIKit/UIKit.h>
@protocol FormViewControllerDelegate
@end


@interface FormViewController : UIViewController
@property (weak, nonatomic) id <FormViewControllerDelegate> delegate;

@end
