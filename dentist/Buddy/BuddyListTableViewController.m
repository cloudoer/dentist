//
//  BuddyListTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/24/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "BuddyListTableViewController.h"
#import "AppDelegate.h"
#import "BuddyContentCell.h"
#import "BuddyHeaderCell.h"
#import "Buddy.h"
#import "pinyin.h"
#import "ProfileTableViewController.h"

@interface BuddyListTableViewController ()

@property (nonatomic, strong) NSMutableArray *filteredCellObjArray;

@end

@implementation BuddyListTableViewController
{
    NSFetchedResultsController *fetchedResultsController;
    
    
    NSMutableDictionary *buddyDict;
    NSArray *letterArray;
    
    Buddy *theBuddy;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getBuddyList];
    
}

- (void)getBuddyList
{
    Userinfo *userinfo = [LoginFacade sharedUserinfo];
    NSString *getPath = [NSString stringWithFormat:@"%@&uid=%d", URL_PATH_ALL_BUDDY, userinfo.uid.intValue];
    
    [Network httpGetPath:getPath success:^(NSDictionary *response) {
        for (NSDictionary *oneBuddyDict in response[@"data"]) {
            [[BuddyManager sharedBuddyManager] addBuddyWithDictionary:oneBuddyDict];
        }
    } failure:^(NSError *error) {
        
    }];
}


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
    
    DEFAULT_NAVIGATION_BAR_TINT_COLOR
    DEFAULT_NAVIGATION_TINT_COLOR
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        //        DDLogError(@"Error performing fetch: %@", error);
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
        
        NSManagedObjectContext *moc = [BuddyManager sharedBuddyManager].managedObjectContext;
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Buddy"
                                                             inManagedObjectContext:moc];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:@"addDate" ascending:NO];
        [request setSortDescriptors:[NSArray arrayWithObject:sort]];
        request.entity = entityDescription;
        request.fetchBatchSize = 20;
        
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                       managedObjectContext:moc
		                                                                 sectionNameKeyPath:nil
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
		
		
		
	}
	
	return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[[self tableView] reloadData];
}

- (void)getBuddyDict
{
    buddyDict = [[NSMutableDictionary alloc] initWithCapacity:30];
    for (Buddy *buddy in [self fetchedResultsController].fetchedObjects) {
        char ch=pinyinFirstLetter([buddy.realname characterAtIndex:0]);
        NSString* letter=[[NSString stringWithFormat:@"%c",ch] uppercaseString];
        
        NSMutableArray *buddyArray = [NSMutableArray arrayWithArray:buddyDict[letter]];
        if (buddyArray == nil) {
            buddyArray = [[NSMutableArray alloc] initWithCapacity:20];
        }
        [buddyArray addObject:buddy];
        buddyDict[letter] = buddyArray;
    }
    
    NSArray *keyArray = buddyDict.allKeys;
    
    letterArray = [keyArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    
    [self getBuddyDict];
    return 1 + letterArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredCellObjArray.count;
    }
    
    if (section == 0) {
        return 2;
    }else {
        NSString *key = letterArray[section - 1];
        NSArray *buddyArray = buddyDict[key];
        return buddyArray.count;
    }
}

- (void)configureCell:(UITableViewCell *)theCell atIndexPath:(NSIndexPath *)indexPath {
    NSString *key = letterArray[indexPath.section - 1];
    NSArray *buddyArray = buddyDict[key];
    
    Buddy *buddy = buddyArray[indexPath.row];
    BuddyContentCell *cell = (BuddyContentCell *)theCell;
    
    cell.nameLabel.text = buddy.realname;
    
    NSData* data = [[NSData alloc] initWithBase64EncodedString:buddy.photoStr options:0];
    UIImage* image = [UIImage imageWithData:data];
    cell.avatarImageView.image = image;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
        }
        Buddy *buddy = self.filteredCellObjArray[indexPath.row];
        cell.textLabel.text = buddy.realname;
        return cell;
        
    }
    
    
    if (indexPath.section == 0) {
        BuddyContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuddyContentCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"新好友";
        }else if (indexPath.row == 1) {
            cell.nameLabel.text = @"服务号";
        }
        
        return cell;
    }else {
        BuddyContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuddyContentCell" forIndexPath:indexPath];
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    if (section > 0) {
        
        NSString *key = letterArray[section - 1];
        BuddyHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuddyHeaderCell"];
        cell.headNameLabel.text = key;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    }
    if (section > 0) {
        return 30;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        theBuddy = self.filteredCellObjArray[indexPath.row];
        [self performSegueWithIdentifier:@"BuddyList2Profile" sender:self];
        return;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"BuddyList2New" sender:self];
        }else if(indexPath.row == 1) {
            [self performSegueWithIdentifier:@"BuddyList2Service" sender:self];
        }
    }else {
        NSString *key = letterArray[indexPath.section - 1];
        NSArray *buddyArray = buddyDict[key];
        theBuddy = buddyArray[indexPath.row];
        
        [self performSegueWithIdentifier:@"BuddyList2Profile" sender:self];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    return letterArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    
    
    int section = [letterArray indexOfObject:title];
//    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return section;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BuddyList2Profile"]) {
        ProfileTableViewController *controller = segue.destinationViewController;
        controller.buddy = theBuddy;
    }
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Remove all objects from the filtered search array
    [self.filteredCellObjArray removeAllObjects];
    // Filter the array using NSPredicate
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.item_name contains[c] %@",searchText];
    NSPredicate *ind_predicate = [NSPredicate predicateWithFormat:@"SELF.realname contains[c] %@",searchText];
    
    NSArray *buddyArray = [self fetchedResultsController].fetchedObjects;
    //    NSArray *filtedItemArray = [self.itemsArray filteredArrayUsingPredicate:predicate];
    
    self.filteredCellObjArray = [[NSMutableArray alloc] initWithArray:[buddyArray filteredArrayUsingPredicate:ind_predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
