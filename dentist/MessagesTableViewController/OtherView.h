//
//  OtherView.h
//  ChatMessageTableViewController
//
//  Created by zhoulong on 14-4-24.
//  Copyright (c) 2014年 Yongchao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    OtherBtnTypePhoto = 0,
    OtherBtnTypeCamera
}OtherBtnType;

typedef void (^OtherBtnClickBlock) (UIButton *sender);

@interface OtherView : UIView

@property (nonatomic, copy) OtherBtnClickBlock block;

- (void)otherBtnClickBlock:(OtherBtnClickBlock)block;

@end
