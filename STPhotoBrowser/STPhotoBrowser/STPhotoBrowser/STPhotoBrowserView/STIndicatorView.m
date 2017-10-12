//
//  STIndicatorView.m
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/15.
//  Copyright © 2016年 ST. All rights reserved.
//

#import "STIndicatorView.h"

static CGFloat const WidthIndicator = 42;
static CGFloat const marginXIndicator = 10;
static CGFloat const marginXSmallIndicator = 10;
@implementation STIndicatorView

#pragma mark - --- 1.lift cycle 生命周期 ---
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
        self.clipsToBounds = YES;
        self.viewMode = STIndicatorViewModeLoopDiagram;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef content = UIGraphicsGetCurrentContext();
    CGFloat centerX = rect.size.width / 2;
    CGFloat centerY = rect.size.height / 2;
    [[UIColor whiteColor] set];
    
    switch (self.viewMode) {
        case STIndicatorViewModeLoopDiagram:{
            CGContextSetLineWidth(content, 2);
            CGContextSetLineCap(content, kCGLineCapRound);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
            CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - marginXIndicator;
            CGContextAddArc(content, centerX, centerY, radius, - M_PI * 0.5, to, 0);
            CGContextStrokePath(content);
        }break;
        default:{
            CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - marginXSmallIndicator;
            
            CGFloat contentW = radius * 2 + marginXIndicator;
            CGFloat contentH = contentW;
            CGFloat contentX = (rect.size.width - contentW) * 0.5;
            CGFloat contentY = (rect.size.height - contentH) * 0.5;
            CGContextAddEllipseInRect(content, CGRectMake(contentX, contentY, contentW, contentH));
            CGContextFillPath(content);
            
            [[UIColor lightGrayColor] set];
            CGContextMoveToPoint(content, centerX, centerY);
            CGContextAddLineToPoint(content, centerX, 0);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
            CGContextAddArc(content, centerX, centerY, radius, - M_PI * 0.5, to, 1);
            CGContextClosePath(content);
            
            CGContextFillPath(content);
        }break;
    }
}
#pragma mark - --- 2.delegate 视图委托 ---

#pragma mark - --- 3.event response 事件相应 ---

#pragma mark - --- 4.private methods 私有方法 ---

#pragma mark - --- 5.setters 属性 ---
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
    // 1.当进度完成时，从父视图移除
    if (progress >= 1) {
        [self removeFromSuperview];
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = WidthIndicator;
    frame.size.height = WidthIndicator;
    self.layer.cornerRadius = WidthIndicator / 2;
    [super setFrame:frame];
}
#pragma mark - --- 6.getters 属性 —--


@end
