//
//  ProfileTableViewController.h
//  dentist
//
//  Created by xiaoyuan wang on 4/30/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Buddy.h"

typedef enum {
    PROFILE_BACK_TYPE_NORMAL = 0,
    PROFILE_BACK_TYPE_CHAT
}PROFILE_BACK_TYPE;

@interface ProfileTableViewController : UITableViewController

@property (nonatomic, retain) Buddy *buddy;

@property (nonatomic) PROFILE_BACK_TYPE type;

@end
