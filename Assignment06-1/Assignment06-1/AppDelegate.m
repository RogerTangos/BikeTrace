//
//  AppDelegate.m
//  Assignment06-1
//
//  Created by Al Carter on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PersonDirectory.h"
#import "CityDirectory.h"


@implementation AppDelegate
@synthesize navController;
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSArray *existing = [NSKeyedUnarchiver unarchiveObjectWithFile:@"cityList"];
    
    CityDirectory *cityDirectory = [[CityDirectory alloc] initializeArray:existing];
      

    
    //Database Stuff
    [cityDirectory copyDatabaseIfNeeded];
    [cityDirectory getInitialDataToDisplay:[cityDirectory getDBPath]];
//    [cityDirectory insertIntoSQL:[cityDirectory getDBPath] andPerson:testPerson];
    
	// Create and configure the main view controller.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; 

    ViewController * viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    viewController.cityDirectory = cityDirectory;
    	
	// Add create and configure the navigation controller.
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
	self.navController = navigationController;
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
	
	// Configure and display the window.
    [window makeKeyAndVisible];
    return YES;
    
    
    
    //  These people are now taken directly from the database.
    //    //Providence
    //    [cityDirectory newPerson:@"Annie" andLastName:@"Hathaway" andPhoneNumber:@"251-324-4321" andAdd1:@"abcdefg" andAdd2:@"non" andCity:@"Providence" andState:@"RI" andZip:@"02912"];
    //    [cityDirectory newPerson:@"Mark" andLastName:@"Suchman" andPhoneNumber:@"987 654-3210" andAdd1:@"10 Evergreen St" andAdd2:@"no 3" andCity:@"Providence" andState:@"RI" andZip:@"02130"];
    //    [cityDirectory newPerson:@"Adam" andLastName:@"Stewart" andPhoneNumber:@"212-480-3864" andAdd1:@"28 Washington Place" andAdd2:@"" andCity:@"Providence" andState:@"MA" andZip:@"32905"];
    //    [cityDirectory newPerson:@"Edward" andLastName:@"Kendall" andPhoneNumber:@"212-480-3864" andAdd1:@"28 Washington Place" andAdd2:@"" andCity:@"Providence" andState:@"MA" andZip:@"32905"];
    //    
    //    //Boston
    //    [cityDirectory newPerson:@"Amy" andLastName:@"Winehouse" andPhoneNumber:@"293-432-3456" andAdd1:@"1 Center pl" andAdd2:@"" andCity:@"Boston" andState:@"MA" andZip:@"38923"];
    //    [cityDirectory newPerson:@"Martha" andLastName:@"Stewart" andPhoneNumber:@"212-480-3864" andAdd1:@"28 Washington Place" andAdd2:@"" andCity:@"Boston" andState:@"MA" andZip:@"32905"];
    //    
    //    //Cambridge
    //    [cityDirectory newPerson:@"Annie" andLastName:@"Hucheson" andPhoneNumber:@"123-456-7890" andAdd1:@"77 Massachusetts Ave" andAdd2:@"38-409C" andCity:@"Cambridge" andState:@"MA" andZip:@"02139"];
    //    Person *testPerson = [cityDirectory newPerson:@"Yours" andLastName:@"Mother" andPhoneNumber:@"3920394930" andAdd1:@"1 home place" andAdd2:@"Master Suite" andCity:@"Cambridge" andState:@"MA" andZip:@"12439"]; 
    
    //    testing
    //    for(PersonDirectory * pd in cityDirectory.cityList) {
    //        Person * tempPerson = [pd.personList objectAtIndex:0];
    //        NSLog(tempPerson.address.city);
    //        
    //        for (Person *p in pd.personList) {
    //            NSLog(p.lName);
    //        }
    //    } 
    //    [cityDirectory deletePerson:cambridgePerson];
    //    [cityDirectory deletePerson:mvPerson];
	
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
