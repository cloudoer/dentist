//
//  LoginFacade.m
//  dentist
//
//  Created by xiaoyuan wang on 4/17/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "LoginFacade.h"

#define kSharedUserinfo @"kSharedUserinfo"

@implementation LoginFacade

+ (BOOL)isLogged
{
    return [self sharedUserinfo] != nil;
}

+ (Userinfo *)sharedUserinfo
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSharedUserinfo];
    if (data == nil) {
        return nil;
    }
    
    Userinfo *userinfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return userinfo;
}

+ (void)loginSuccessWithXMPPvCardTemp:(XMPPvCardTemp *)vCardTemp
{
    Userinfo *userinfo = [Userinfo userinfoFromXMPPvCardTemp:vCardTemp];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userinfo];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSharedUserinfo];
}


@end
