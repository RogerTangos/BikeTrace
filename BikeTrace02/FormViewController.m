//
//  FormViewController.m
//  BikeTrace02
//
//  Created by Albert Carter on 6/2/14.
//
//

#import "FormViewController.h"

@interface FormViewController ()

@end

@implementation FormViewController
@synthesize delegate = _delegate;

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
    
    self.latitudeLabel.delegate = self;
    self.longitudeLabel.delegate = self;
    self.degreeLabel.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.latitudeLabel resignFirstResponder];
    [self.longitudeLabel resignFirstResponder];
    [self.degreeLabel resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
    [self.delegate formViewControllerDidFinish:self];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)submit:(id)sender {
    NSLog(@"submit called");
    
    [self dismissKeyboard];
    
    
    NSString * latitude = [self.latitudeLabel text];
    NSString *longitude = [self.longitudeLabel text];
    NSString *range = [self.degreeLabel text];
    
     NSString *queryString = @"http://ec2-107-22-150-242.compute-1.amazonaws.com/retrieveNearby.php";
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                              requestWithURL:[NSURL URLWithString:
                                              queryString]
                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                              timeoutInterval:60.0];
    [theRequest setHTTPMethod:@"POST"];
    
    NSString *post = [NSString stringWithFormat:@"latitude=%@&longitude=%@&range=%@", latitude, longitude, range];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    [theRequest setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            [self.resultView setText:@"No response from server"];
        } else {
            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
            NSLog(@"Response: %@", responseText);
            
            NSString *newLineStr = @"\n";
            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
            [self.resultView setText:responseText];
        }
    }];
}
@end
