//
//  baiduHiUIApplication.m
//  baiduHi
//
//  Created by Wang Ping on 13-5-17.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "baiduHiUIWindow.h"

@implementation baiduHiUIWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)sendEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {//发送一个名为‘nScreenTouch’（自定义）的事件
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"nScreenTouch" object:nil userInfo:[NSDictionary dictionaryWithObject:event forKey:@"data"]]];
    }
    [super sendEvent:event];
}
@end
