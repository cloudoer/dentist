//
//  PhotoesView.h
//  dentist
//
//  Created by zhoulong on 14-4-25.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AddPhotoes) (NSInteger buttonIndex);
typedef void (^DeletePhoto) (NSInteger buttonIndex);
@interface PhotoesView : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, copy) AddPhotoes block;
@property (nonatomic, strong) NSMutableArray *photoes;

- (void)selectPhotes:(AddPhotoes)block;

- (void)addPhotoes:(NSArray *)images;

- (void)adjustTheFrame:(int)index;

@end


@interface PhotoView : UIView

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, copy) DeletePhoto block;

- (void)deltePhotoView:(DeletePhoto)block;

@end