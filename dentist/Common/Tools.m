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

@end
