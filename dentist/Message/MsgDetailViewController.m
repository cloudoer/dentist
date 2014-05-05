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
#import <AVFoundation/AVFoundation.h>
#import "amrFileCodec.h"


@interface MsgDetailViewController () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate,
AVAudioSessionDelegate,
AVAudioPlayerDelegate>


@end

@implementation MsgDetailViewController
{
    NSFetchedResultsController *fetchedResultsController;
    
    
    
    NSMutableDictionary * _recorderSetting;
    AVAudioPlayer       * _player;
    AVAudioRecorder     * _recorder;
    NSString            * _filePath;
    
    VoicdHUDViewController *_voicePanelViewController;
    UINavigationController *nv;
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
    
    self.title = self.theBuddy.realname;
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        //        DDLogError(@"Error performing fetch: %@", error);
    }
    
    [self prepareToTestRecord];
    
    [self prepareTheVoiceController];
}

- (void)prepareTheVoiceController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    nv = [storyboard instantiateViewControllerWithIdentifier:@"VoiceNav"];
    
    [nv.view setBackgroundColor:[UIColor clearColor]];
    [nv setNavigationBarHidden:YES animated:NO];
    
    _voicePanelViewController = nv.viewControllers[0];
    _voicePanelViewController.delegate = self;
//    [_voicePanelViewController refreshWithMaskFrame:self.view.frame];
//    [_voicePanelViewController preShowVoicePanel];
    
    
//    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    UIViewController * controller = mydelegate.window.rootViewController;
//    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
//    [controller presentViewController:nv animated:NO completion:nil];
}

- (void)prepareToTestRecord
{
    _recorderSetting = [[NSMutableDictionary alloc] init];
    //数据格式
    [_recorderSetting setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //采样率
    [_recorderSetting setObject:[NSNumber numberWithInt:8000] forKey:AVSampleRateKey];
    //声道数目
    [_recorderSetting setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //采样位数
    [_recorderSetting setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    
    _filePath = [NSTemporaryDirectory() stringByAppendingString:@"TestRecording.caf"];
    NSError * _err = nil;
    NSLog(@"file path = %@",_filePath);
    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_filePath]
                                            settings:_recorderSetting
                                               error:&_err];
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    
    
    
    AVAudioSession * _audioSession = [AVAudioSession sharedInstance];
    NSError * _error = nil;
    [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&_error];
    if(_audioSession == nil)
        NSLog(@"Error creating session: %@", [_error description]);
    else
        [_audioSession setActive:YES error:nil];
    
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
//    [self finishSend];
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
    
    if ([Tools typeForMessage:message] == CHAT_TYPE_IMAGE) {
        NSString *realbody = [Tools bodyWithoutPrefixForMessage:message];
        NSData* data = [[NSData alloc] initWithBase64EncodedString:realbody options:0];
        return [UIImage imageWithData:data];
    }
    
    if ([Tools typeForMessage:message] == CHAT_TYPE_AUDIO) {
        return [UIImage imageNamed:@"voice_pic.png"];
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
    
//    CGFloat compression = 0.9f;
//    CGFloat maxCompression = 0.1f;
//    int maxFileSize = 250*1024;
//    
//    NSData *imageData = UIImageJPEGRepresentation(chosenImage, compression);
//    
//    while ([imageData length] > maxFileSize && compression > maxCompression)
//    {
//        compression -= 0.1;
//        imageData = UIImageJPEGRepresentation(chosenImage, compression);
//    }
    
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    
    
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
    return [Tools imageFromBase64Str:self.theBuddy.photoStr];
}

- (UIImage *)avatarImageForOutgoingMessage
{
    Userinfo *userinfo = [LoginFacade sharedUserinfo];
    return [Tools imageFromBase64Str:userinfo.photo];
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


- (void)longPressBtnPressed:(UIButton *)sender
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UINavigationController *nv = [storyboard instantiateViewControllerWithIdentifier:@"VoiceNav"];
//    
//    [nv.view setBackgroundColor:[UIColor clearColor]];
//    [nv setNavigationBarHidden:YES animated:NO];
    
//    VoicdHUDViewController *_voicePanelViewController = nv.viewControllers[0];
//    _voicePanelViewController.delegate = self;
    [_voicePanelViewController refreshWithMaskFrame:self.view.frame];
    [_voicePanelViewController preShowVoicePanel];
    
    
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController * controller = mydelegate.window.rootViewController;
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    [controller presentViewController:nv animated:NO completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    
    if ([Tools typeForMessage:message] == CHAT_TYPE_AUDIO) {
        [self playWithBase64Str:[Tools bodyWithoutPrefixForMessage:message]];
    }

}



- (void)playWithBase64Str:(NSString *)audioBase64Str {
    if (_player && _player.isPlaying) {
        [_player stop];
        return;
    }
    
    NSString * _wavFilePath = [NSTemporaryDirectory() stringByAppendingString:@"TestRecording.wav"];
    NSData * _amrData = [Tools base64DataFromString:audioBase64Str];
    NSData * _wavData = DecodeAMRToWAVE(_amrData);
    [_wavData writeToFile:_wavFilePath atomically:YES];
    
    NSError * _error = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_wavFilePath] error:&_error];
    _player.delegate = self;
    _player.volume = 1.0;
    if (_player==nil)
    {
        NSLog(@"声音放送--%@",[_error description]);
    }else
    {
        [_player prepareToPlay];
    }
    
    
    if (![_player play])
    {
        NSLog(@" wrong !!!!");
    }else
    {
        
    }
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
}

#pragma mark Record Delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    // nothing
    
}

#pragma mark AVAudioPlayer Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)startRecord
{
    
}
- (void)cancelRecord
{
    
}
- (void)finishRecord:(NSString *)audioBase64Str
{
    [self sendTheText:audioBase64Str withKind:CHAT_TYPE_AUDIO];
}


@end
