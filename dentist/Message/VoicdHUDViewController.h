//
//  VoicdHUDViewController.h
//  JYVoicHUD
//
//  Created by xiaoyuan wang on 5/3/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HI_RECORD_LEVER_METER_TIMER 0.1f

typedef enum hiVoicePanelType {
    HI_VOICEPANEL_TYPE_DEFAULT = 0,
    HI_VOICEPANEL_TYPE_NORMAL,
    HI_VOICEPANEL_TYPE_RE_DELETE,
    HI_VOICEPANEL_TYPE_DELETE,
    HI_VOICEPANEL_TYPE_ERROR
} HiVoicePanelType;


@protocol HIVoiceDelegate <NSObject>

- (void)startRecord;
- (void)cancelRecord;
- (void)finishRecord:(NSString *)audioBase64Str;

@end

@interface VoicdHUDViewController : UIViewController
{
    CGFloat _soundWaveScale ;  //声波扩散的最大比例
    CGFloat _soundWaveDiameter ; //声波默认的直径
    CGFloat _soundWaveStartAlpha ; //声波启动的透明度
    CGFloat _soundWaveEndAlpha ; //声波扩散停止的透明度
    NSTimeInterval  _soundWaveTimeduration ;//声波发送的频率
    UIColor *_soundWaveColor;//声波颜色
    
    CGFloat _volumeWaveScale ;  //音量波扩散的最大比例
    CGFloat _volumeWaveAlpha ; //音量波的透明度
    UIColor *_volumeWaveColor ;//音量波颜色
    int    _maxVolumeTime ;//最大录音长度
}

@property (nonatomic, weak) id<HIVoiceDelegate> delegate;

-(void)preHideVoicePanel;
-(void)preShowVoicePanel;
-(void)refreshWithMaskFrame:(CGRect)frame;
-(void)refreshVolumeWaveViewByValue:(float)valueScale withTime:(NSInteger )voiceTimerCount;

@end
