//
//  HiMacros.h
//  baiduHi
//
//  Created by Hua Cao on 13-12-16.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

// 判断系统版本号
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 为解决6.0后不推荐，7.0不支持的定义
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 6000
#define HiTextAlignment            NSTextAlignment
#define HiTextAlignmentCenter      NSTextAlignmentCenter
#define HiTextAlignmentLeft        NSTextAlignmentLeft
#define HiTextAlignmentRight       NSTextAlignmentRight
#define HiLineBreak                NSLineBreakMode
#define HiLineBreakWordWrap        NSLineBreakByWordWrapping
#define HiLineBreakcharWrap        NSLineBreakByCharWrapping
#define HiLineBreakClip            NSLineBreakByClipping
#define HiLineBreakTruncationHead  NSLineBreakByTruncatingHead
#define HiLineBreakTruncationTail  NSLineBreakByTruncatingTail
#define HiLineBreakTruncationMiddle  NSLineBreakByTruncatingMiddle
#else
#define HiTextAlignment            UITextAlignment
#define HiTextAlignmentCenter      UITextAlignmentCenter
#define HiTextAlignmentLeft        UITextAlignmentLeft
#define HiTextAlignmentRight       UITextAlignmentRight
#define HiLineBreak                UILineBreakMode
#define HiLineBreakWordWrap        UILineBreakModeWordWrap
#define HiLineBreakcharWrap        UILineBreakModeCharacterWrap
#define HiLineBreakClip            UILineBreakModeClip
#define HiLineBreakTruncationHead  UILineBreakModeHeadTruncation
#define HiLineBreakTruncationTail  UILineBreakModeTailTruncation
#define HiLineBreakTruncationMiddle  UILineBreakModeMiddleTruncation
#endif

//
#define SuppressPerformSelectorLeakWarning(Stuff) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff \
_Pragma("clang diagnostic pop")

// Layout
#define HiControllerViewEdgeInsetsTop (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")?64.f:0.f)