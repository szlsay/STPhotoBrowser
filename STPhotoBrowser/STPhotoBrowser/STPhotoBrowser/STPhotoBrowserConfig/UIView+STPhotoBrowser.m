//
//  UIView+STPhotoBrowser.m
//  STPhotoBrowser
//
//  Created by 沈兆良 on 2017/10/12.
//  Copyright © 2017年 ST. All rights reserved.
//

#import "UIView+STPhotoBrowser.h"

@implementation UIView (STPhotoBrowser)
- (void)setSt_x:(CGFloat)st_x
{
    CGRect frame = self.frame;
    frame.origin.x = st_x;
    self.frame = frame;
}

- (void)setSt_y:(CGFloat)st_y
{
    CGRect frame = self.frame;
    frame.origin.y = st_y;
    self.frame = frame;
}

- (CGFloat)st_x
{
    return self.frame.origin.x;
}

- (CGFloat)st_y
{
    return self.frame.origin.y;
}

- (void)setSt_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setSt_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)st_height
{
    return self.frame.size.height;
}

- (CGFloat)st_width
{
    return self.frame.size.width;
}

- (void)setSt_centerX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)st_centerX
{
    return self.center.x;
}

- (void)setSt_centerY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)st_centerY
{
    return self.center.y;
}

- (void)setSt_size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)st_size
{
    return self.frame.size;
}

- (void)setSt_origin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)st_origin
{
    return self.frame.origin;
}

- (CGFloat)st_left {
    return self.frame.origin.x;
}

- (void)setSt_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)st_top {
    return self.frame.origin.y;
}

- (void)setSt_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)st_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setSt_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)st_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setSt_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

//- (UIView *(^)(UIColor *color)) setColor
//{
//    return ^ (UIColor *color) {
//        self.backgroundColor = color;
//        return self;
//    };
//}
//
//- (UIView *(^)(CGRect frame)) setFrame
//{
//    return ^ (CGRect frame) {
//        self.frame = frame;
//        return self;
//    };
//}
//
//- (UIView *(^)(CGSize size)) setSize
//{
//    return ^ (CGSize size) {
//        self.bounds = CGRectMake(0, 0, size.width, size.height);
//        return self;
//    };
//}
//
//- (UIView *(^)(CGPoint point)) setCenter
//{
//    return ^ (CGPoint point) {
//        self.center = point;
//        return self;
//    };
//}
//
//- (UIView *(^)(NSInteger tag)) setTag
//{
//    return ^ (NSInteger tag) {
//        self.tag = tag;
//        return self;
//    };
//}

- (UIView *)getParsentView:(UIView *)view
{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}

@end
