//
//  UIActionSheetBlock.m
//  HW3Combine
//
//  Created by zhoulong on 14-3-25.
//  Copyright (c) 2014年 willow. All rights reserved.
//

#import "UIActionSheetBlock.h"

@implementation UIActionSheetBlock

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles block:(ActionSheet)block {
    self = [super initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
    self.sheet = block;
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.sheet(actionSheet, buttonIndex);
}

@end
