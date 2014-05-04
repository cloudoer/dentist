//
//  NSArray+Hi.m
//  baiduHi
//
//  Created by Hua Cao on 13-12-16.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "NSArray+Hi.h"

BOOL HiArrayIsEmpty(NSArray * array) {
    return (array==nil || array.count==0);
}

@implementation NSArray (Hi)


//////////////////////////////////////////////////////////////////////////////////
- (id)firstObject {
	return [self objectAtPosition:0];
}

//////////////////////////////////////////////////////////////////////////////////
- (id)objectAtPosition:(NSInteger)position {
	
    NSUInteger count = self.count;
    if (count<1) return nil;
    
    NSInteger index;
	if (position<0) {
		index = count + position;
	}else {
		index = position;
	}
	
	if (index>=0 && index<count) {
		return [self objectAtIndex:index];
	}else{
		return nil;
	}
}
- (id)objectAtCirclePosition:(NSInteger)position
{
    NSUInteger count = self.count;
    if (count<=1) return [self firstObject];
    
    NSInteger index = position;
    while (index<0) {
        index += count;
    }
    
    index = index%count;
    
    return [self objectAtIndex:index];
}

@end
