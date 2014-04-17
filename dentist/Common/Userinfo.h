//
//  Userinfo.h
//  dentist
//
//  Created by xiaoyuan wang on 4/17/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Userinfo : NSObject <NSCoding>

@property (nonatomic, copy) NSString *jabberId;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *orgName;
@property (nonatomic, copy) NSString *orgUnit;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *expert;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *avatar_url;

@end
