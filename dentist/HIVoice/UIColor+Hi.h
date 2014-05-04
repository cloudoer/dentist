//
//  UIColor+Hi.h
//  baiduHi
//
//  Created by Hua Cao on 13-12-7.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Create UIColor object
 */
//white
UIColor * HiColorWithWhite(CGFloat white);

//white alpha
UIColor * HiColorWithWhiteAlpha(CGFloat white, CGFloat alpha);

//r g b
UIColor * HiColorWithRGB(CGFloat red, CGFloat green, CGFloat blue);

//r g b a
UIColor * HiColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

//hex
UIColor * HiColorWithHex(unsigned int hex);

//hex alpha
UIColor * HiColorWithHexAlpha(unsigned int hex, CGFloat alpha);

//hex string
// RGB
// RGBA
// RRGGBB
// RRGGBBAA
UIColor * HiColorWithHexString(NSString * hexString);
CGFloat HiColorComponentFromHexString(NSString * hexString, NSUInteger start, NSUInteger length);

//random
UIColor * HiRandomColor(void);

//random alpha
UIColor * HiRandomColorWithAlpha(CGFloat alpha);

//clear
UIColor * HiClearColor(void);

@interface UIColor (Hi)

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
