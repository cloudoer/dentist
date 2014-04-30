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
#import <AVFoundation/AVFoundation.h>
#import "amrFileCodec.h"
#import "GTMBase64.h"
#import "MsgListCell.h"

@interface MessageListTableViewController () <AVAudioRecorderDelegate,
AVAudioSessionDelegate,
AVAudioPlayerDelegate>

@end

@implementation MessageListTableViewController
{
    NSFetchedResultsController *fetchedResultsController;
    
    NSMutableArray *latestMsgArray;
    NSArray *finalBuddyArray;
    
    NSString *clickedBareJIDStr;
    
    
    NSMutableDictionary * _recorderSetting;
    AVAudioPlayer       * _player;
    AVAudioRecorder     * _recorder;
    NSString            * _filePath;
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
        
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
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
    
    DEFAULT_NAVIGATION_BAR_TINT_COLOR
    DEFAULT_NAVIGATION_TINT_COLOR
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
//        DDLogError(@"Error performing fetch: %@", error);
    }
    
    [self prepareToTestRecord];
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

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
	// Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
	// We only need to ask the avatar module for a photo, if the roster doesn't have it.
	
	if (user.photo != nil)
	{
		cell.imageView.image = user.photo;
	}
	else
	{
		NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
        
		if (photoData != nil)
			cell.imageView.image = [UIImage imageWithData:photoData];
		else
			cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    XMPPMessageArchiving_Message_CoreDataObject *message = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    XMPPMessageArchiving_Message_CoreDataObject *message = finalBuddyArray[indexPath.row];
    
    static NSString *CellIdentifier = @"MsgListCell";
    MsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if ([Tools typeForMessage:message] == CHAT_TYPE_TEXT) {
        cell.msgLabel.text = [Tools bodyWithoutPrefixForMessage:message];
    }else {
        cell.msgLabel.text = @"[图片]";
    }
    
    cell.nameLabel.text = message.bareJidStr;
    cell.redDotImageView.hidden = YES;
    if ([[BuddyManager sharedBuddyManager] containBuddyNewMessegeFrom:message.message.from.user]) {
        cell.redDotImageView.hidden = NO;
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
- (IBAction)record:(UIBarButtonItem *)sender {
    if (sender.tag == 0) {
        sender.title = @"stop";
        [self beginRecorder];
    }else {
        sender.title = @"record";
        [self stopRecorder];
    }
    sender.tag = 1 - sender.tag;
}

- (void)beginRecorder
{
    if (![_recorder record])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"录音失败"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"录制失败");
    }
    
}


- (void)stopRecorder
{
    [_recorder stop];
}
- (IBAction)play:(UIBarButtonItem *)sender {
    if (_player && _player.isPlaying) {
        [_player stop];
        return;
    }
    
    NSString * _amrFilePath = [NSTemporaryDirectory() stringByAppendingString:@"TestRecording.amr"];
    NSString * _wavFilePath = [NSTemporaryDirectory() stringByAppendingString:@"TestRecording.wav"];
    NSData * _amrData = [NSData dataWithContentsOfFile:_amrFilePath];
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
    _filePath = [NSTemporaryDirectory() stringByAppendingString:@"TestRecording.caf"];
    NSData * _cafData = [NSData dataWithContentsOfFile:_filePath];
    
    UILabel * _cafSizeLabel = (UILabel *)[self.view viewWithTag:103];
    [_cafSizeLabel setText:[NSString stringWithFormat:@"%@%.1fk",_cafSizeLabel.text,[_cafData length] / 1024.0]];
    
    NSString * _amrFilePath = [NSTemporaryDirectory() stringByAppendingString:@"TestRecording.amr"];
    NSData * _amrData = EncodeWAVEToAMR(_cafData, 1, 16);
    
    UILabel * _amrSizeLabel = (UILabel *)[self.view viewWithTag:104];
    [_amrSizeLabel setText:[NSString stringWithFormat:@"%@%.1fk",_amrSizeLabel.text,[_amrData length] / 1024.0]];
    [_amrData writeToFile:_amrFilePath atomically:YES];
    
    NSString * amrDataBase64Str = [[NSString alloc] initWithData:[GTMBase64 encodeData:_amrData] encoding:NSUTF8StringEncoding];
    
    NSLog(@"armString -> %@", amrDataBase64Str);
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
