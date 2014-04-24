//
//  MessageListTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/24/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "MessageListTableViewController.h"
#import "AppDelegate.h"

@interface MessageListTableViewController ()

@end

@implementation MessageListTableViewController
{
    NSFetchedResultsController *fetchedResultsController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![LoginFacade isLogged]) {
        [LoginFacade presentLoginViewControllerFrom:self];
    }else {
        [[self appDelegate] connect];
        //        NSError *error = nil;
        //        if (![self.fetchedResultsController performFetch:&error])
        //        {
        //            //        DDLogError(@"Error performing fetch: %@", error);
        //        }
        
    }
    
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
        
        XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                             inManagedObjectContext:moc];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        request.entity = entityDescription;
        request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES]];
        request.fetchBatchSize = 20;
//        request.predicate = [NSPredicate predicateWithFormat:@"bareJidStr contains %@", self.userStr];
//        [request setReturnsDistinctResults:YES];
//        request.propertiesToFetch;
        
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




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
//        DDLogError(@"Error performing fetch: %@", error);
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = message.body;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
