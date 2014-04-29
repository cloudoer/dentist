//
//  EmojiView.h
//  ChatMessageTableViewController
//
//  Created by zhoulong on 14-4-23.
//  Copyright (c) 2014年 Yongchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacialView.h"

typedef void (^EmojiSelected) (NSString *emotion);
typedef void (^EmojiSend) (void);

@interface EmojiView : UIView<facialViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIButton *sendBtn;

@property (copy, nonatomic) EmojiSelected block;
@property (copy, nonatomic) EmojiSend sendBlock;

- (void)emojiSeleted:(EmojiSelected)block;

- (void)emojiSend:(EmojiSend)block;

@end
