//
//  BuddyRequest.h
//  dentist
//
//  Created by xiaoyuan wang on 5/3/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BuddyRequest : NSManagedObject

@property (nonatomic, retain) NSNumber * success;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSNumber * fromMe;

@end
