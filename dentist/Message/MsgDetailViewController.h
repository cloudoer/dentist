//
//  MsgDetailViewController.h
//  dentist
//
//  Created by xiaoyuan wang on 4/24/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "VoicdHUDViewController.h"
#import "Buddy.h"

@interface MsgDetailViewController : JSMessagesViewController <NSFetchedResultsControllerDelegate, HIVoiceDelegate>

@property (nonatomic, copy) NSString *bareJIDStr;
@property (nonatomic, retain) Buddy *theBuddy;

@end
