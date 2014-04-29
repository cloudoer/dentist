//
//  BuddyRequest.h
//  dentist
//
//  Created by xiaoyuan wang on 4/29/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BuddyRequest : NSManagedObject

@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSNumber * fromMe;

@end
