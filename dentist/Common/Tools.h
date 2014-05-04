//
//  Tools.h
//  dentist
//
//  Created by xiaoyuan wang on 4/17/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPvCardTemp.h"
#import "Userinfo.h"

typedef enum : NSUInteger {
    CHAT_TYPE_TEXT,
    CHAT_TYPE_IMAGE,
    CHAT_TYPE_AUDIO,
} CHAT_TYPE;

@interface Tools : NSObject
+ (XMPPvCardTemp *)xmppVCardTempFromVCardStr:(NSString *)vCardStr;


+ (void)showAlertViewWithText:(NSString *)text;


+ (CHAT_TYPE)typeForMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message;
+ (NSString *)bodyWithoutPrefixForMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message;


+ (UIImage *)imageFromBase64Str:(NSString *)base64Str;

+ (NSString *)bareJIDStringFromBuddyClicked;
+ (void)setBareJIDStringFromBuddyClicked:(NSString *)bareJIDStr;

+ (NSData *)base64DataFromString: (NSString *)string;

@end
