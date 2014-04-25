//
//  OtherView.m
//  ChatMessageTableViewController
//
//  Created by zhoulong on 14-4-24.
//  Copyright (c) 2014年 Yongchao. All rights reserved.
//

#import "OtherView.h"


@interface OtherView()


@property (nonatomic, strong) NSArray *items;
@end

@implementation OtherView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    self.items = @[@"照片", @"拍摄"];
    for (int i = 0; i < self.items.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10 + (10 + 60) * i, 10, 60, 60)];
        [btn setTitle:_items[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor greenColor]];
        [btn addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)otherBtnClick:(UIButton *)sender {
    self.block(sender);
}

- (void)otherBtnClickBlock:(OtherBtnClickBlock)block {
    self.block = block;
}
@end
