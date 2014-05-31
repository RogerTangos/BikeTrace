//
//  DetailViewController.m
//  Assignment05-4
//
//  Created by Al Carter on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "PersonDirectory.h"
#import "Person.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize person;
@synthesize fName;
@synthesize lName;
@synthesize phone;
@synthesize add1;
@synthesize add2;
@synthesize city;
@synthesize state;
@synthesize zip;


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
    
    lFname.text = self.person.fName; 
    fName.text = self.person.fName;
    lName.text = self.person.lName;
    phone.text = self.person.phone;
    add1.text = self.person.address.address1;
    add2.text = self.person.address.address2;
    city.text = self.person.address.city;
    state.text = self.person.address.state;
    zip.text = self.person.address.zip;

}

- (void)viewDidUnload
{
    [self setLName:nil];
    [self setPhone:nil];
    [self setAdd1:nil];
    [self setAdd2:nil];
    [self setCity:nil];
    [self setState:nil];
    [self setZip:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
