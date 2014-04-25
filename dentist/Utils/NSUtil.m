//
//  NSUtil.m
//  pocketplayer
//
//  Created by zhoulong on 13-11-15.
//  Copyright (c) 2013年 koudaiv. All rights reserved.
//

#import "NSUtil.h"

//常用时间格式
#define kFormatterTimeNormal @"yyyy-MM-dd HH:mm:ss"

//当前系统的版本号
#define kDeviceSystemVersion [[UIDevice currentDevice].systemVersion floatValue]

//关于固定路径************************************************************
#define kXSBundlePath [NSBundle mainBundle]
#define kXSDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kXSCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation NSUtil

+ (UIImage *)imageWithContentFileByName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

/*处理返回应该显示的时间*/
+ (NSString *) returnUploadTime:(NSString *)time format:(NSString *)format
{
    //"publish_time": "2012-04-19 11:30:08"    format:@"yyyy-MM-dd HH:mm:SS"
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:format];
    NSDate *d=[date dateFromString:time];
    
    NSTimeInterval late=[d timeIntervalSince1970] * 1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970] * 1;
   
    NSString *timeString;
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
        //        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        //        [dateformatter setDateFormat:@"HH:mm"];
        //        timeString = [NSString stringWithFormat:@"今天 %@",[dateformatter stringFromDate:d]];
        //        [dateformatter release];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
        //        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        //        [dateformatter setDateFormat:@"YY-MM-dd HH:mm"];
        //        timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:d]];
        //        [dateformatter release];
    }
    return timeString;
}

+ (CGFloat)widthForString:(NSString *)str fontSize:(float)fontSize andHeight:(float)height {
    CGFloat width = 0;
    if (kDeviceSystemVersion >= 7) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
        width = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        
    } else {
        
        CGSize sizeToFit = [str sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
        width = sizeToFit.width;
    }
    
    return width;
}

+ (void)alertNotice:(NSString *)title withMSG:(NSString *)msg cancleButtonTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherTitle
{
    UIAlertView *alert;
    if([otherTitle isEqualToString:@""])
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancleTitle otherButtonTitles:nil,nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancleTitle otherButtonTitles:otherTitle,nil];
    [alert show];
}

+ (void)alertNotice:(NSString *)title withMSG:(NSString *)msg cancleButtonTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherTitle hideDelay:(NSTimeInterval)interval
{
    UIAlertView *alert;
    if([otherTitle isEqualToString:@""])
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancleTitle otherButtonTitles:nil,nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancleTitle otherButtonTitles:otherTitle,nil];
    [alert show];

    if (interval) {
        double delayInSeconds = interval;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
}

+ (NSString *)formatterDate:(NSDate *)date formatter:(NSString *)formatter {
    NSString *str = [[NSString alloc] init];
    NSDateFormatter *datef=[[NSDateFormatter alloc] init];
    [datef setDateFormat:formatter];
    str = [datef stringFromDate:date];
    return str;
}

+ (NSString *)formatterDateStr:(NSString *)date formatter:(NSString *)formatter {
    
    NSDateFormatter *datef=[[NSDateFormatter alloc] init];
    [datef setDateFormat:kFormatterTimeNormal];
    NSDate *date_ = [datef dateFromString:date];
    [datef setDateFormat:formatter];
    return  [datef stringFromDate:date_];
}

    //"publish_time": "2012-04-19 11:30:08"    format:@"yyyy-MM-dd HH:mm:SS"
+ (double)DistanceTime:(NSString *)time format:(NSString *)format type:(dayType)type
{

    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:format];
    NSDate *d = [date dateFromString:time];
    NSTimeInterval late = [d timeIntervalSince1970] * 1;
   
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970] * 1;

    NSTimeInterval cha = now - late;
    
    switch (type) {
        case TimeMinute:
        {
            return cha / 60;
        }
        case TimeHour:
        {
            return cha / (60*60);
        }
        case TimeDay:
        {
            return cha / (60*60*24);
        }
    }
    return cha / (60*60);
}

+ (NSTimeInterval)distinceTime:(NSString *)time format:(NSString *)format {
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:format];
    NSDate *d = [date dateFromString:time];
    NSTimeInterval late = [d timeIntervalSince1970] * 1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970] * 1;
    
    NSTimeInterval cha = now - late;
    return cha;
}

+ (NSString *)trimSpace:(NSString *)string {
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *str = [[NSString alloc]initWithString:[string stringByTrimmingCharactersInSet:whiteSpace]];
    return str;
}

+ (NSString *)theNowTime {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *nowDate = [formatter stringFromDate:now];
    return nowDate;
}

+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGFloat height = 0;
    if (kDeviceSystemVersion >= 7 ) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
        height = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    } else {
        CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
        height = sizeToFit.height;
    }
    return height;
}

/** 遍历文件夹获得文件夹大小，单位M */
+ (float)dirSizeAtPath:(NSString*)dirPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:dirPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:dirPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [dirPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0 * 1024.0);
}

/** 单个文件的大小 */
+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (NSString *)replaceHTMLString:(NSString *)text {
    NSString *str = text;
    if ([str rangeOfString:@"&lt;"].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    }
    
    if ([str rangeOfString:@"&gt;"].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    }
    
    if ([str rangeOfString:@"&amp;"].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    }
    
    if ([str rangeOfString:@"&nbsp;"].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }
    
    if ([str rangeOfString:@"&quot;"].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    }
    
    if ([str rangeOfString:@"&apos;"].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"&apos;"  withString:@"\""];
    }
    
    return str;
}

+ (NSString *)saveCachePath {
    NSString *cachePath = [kXSCachesPath stringByAppendingPathComponent:@"CacheTemp/"];
    // 判断文件主目录是否存在,如果不存在则创建,否则下载文件保存失败
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return cachePath;
}


@end
