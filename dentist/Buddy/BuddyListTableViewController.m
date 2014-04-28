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
#import "Buddy.h"

@interface BuddyListTableViewController ()

@end

@implementation BuddyListTableViewController
{
    NSFetchedResultsController *fetchedResultsController;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getBuddyList];
    
}

- (void)getBuddyList
{
    NSString *getPath = [NSString stringWithFormat:@"%@&uid=%d", URL_PATH_ALL_BUDDY, 2];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Buddy *buddy = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    BuddyContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuddyContentCell" forIndexPath:indexPath];
    cell.nameLabel.text = buddy.realname;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
