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
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *imagesHl;
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
   
    self.items    = @[@"照片", @"拍摄"];
    self.images   = @[@"tool_photo", @"tool_camera"];
    self.imagesHl = @[@"tool_photo_hl", @"tool_camera_hl"];
    
    for (int i = 0; i < self.items.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(21 + (21 + 53) * i, 10, 53, 55)];
        btn.tag = i;
        
        [btn setBackgroundImage:[UIImage imageNamed:_images[i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:_imagesHl[i]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(21 + (21 + 53) * i,
                                                                        10 + 55 + 5, 53, 20)];
        label.text          = self.items[i];
        label.font          = SYSTEMFONT(14.);
        label.textColor     = [UIColor grayColor];
        label.textAlignment = TextAlignmentCenter;
        [self addSubview:label];
    }
}

- (void)otherBtnClick:(UIButton *)sender {
    self.block(sender);
}

- (void)otherBtnClickBlock:(OtherBtnClickBlock)block {
    self.block = block;
}
@end
