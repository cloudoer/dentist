//
//  FileUtil.h
//  pocketplayer
//
//  Created by zhoulong on 13-12-26.
//  Copyright (c) 2013年 koudaiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

/**
 *	@brief	清楚几天之前的图片缓存
 *
 *	@param 	day 	day
 */
+ (void)clearImageCacheBeforeTheDay:(double)day filePath:(NSString *)path;

/**
 *	@brief	文件大小
 *
 *	@param 	path 	path description
 *
 *	@return	return value description
 */
+ (long long)fileSize:(NSString *)path;

@end
