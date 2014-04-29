//
//  EmojiView.m
//  ChatMessageTableViewController
//
//  Created by zhoulong on 14-4-23.
//  Copyright (c) 2014年 Yongchao. All rights reserved.
//

#import "EmojiView.h"

#define  keyboardHeight 216

#define  choiceBarHeight 35
#define  facialViewWidth 300
#define facialViewHeight 170
#define PAGE_COUNT 9


@implementation EmojiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self setUp];
    }
    return self;
}

- (void)setUp {
    //创建表情键盘
    if (!self.scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), keyboardHeight)];
        for (int i = 0; i < PAGE_COUNT; i++) {
            FacialView *fview = [[FacialView alloc] initWithFrame:CGRectMake(12 + DEVICE_WIDTH * i, 15,
                                                                             facialViewWidth, facialViewHeight)];
            [fview loadFacialView:i size:CGSizeMake(33, 43)];
            fview.delegate = self;
            [_scrollView addSubview:fview];
        }
    }
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator   = NO;
    _scrollView.contentSize                    = CGSizeMake(DEVICE_WIDTH * PAGE_COUNT, keyboardHeight);
    _scrollView.pagingEnabled                  = YES;
    _scrollView.delegate                       = self;

    self.pageControl                           = [[UIPageControl alloc]initWithFrame:CGRectMake((DEVICE_WIDTH - 150) / 2,
                                                                                                HEIGHT(self) - 30,
                                                                                                150, 30)];
    _pageControl.currentPage                   = 0;
    _pageControl.pageIndicatorTintColor        = RGBCOLOR(195, 179, 163);
    _pageControl.currentPageIndicatorTintColor = RGBCOLOR(132, 104, 77);
    _pageControl.numberOfPages                 = PAGE_COUNT;
    
    
    self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 60, HEIGHT(self) - 30, 60, 30)];
    self.sendBtn.titleLabel.font = SYSTEMFONT(16.);
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setBackgroundColor:[UIColor blueColor]];
    
    [_sendBtn addTarget:self action:@selector(sendTo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    [self addSubview:_sendBtn];
   

}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page      = (sender.contentOffset.x + (DEVICE_WIDTH / 2)) / DEVICE_WIDTH;
    _pageControl.currentPage = page;
}

-(void)selectedFacialView:(NSString *)str {
    self.block(str);
}

- (void)emojiSeleted:(EmojiSelected)block {
    self.block = block;
}

- (void)sendTo:(UIButton *)sender {
    self.sendBlock();
}

- (void)emojiSend:(EmojiSend)block {
    self.sendBlock = block;
}
@end
