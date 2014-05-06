//
//  VoicdHUDViewController.m
//  JYVoicHUD
//
//  Created by xiaoyuan wang on 5/3/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "VoicdHUDViewController.h"
#import "UIColor+Hi.h"
#import <AVFoundation/AVFoundation.h>
#import "amrFileCodec.h"
#import "GTMBase64.h"

@interface VoicdHUDViewController () <AVAudioRecorderDelegate,
AVAudioSessionDelegate,
AVAudioPlayerDelegate>

@end

@implementation VoicdHUDViewController
{
    CGRect  markRect ; //遮罩部分面积
    CGRect  optionRect;//操作面板面积
    CGRect  volumeRect;//音量面板面积
    CGRect  deleteRectOnMain;//操作面板面积-全屏
    CGRect  warnRectOnMain;//提示区域面积-全屏
    UIView *_voiceMarkView ;//灰色遮罩区域
    UIView *_voiceOptionView;//操控区域
    UIImageView *_optionImageView;//操控图标
    UIImageView *_markBgView;//遮罩背景
    UIImageView *_optionBgView;//操控背景
    UILabel *_optionTitle;//操作面板的提示
    UILabel *_markTitle;//遮蔽面板的提示
    UIView  *_volumeView;//音量波形版
    UIView  *_volumeViewLayer;//音量波形版边框
    
    HiVoicePanelType _oldVoicePanelType; //输入面板状态
    HiVoicePanelType _newVoicePanelType; //输入面板状态
    
    NSTimer *_soundWaveTimer ;//声波计时器
    
    int   _voiceTimerCount;//计时器轮询次数
    float _voiceTimerTime;//上轮计时器时间
    BOOL _isNotFrist;
    BOOL _nowIsTouch;
    CGPoint                 curTouchPoint;      //当前触摸点
    
    
    
    
    NSTimer                     *_volumeValueTimer;
    
    
    
    NSMutableDictionary * _recorderSetting;
    AVAudioPlayer       * _player;
    AVAudioRecorder     * _recorder;
    NSString            * _filePath;
    
    
    float recordTime;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)refreshVolueValue{
    
//    if(_recorder->IsRunning()){
//        _recordQueue = _recorder->Queue();
//    }
//    if(NULL == _recordQueue){
//        return;
//    }
    //处理录音音量与录音时间
//    AudioQueueLevelMeterState levelMeter[1];
//    UInt32 levelMeterSize = sizeof(AudioQueueLevelMeterState);
//    AudioQueueGetProperty(_recordQueue, kAudioQueueProperty_CurrentLevelMeterDB, &levelMeter, &levelMeterSize);
//    float volumeValue = levelMeter[0].mAveragePower;
//    CGFloat valueFloat = _meterTable->ValueAt(volumeValue);
//    long long fileSize = _nowRecordFileLength;
//    int duration = fileSize*8 / OPENCORE_AMRNB_BYTE_SIZE_ONSEC ;
    [_recorder updateMeters];
    
    NSLog(@"meter:%5f", [_recorder averagePowerForChannel:0]);
//    if (([_recorder averagePowerForChannel:0] < -60.0) && (recordTime > 3.0)) {
////        [self commitRecording];
//        return;
//    }
    
    recordTime += HI_RECORD_LEVER_METER_TIMER;
//    [self addSoundMeterItem:[recorder averagePowerForChannel:0]];
    
    [self refreshVolumeWaveViewByValue:([_recorder averagePowerForChannel:0]/20.0)+2 withTime:(NSInteger)recordTime];
}

-(void)startVolueValueTimer{
    if(nil == _volumeValueTimer){
        _volumeValueTimer =  [NSTimer scheduledTimerWithTimeInterval:HI_RECORD_LEVER_METER_TIMER target:self selector:@selector(refreshVolueValue) userInfo:Nil repeats:YES];
    }
}


