//
//  TagViewController.h
//  dentist
//
//  Created by zhoulong on 14-4-25.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GetSelectedTags) (NSMutableArray *array, NSMutableArray *selectedIndex);

@interface TagViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *selecteds;
@property (nonatomic, strong) NSMutableArray *selectedTags;
@property (nonatomic, copy) GetSelectedTags block;

- (void)getSelectedTags:(GetSelectedTags)block;

@end
