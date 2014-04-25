//
//  FileUtil.m
//  pocketplayer
//
//  Created by zhoulong on 13-12-26.
//  Copyright (c) 2013年 koudaiv. All rights reserved.
//

#import "FileUtil.h"
#import "NSUtil.h"

@implementation FileUtil

+ (void)clearImageCacheBeforeTheDay:(double)day filePath:(NSString *)path {
//    NSString *imageDir = [SYSTEM_CACHES_PATH stringByAppendingPathComponent:file];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (files.count) {
        for (NSString *tem in files) {
            NSDate *date = [[manager attributesOfItemAtPath:[path stringByAppendingPathComponent:tem] error:nil] fileCreationDate];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            double distance = [NSUtil DistanceTime:[formatter stringFromDate:date] format:@"yyyyMMddHHmmss" type:TimeDay];
            if (distance >= day) {
                [manager removeItemAtPath:[path stringByAppendingPathComponent:tem] error:nil];
            }
        }
    }
}

+ (long long)fileSize:(NSString *)path {
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
}
@end
