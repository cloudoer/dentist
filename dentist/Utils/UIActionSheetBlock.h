//
//  UIActionSheetBlock.h
//  HW3Combine
//
//  Created by zhoulong on 14-3-25.
//  Copyright (c) 2014年 willow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionSheet)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface UIActionSheetBlock : UIActionSheet <UIActionSheetDelegate>

@property (nonatomic, copy) ActionSheet sheet;

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles block:(ActionSheet)block;

@end
