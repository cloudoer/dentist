//
//  MsgDetailViewController.h
//  dentist
//
//  Created by xiaoyuan wang on 4/24/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"

@interface MsgDetailViewController : JSMessagesViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, copy) NSString *bareJIDStr;

@end
