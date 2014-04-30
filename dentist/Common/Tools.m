//
//  Tools.m
//  dentist
//
//  Created by xiaoyuan wang on 4/17/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "Tools.h"
#import <objc/runtime.h>


@implementation Tools

+ (XMPPvCardTemp *)xmppVCardTempFromVCardStr:(NSString *)vCardStr
{
    NSXMLElement *cardXML = [[NSXMLElement alloc] initWithXMLString:vCardStr error:nil];
    
    return [self vCardTempFromElement:cardXML];
}

+ (XMPPvCardTemp *)vCardTempFromElement:(NSXMLElement *)elem {
    object_setClass(elem, [XMPPvCardTemp class]);
    
    return (XMPPvCardTemp *)elem;
}

+ (void)showAlertViewWithText:(NSString *)text
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
}

+ (CHAT_TYPE)typeForMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message
{
    NSString *body = message.body;
    if ([body hasPrefix:@"[image]"]) {
        return CHAT_TYPE_IMAGE;
    }else if ([body hasPrefix:@"[audio]"]) {
        return CHAT_TYPE_AUDIO;
    }
    
    return CHAT_TYPE_TEXT;
}

+ (NSString *)bodyWithoutPrefixForMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message
{
    NSString *body = message.body;
    if ([body hasPrefix:@"[image]"]) {
        return [body substringFromIndex:@"[image]".length];
    }else if ([body hasPrefix:@"[audio]"]) {
        return [body substringFromIndex:@"[audio]".length];
    }else if ([body hasPrefix:@"[text]"]) {
        return [body substringFromIndex:@"[text]".length];
    }
    
    return message.body;
}


+ (UIImage *)imageFromBase64Str:(NSString *)base64Str {
    
    if (base64Str == nil || base64Str.length <= 0) {
        return nil;
    }
    
    NSData* data = [[NSData alloc] initWithBase64EncodedString:base64Str options:0];
    return [UIImage imageWithData:data];
}

@end
