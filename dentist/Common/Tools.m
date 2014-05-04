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


+ (NSString *)bareJIDStringFromBuddyClicked
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"bareJIDStringFromBuddyClicked"];
}

+ (void)setBareJIDStringFromBuddyClicked:(NSString *)bareJIDStr;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:bareJIDStr forKey:@"bareJIDStringFromBuddyClicked"];
}

+ (NSData *)base64DataFromString: (NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}

@end
