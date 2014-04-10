//
//  RoomInfo.h
//  dentist
//
//  Created by xiaoyuan wang on 4/10/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomInfo : NSObject

@property (nonatomic, assign) NSInteger roomID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *naturalName;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *creationDate;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, copy) NSString *alias;


+ (RoomInfo *)roomInfoFromDictionary:(NSDictionary *)dict;

@end
