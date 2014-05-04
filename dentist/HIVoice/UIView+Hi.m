//
//  UIView+Hi.m
//  baiduHi
//
//  Created by Hua Cao on 13-12-7.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "UIView+Hi.h"

CGRect HiRectSetX(CGRect rect, CGFloat x) {
	return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
}


CGRect HiRectSetY(CGRect rect, CGFloat y) {
	return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
}


CGRect HiRectSetWidth(CGRect rect, CGFloat width) {
	return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
}


CGRect HiRectSetHeight(CGRect rect, CGFloat height) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
}

CGRect HiRectSetOrigin(CGRect rect, CGPoint origin) {
	return CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
}


CGRect HiRectSetSize(CGRect rect, CGSize size) {
	return CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
}


CGRect HiRectSetZeroOrigin(CGRect rect) {
	return CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height);
}


CGRect HiRectSetZeroSize(CGRect rect) {
	return CGRectMake(rect.origin.x, rect.origin.y, 0.0f, 0.0f);
}


CGSize HiSizeAspectScaleToSize(CGSize size, CGSize toSize) {
	// Probably a more efficient way to do this...
	CGFloat aspect = 1.0f;
	
	if (size.width > toSize.width) {
		aspect = toSize.width / size.width;
	}
	
	if (size.height > toSize.height) {
		aspect = fminf(toSize.height / size.height, aspect);
	}
    
	return CGSizeMake(size.width * aspect, size.height * aspect);
}


CGRect HiRectAddPoint(CGRect rect, CGPoint point) {
	return CGRectMake(rect.origin.x + point.x, rect.origin.y + point.y, rect.size.width, rect.size.height);
}

CGRect HiRectAddSize(CGRect rect, CGSize size) {
    return HiRectSetSize(rect, CGSizeMake(rect.size.width + size.width,
                                         rect.size.height + size.height));
}


@implementation UIView (Hi)

//////////////
- (void)setX:(CGFloat)x{
    self.frame = HiRectSetX(self.frame, x);
}
- (void)setY:(CGFloat)y{
    self.frame = HiRectSetY(self.frame, y);
}
- (void)setWidth:(CGFloat)width{
    self.frame = HiRectSetWidth(self.frame, width);
}
- (void)setHeight:(CGFloat)height{
    self.frame = HiRectSetHeight(self.frame, height);
}
- (void)setOrigin:(CGPoint)origin{
    self.frame = HiRectSetOrigin(self.frame, origin);
}
- (void)setSize:(CGSize)size{
    self.frame = HiRectSetSize(self.frame, size);
}
- (void)setZeroOrigin{
    self.frame = HiRectSetZeroOrigin(self.frame);
}
- (void)setZeroSize{
    self.frame = HiRectSetZeroSize(self.frame);
}
- (void)sizeAspectScaleToSize:(CGSize)toSize{
    [self setSize:HiSizeAspectScaleToSize(self.frame.size, toSize)];
}
- (void)frameAddPoint:(CGPoint)point{
    self.frame = HiRectAddPoint(self.frame, point);
}
- (void)frameAddSize:(CGSize)size{
    self.frame = HiRectAddSize(self.frame, size);
}

/////////////
- (CGFloat)x {
    return self.frame.origin.x;
}
- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)minX {
    return self.frame.origin.x;
}
- (CGFloat)minY {
    return self.frame.origin.y;
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (CGPoint)origin {
    return self.frame.origin;
}
- (CGFloat)width {
    return self.frame.size.width;
}
- (CGFloat)height {
    return self.frame.size.height;
}
- (CGSize)size {
    return self.frame.size;
}
- (CGPoint)innerCenter {
    return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

/////////////
- (void)removeAllSubviewOfClass:(Class)aClass {
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperviewWhenSelfIsKindOfClassWithString:)
                                     withObject:NSStringFromClass(aClass)];
}
- (void)removeFromSuperviewWhenSelfIsKindOfClass:(Class)aClass {
	
    if ([self isKindOfClass:aClass]) {
        [self removeFromSuperview];
    }
}
- (void)removeFromSuperviewWhenSelfIsKindOfClassWithString:(NSString *)aClassString {
    [self removeFromSuperviewWhenSelfIsKindOfClass:NSClassFromString(aClassString)];
}

/////////////
- (UIView *)superviewOfClass:(Class)aClass
{
	if (self.superview) {
		if ([self.superview isKindOfClass:aClass]) {
			return self.superview;
		}
        else {
			return [self.superview superviewOfClass:aClass];
		}
	}
    else {
		return nil;
	}
}

/////////////
- (UIViewController *)viewController
{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    }
    else if ([nextResponder isKindOfClass:[UIView class]]){
        return [[self superview] viewController];
    }
    else {
        return nil;
    }
}

@end

#pragma mark - Snapshot
@implementation UIView (Snapshot)

- (UIImage *)snapshot {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [[UIScreen mainScreen] scale]);
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}

- (UIImageView *)snapshotView {
    UIImageView * snapshotView = [[UIImageView alloc] initWithImage:[self snapshot]];
    return snapshotView;
}

@end

#pragma mark - Layout
@implementation UIView (Layout)

- (UIImage *)snapshot {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [[UIScreen mainScreen] scale]);
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}

- (UIImageView *)snapshotView {
    UIImageView * snapshotView = [[UIImageView alloc] initWithImage:[self snapshot]];
    return snapshotView;
}

@end