-(void)preShowVoicePanel{
    [self addScreenTouchObserver];
//    if([_delegate respondsToSelector:@selector(startVoiceRecord)]){
//        [_delegate startVoiceRecord];
//    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"startVoiceRecord...");
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
    
    [self startVolueValueTimer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)preHideVoicePanel{
    if(!_nowIsTouch){
        CGPoint point = CGPointMake(0, 0);
        [self touchEnded:point];
    }
}

-(void)stopVoiceRecrod{
    [self removeScreenTouchObserver];
    [self stopSoundWave];
    if(HI_VOICEPANEL_TYPE_DELETE == _oldVoicePanelType || HI_VOICEPANEL_TYPE_ERROR == _oldVoicePanelType)
    {
//        if([_delegate respondsToSelector:@selector(cancelVoiceRecord)]){
//            [_delegate cancelVoiceRecord];
//        }
        NSLog(@"cancel...");
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else{
//        if([_delegate respondsToSelector:@selector(stopVoiceRecord)]){
//            if(_voiceTimerTime < 1)
//                _voiceTimerTime = 1;
//            [_delegate stopVoiceRecord];
//        }
        NSLog(@"stop....");
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    [_volumeValueTimer invalidate];
    _volumeValueTimer = nil;
    
    [_recorder stop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5]];
    
    [self prepareToTestRecord];
    
    if(!_isNotFrist){
        _isNotFrist = YES;
        markRect = [self.view convertRect:markRect fromView:nil];
        [self initView];
        [self resetVoicePanelType:HI_VOICEPANEL_TYPE_NORMAL];
    }
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

#pragma mark initView
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}

-(void)refreshWithMaskFrame:(CGRect)frame{
    markRect = frame;
    [self setDefaultSetting];
    if(_isNotFrist){
        [self resetVoicePanelType:HI_VOICEPANEL_TYPE_NORMAL];
    }
}


-(void)setDefaultSetting{
    _soundWaveScale = 4.0f;
    _soundWaveDiameter = 100.0f;
    _soundWaveStartAlpha = 0.2f;
    _soundWaveEndAlpha = 0.0f;
    _soundWaveTimeduration = 1.0f;
    _soundWaveColor = [UIColor whiteColor];
    _volumeWaveScale = 3.2f;
    _volumeWaveAlpha = 0.2f;
    _volumeWaveColor = [UIColor whiteColor];
    _voiceTimerCount = 0;
    _optionTitle.text = @"0s";
    _maxVolumeTime = 60;
    _nowIsTouch = NO;
    _oldVoicePanelType = HI_VOICEPANEL_TYPE_DEFAULT;
    _newVoicePanelType = HI_VOICEPANEL_TYPE_DEFAULT;
}


-(void)initView{
    [self initMarkView];
    [self initVoiceOptionView];
    [self initRectOnMain];
    [self initVolumeView];
}

-(void)initMarkView{
    CGRect markBgRect = CGRectMake(0, 0, markRect.size.width, markRect.size.height);
    CGRect markTitleRect =  CGRectMake((markRect.size.width - 150) /2, (markRect.size.height-100)/2+108, 150, 15);
    if(nil == _voiceMarkView){
        _voiceMarkView = [[UIView alloc] init];
        
        [self.view addSubview:_voiceMarkView];
    }
    if(nil==_markBgView){
        _markBgView = [[UIImageView alloc]init];
        _markBgView.image = [UIImage imageNamed:@"n_zhezhao20"];
        [_voiceMarkView addSubview:_markBgView];
    }
    if(nil==_markTitle){
        _markTitle = [[UILabel alloc] init];
        [_markTitle setBackgroundColor:[UIColor clearColor]];
        _markTitle.font = [UIFont boldSystemFontOfSize:15.0f];
        _markTitle.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _markTitle.textAlignment = NSTextAlignmentCenter;
        [_voiceMarkView addSubview:_markTitle];
    }
    [_voiceMarkView setFrame:markRect];
    [_markBgView setFrame:markBgRect];
    [_markTitle setFrame:markTitleRect];
}

-(void)initVoiceOptionView{
    optionRect = CGRectMake((markRect.size.width - 100) /2, (markRect.size.height - 100) /2, 100, 100);
    if(nil == _voiceOptionView){
        _voiceOptionView = [[UIView alloc] init];
        [_voiceMarkView addSubview:_voiceOptionView];
    }
    if(nil == _optionBgView){
        CGRect optionBgRect = CGRectMake(0, 0, 100, 100);
        _optionBgView = [[UIImageView alloc]initWithFrame:optionBgRect];
        _optionBgView.image = [UIImage imageNamed:@"n_yu_kuang"];
        [_voiceOptionView addSubview:_optionBgView];
        
    }
    if(nil == _optionImageView){
        CGRect optionImageRect = CGRectMake(30, 30, 40, 40);
        _optionImageView = [[UIImageView alloc]initWithFrame:optionImageRect];
        [_voiceOptionView addSubview:_optionImageView];
    }
    if(nil == _optionTitle){
        CGRect optionTitleRect = CGRectMake(30, 80, 40, 12);
        _optionTitle = [[UILabel alloc] initWithFrame:optionTitleRect];
        [_optionTitle setBackgroundColor:[UIColor clearColor]];
        _optionTitle.font = [UIFont boldSystemFontOfSize:12.0f];
        _optionTitle.textAlignment = NSTextAlignmentCenter;
        _optionTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        _optionTitle.text = @"0s";
        _optionTitle.hidden = YES;
        [_voiceOptionView addSubview:_optionTitle];
    }
    [_voiceOptionView setFrame:optionRect];
}

-(void)initRectOnMain{
    //    CGRect warnRect = CGRectMake(0, 0, 320, markRect.size.height);
    CGRect warnRect = CGRectMake(0, 0, 320,markRect.size.height - 48);//UE更改为 两个发送按钮面板的高度
    warnRectOnMain =  [_voiceMarkView convertRect:warnRect toView:nil];
    warnRectOnMain.size.height = warnRectOnMain.size.height + warnRectOnMain.origin.y;
    warnRectOnMain.origin.x = 0;
    warnRectOnMain.origin.y = 0;
    
    //    CGRect deleteRect = CGRectMake((markRect.size.width - 140) /2, (markRect.size.height - 140) /2, 140, 140);
    //    deleteRectOnMain = [_voiceMarkView convertRect:deleteRect toView:nil];
    deleteRectOnMain = warnRectOnMain;
}


-(void)initVolumeView{
    if(nil == _volumeView){
        volumeRect = CGRectMake(0, 0, 100, 100);
        _volumeView = [[UIView alloc] init];
        _volumeView.layer.borderColor = [UIColor clearColor].CGColor;
        _volumeView.layer.borderWidth = 1;
        [_volumeView setFrame:volumeRect];
        [_voiceOptionView insertSubview:_volumeView belowSubview:_optionImageView];
    }
    if(nil == _volumeViewLayer){
        _volumeViewLayer = [[UIView alloc] init];
        _volumeViewLayer.layer.borderColor = [UIColor whiteColor].CGColor;
        _volumeViewLayer.layer.borderWidth = 1;
        [_volumeViewLayer setBackgroundColor:[UIColor clearColor]];
        _volumeViewLayer.alpha = 0.25f;
        
        [_volumeViewLayer setFrame:volumeRect];
        [_voiceOptionView insertSubview:_volumeViewLayer belowSubview:_volumeView];
    }
    _volumeView.layer.cornerRadius = _soundWaveDiameter/2;
    [_volumeView setBackgroundColor:_volumeWaveColor];
    _volumeView.alpha = _volumeWaveAlpha;
    
    _volumeViewLayer.layer.cornerRadius = _soundWaveDiameter/2;
}


-(void)resetNormalPanel{
    if(HI_VOICEPANEL_TYPE_NORMAL == _newVoicePanelType){
        _markTitle.text = NSLocalizedString(@"Voice_Panel_Mark_Normal", nil);
        _optionImageView.image = [BDImage getImage:KX_IMAGE_OF_VOICE_YUYIN];
        [self startSoundWave];
    }else{
        
    }
}

-(void)resetReDeletePanel{
    if(HI_VOICEPANEL_TYPE_RE_DELETE == _newVoicePanelType){
        _markTitle.text = NSLocalizedString(@"Voice_Panel_Mark_Normal", nil);
        _optionImageView.image = [BDImage getImage:KX_IMAGE_OF_VOICE_RE_DELETE];
        [self startSoundWave];
    }else{
        
    }
}

-(void)resetDeletePanel{
    if(HI_VOICEPANEL_TYPE_DELETE == _newVoicePanelType){
        _markTitle.text = NSLocalizedString(@"Voice_Panel_Mark_Delete", nil);
        _optionImageView.image = [BDImage getImage:KX_IMAGE_OF_VOICE_RE_DELETE];
        [self startSoundWave];
    }else{
        
    }
}

-(void)resetErrorPanel{
    if(HI_VOICEPANEL_TYPE_ERROR == _newVoicePanelType){
        _markTitle.text = NSLocalizedString(@"Voice_Panel_Mark_Error_TimeTooShort", nil);
        _optionImageView.image = [BDImage getImage:KX_IMAGE_OF_VOICE_ERROR];
        [self stopSoundWave];
    }else{
        
    }
}

-(void)resetVoicePanelType:(HiVoicePanelType )panelType{
    if(_oldVoicePanelType == panelType){
        return ;
    }
    _newVoicePanelType = panelType;
    [self resetNormalPanel];
    [self resetReDeletePanel];
    [self resetDeletePanel];
    [self resetErrorPanel];
    _oldVoicePanelType = _newVoicePanelType;
}

//获取声波试图
-(UIView *)newSoundWaveViewCreate{
    UIView *soundWaveView = [[UIView alloc] initWithFrame:optionRect];
    soundWaveView.layer.cornerRadius = _soundWaveDiameter/2;
    soundWaveView.layer.borderColor = [UIColor whiteColor].CGColor;
    soundWaveView.layer.borderWidth = 1;
    soundWaveView.alpha = _soundWaveStartAlpha;
    return soundWaveView;
}
-(void)refreshSoundWaveView{
    UIView *soundWaveView = [self newSoundWaveViewCreate];
    [_voiceMarkView insertSubview:soundWaveView belowSubview:_markTitle];
    [UIView animateWithDuration:_soundWaveTimeduration*2
                     animations:^{
                         soundWaveView.transform = CGAffineTransformMakeScale(_soundWaveScale, _soundWaveScale);
                         soundWaveView.alpha = _soundWaveEndAlpha;
                     }
                     completion:^(BOOL finished) {
                         [soundWaveView removeFromSuperview];
                     }];
}
//启动波形图
-(void)startSoundWave{
    if(nil == _soundWaveTimer){
        [self refreshSoundWaveView];
        _soundWaveTimer  = [NSTimer scheduledTimerWithTimeInterval:_soundWaveTimeduration*2 target:self selector:@selector(refreshSoundWaveView) userInfo:Nil repeats:YES];
    }
}

-(void)stopSoundWave{
    if(_soundWaveTimer){
        _volumeView.transform = CGAffineTransformIdentity;
        _volumeViewLayer.transform = CGAffineTransformIdentity;
        [_soundWaveTimer invalidate];
        _soundWaveTimer = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 移除触摸观察者
- (void)removeScreenTouchObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nScreenTouch" object:nil];//移除nScreenTouch事件
}
#pragma mark - 添加触摸观察者
- (void)addScreenTouchObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScreenTouch:) name:@"nScreenTouch" object:nil];
}

