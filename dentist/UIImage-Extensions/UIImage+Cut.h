//
//  UIImage+Cut.h
//  HW3Combine
//
//  Created by zhoulong on 14-2-13.
//  Copyright (c) 2014年 willow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Cut)

- (UIImage *)clipImageWithScaleWithsize:(CGSize)asize;
- (UIImage *)clipImageWithScaleWithsize:(CGSize)asize roundedCornerImage:(NSInteger)roundedCornerImage borderSize:(NSInteger)borderSize;

@end
