//
//  STAlertView.m
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/17.
//  Copyright © 2016年 ST. All rights reserved.
//

#import "STAlertView.h"
#import "STConfig.h"

static CGFloat const WAlert = 154;
static CGFloat const HAlert = 112;

@interface STAlertView()
/** 1.标题 */
@property (nonatomic, strong, nullable)UILabel *labelTitle;
/** 2.图片 */
@property (nonatomic, strong, nullable)UIImageView *imageView;
@end

@implementation STAlertView

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, WAlert, HAlert);
         [self setupUI];
        
      
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    frame = CGRectMake(0, 0, WAlert, HAlert);
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self setBackgroundColor:RGBA(0, 0, 0, 115.0/255)];
    [self setClipsToBounds:YES];
    [self.layer setCornerRadius:2];
    [self.layer setOpacity:1.0];
    
    [self addSubview:self.labelTitle];
    [self addSubview:self.imageView];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    [UIView animateKeyframesWithDuration:0.5
                                   delay:0.5
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
                                     [self.layer setOpacity:0.0];
                                 } completion:^(BOOL finished) {
                                     [self removeFromSuperview];
                                 }];
}

- (void)setStyle:(STAlertViewStyle)style
{
    _style = style;
    
    if (style == STAlertViewStyleError) {
        [self.labelTitle setText:@"图片保存出错"];
        [self.imageView setImage:[UIImage imageNamed:@"alert_error_icon"]];
    }else{
        [self.labelTitle setText:@"图片已保存"];
        [self.imageView setImage:[UIImage imageNamed:@"alert_success_icon"]];
    }
}


- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        CGFloat titleX = 0;
        CGFloat titleY = self.height/2 - STMarginSmall;
        CGFloat titleW = self.width;
        CGFloat titleH = self.height/2;
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        [_labelTitle setTextColor:[UIColor whiteColor]];
        [_labelTitle setTextAlignment:NSTextAlignmentCenter];
        [_labelTitle setFont:[UIFont systemFontOfSize:15]];
    }
    return _labelTitle;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        CGFloat imageW = 40;
        CGFloat imageH = 40;
        CGFloat imageCenterX = self.width / 2;
        CGFloat imageCenterY = (self.height - imageH) / 2 + STMargin;
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageH)];
        [_imageView setCenter:CGPointMake(imageCenterX, imageCenterY)];
    }
    return _imageView;
}
@end
