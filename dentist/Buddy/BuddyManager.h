//
//  BuddyManager.h
//  dentist
//
//  Created by xiaoyuan wang on 4/28/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Buddy.h"

@interface BuddyManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (BuddyManager *)sharedBuddyManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


- (void)addBuddyWithDictionary:(NSDictionary *)oneBuddy;
- (void)removeBuddy:(Buddy *)theBuddy;
- (void)removeAllBuddys;

- (void)addBuddyNewMessageFrom:(NSString *)user;
- (void)removeBuddyNewMessageFrom:(NSString *)user;
- (NSInteger)numberOfNewMessageUser;
- (BOOL)containBuddyNewMessegeFrom:(NSString *)user;


// buddy
- (Buddy *)buddyWithPhoneNum:(NSString *)phone;

- (void)buddyRequestAddedFromMe:(BOOL)isFromMe Friend:(NSString *)user success:(BOOL)success;
- (void)buddyRequestReceivedFriend:(NSString *)user;
- (NSArray *)buddyRequestsArray;


// buddy request



@end
