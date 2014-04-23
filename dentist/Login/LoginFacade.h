//
//  LoginFacade.h
//  dentist
//
//  Created by xiaoyuan wang on 4/17/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Userinfo;
@class XMPPvCardTemp;

@interface LoginFacade : NSObject

+ (BOOL)isLogged;

+ (Userinfo *)sharedUserinfo;

+ (void)loginSuccessWithXMPPvCardTemp:(XMPPvCardTemp *)vCardTemp;

+ (void)presentLoginViewControllerFrom:(UIViewController *)fromViewController;

@end
