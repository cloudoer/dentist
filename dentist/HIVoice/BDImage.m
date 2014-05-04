//
//  UIImage+Helper.m
//  baiduHi
//
//  Created by apple on 11-8-18.
//  Copyright 2011年 baidu_ios. All rights reserved.
//

#import "BDImage.h"
//#import "ABContact.h"
#import <QuartzCore/QuartzCore.h>

@implementation BDImage


//图片较多或者较大的时候使用
//原有方法对内存没有太好提升
//参考链接http://blog.csdn.net/koupoo/article/details/6624293
+ (UIImage *)getImage:(NSString *)imageName{
  return [UIImage imageNamed:imageName];
}

+ (UIImage *)getImageFromPath:(NSString *)imagepath{
  UIImage *image = [UIImage imageWithContentsOfFile:imagepath];
  return image;
}



@end
