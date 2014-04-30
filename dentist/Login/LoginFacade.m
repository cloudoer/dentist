//
//  LoginFacade.m
//  dentist
//
//  Created by xiaoyuan wang on 4/17/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "LoginFacade.h"
#import "Userinfo.h"

#define kSharedUserinfo @"kSharedUserinfo"

#define STORYBOARD_NAEM @"Login"

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

/*
+ (void)loginSuccessWithXMPPvCardTemp:(XMPPvCardTemp *)vCardTemp
{
    Userinfo *userinfo = [Userinfo userinfoFromXMPPvCardTemp:vCardTemp];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userinfo];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSharedUserinfo];
}
 */

+ (void)presentLoginViewControllerFrom:(UIViewController *)fromViewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:STORYBOARD_NAEM bundle:[NSBundle mainBundle]];
    
    UINavigationController *navController = (UINavigationController *)storyBoard.instantiateInitialViewController;
    
    [fromViewController presentViewController:navController animated:YES completion:nil];
}

+ (void)loginSuccessWithHttpgetPath:(NSDictionary *)dic {
    Userinfo *userinfo = [Userinfo userinfoFromHttpget:dic];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userinfo];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSharedUserinfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
