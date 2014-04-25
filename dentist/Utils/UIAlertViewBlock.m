//
//  UIAlertViewBlock.m
//  HW3Combine
//
//  Created by zhoulong on 14-3-25.
//  Copyright (c) 2014年 willow. All rights reserved.
//

#import "UIAlertViewBlock.h"

@implementation UIAlertViewBlock

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles block:(Block)block {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    self.block = block;
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.block(buttonIndex);
}

@end
