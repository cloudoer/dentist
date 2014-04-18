//
//  RoomChatViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/18/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "RoomChatViewController.h"
#import "AppDelegate.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"

@interface RoomChatViewController () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation RoomChatViewController
{
    NSFetchedResultsController *fetchedResultsController;
    
    NSDictionary *vCardDict;
    NSMutableSet *userSet;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    self.delegate = self;
    self.dataSource = self;
    
    self.title = self.oneRoom.naturalName;
    
    vCardDict = [[NSMutableDictionary alloc] initWithCapacity:20];
    
    [[self appDelegate] joinTheRoom:self.oneRoom.name];
    
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
        
        XMPPRoomCoreDataStorage *storage = [XMPPRoomCoreDataStorage sharedInstance];
        NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPRoomMessageCoreDataStorageObject"
                                                             inManagedObjectContext:moc];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        request.entity = entityDescription;
        request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"localTimestamp" ascending:YES]];
        request.fetchBatchSize = 20;
        request.predicate = [NSPredicate predicateWithFormat:@"roomJIDStr contains %@ && roomJIDStr != jidStr", self.oneRoom.name];
        
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
    [self scrollToBottomAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    NSString *roomStr = [self.oneRoom.name stringByAppendingString:[NSString stringWithFormat:@"@conference.%@", [self appDelegate].xmppStream.myJID.domain]];
    XMPPJID *roomJID = [XMPPJID jidWithString:roomStr];
    
    if (text && text.length > 0) {
        
        XMPPMessage *message = [XMPPMessage messageWithType:@"groupchat" to:roomJID];
        [message addBody:text];
        
        
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
    XMPPRoomMessageCoreDataStorageObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    return ([message.jid.resource isEqualToString:[LoginFacade sharedUserinfo].realname] || [message.jid.resource isEqualToString:[LoginFacade sharedUserinfo].jabberId]) ? JSBubbleMessageTypeOutgoing : JSBubbleMessageTypeIncoming;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"]){
//        return JSBubbleMediaTypeText;
//    }else if ([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"]){
//        return JSBubbleMediaTypeImage;
//    }
    
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
    XMPPRoomMessageCoreDataStorageObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    return message.body;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPRoomMessageCoreDataStorageObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    return message.localTimestamp;
}


- (UIImage *)avatarImageForAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPRoomMessageCoreDataStorageObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    XMPPJID *fromJID = message.message.from;
    NSString *uid = fromJID.resource;
    NSLog(@"uid --> %@", uid);
    if (uid == nil) {
        uid = [LoginFacade sharedUserinfo].jabberId;
    }
    if (vCardDict[uid] == nil) {
        [self fetchAvatarForIndexPath:indexPath withUID:uid];
        return nil;
    }
    
    Userinfo *currUser = [Userinfo userinfoFromXMPPvCardTempStr:vCardDict[uid]];
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:currUser.avatar_url];
    
}

- (void)fetchAvatarForIndexPath:(NSIndexPath *)indexPath withUID:(NSString *)uidStr
{
    if (userSet == nil) {
        userSet = [[NSMutableSet alloc] initWithCapacity:20];
    }
    if ([userSet containsObject:uidStr]) {
        return;
    }
    [userSet addObject:uidStr];
    
    NSString *getPath = [NSString stringWithFormat:@"%@&uid=%@", URL_PATH_ONE_VCARD, uidStr];
    [Network httpGetPath:getPath success:^(NSDictionary *response) {
        if ([Network statusOKInResponse:response]) {
            NSString *vCardStr = response[@"data"];
            [vCardDict setValue:vCardStr forKey:uidStr];
            __block Userinfo *currUser = [Userinfo userinfoFromXMPPvCardTempStr:vCardStr];

            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:currUser.avatar_url] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (!finished || error || image == nil) {
                    image = [UIImage imageNamed:@"tab_me.png"];
                }
                [[SDImageCache sharedImageCache] storeImage:image forKey:currUser.avatar_url toDisk:YES];
                [self.tableView reloadData];
            }];
        }
    } failure:nil];
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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