- (void)onScreenTouch:(NSNotification *)notification {
    _nowIsTouch = YES;
    UIEvent *event=[notification.userInfo objectForKey:@"data"];
    NSSet *allTouches = event.allTouches;
    //如果未触摸或只有单点触摸
    if ((curTouchPoint.x == CGPointZero.x && curTouchPoint.y == CGPointZero.y) || allTouches.count == 1)
        [self transferTouch:[allTouches anyObject]];
    else{
        //遍历touch,找到最先触摸的那个touch
        for (UITouch *touch in allTouches){
            CGPoint prePoint = [touch previousLocationInView:nil];
            if (prePoint.x == curTouchPoint.x && prePoint.y == curTouchPoint.y)
                [self transferTouch:touch];
        }
    }
}

//传递触点
- (void)transferTouch:(UITouch*)_touch{
    CGPoint point = [_touch locationInView:nil];
    switch (_touch.phase) {
        case UITouchPhaseBegan:{
            //            [self touchBegan:point];
        }
            break;
        case UITouchPhaseMoved:{
            [self touchMoved:point];
        }
            break;
        case UITouchPhaseCancelled:
        case UITouchPhaseEnded:{
            [self touchEnded:point];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 触摸开始
//- (void)touchBegan:(CGPoint)_point{
//    curTouchPoint = _point;
//    if([_delegate respondsToSelector:@selector(startVoiceRecord)]){
//        [_delegate startVoiceRecord];
//    }
//}
#pragma mark - 触摸移动
- (void)touchMoved:(CGPoint)_point{
    curTouchPoint = _point;
    //判断是否移动到取消区域
    if(CGRectContainsPoint(deleteRectOnMain,curTouchPoint)){
        [self resetVoicePanelType:HI_VOICEPANEL_TYPE_DELETE];
    }else if(CGRectContainsPoint(warnRectOnMain, curTouchPoint)){
        [self resetVoicePanelType:HI_VOICEPANEL_TYPE_RE_DELETE];
    }else{
        [self resetVoicePanelType:HI_VOICEPANEL_TYPE_NORMAL];
    }
}


#pragma mark 音量波控制
-(void)refreshVolumeWaveViewByValue:(float)valueScale withTime:(NSInteger )voiceTimerCount{
    _voiceTimerCount = voiceTimerCount;
    CGFloat rangeScale = (_volumeWaveScale-1) * valueScale +1;
    dispatch_async(dispatch_get_main_queue(), ^{
        _voiceTimerTime = _voiceTimerCount;
        //        NSString *titleStr ;
        if(_voiceTimerCount <= 0){
            return;
        }
        //        if(_voiceTimerCount < 10){
        //            titleStr = [NSString stringWithFormat:@"0%dS",_voiceTimerCount ];
        //        }else{
        //            titleStr = [NSString stringWithFormat:@"%ds", _voiceTimerCount];
        //        }
        _optionTitle.text = [NSString stringWithFormat:@"%ds", _voiceTimerCount];
        [UIView animateWithDuration:HI_RECORD_LEVER_METER_TIMER
                         animations:^{
                             _volumeView.transform = CGAffineTransformMakeScale(rangeScale, rangeScale);
                             _volumeViewLayer.transform = CGAffineTransformMakeScale(rangeScale, rangeScale);
                         }
                         completion:^(BOOL finished) {
                         }];
        
    });
    if(_voiceTimerCount >= _maxVolumeTime){
        [self stopVoiceRecrod];
    }
}



-(void)hideVoicePanel{
    //[_voicePanelViewController dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - 触摸结束
- (void)touchEnded:(CGPoint)_point{
    curTouchPoint = _point;
    
    
    if (_voiceTimerCount < 1 )
    {
        [self resetVoicePanelType:HI_VOICEPANEL_TYPE_ERROR];
        
        [self stopVoiceRecrod];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(hideVoicePanel) userInfo:Nil repeats:NO];
    }
    else{
        [self stopVoiceRecrod];
        [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(hideVoicePanel) userInfo:Nil repeats:NO];
    }
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
    
    if(HI_VOICEPANEL_TYPE_DELETE == _oldVoicePanelType || HI_VOICEPANEL_TYPE_ERROR == _oldVoicePanelType)
    {
        if ([_delegate respondsToSelector:@selector(cancelRecord)]) {
            [_delegate cancelRecord];
        }
        NSLog(@"cancel...");
    }
    else{
        if ([_delegate respondsToSelector:@selector(finishRecord:)]) {
            [_delegate finishRecord:amrDataBase64Str];
        }
        NSLog(@"stop....");
    }

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




@end
