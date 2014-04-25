//
//  NSUtil.h
//  pocketplayer
//
//  Created by zhoulong on 13-11-15.
//  Copyright (c) 2013年 koudaiv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    TimeDay,
    TimeHour,
    TimeMinute
}dayType;


@interface NSUtil : NSObject

/**
 *	@brief	通过图片的名字从文件中读取图片,图片给全名
 *
 *	@param 	name 	图片name,给上扩展名
 *
 *	@return	UIImage
 */
+ (UIImage *)imageWithContentFileByName:(NSString *)name;

/**
 *	@brief	返回时间距现在发生的时间段
 *
 *	@param 	time 	一个指定的时间  "2012-04-19 11:30:08"
 *	@param 	format 	格式化时间     @"yyyy-MM-dd HH:mm:SS"
 *
 *	@return	距离现在多久       
 */
+ (NSString *)returnUploadTime:(NSString *)time format:(NSString *)format;

/**
 *	@brief	通过指定的高度,算出字符串的宽度
 *
 *	@param 	str 	字符串
 *	@param 	fontSize 	字体大小
 *	@param 	height 	固定攻读
 *
 *	@return	字符串的宽度
 */
+ (CGFloat)widthForString:(NSString *)str fontSize:(float)fontSize andHeight:(float)height;

/**
 *	@brief	通过指定的宽度计算高度
 *
 *	@param 	value 	value description
 *	@param 	fontSize 	fontSize description
 *	@param 	width 	width description
 *
 *	@return	return value description
 */
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;


/**
 *	@brief	系统弹出框
 *
 *	@param 	title 	标题
 *	@param 	msg 	提示信息
 *	@param 	cancleTitle 	取消标题
 *	@param 	otherTitle 	其他
 */
+ (void)alertNotice:(NSString *)title withMSG:(NSString *)msg cancleButtonTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherTitle;

/**
 *	@brief	系统弹出框支持显示指定时间
 *
 *	@param 	title 	标题
 *	@param 	msg 	提示信息
 *	@param 	cancleTitle 	取消标题
 *	@param 	otherTitle 	其他
 *  @param  interval  显示多少秒
 */
+ (void)alertNotice:(NSString *)title withMSG:(NSString *)msg cancleButtonTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherTitle hideDelay:(NSTimeInterval)interval;
/**
 *	@brief	格式化时间
 *
 *	@param 	date 	时间
 *	@param 	formatter 	格式
 *
 *	@return	格式化的时间
 */
+ (NSString *)formatterDate:(NSDate *)date formatter:(NSString *)formatter;

/**
 *	@brief	格式化时间
 *
 *	@param 	date 	时间字符串
 *	@param 	formatter 	格式
 *
 *	@return	return value description
 */
+ (NSString *)formatterDateStr:(NSString *)date formatter:(NSString *)formatter;

/**
 *	@brief	得到当前网络状况
 *
 *	@return	得到当前网络状况
 */
//+ (NSString *)netCheck;

/**
 *	@brief	得到当前网络状况
 *
 *	@return	是否链接网络
 */
//+ (BOOL)isNetCheck;

/**
 *	@brief	判断时间间隔
 *
 *	@param 	time 	time description
 *	@param 	format 	format description
 *
 *	@return	return value description
 */
+ (double)DistanceTime:(NSString *)time format:(NSString *)format type:(dayType)type;

/**
 *	@brief	判断时间间隔
 *
 *	@param 	time 	time description
 *	@param 	format 	format description
 *
 *	@return	return value description
 */
+ (NSTimeInterval)distinceTime:(NSString *)time format:(NSString *)format;
/**
 *	@brief	去掉字符串两端的空格
 *
 *	@param 	string 	string description
 *
 *	@return	return value description
 */
+ (NSString *)trimSpace:(NSString *)string;

/**
 *	@brief	返回当前时间
 *
 *	@return	return value description
 */
+ (NSString *)theNowTime;

/**
 *	@brief	得到文件夹下得文件总大小
 *
 *	@param 	dirPath 	dirPath description
 *
 *	@return	return value description
 */
+ (float)dirSizeAtPath:(NSString*)dirPath;

/**
 *	@brief	替换字符
 *
 *	@param 	text 	text description
 *
 *	@return	return value description
 */
+ (NSString *)replaceHTMLString:(NSString *)text;

/**
 *	@brief	缓存路径
 *
 *
 *	@return	return value description
 */
+ (NSString *)saveCachePath;

@end
