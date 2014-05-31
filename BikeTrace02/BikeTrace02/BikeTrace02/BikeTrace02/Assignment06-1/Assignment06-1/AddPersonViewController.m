//
//  AddPersonViewController.m
//  Assignment05-4
//
//  Created by Al Carter on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define SCROLLVIEW_CONTENT_HEIGHT 460
#define SCROLLVIEW_CONTENT_WIDTH  320

#import "AddPersonViewController.h"
#import "CityDirectory.h"
#import "AppDelegate.h"

@interface AddPersonViewController ()

@end

@implementation AddPersonViewController
@synthesize tfFname;
@synthesize tfLname;
@synthesize tfPhone;
@synthesize tfAdd1;
@synthesize tfAdd2;
@synthesize tfCity;
@synthesize tfState;
@synthesize tfZip;
@synthesize cityDirectory;
@synthesize scrollview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self
	 selector:@selector
	 (keyboardDidShow:) 
	 name: UIKeyboardDidShowNotification
	 object:nil];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self 
	 selector:@selector
	 (keyboardDidHide:) name:
	 UIKeyboardDidHideNotification
	 object:nil];
	
	scrollview.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH,SCROLLVIEW_CONTENT_HEIGHT);
	
	displayKeyboard = NO;
}


-(void) viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self];
}

-(void) keyboardDidShow: (NSNotification *)notif {
	if (displayKeyboard) {
		return;
	}
	
	
	NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
	offset = scrollview.contentOffset;
	
	CGRect viewFrame = scrollview.frame;
	NSLog(@" viewFrame= %f",viewFrame.size.height);
	viewFrame.size.height -= keyboardSize.height;
	scrollview.frame = viewFrame;
	
	CGRect textFieldRect = [Field frame];
	textFieldRect.origin.y += 10;
	[scrollview scrollRectToVisible: textFieldRect animated:YES];
	displayKeyboard = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
	if (!displayKeyboard) {
		return; 
	}
	
	scrollview.frame = CGRectMake(0, 0, SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
	
	scrollview.contentOffset =offset;
	
	displayKeyboard = NO;
	
}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
	Field = textField;
	return YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector (savePerson:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}



- (void)viewDidUnload
{
    [self setTfFname:nil];
    [self setTfLname:nil];
    [self setTfPhone:nil];
    [self setTfAdd1:nil];
    [self setTfAdd2:nil];
    [self setTfCity:nil];
    [self setTfState:nil];
    [self setTfZip:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)savePerson:(id)sender {
    
    Person *p = [self.cityDirectory newPerson:[tfFname text] andLastName:[tfLname text] andPhoneNumber:[tfLname text] andAdd1:[tfPhone text] andAdd2:[tfAdd1 text] andCity:[tfCity text] andState:[tfState text] andZip:[tfZip text]];
    
    [self.cityDirectory insertIntoSQL:[cityDirectory getDBPath] andPerson:p];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Person Added" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [NSKeyedArchiver archiveRootObject:cityDirectory.cityList toFile:@"cityList"];
    
    [alert show];

    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
