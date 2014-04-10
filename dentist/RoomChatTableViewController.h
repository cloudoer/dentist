//
//  RoomChatTableViewController.h
//  dentist
//
//  Created by xiaoyuan wang on 4/10/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomInfo.h"

@interface RoomChatTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) RoomInfo *oneRoom;

@end
