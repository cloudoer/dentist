//
//  MessageListTableViewController.h
//  dentist
//
//  Created by xiaoyuan wang on 4/24/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"

@interface MessageListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, WEPopoverControllerDelegate, UIPopoverControllerDelegate>
{
    Class popoverClass;
}

@property (nonatomic, retain) WEPopoverController *popoverController;

@end
