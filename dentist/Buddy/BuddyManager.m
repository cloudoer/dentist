//
//  BuddyManager.m
//  dentist
//
//  Created by xiaoyuan wang on 4/28/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "BuddyManager.h"
#import "Buddy.h"


@implementation BuddyManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static BuddyManager *sharedInstance;

+ (BuddyManager *)sharedBuddyManager
{
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		sharedInstance = [[BuddyManager alloc] init];
	});
	
	return sharedInstance;
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Buddy" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Buddy.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (void)addBuddyWithDictionary:(NSDictionary *)oneBuddy
{
    NSString *entityName = @"Buddy";
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", oneBuddy[@"id"]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || error || matches.count > 1) {
        // something went wrong!
    }else if (matches.count == 1) {
        Buddy *buddy = matches.firstObject;
//        product.number = [NSNumber numberWithInt:(product.number.intValue + 1)];
//        product.addDate = [NSDate date];
        buddy.uid = [NSNumber numberWithInt:[oneBuddy[@"id"] intValue]];
        buddy.username = oneBuddy[@"username"];
        buddy.realname = oneBuddy[@"realname"];
        buddy.phone = oneBuddy[@"phone"];
        buddy.photoStr = oneBuddy[@"photo"];
        buddy.gender = [oneBuddy[@"sex"] isEqualToString:@"1"] ? @"男" : @"女";
        buddy.brand = oneBuddy[@"brand"];
        buddy.jobTitle = oneBuddy[@"job_title"];
        buddy.desc = oneBuddy[@"description"];
        buddy.address = oneBuddy[@"area"];
        buddy.addDate = [NSDate date];
    }else {
        
        Buddy *buddy = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        buddy.uid = [NSNumber numberWithInt:[oneBuddy[@"id"] intValue]];
        buddy.username = oneBuddy[@"username"];
        buddy.realname = oneBuddy[@"realname"];
        buddy.phone = oneBuddy[@"phone"];
        buddy.photoStr = oneBuddy[@"photo"];
        buddy.gender = [oneBuddy[@"sex"] isEqualToString:@"1"] ? @"男" : @"女";
        buddy.brand = oneBuddy[@"brand"];
        buddy.jobTitle = oneBuddy[@"job_title"];
        buddy.desc = oneBuddy[@"description"];
        buddy.address = oneBuddy[@"area"];
        buddy.addDate = [NSDate date];
    }
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

@end
