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

#define BaseURLString  @"http://115.28.12.26/"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



#define URL_PATH_ROOM_LIST @"dentist/index.php?r=api/RoomList"

#endif
