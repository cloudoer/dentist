//
//  RoomInfo.m
//  dentist
//
//  Created by xiaoyuan wang on 4/10/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "RoomInfo.h"

@implementation RoomInfo


+ (RoomInfo *)roomInfoFromDictionary:(NSDictionary *)dict;
{
    RoomInfo *oneRoom = [[RoomInfo alloc] init];
    oneRoom.roomID = [dict[@"roomID"] integerValue];
    oneRoom.name = dict[@"name"];
    oneRoom.naturalName = dict[@"naturalName"];
    oneRoom.description = dict[@"description"];
    oneRoom.creationDate = dict[@"creationDate"];
    oneRoom.username = dict[@"username"];
    oneRoom.isCollection = [dict[@"isCollection"] intValue] == 1;
    oneRoom.alias = dict[@"alias"];
    oneRoom.vCardStr = dict[@"vcard"];
    
    return oneRoom;
}

@end
