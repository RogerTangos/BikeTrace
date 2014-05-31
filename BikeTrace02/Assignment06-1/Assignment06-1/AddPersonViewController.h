//
//  AddPersonViewController.h
//  Assignment05-4
//
//  Created by Al Carter on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonDirectory;
@class CityDirectory;

@interface AddPersonViewController : UIViewController {
    CityDirectory * cityDirectory;
    BOOL displayKeyboard;
	CGPoint  offset;
	UITextField *Field;
    IBOutlet UIScrollView *scrollview;
}

@property (strong, nonatomic) IBOutlet UITextField *tfFname;
@property (strong, nonatomic) IBOutlet UITextField *tfLname;
@property (strong, nonatomic) IBOutlet UITextField *tfPhone;
@property (strong, nonatomic) IBOutlet UITextField *tfAdd1;
@property (strong, nonatomic) IBOutlet UITextField *tfAdd2;
@property (strong, nonatomic) IBOutlet UITextField *tfCity;
@property (strong, nonatomic) IBOutlet UITextField *tfState;
@property (strong, nonatomic) IBOutlet UITextField *tfZip;
@property (retain, nonatomic) CityDirectory *cityDirectory;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollview;




- (IBAction)back:(id)sender;
- (IBAction)savePerson:(id)sender;

@end
