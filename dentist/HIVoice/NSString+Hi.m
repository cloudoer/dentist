//
//  NSString+Hi.m
//  baiduHi
//
//  Created by Hua Cao on 13-12-17.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "NSString+Hi.h"

BOOL HiStringIsNil(NSString * string) {
	if (string==nil||
        [string isEqual:[NSNull null]]||
        string.length==0||
        [[string lowercaseString] isEqualToString:@"(null)"]) {
		return YES;
	}
	return NO;
}

@implementation NSString (Hi)

#pragma mark - Remove All

- (NSString *)stringByRemoveAllCharactersInSet:(NSCharacterSet *)characterSet {
    return [[self componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
}

- (NSString *)stringByRemoveAllWhitespaceAndNewlineCharacters {
    return [self stringByRemoveAllCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - Trimming

- (NSString *)stringByTrimmingLeadingAndTrailingCharactersInSet:(NSCharacterSet *)characterSet {
	return [[self stringByTrimmingLeadingCharactersInSet:characterSet]
			stringByTrimmingTrailingCharactersInSet:characterSet];
}


- (NSString *)stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters {
	return [[self stringByTrimmingLeadingWhitespaceAndNewlineCharacters]
			stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
}


- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfFirstWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]];
    if (rangeOfFirstWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringFromIndex:rangeOfFirstWantedCharacter.location];
}


- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters {
    return [self stringByTrimmingLeadingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]
                                                               options:NSBackwardsSearch];
    if (rangeOfLastWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringToIndex:rangeOfLastWantedCharacter.location + 1]; // Non-inclusive
}


- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters {
    return [self stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end
