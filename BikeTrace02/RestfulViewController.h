//
//  RestfulViewController.h
//  BikeTrace02
//
//  Created by Albert Carter on 5/31/14.
//
//

#import <UIKit/UIKit.h>

@interface RestfulViewController : UIViewController <NSURLConnectionDelegate> {
    NSMutableData* _receivedData;
    NSString* _sentData;
}

@property (weak, nonatomic) IBOutlet UITextView *sqlQuery;
- (IBAction)postQuery:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblData;

@end
