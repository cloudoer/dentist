//
//  Define.h
//  dentist
//
//  Created by xiaoyuan wang on 4/8/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#ifndef dentist_Define_h
#define dentist_Define_h

#define kXMPPjoyJID @"kXMPPmyJID"
#define kXMPPjoyPassword @"kXMPPmyPassword"

#define kXMPPLoginSuccess @"kXMPPLoginSuccess"

#define BaseURLString  @"http://tijian8.cn/yayibao/"
//#define BaseURLString  @"http://tijian8.cn/"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define DEFAULT_THEME_COLOR RGBCOLOR(34., 39., 42.)
#define DEFAULT_NAVIGATION_BAR_TINT_COLOR self.navigationController.navigationBar.barTintColor = RGBCOLOR(34., 39., 42.);
#define DEFAULT_NAVIGATION_TINT_COLOR self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

#define BASE_URL @"http://tijian8.cn/yayibao/"

//* 我的病历*********************
#define RELATIVE_URL_RECORDS_INDEX(USERID) [NSString stringWithFormat:@"index.php?r=app/cases/index/uid/%@", (USERID)]
#define RELATIVE_URL_RECORDS_SUBMIT  @"index.php?r=app/cases/submit"
#define RELATIVE_URL_MY_RECORDS(USERID) [NSString stringWithFormat:@"index.php?r=app/cases/listByUid/uid/%@", (USERID)]
#define RELATIVE_URL_RECORDS_SUBMIT_TEST  @"index.php?r=app/cases/test"

//*  资讯  ************************
#define RELATIVE_URL_NEWS_INDEX(USERID) [NSString stringWithFormat:@"index.php?r=app/news/index/uid/%@", (USERID)]

#define URL_PATH_ROOM_LIST @"dentist/index.php?r=api/RoomList"
#define URL_PATH_ONE_VCARD @"dentist/index.php?r=api/GetVcard"
#define URL_PATH_ALL_BUDDY @"index.php?r=app/user/getFriends"

#define URL_PATH_REG_CAPTCHA @"index.php?r=app/user/getCaptchaForRegister"
#define URL_PATH_REG_DONE @"index.php?r=app/user/register"

#endif
