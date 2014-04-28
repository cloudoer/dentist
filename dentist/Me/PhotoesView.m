//
//  PhotoesView.m
//  dentist
//
//  Created by zhoulong on 14-4-25.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "PhotoesView.h"
#import "UIAlertViewBlock.h"
#import "UIActionSheetBlock.h"

#define kCarPhotoWidth 90
#define kCarPhotoHeight 67.5
#define kMarginSpace    16
#define MAIN_HEIGHT 84

@class PhotoView;
@implementation PhotoesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    self.images  = [NSMutableArray array];
    self.photoes = [NSMutableArray array];
    
    self.mainView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setTitle:@"+" forState:UIControlStateNormal];
    self.addBtn.titleLabel.font = SYSTEMFONT(40.);
    [self.addBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.addBtn.frame = CGRectMake(kMarginSpace, (HEIGHT(self) - kCarPhotoHeight) / 2, kCarPhotoWidth, kCarPhotoHeight);
    [self.addBtn addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(_addBtn, 0, 1., [UIColor greenColor]);
    
    [self addSubview:_mainView];
    [self.mainView addSubview:self.addBtn];
}

- (void)selectPhoto:(UIButton *)sender {
    UIActionSheetBlock *sheet = [[UIActionSheetBlock alloc] initWithTitle:@"添加照片" cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"相机" block:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        
         dispatch_async(dispatch_get_main_queue(), ^{
             self.block(buttonIndex);
         });
    }];
    [sheet showInView:self];
}

- (void)selectPhotes:(AddPhotoes)block {
    self.block = block;
}

- (void)addPhotoes:(NSArray *)images {
    int index = self.images.count;
    [self.images addObjectsFromArray:images];
    for (int i = 0; i < images.count; i++) {
        PhotoView *photo = [[PhotoView alloc] initWithFrame:CGRectMake((kMarginSpace + kCarPhotoWidth) * (index + i) , 0, kCarPhotoWidth + 10, MAIN_HEIGHT)];
        photo.image.image = images[i];
        photo.tag = index + i;
        [self.mainView addSubview:photo];
        [self.photoes addObject:photo];
        [photo deltePhotoView:^(NSInteger buttonIndex) {
            [self adjustTheFrame:buttonIndex];
        }];
    }
    
    CGRect frame      = self.addBtn.frame;
    frame.origin.x    =  (kMarginSpace + kCarPhotoWidth) * self.images.count;
    self.addBtn.frame = frame;
    
    self.mainView.contentSize = CGSizeMake(kMarginSpace + (kMarginSpace + kCarPhotoWidth) * (self.images.count + 1), HEIGHT(_mainView));
}


- (void)adjustTheFrame:(int)index {
    [self.images removeObjectAtIndex:index];
    PhotoView *view = self.photoes[index];
    view.alpha = 0;
    [self.photoes removeObjectAtIndex:index];
    
    [UIView animateWithDuration:.3 animations:^{
        for (int i = index; i < self.photoes.count; i++) {
            CGRect frame = ((PhotoView *)self.photoes[i]).frame;
            frame.origin.x -= (kMarginSpace + kCarPhotoWidth);
            ((PhotoView *)self.photoes[i]).frame = frame;
        }
        CGRect frame = self.addBtn.frame;
        frame.origin.x -= (kMarginSpace + kCarPhotoWidth);
        self.addBtn.frame = frame;
        self.mainView.contentSize = CGSizeMake(kMarginSpace + (kMarginSpace + kCarPhotoWidth) * (self.images.count + 1), HEIGHT(_mainView));
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    
}

@end

@implementation PhotoView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    self.image                        = [[UIImageView alloc] initWithFrame:CGRectMake(5,
                                                                                      (HEIGHT(self) - kCarPhotoHeight) / 2.,
                                                                                      kCarPhotoWidth,
                                                                                      kCarPhotoHeight)];
    self.image.userInteractionEnabled = YES;
    self.image.backgroundColor        = [UIColor grayColor];

    // 删除
    UIImage *imgBtnDel                = [UIImage imageNamed:@"publish_delete"];
    UIButton *btnDel                  = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH(_image) - 10,
                                                                  Y(_image) - 5,
                                                                  imgBtnDel.size.width,
                                                                  imgBtnDel.size.height)];
    btnDel.exclusiveTouch             = YES;
    [btnDel setImage:imgBtnDel forState:UIControlStateNormal];
    [btnDel addTarget:self action:@selector(onClickDel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_image];
    [self addSubview:btnDel];
}

- (void)onClickDel:(UIButton *)sender {
    UIAlertViewBlock *alert = [[UIAlertViewBlock alloc] initWithTitle:@"提示" message:@"确定删除" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (buttonIndex) {
                int index = X(sender.superview) / (kMarginSpace + kCarPhotoWidth);
                self.block(index);
            }
        });
        
    }];
    [alert show];
}

- (void)deltePhotoView:(DeletePhoto)block {
    self.block = block;
}
@end
