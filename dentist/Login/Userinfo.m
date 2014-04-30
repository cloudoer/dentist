//
//  Userinfo.m
//  dentist
//
//  Created by xiaoyuan wang on 4/17/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "Userinfo.h"

@implementation Userinfo

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.uid      = [aDecoder decodeObjectForKey:@"jabberId"];
        self.realname = [aDecoder decodeObjectForKey:@"realname"];
        self.gender   = [[aDecoder decodeObjectForKey:@"sex"] integerValue];
        self.address  = [aDecoder decodeObjectForKey:@"area"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.photo    = [aDecoder decodeObjectForKey:@"photo"];
        self.jobTitle = [aDecoder decodeObjectForKey:@"title"];
        self.desc     = [aDecoder decodeObjectForKey:@"description"];
        self.photo    = [aDecoder decodeObjectForKey:@"avatar_url"];
        self.brand    = [aDecoder decodeObjectForKey:@"brand"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uid forKey:@"jabberId"];
    [aCoder encodeObject:self.realname forKey:@"realname"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.gender] forKey:@"sex"];
    [aCoder encodeObject:self.address forKey:@"area"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.photo forKey:@"photo"];
    [aCoder encodeObject:self.jobTitle forKey:@"title"];
    [aCoder encodeObject:self.desc forKey:@"description"];
    [aCoder encodeObject:self.photo forKey:@"avatar_url"];
    [aCoder encodeObject:self.brand forKey:@"brand"];
}


+ (Userinfo *)userinfoFromHttpget:(NSDictionary *)dic {
    Userinfo *userinfo = [[Userinfo alloc] init];
    userinfo.uid       = dic[@"id"];
    userinfo.username  = dic[@"username"];
    userinfo.realname  = dic[@"realname"];
    userinfo.phone     = dic[@"phone"];
    userinfo.photo     = dic[@"photo"];
    userinfo.gender    = [dic[@"sex"] integerValue];
    userinfo.desc      = dic[@"description"];
    userinfo.jobTitle  = dic[@"job_title"];
    userinfo.brand     = dic[@"brand"];
    userinfo.address   = dic[@"area"];
    return userinfo;
}

/*
+ (Userinfo *)userinfoFromXMPPvCardTemp:(XMPPvCardTemp *)vCardTemp
{
    Userinfo *userinfo = [[Userinfo alloc] init];
    userinfo.jabberId = vCardTemp.jabberId;
    userinfo.realname = vCardTemp.realname;
    userinfo.sex = vCardTemp.sex;
    userinfo.province = vCardTemp.province;
    userinfo.city = vCardTemp.city;
    userinfo.area = vCardTemp.area;
    userinfo.orgName = vCardTemp.orgName;
    if (vCardTemp.orgUnits.count > 0) {
        userinfo.orgUnit = vCardTemp.orgUnits[0];
    }
    
    userinfo.department = vCardTemp.department;
    userinfo.title = vCardTemp.title;
    userinfo.expert = vCardTemp.expert;
    userinfo.description = vCardTemp.description;
    userinfo.avatar_url = vCardTemp.avatar_url;
    
    
    return userinfo;
}

+ (Userinfo *)userinfoFromXMPPvCardTempStr:(NSString *)vCardTempStr
{
    XMPPvCardTemp *vCardTemp = [Tools xmppVCardTempFromVCardStr:vCardTempStr];
    Userinfo *curUser = [self userinfoFromXMPPvCardTemp:vCardTemp];
    return curUser;
}

 */


@end
