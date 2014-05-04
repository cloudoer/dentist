//
//  HiMath.m
//  baiduHi
//
//  Created by Hua Cao on 13-12-7.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "HiMath.h"

//角度转化为弧度
CGFloat HiRadiansFromDegrees(CGFloat degrees) {
    return (degrees) * M_PI / 180.f;
}

//弧度转化为角度
CGFloat HiDegreesFromRadians(CGFloat radians) {
    return (radians) * 180.f / M_PI;
}
