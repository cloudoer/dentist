//
//  UIDevice+Hi.m
//  baiduHi
//
//  Created by Hua Cao on 13-12-6.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "UIDevice+Hi.h"

@implementation UIDevice (Hi)

//////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (BOOL) isPhone {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (BOOL) isPhone5 {
    return ([UIDevice isPhone] && [[UIScreen mainScreen] bounds].size.height == 568.0f);
}

//////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isRetinaDisplay{
    return ([UIScreen instancesRespondToSelector:@selector(scale)] &&
            [[UIScreen mainScreen] scale] == 2.0);
}

@end
