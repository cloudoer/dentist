//
//  UIAlertViewBlock.h
//  HW3Combine
//
//  Created by zhoulong on 14-3-25.
//  Copyright (c) 2014年 willow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(NSInteger buttonIndex);

@interface UIAlertViewBlock : UIAlertView <UIAlertViewDelegate>

@property (nonatomic, copy)Block block;

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles block:(Block)block;

@end
