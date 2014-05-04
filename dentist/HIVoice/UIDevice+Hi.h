//
//  UIDevice+Hi.h
//  baiduHi
//
//  Created by Hua Cao on 13-12-6.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Hi)

/**
 */
+ (BOOL)isPad;
+ (BOOL)isPhone;
+ (BOOL)isPhone5;

/**
 */
+ (BOOL)isRetinaDisplay;

@end
