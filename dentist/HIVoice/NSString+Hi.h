//
//  NSString+Hi.h
//  baiduHi
//
//  Created by Hua Cao on 13-12-17.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL HiStringIsNil(NSString * string);

@interface NSString (Hi)

/**
 */
- (NSString *)stringByRemoveAllCharactersInSet:(NSCharacterSet *)characterSet;

- (NSString *)stringByRemoveAllWhitespaceAndNewlineCharacters;

/**
 Returns a new string by trimming leading and trailing characters in a given `NSCharacterSet`.
 
 @param characterSet Character set to trim characters
 
 @return A new string by trimming leading and trailing characters in `characterSet`
 */
- (NSString *)stringByTrimmingLeadingAndTrailingCharactersInSet:(NSCharacterSet *)characterSet;

/**
 Returns a new string by trimming leading and trailing whitespace and newline characters.
 
 @return A new string by trimming leading and trailing whitespace and newline characters
 */
- (NSString *)stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters;

/**
 Returns a new string by trimming leading characters in a given `NSCharacterSet`.
 
 @param characterSet Character set to trim characters
 
 @return A new string by trimming leading characters in `characterSet`
 */
- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;

/**
 Returns a new string by trimming leading whitespace and newline characters.
 
 @return A new string by trimming leading whitespace and newline characters
 */
- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters;

/**
 Returns a new string by trimming trailing characters in a given `NSCharacterSet`.
 
 @param characterSet Character set to trim characters
 
 @return A new string by trimming trailing characters in `characterSet`
 */
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;

/**
 Returns a new string by trimming trailing whitespace and newline characters.
 
 @return A new string by trimming trailing whitespace and newline characters
 */
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;

@end
