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
        self.jabberId = [aDecoder decodeObjectForKey:@"jabberId"];
        self.realname = [aDecoder decodeObjectForKey:@"realname"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.area = [aDecoder decodeObjectForKey:@"area"];
        self.orgName = [aDecoder decodeObjectForKey:@"orgName"];
        self.orgUnit = [aDecoder decodeObjectForKey:@"orgUnit"];
        self.department = [aDecoder decodeObjectForKey:@"department"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.expert = [aDecoder decodeObjectForKey:@"expert"];
        self.description = [aDecoder decodeObjectForKey:@"description"];
        self.avatar_url = [aDecoder decodeObjectForKey:@"avatar_url"];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.jabberId forKey:@"jabberId"];
    [aCoder encodeObject:self.realname forKey:@"realname"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.area forKey:@"area"];
    [aCoder encodeObject:self.orgName forKey:@"orgName"];
    [aCoder encodeObject:self.orgUnit forKey:@"orgUnit"];
    [aCoder encodeObject:self.department forKey:@"department"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.expert forKey:@"expert"];
    [aCoder encodeObject:self.description forKey:@"description"];
    [aCoder encodeObject:self.avatar_url forKey:@"avatar_url"];
}


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

@end
