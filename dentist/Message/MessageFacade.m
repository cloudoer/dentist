//
//  MessageFacade.m
//  dentist
//
//  Created by xiaoyuan wang on 4/24/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "MessageFacade.h"

#define STORYBOARD_NAEM @"Message"

@implementation MessageFacade

+ (UIViewController *)instantiateInitialViewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:STORYBOARD_NAEM bundle:[NSBundle mainBundle]];
    
    return storyBoard.instantiateInitialViewController;
}

@end
