//
//  Buddy.h
//  dentist
//
//  Created by xiaoyuan wang on 4/29/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Buddy : NSManagedObject

@property (nonatomic, retain) NSDate * addDate;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * photoStr;
@property (nonatomic, retain) NSString * realname;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * username;

@end
