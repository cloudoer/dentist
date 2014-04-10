//
//  RoomChatTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/10/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "RoomChatTableViewController.h"
#import "AppDelegate.h"
#import "ChatSendCell.h"
#import "RoomChatMeCell.h"
#import "RoomChatOtherCell.h"
#import "DDLog.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface RoomChatTableViewController ()

@end



@implementation RoomChatTableViewController
{
    NSFetchedResultsController *fetchedResultsController;
    
    UITextField *sendTextField;
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
    
    self.title = self.oneRoom.naturalName;
    
    
    [[self appDelegate] joinTheRoom:self.oneRoom.name];
    
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        DDLogError(@"Error performing fetch: %@", error);
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
        
        XMPPRoomCoreDataStorage *storage = [XMPPRoomCoreDataStorage sharedInstance];
        NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPRoomMessageCoreDataStorageObject"
                                                             inManagedObjectContext:moc];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        request.entity = entityDescription;
        request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"localTimestamp" ascending:YES]];
        request.fetchBatchSize = 20;
        request.predicate = [NSPredicate predicateWithFormat:@"roomJIDStr contains %@", self.oneRoom.name];
        
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

-(void)printRoomMSG:(NSMutableArray*)messages{
    @autoreleasepool {
        for (XMPPRoomMessageCoreDataStorageObject *message in messages) {
            NSLog(@"messageStr param is %@",message.messageStr);
            NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:message.messageStr error:nil];
            NSLog(@"to param is %@",[element attributeStringValueForName:@"to"]);
            NSLog(@"NSCore object id param is %@",message.objectID);
            NSLog(@"body param is %@",message.body);
            NSLog(@"timestamp param is %@",message.localTimestamp);
            NSLog(@"outgoing param is %d",message.isFromMe);
        }
    }
}
- (void)testRoomMessage
{
    XMPPRoomCoreDataStorage *storage = [XMPPRoomCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPRoomMessageCoreDataStorageObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *messages = [moc executeFetchRequest:request error:&error];
    
    [self printRoomMSG:[[NSMutableArray alloc]initWithArray:messages]];
}



- (void)discoverRoom:(NSString *)roomName
{
    XMPPStream *stream = [self appDelegate].xmppStream;
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"from" stringValue:stream.myJID.bare];
    
    NSString *room = [roomName stringByAppendingString:[NSString stringWithFormat:@"@conference.%@", stream.myJID.domain]];
    [iq addAttributeWithName:@"to" stringValue:room];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/disco#info"];
    [iq addChild:query];
    
    [stream sendElement:iq];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPRoomMessageCoreDataStorageObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"ChatOtherCell";
    if (!message.isFromMe) {
        CellIdentifier = @"RoomChatOtherCell";
        RoomChatOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.contentLabel.text = message.body;
        return cell;
    }else {
        CellIdentifier = @"RoomChatMeCell";
        RoomChatMeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
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

/*
 NSString *textToSend = sendTextField.text;
 if (textToSend && textToSend.length > 0) {
 
 XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.jid];
 [message addBody:textToSend];
 
 NSXMLElement *bodyElement = [NSXMLElement elementWithName:@"kind" stringValue:@"text"];
 [message addChild:bodyElement];
 
 
 [[[self appDelegate] xmppStream] sendElement:message];
 }
 sendTextField.text = @"";
*/
- (IBAction)sendButtonPressed:(UIButton *)sender {
 
    NSString *roomStr = [self.oneRoom.name stringByAppendingString:[NSString stringWithFormat:@"@conference.%@", [self appDelegate].xmppStream.myJID.domain]];
    XMPPJID *roomJID = [XMPPJID jidWithString:roomStr];
    
    NSString *textToSend = sendTextField.text;
    if (textToSend && textToSend.length > 0) {
        
        XMPPMessage *message = [XMPPMessage messageWithType:@"groupchat" to:roomJID];
        [message addBody:textToSend];
        
        NSXMLElement *bodyElement = [NSXMLElement elementWithName:@"kind" stringValue:@"text"];
        [message addChild:bodyElement];
        
        [[[self appDelegate] xmppStream] sendElement:message];
    }
    sendTextField.text = @"";
}

@end
