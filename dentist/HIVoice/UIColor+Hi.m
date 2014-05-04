//
//  UIColor+Hi.m
//  baiduHi
//
//  Created by Hua Cao on 13-12-7.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "UIColor+Hi.h"

//white
UIColor * HiColorWithWhite(CGFloat white)
{
    return HiColorWithWhiteAlpha(white, 1.0);
}

//white alpha
UIColor * HiColorWithWhiteAlpha(CGFloat white, CGFloat alpha)
{
    return [UIColor colorWithWhite:(white)/255.0f alpha:(alpha)];
}

//r g b
UIColor * HiColorWithRGB(CGFloat red, CGFloat green, CGFloat blue)
{
    return HiColorWithRGBA(red, green, blue, 1.0);
}

//r g b alpha
UIColor * HiColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return [UIColor colorWithRed:(red)/255.0f green:(green)/255.0f blue:(blue)/255.0f alpha:(alpha)];
}

//hex
UIColor * HiColorWithHex(unsigned int hex)
{
	return HiColorWithHexAlpha(hex, 1.0);
}

//hex alpha
UIColor * HiColorWithHexAlpha(unsigned int hex, CGFloat alpha)
{
	return HiColorWithRGBA((float)((hex & 0xFF0000) >> 16),
                          (float)((hex & 0xFF00) >> 8),
                          (float)((hex & 0xFF)),
                          alpha);
}

//hex string
UIColor * HiColorWithHexString(NSString * hexString) {
    NSString * colorString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    colorString = [[colorString stringByReplacingOccurrencesOfString:@"0x" withString:@""] uppercaseString];
    CGFloat red, blue, green, alpha;
    switch ([colorString length]) {
        case 3: // #RGB
            red   = HiColorComponentFromHexString(colorString, 0, 1);
            green = HiColorComponentFromHexString(colorString, 1, 1);
            blue  = HiColorComponentFromHexString(colorString, 2, 1);
            alpha = 1.0f;
            break;
        case 4: // #RGBA
            red   = HiColorComponentFromHexString(colorString, 0, 1);
            green = HiColorComponentFromHexString(colorString, 1, 1);
            blue  = HiColorComponentFromHexString(colorString, 2, 1);
            alpha = HiColorComponentFromHexString(colorString, 3, 1);
            break;
        case 6: // #RRGGBB
            red   = HiColorComponentFromHexString(colorString, 0, 2);
            green = HiColorComponentFromHexString(colorString, 2, 2);
            blue  = HiColorComponentFromHexString(colorString, 4, 2);
            alpha = 1.0f;
            break;
        case 8: // #RRGGBBAA
            red   = HiColorComponentFromHexString(colorString, 0, 2);
            green = HiColorComponentFromHexString(colorString, 2, 2);
            blue  = HiColorComponentFromHexString(colorString, 4, 2);
            alpha = HiColorComponentFromHexString(colorString, 6, 2);
            break;
        default:
            return nil;
            break;
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

CGFloat HiColorComponentFromHexString(NSString * hexString, NSUInteger start, NSUInteger length) {
    NSString *substring = [hexString substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length==2?substring:[NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned int hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

//random
UIColor * HiRandomColor(void)
{
	return HiRandomColorWithAlpha(1.0);
}

//random alpha
UIColor * HiRandomColorWithAlpha(CGFloat alpha)
{
	return HiColorWithRGBA(arc4random() % 255,
                           arc4random() % 255,
                           arc4random() % 255,
                           alpha);
}

//clear
UIColor * HiClearColor(void) {
    return [UIColor clearColor];
}

@implementation UIColor (Hi)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return HiColorWithHexString(hexString);
}

@end
