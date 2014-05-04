//
//  UIImage+Helper.h
//  baiduHi
//
//  Created by apple on 11-8-18.
//  Copyright 2011年 baidu_ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABContact;

@interface BDImage: NSObject {
    
}

+ (UIImage *)getImage:(NSString *)imageName;

+ (UIImage *)getImageFromPath:(NSString *)imagepath;
@end
