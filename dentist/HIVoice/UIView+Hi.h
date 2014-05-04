//
//  UIView+Hi.h
//  baiduHi
//
//  Created by Hua Cao on 13-12-7.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGRect HiRectSetX(CGRect rect, CGFloat x);
extern CGRect HiRectSetY(CGRect rect, CGFloat y);
extern CGRect HiRectSetWidth(CGRect rect, CGFloat width);
extern CGRect HiRectSetHeight(CGRect rect, CGFloat height);
extern CGRect HiRectSetOrigin(CGRect rect, CGPoint origin);
extern CGRect HiRectSetSize(CGRect rect, CGSize size);
extern CGRect HiRectSetZeroOrigin(CGRect rect);
extern CGRect HiRectSetZeroSize(CGRect rect);
extern CGSize HiSizeAspectScaleToSize(CGSize size, CGSize toSize);
extern CGRect HiRectAddPoint(CGRect rect, CGPoint point);
extern CGRect HiRectAddSize(CGRect rect, CGSize size);

@interface UIView (Hi)

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;
- (void)setZeroOrigin;
- (void)setZeroSize;
- (void)sizeAspectScaleToSize:(CGSize)toSize;
- (void)frameAddPoint:(CGPoint)point;
- (void)frameAddSize:(CGSize)size;

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)minX;
- (CGFloat)minY;
- (CGFloat)maxX;
- (CGFloat)maxY;
- (CGPoint)origin;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
//get the view's inner center
- (CGPoint)innerCenter;

//
- (void)removeAllSubviewOfClass:(Class)aClass;
- (void)removeFromSuperviewWhenSelfIsKindOfClass:(Class)aClass;
- (void)removeFromSuperviewWhenSelfIsKindOfClassWithString:(NSString *)aClassString;

//
- (UIView *)superviewOfClass:(Class)aClass;

//find view's controller or superview's controller
- (UIViewController *)viewController;

@end

#pragma mark - Snapshot
@interface UIView (Snapshot)

- (UIImage *) snapshot;
- (UIImageView *) snapshotView;

@end

#pragma mark - Layout
// TODO: 为UIView增加自动布局方法，简化界面开发
@interface UIView (Layout)

@end
