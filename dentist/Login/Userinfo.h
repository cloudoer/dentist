//
//  Userinfo.h
//  dentist
//
//  Created by xiaoyuan wang on 4/17/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Userinfo : NSObject <NSCoding>

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, assign) NSInteger  gender;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * realname;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * photo;


//+ (Userinfo *)userinfoFromXMPPvCardTemp:(XMPPvCardTemp *)vCardTemp;
//+ (Userinfo *)userinfoFromXMPPvCardTempStr:(NSString *)vCardTempStr;
+ (Userinfo *)userinfoFromHttpget:(NSDictionary *)dic;


@end
