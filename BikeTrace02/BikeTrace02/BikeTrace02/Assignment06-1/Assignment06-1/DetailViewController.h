//
//  DetailViewController.h
//  Assignment05-4
//
//  Created by Al Carter on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@class Person;

@interface DetailViewController : UIViewController {
    Person *person;
    IBOutlet UILabel * lFname;
}

@property Person * person;
@property (strong, nonatomic) IBOutlet UILabel *fName;
@property (strong, nonatomic) IBOutlet UILabel *lName;
@property (strong, nonatomic) IBOutlet UILabel *phone;
@property (strong, nonatomic) IBOutlet UILabel *add1;
@property (strong, nonatomic) IBOutlet UILabel *add2;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UILabel *state;
@property (strong, nonatomic) IBOutlet UILabel *zip;




@end
