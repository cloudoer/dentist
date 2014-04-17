//
//  Tools.h
//  dentist
//
//  Created by xiaoyuan wang on 4/17/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPvCardTemp.h"

@interface Tools : NSObject
+ (XMPPvCardTemp *)xmppVCardTempFromVCardStr:(NSString *)vCardStr;
@end
