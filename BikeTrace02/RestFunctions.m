//
//  RestFunctions.m
//  BikeTrace02
//
//  Created by Albert Carter on 5/31/14.
//
//

#import "RestFunctions.h"
#import "DataPoint.h"

@implementation RestFunctions 


-(void) postRideData {
    NSString *queryString = @"http://ec2-107-22-150-242.compute-1.amazonaws.com/insertRide.php";
    NSMutableURLRequest *theRequest = [NSMutableURLRequest
                                requestWithURL:[NSURL URLWithString:queryString]
                                cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0
                                ];
    [theRequest setHTTPMethod:@"POST"];
    
    // format and post data;
    NSString *post = [NSString stringWithFormat:@"query=%s", "appQueryString"];
    
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    [theRequest setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            // do something with error
        } else {
            NSString *responseText = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"Response: %@", responseText);
            
            NSString *newLineStr = @"\n";
            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
            
            NSLog(@"%@", responseText);
        }
    }];

    
    
    
}

-(void) postArbitrarySql{
   
}

-(void) postDataRequest{
    
}


@end
