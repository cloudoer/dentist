//
//  MsgDetailViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/24/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "MsgDetailViewController.h"
#import "AppDelegate.h"

@interface MsgDetailViewController () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation MsgDetailViewController
{
    NSFetchedResultsController *fetchedResultsController;
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    self.dataSource = self;
    
    self.title = self.bareJIDStr;
    
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
        XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                             inManagedObjectContext:moc];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        request.entity = entityDescription;
        request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES]];
        request.fetchBatchSize = 20;
        request.predicate = [NSPredicate predicateWithFormat:@"bareJidStr contains %@", self.bareJIDStr];
        
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
    [JSMessageSoundEffect playMessageReceivedSound];
	[[self tableView] reloadData];
    [self scrollToBottomAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)textToSend
{
    if (textToSend && textToSend.length > 0) {
        
        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:self.bareJIDStr]];
        [message addBody:textToSend];
        
        NSXMLElement *bodyElement = [NSXMLElement elementWithName:@"kind" stringValue:@"text"];
        [message addChild:bodyElement];
        
        
        [[[self appDelegate] xmppStream] sendElement:message];
    }
    [JSMessageSoundEffect playMessageSentSound];
    
    [self finishSend];
}

- (void)cameraPressed:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    return message.isOutgoing ? JSBubbleMessageTypeOutgoing: JSBubbleMessageTypeIncoming;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return JSBubbleMediaTypeText;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    /*
     JSMessagesViewTimestampPolicyAll = 0,
     JSMessagesViewTimestampPolicyAlternating,
     JSMessagesViewTimestampPolicyEveryThree,
     JSMessagesViewTimestampPolicyEveryFive,
     JSMessagesViewTimestampPolicyCustom
     */
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
    return JSAvatarStyleCircle;
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat
     
     */
    return JSInputBarStyleFlat;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];

    return message.body;
}



- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    return message.timestamp;
}


- (UIImage *)avatarImageForAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
    
}



- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
    
}

#pragma UIImagePicker Delegate

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //	NSLog(@"Chose image!  Details:  %@", info);
    //
    //    self.willSendImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //    [self.messageArray addObject:[NSDictionary dictionaryWithObject:self.willSendImage forKey:@"Image"]];
    //    [self.timestamps addObject:[NSDate date]];
    //    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    
	
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
