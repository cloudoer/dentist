//
//  RoomChatViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/18/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "RoomChatViewController.h"
#import "AppDelegate.h"

@interface RoomChatViewController () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation RoomChatViewController

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
    
    
    [[self appDelegate] joinTheRoom:self.oneRoom.name];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
//    [self.messageArray addObject:[NSDictionary dictionaryWithObject:text forKey:@"Text"]];
//    
//    [self.timestamps addObject:[NSDate date]];
//    
//    if((self.messageArray.count - 1) % 2)
//        [JSMessageSoundEffect playMessageSentSound];
//    else
//        [JSMessageSoundEffect playMessageReceivedSound];
    
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
    return (indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
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
    return @"fdsf";
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NSDate date];
}

- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"demo-avatar-jobs"];
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"demo-avatar-woz"];
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
