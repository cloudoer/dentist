//
//  ChatTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/8/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "ChatTableViewController.h"
#import "AppDelegate.h"
#import "DDLog.h"
#import "ChatMeCell.h"
#import "ChatOtherCell.h"
#import "ChatSendCell.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface ChatTableViewController ()

@end

@implementation ChatTableViewController
{
    UITextField *sendTextField;
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        DDLogError(@"Error performing fetch: %@", error);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)print:(NSMutableArray*)messages{
    @autoreleasepool {
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messages) {
            NSLog(@"messageStr param is %@",message.messageStr);
            NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:message.messageStr error:nil];
            NSLog(@"to param is %@",[element attributeStringValueForName:@"to"]);
            NSLog(@"NSCore object id param is %@",message.objectID);
            NSLog(@"bareJid param is %@",message.bareJid);
            NSLog(@"bareJidStr param is %@",message.bareJidStr);
            NSLog(@"body param is %@",message.body);
            NSLog(@"timestamp param is %@",message.timestamp);
            NSLog(@"outgoing param is %d",[message.outgoing intValue]);
        }
    }
}

-(void)testMessageArchiving{
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *messages = [moc executeFetchRequest:request error:&error];
    
    [self print:[[NSMutableArray alloc]initWithArray:messages]];
}
- (IBAction)sendButtonPressed:(UIButton *)sender {
    
    NSString *textToSend = sendTextField.text;
    if (textToSend && textToSend.length > 0) {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:textToSend];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:[self.jid full]];
        [message addChild:body];
        
        [[[self appDelegate] xmppStream] sendElement:message];
    }
    sendTextField.text = @"";
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
        request.predicate = [NSPredicate predicateWithFormat:@"bareJidStr contains %@", self.userStr];
        
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


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"ChatOtherCell";
    if (!message.isOutgoing) {
        CellIdentifier = @"ChatOtherCell";
        ChatOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.contentLabel.text = message.body;
        return cell;
    }else {
        CellIdentifier = @"ChatMeCell";
        ChatMeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.contentLabel.text = message.body;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ChatSendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatSendCell"];
    sendTextField = cell.sendTextField;
    return cell;
}





@end
