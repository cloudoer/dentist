//
//  MsgDetailViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/24/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "MsgDetailViewController.h"
#import "AppDelegate.h"
#import "GTMBase64.h"


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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString *user = [self.bareJIDStr componentsSeparatedByString:@"@"][0];
    [[BuddyManager sharedBuddyManager] removeBuddyNewMessageFrom:user];
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
    [self finishSend];
//	[[self tableView] reloadData];
//    [self scrollToBottomAnimated:YES];
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
    [self sendTheText:textToSend withKind:CHAT_TYPE_TEXT];
}

//- (void)cameraPressed:(id)sender{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:picker animated:YES completion:NULL];
//}

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
    
    XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    if ([Tools typeForMessage:message] != CHAT_TYPE_TEXT) {
        return JSBubbleMediaTypeImage;
    }
    
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
    
    if ([Tools typeForMessage:message] != CHAT_TYPE_TEXT) {
        return nil;
    }

    return [Tools bodyWithoutPrefixForMessage:message];
}



- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    return message.timestamp;
}




- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    if ([Tools typeForMessage:message] != CHAT_TYPE_TEXT) {
        NSString *realbody = [Tools bodyWithoutPrefixForMessage:message];
        NSData* data = [[NSData alloc] initWithBase64EncodedString:realbody options:0];
        return [UIImage imageWithData:data];
    }
    
    return nil;
}

#pragma mark - other btn click
- (void)otherPhotoBtnPressed:(UIButton *)sender {
    NSLog(@"otherPhotoBtnPressed");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate                 = self;
    picker.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing            = YES;
    [self presentViewController:picker animated:YES completion:NULL];
    
}
- (void)otherCameraBtnPressed:(UIButton *)sender {
    NSLog(@"otherCameraBtnPressed");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate                 = self;
    picker.sourceType               = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing            = YES;
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(chosenImage, compression);
    }
    
    
    NSString *imageDataBase64Str = [[NSString alloc] initWithData:[GTMBase64 encodeData:imageData] encoding:NSUTF8StringEncoding];
    
    [self sendTheText:imageDataBase64Str withKind:CHAT_TYPE_IMAGE];
	
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)sendTheText:(NSString *)textToSend withKind:(CHAT_TYPE)kind
{
    if (textToSend && textToSend.length > 0) {
        
        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:self.bareJIDStr]];
        
        NSString *finalText = @"";
        
        if (kind == CHAT_TYPE_TEXT) {
            finalText = @"[text]";
        }else if (kind == CHAT_TYPE_IMAGE) {
            finalText = @"[image]";
        }else if (kind == CHAT_TYPE_AUDIO) {
            finalText = @"[audio]";
        }
        
        finalText = [finalText stringByAppendingString:textToSend];
        
        [message addBody:finalText];
        
        
        
//        NSXMLElement *bodyElement = [NSXMLElement elementWithName:@"kind" stringValue:kind];
//        [message addChild:bodyElement];
        
        
        [[[self appDelegate] xmppStream] sendElement:message];
        
        [JSMessageSoundEffect playMessageSentSound];
        
    }
    

}

- (UIImage *)avatarImageForIncomingMessage
{
    return nil;
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return nil;
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
