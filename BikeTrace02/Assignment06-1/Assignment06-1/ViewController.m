//
//  ViewController.m
//  Assignment06-1
//
//  Created by Al Carter on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "ViewController.h"
#import "CityDirectory.h"



#import "PersonDirectory.h"
#import "Person.h"
#import "DetailViewController.h"
#import "AddPersonViewController.h"


@implementation ViewController
@synthesize cityDirectory;
@synthesize filteredPD;

///old synthasized things
@synthesize savedSearchTerm, savedScopeButtonIndex, searchWasActive;
//@synthesize cityList;


#pragma mark - 
#pragma mark Lifecycle methods


- (void)viewDidLoad
{
	self.title = @"People";
	self.filteredPD = [cityDirectory returnAllPeoplePD];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
    //add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector (addPerson)];
    self.navigationItem.rightBarButtonItem = addButton;
    
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
//        self.searchDisplayController.searchResultsTableView.numberOfSections;
//        need to find a way to set this to 1, but there's no setter method.
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    //forces a reload of the data when you press back
    
        
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}


#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section

{      
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }else {
        return [cityDirectory findCityFromSection:section];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return the number of cities that exist
    //also checks for diatrics and ignores case
    //while we're doing this, we build an array of all of the cities that will exist.
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return 1;
    }
	else
	{
        return [self.cityDirectory.cityList count];
    }
        
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	 If the requesting table view is the search display controller's table view, return the count of the filtered list, otherwise return the count of the main list.
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredPD.personList count];
    }
	else
	{
        PersonDirectory * cpd = [cityDirectory.cityList objectAtIndex:section];
        return [cpd.personList count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}    

    Person * tempPerson = [[Person alloc] init];
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        tempPerson = [self.filteredPD.personList objectAtIndex:indexPath.row];
    } else {
        tempPerson = [self.cityDirectory findPersonFromSectionAndRow:indexPath.section andRow:indexPath.row];
    }
    
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", tempPerson.lName, tempPerson.fName];
        cell.detailTextLabel.text = tempPerson.phone;
        cell.imageView.image = tempPerson.picture;
   
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
	Person * p  = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView){        
        p = [self.filteredPD.personList objectAtIndex:indexPath.row];
    }
	else {
        p = [self.cityDirectory findPersonFromSectionAndRow:indexPath.section andRow:indexPath.row];
    }
    
	detailViewController.title = [NSString stringWithFormat:@"%@, %@", p.lName, p.fName];
    detailViewController.person = p;
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void) addPerson {
    AddPersonViewController *addPersonViewController = [[AddPersonViewController alloc] initWithNibName:@"AddPersonViewController" bundle:nil];
    
    addPersonViewController.cityDirectory = self.cityDirectory;
    
    [self.navigationController pushViewController:addPersonViewController animated:YES];
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{	
	[self.filteredPD.personList removeAllObjects];
    self.filteredPD = [cityDirectory returnAllPeoplePD];
    
    self.filteredPD.personList = [self.filteredPD searchWithRange:searchText];
    
}
#pragma mark -
#pragma mark Editing Cell Methods
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return NO;
    }
	else
	{
        return YES;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Person *tempPerson = [cityDirectory findPersonFromSectionAndRow:indexPath.section andRow:indexPath.row];
        [cityDirectory deletePerson:tempPerson];
        [cityDirectory deleteFromSQL:[cityDirectory getDBPath] andPerson:tempPerson];
        
        
//        This method was more efficient, but for some reason I couldn't get it to work.
//        PersonDirectory * cpd = [cityDirectory.cityList objectAtIndex:indexPath.section];
//        Person *tempPerson = [cpd.personList objectAtIndex:indexPath.row];
//        [cityDirectory deletePerson:tempPerson];
//        
//        if ([cpd.personList count]==0){
//            [cityDirectory.cityList delete:cpd];
//        }
        
        [NSKeyedArchiver archiveRootObject:cityDirectory.cityList toFile:@"cityList"];
        
        [self viewWillAppear:TRUE];
    }
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


@end
