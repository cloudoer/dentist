//
//  MessageListTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/24/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "MessageListTableViewController.h"
#import "AppDelegate.h"
#import "MsgDetailViewController.h"

@interface MessageListTableViewController ()

@end

@implementation MessageListTableViewController
{
    NSFetchedResultsController *fetchedResultsController;
    
    NSMutableArray *latestMsgArray;
    NSArray *finalBuddyArray;
    
    NSString *clickedBareJIDStr;
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
        request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"bareJidStr" ascending:NO], [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO]];
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

- (void)getLatestMsgArray
{
    
    latestMsgArray = [[NSMutableArray alloc] initWithCapacity:20];
    for (XMPPMessageArchiving_Message_CoreDataObject *msg in [self fetchedResultsController].fetchedObjects) {
        if (latestMsgArray.count == 0) {
            [latestMsgArray addObject:msg];
        }else {
            XMPPMessageArchiving_Message_CoreDataObject *lastMsg = latestMsgArray[latestMsgArray.count - 1];
            if (![lastMsg.bareJidStr isEqualToString:msg.bareJidStr]) {
                [latestMsgArray addObject:msg];
            }
        }
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    finalBuddyArray = [latestMsgArray sortedArrayUsingDescriptors:@[sort]];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    [self getLatestMsgArray];
    
    if (finalBuddyArray == nil) {
        return 0;
    }
    return finalBuddyArray.count;
//    id  sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
//    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    XMPPMessageArchiving_Message_CoreDataObject *message = finalBuddyArray[indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = message.body;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *message = finalBuddyArray[indexPath.row];
    clickedBareJIDStr = message.bareJidStr;
    
    [self performSegueWithIdentifier:@"MsgList2Detail" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MsgList2Detail"]) {
        MsgDetailViewController *controller = segue.destinationViewController;
        controller.bareJIDStr = clickedBareJIDStr;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
