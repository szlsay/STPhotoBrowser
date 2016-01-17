//
//  STPhotoBrowserView.m
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/15.
//  Copyright © 2016年 ST. All rights reserved.
//

#import "STPhotoBrowserView.h"
#import "STIndicatorView.h"
#import "STConfig.h"
#import <UIImageView+WebCache.h>

@interface STPhotoBrowserView()<UIScrollViewDelegate>

@property (nonatomic, strong, nullable)STIndicatorView *indicatorView; //

@property (nonatomic, strong, nullable)UIButton *buttonReload; //
@property (nonatomic, strong, nullable)UIImage *placeHolderImage; //
@property (nonatomic, strong, nullable)UITapGestureRecognizer *tapSingle;
@property (nonatomic, strong, nullable)UITapGestureRecognizer *tapDouble;
@property (nonatomic, strong, nullable)NSURL *urlImage; //
@property (nonatomic, assign)BOOL hasLoadedImage; //
@end

@implementation STPhotoBrowserView
#pragma mark - --- lift cycle 生命周期 ---
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.scrollView];
        [self addGestureRecognizer:self.tapSingle];
        [self addGestureRecognizer:self.tapDouble];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.indicatorView.center = self.scrollView.center;
    self.scrollView.frame = self.bounds;
    self.buttonReload.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    self.imageView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    [self adjustFrame];
}

#pragma mark - --- Delegate 视图委托 ---

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
#pragma mark - --- event response 事件相应 ---

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.singleTapBlock) {
        self.singleTapBlock(recognizer);
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    // 1.如果没有图片，没有响应
    if (!self.hasLoadedImage) {
        return;
    }
    
    // 2.放大和缩小
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollView.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + self.scrollView.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.scrollView.contentOffset.y;//需要放大的图片的Y点
        [self.scrollView zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES]; //还原
    }
}

- (void)reloadImage
{
    [self setImageWithURL:self.urlImage
         placeholderImage:self.placeHolderImage];
}

#pragma mark - --- private methods 私有方法 ---

- (void)adjustFrame
{
    CGRect frameScroll = self.scrollView.frame;
    
    
    
    if (self.imageView.image) {
        CGSize sizeImage = self.imageView.image.size;
        CGRect frameImage = CGRectMake(0, 0, sizeImage.width, sizeImage.height);
        
        if (STFullWidthForLandScape) {
            CGFloat ratio = frameScroll.size.width / frameImage.size.width;
            frameImage.size.height = frameImage.size.height * ratio;
            frameImage.size.width = frameScroll.size.width;
        }else {
            if (frameScroll.size.width <= frameScroll.size.height) {
                CGFloat ratio = frameScroll.size.width / frameImage.size.width;
                frameImage.size.height = frameImage.size.height * ratio;
                frameImage.size.width = frameScroll.size.width;
            }else {
                CGFloat ratio = frameScroll.size.height / frameImage.size.height;
                frameImage.size.width = frameImage.size.width * ratio;
                frameImage.size.height = frameScroll.size.height;
            }
        }
        
        
        [self.imageView setFrame:frameImage];
        [self.scrollView setContentSize:self.imageView.size];
        [self.imageView setCenter:[self centerOfScrollViewContent:self.scrollView]];
        
        
        CGFloat maxScale = frameScroll.size.height/frameImage.size.height;
        
        if ((frameScroll.size.width/frameImage.size.width) > maxScale) {
            maxScale = frameScroll.size.width/frameImage.size.width;
        }else {
            maxScale = maxScale;
        }
        
        if (maxScale > STScaleMax) {
            maxScale = maxScale;
        }else {
            maxScale = STScaleMax;
        }
        
        [self.scrollView setMinimumZoomScale:STScaleMin];
        [self.scrollView setMaximumZoomScale:STScaleMax];
        [self.scrollView setZoomScale:1.0f animated:YES];
    }else{
        
        frameScroll.origin = CGPointZero;
        self.imageView.frame = frameScroll;
        self.scrollView.contentSize = self.imageView.frame.size;
    }
    self.scrollView.contentOffset = CGPointZero;
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

- (void)setImageWithURL:(NSURL*)url placeholderImage:(UIImage *)placeholderImage
{
    // 1.如果有点击载入按钮，需要移除
    if (self.buttonReload) {
        [self.buttonReload removeFromSuperview];
    }
    
    self.urlImage = url;
    self.placeHolderImage = placeholderImage;
    [self addSubview:self.indicatorView];
    
    // 2.加载图片
    __weak typeof(self) weakSelf = self;
    [self.imageView sd_setImageWithURL:url
                      placeholderImage:placeholderImage
                               options:SDWebImageRetryFailed
                              progress:^(NSInteger receivedSize,
                                         NSInteger expectedSize) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.indicatorView.progress = (CGFloat)receivedSize / expectedSize;
        
    } completed:^(UIImage *image,
                  NSError *error,
                  SDImageCacheType cacheType,
                  NSURL *imageURL) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.indicatorView removeFromSuperview];
        
        if (error) {
            [strongSelf addSubview:self.buttonReload];
            return;
        }
        strongSelf.hasLoadedImage = YES;
    }];
}
#pragma mark - getters and setters 属性

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.indicatorView.progress = progress;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [_scrollView setClipsToBounds:YES];
        [_scrollView setDelegate:self];
        [_scrollView addSubview:self.imageView];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _imageView;
}

- (STIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[STIndicatorView alloc]init];
        [_indicatorView setViewMode:STIndicatorViewModePieDiagram];
        [_indicatorView setCenter:CGPointMake(ScreenWidth/2, ScreenHeight/2)];
    }
    return _indicatorView;
}

- (UIButton *)buttonReload
{
    if (!_buttonReload) {
        _buttonReload = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        [_buttonReload setCenter:CGPointMake(ScreenWidth/2, ScreenHeight/2)];
        [_buttonReload setBackgroundColor:RGB(240, 170, 170)];
        [_buttonReload setClipsToBounds:YES];
        [_buttonReload setTitle:@"原图加载失败，点击重新加载" forState:UIControlStateNormal];
        [_buttonReload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonReload.layer setCornerRadius:2];
        [_buttonReload.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_buttonReload addTarget:self
                          action:@selector(reloadImage)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonReload;
}

- (UITapGestureRecognizer *)tapSingle
{
    if (!_tapSingle) {
        _tapSingle = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                            action:@selector(handleSingleTap:)];
        [_tapSingle setNumberOfTapsRequired:1];
        [_tapSingle setNumberOfTouchesRequired:1];
        [_tapSingle requireGestureRecognizerToFail:self.tapDouble];
    }
    return _tapSingle;
}

- (UITapGestureRecognizer *)tapDouble
{
    if (!_tapDouble) {
        _tapDouble = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                            action:@selector(handleDoubleTap:)];
        [_tapDouble setNumberOfTapsRequired:2];
        [_tapDouble setNumberOfTouchesRequired:1];
    }
    return _tapDouble;
}

@end

