//
//  NSArray+Hi.h
//  baiduHi
//
//  Created by Hua Cao on 13-12-16.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Convinient method to check if a array is empty or not.
 */
BOOL HiArrayIsEmpty(NSArray * array);

@interface NSArray (Hi)

/**
 Return the first object or nil if array is empty.
 */
- (id)firstObject;

/**
 Replace objectAtIndex
 
 目的1：可以使用负数，来访问数组末尾的元素，例如：-1表示最后一个，-2表示倒数第二个
 目的2：进行位置合法性检查，避免崩溃
 
 */
- (id)objectAtPosition:(NSInteger)position;

/**
 循环访问数组内容
 */
- (id)objectAtCirclePosition:(NSInteger)position;

@end
