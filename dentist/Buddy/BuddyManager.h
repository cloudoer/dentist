//
//  BuddyManager.h
//  dentist
//
//  Created by xiaoyuan wang on 4/28/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuddyManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (BuddyManager *)sharedBuddyManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


- (void)addBuddyWithDictionary:(NSDictionary *)oneBuddy;

@end
