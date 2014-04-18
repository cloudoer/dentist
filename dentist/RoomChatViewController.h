//
//  RoomChatViewController.h
//  dentist
//
//  Created by xiaoyuan wang on 4/18/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "RoomInfo.h"

@interface RoomChatViewController : JSMessagesViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) RoomInfo *oneRoom;

@end
