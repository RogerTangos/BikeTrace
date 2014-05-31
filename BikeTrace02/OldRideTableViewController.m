//
//  OldRideTableViewController.m
//  BikeTrace02
//
//  Created by Al Carter on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OldRideTableViewController.h"
#import "Ride.h"


@interface OldRideTableViewController ()

@end

@implementation OldRideTableViewController
@synthesize rideDirectory;
@synthesize filteredRideDirectory;
@synthesize savedSearchTerm;
@synthesize savedScopeButtonIndex;
@synthesize searchWasActive;
@synthesize longPressRide;
@synthesize navigationController;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //stylize top bar
    self.title = @"Previous Rides";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
    
    
    //if there's a search term already there
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        self.savedSearchTerm = nil;
    }
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;


    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated{
    CGRect resizeFrame = {0,0, 320,416};
    self.view.frame= resizeFrame;
    
    //clear out the rideList and refresh from the database.
    //this is actually a relatively light method, because we aren't loading the ride.dataPoint information until you click.
    self.rideDirectory.rideList = [[NSMutableArray alloc] init];
    [self.rideDirectory  getInitialDataToDisplay:[rideDirectory getDBPath]];
    
    
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //no sections, thank goodness...
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [filteredRideDirectory.rideList count];
    } else {
        return [rideDirectory.rideList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [cell addGestureRecognizer:longPressRecognizer];     
        
	} 
    
    Ride *tempRide = [[Ride alloc] init];
    
     if (tableView == self.searchDisplayController.searchResultsTableView){
         tempRide = [self.filteredRideDirectory.rideList objectAtIndex:indexPath.row];
     } else {
         tempRide = [self.rideDirectory.rideList objectAtIndex:indexPath.row];
     }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", tempRide.title];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return NO;
    } else {
        return YES;
    }
}





#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{	
	[self.filteredRideDirectory.rideList removeAllObjects];
    self.filteredRideDirectory = [[RideDirectory alloc] initialize];
    
    self.filteredRideDirectory.rideList = [self.rideDirectory searchWithRange:searchText];
}

#pragma mark - Content Editing
-(void)handleLongPress:(UILongPressGestureRecognizer*)longPressRecognizer {
    
    
    //Show the alert
    //get the correct cell
    //edit the name
    //update the database
    
    CGPoint p = [longPressRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    
    
    
    if (indexPath == nil){
//        NSLog(@"long press on table view but not on a row");
    } else {
        if ([self.filteredRideDirectory.rideList count]!=0) //the user was searching        
        {
            self.longPressRide = [self.filteredRideDirectory.rideList objectAtIndex:indexPath.row];  
            
        } else {
            self.longPressRide = [rideDirectory.rideList objectAtIndex:indexPath.row];  
        }

    }

        if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter a new name:"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"OK", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
        }
}

#pragma mark UIAlertView Delegate Methods


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
//    NSLog(@"clickedButtonAtIndex");
    NSString *newTitle = [alertView textFieldAtIndex:0].text;

    
    NSString *buttonText = [alertView buttonTitleAtIndex:buttonIndex];
    
     if([buttonText isEqualToString:@"OK"])
    {
//        NSLog(@"OK was selected.");
        self.longPressRide.title = newTitle;
    }
    
    
    //update the database
    [rideDirectory updateRideTitleInSQL:[rideDirectory getDBPath] andRide:longPressRide];
    
    
    [self viewDidLoad];
    
    
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Ride * ride = [[Ride alloc] init];
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        
        ride = [filteredRideDirectory.rideList objectAtIndex:indexPath.row];
        [ride getInitialDataToDisplay:[ride getDBPath]];
                
    } else {
        ride = [rideDirectory.rideList objectAtIndex:indexPath.row];
        [ride getInitialDataToDisplay:[ride getDBPath]];
    }
    
     DetailViewController * detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailVC.ride = ride;
    
    [self presentModalViewController:detailVC animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Ride * tempRide = [[Ride alloc] init];
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        tempRide = [filteredRideDirectory.rideList objectAtIndex:indexPath.row];
    } else {
        tempRide = [rideDirectory.rideList objectAtIndex:indexPath.row];
    }
    //here, we don't bother rereshing the list afterward, because we removed it from the rideList concurrently.
    [rideDirectory deleteFromSQL:[rideDirectory getDBPath] andRide:tempRide];
    [rideDirectory.rideList removeObject:tempRide];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}  


@end
