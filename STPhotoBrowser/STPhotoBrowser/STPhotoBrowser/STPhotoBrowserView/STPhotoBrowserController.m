//
//  STPhotoBrowserController.m
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/15.
//  Copyright © 2016年 ST. All rights reserved.
//

#import "STPhotoBrowserController.h"
#import "STPhotoBrowserView.h"
#import "STConfig.h"
#import "STIndicatorView.h"

@interface STPhotoBrowserController ()<UIScrollViewDelegate>

@property (nonatomic, strong, nullable)UIScrollView *scrollView; //
@property (nonatomic, strong, nullable)UILabel *labelIndex; //
@property (nonatomic, strong, nullable)UIButton *buttonSave; //


@property (nonatomic,assign) BOOL hasShowedPhotoBrowser;
@property (nonatomic,strong) UILabel *indexLabel;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) UIButton *saveButton;



@end

@implementation STPhotoBrowserController

#pragma mark - lift cycle 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hasShowedPhotoBrowser = NO;
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    if (self.countImage > 1) {
        self.labelIndex.text = [NSString stringWithFormat:@"1/%ld", (long)self.countImage];
    }
    
    for (int i = 0; i < self.countImage; i++) {
            STPhotoBrowserView *view = [[STPhotoBrowserView alloc] init];
            view.imageView.tag = i;
    
            //处理单击
            __weak __typeof(self)weakSelf = self;
            view.singleTapBlock = ^(UITapGestureRecognizer *recognizer){
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf hidePhotoBrowser:recognizer];
            };
    
            [self.scrollView addSubview:view];
        }
    
    [self setupImageOfImageViewForIndex:self.currentIndex];

    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.labelIndex];
    [self.view addSubview:self.buttonSave];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_hasShowedPhotoBrowser) {
        [self showPhotoBrowser];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self setupFrame];
}

#pragma mark - Delegate 视图委托


#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageCurrent = scrollView.contentOffset.x / scrollView.width + 0.5;
    self.labelIndex.text = [NSString stringWithFormat:@"%ld/%ld", pageCurrent + 1, (long)self.countImage];
    
    NSInteger left = pageCurrent - 2;
    NSInteger right = pageCurrent + 2;
    left = left > 0 ? left : 0;
    right = right > self.countImage ? self.countImage : right;
    
    for (NSInteger i =  left; i < right; i++) {
        [self setupImageOfImageViewForIndex:i];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageCurrent = scrollView.contentOffset.x / scrollView.width;
    self.currentIndex = pageCurrent;
    
    for (STPhotoBrowserView *view in scrollView.subviews) {
        if (view.imageView.tag != pageCurrent) {
            view.scrollView.zoomScale = 1.0;
        }
    }
}

#pragma mark - event response 事件相应

- (void)saveImage
{
    int index = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    
    STPhotoBrowserView *currentView = self.scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentView.imageView.image,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.view.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

#pragma mark - private methods 私有方法

- (void)show
{
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self
                                                                                     animated:NO
                                                                                   completion:nil];
}

- (BOOL)shouldAutorotate
{
    return STSupportLandscape;
}

- (void)setupFrame
{
    CGRect rectSelf = self.view.bounds;
    rectSelf.size.width += STMargin * 2;
    self.scrollView.bounds = rectSelf;
    self.scrollView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    
    
    __block CGFloat photoX = 0;
    __block CGFloat photoY = 0;
    __block CGFloat photoW = ScreenWidth;
    __block CGFloat photoH = ScreenHeight;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof STPhotoBrowserView * _Nonnull obj,
                                                           NSUInteger idx,
                                                           BOOL * _Nonnull stop) {
        photoX = STMargin + idx * (STMargin * 2 + photoW);
        [obj setFrame:CGRectMake(photoX, photoY, photoW, photoH)];
        
    }];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.subviews.count * self.scrollView.width,
                                             ScreenHeight);
    self.scrollView.contentOffset = CGPointMake(self.currentIndex * self.scrollView.width, 0);
    self.labelIndex.bounds = CGRectMake(0, 0, 80, 30);
    self.labelIndex.center = CGPointMake(ScreenWidth / 2, 30);
    self.buttonSave.frame = CGRectMake(30, ScreenHeight - 70, 55, 30);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (STSupportLandscape) {
        return UIInterfaceOrientationMaskAll;
    }else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)showPhotoBrowser
{
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentIndex];
    UIView *parentView = [self getParsentView:sourceView];
    CGRect rect = [sourceView.superview convertRect:sourceView.frame toView:parentView];
    
    // 1.如果是tableview，要减去偏移量
    if ([parentView isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)parentView;
        rect.origin.y =  rect.origin.y - tableview.contentOffset.y;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.frame = rect;
    tempImageView.image = [self placeholderImageForIndex:self.currentIndex];
    [self.view addSubview:tempImageView];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat placeImageSizeW = tempImageView.image.size.width;
    CGFloat placeImageSizeH = tempImageView.image.size.height;
    CGRect targetTemp;
    
    if (!STFullWidthForLandScape) {
        if (ScreenWidth < ScreenHeight) {
            CGFloat placeHolderH = (placeImageSizeH * ScreenWidth)/placeImageSizeW;
            if (placeHolderH <= ScreenHeight) {
                targetTemp = CGRectMake(0, (ScreenHeight - placeHolderH) * 0.5 , ScreenWidth, placeHolderH);
            } else {
                targetTemp = CGRectMake(0, 0, ScreenWidth, placeHolderH);
            }
        } else {
            CGFloat placeHolderW = (placeImageSizeW * ScreenHeight)/placeImageSizeH;
            if (placeHolderW < ScreenWidth) {
                targetTemp = CGRectMake((ScreenWidth - placeHolderW)*0.5, 0, placeHolderW, ScreenHeight);
            } else {
                targetTemp = CGRectMake(0, 0, placeHolderW, ScreenHeight);
            }
        }
        
    } else {
        CGFloat placeHolderH = (placeImageSizeH * ScreenWidth)/placeImageSizeW;
        if (placeHolderH <= ScreenHeight) {
            targetTemp = CGRectMake(0, (ScreenHeight - placeHolderH) * 0.5 , ScreenWidth, placeHolderH);
        } else {
            targetTemp = CGRectMake(0, 0, ScreenWidth, placeHolderH);
        }
    }
    
    _scrollView.hidden = YES;
    _indexLabel.hidden = YES;
    _saveButton.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished) {
        _hasShowedPhotoBrowser = YES;
        [tempImageView removeFromSuperview];
        _scrollView.hidden = NO;
        _indexLabel.hidden = NO;
        _saveButton.hidden = NO;
    }];
}

#pragma mark 单击隐藏图片浏览器
- (void)hidePhotoBrowser:(UITapGestureRecognizer *)recognizer
{
    STPhotoBrowserView *view = (STPhotoBrowserView *)recognizer.view;
    UIImageView *currentImageView = view.imageView;
    
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentIndex];
    UIView *parentView = [self getParsentView:sourceView];
    CGRect targetTemp = [sourceView.superview convertRect:sourceView.frame toView:parentView];
    
    // 减去偏移量
    if ([parentView isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)parentView;
        targetTemp.origin.y =  targetTemp.origin.y - tableview.contentOffset.y;
    }
    
    CGFloat appWidth;
    CGFloat appHeight;
    if (ScreenWidth < ScreenHeight) {
        appWidth = ScreenWidth;
        appHeight = ScreenHeight;
    } else {
        appWidth = ScreenHeight;
        appHeight = ScreenWidth;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = currentImageView.image;
    if (tempImageView.image) {
        CGFloat tempImageSizeH = tempImageView.image.size.height;
        CGFloat tempImageSizeW = tempImageView.image.size.width;
        CGFloat tempImageViewH = (tempImageSizeH * appWidth)/tempImageSizeW;
        if (tempImageViewH < appHeight) {
            tempImageView.frame = CGRectMake(0, (appHeight - tempImageViewH)*0.5, appWidth, tempImageViewH);
        } else {
            tempImageView.frame = CGRectMake(0, 0, appWidth, tempImageViewH);
        }
    } else {
        tempImageView.backgroundColor = [UIColor whiteColor];
        tempImageView.frame = CGRectMake(0, (appHeight - appWidth)*0.5, appWidth, appWidth);
    }
    
    [self.view.window addSubview:tempImageView];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [UIView animateWithDuration:0.3 animations:^{
        tempImageView.frame = targetTemp;
        
    } completion:^(BOOL finished) {
        [tempImageView removeFromSuperview];
    }];
}

- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    STPhotoBrowserView *view = self.scrollView.subviews[index];
    if (view.beginLoadingImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [view setImageWithURL:[self highQualityImageURLForIndex:index]
             placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        view.imageView.image = [self placeholderImageForIndex:index];
    }
    view.beginLoadingImage = YES;
}

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    [self.indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.50f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 60);
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:21];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = @"保存失败";
    }   else {
        label.text = @"保存成功";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (UIView *)getParsentView:(UIView *)view
{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}

#pragma mark 获取低分辨率（占位）图片
- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

#pragma mark 获取高分辨率图片url
- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - getters and setters 属性

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        [_scrollView setDelegate:self];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setHidden:YES];
    }
    return _scrollView;
}

- (UILabel *)labelIndex
{
    if (!_labelIndex) {
        CGFloat indexW = 100;
        CGFloat indexH = 40;
        CGFloat indexX = 100;
        CGFloat indexY = 30;
        _labelIndex = [[UILabel alloc]initWithFrame:CGRectMake(indexX, indexY, indexW, indexH)];
        [_labelIndex setTextAlignment:NSTextAlignmentCenter];
        [_labelIndex setTextColor:[UIColor whiteColor]];
        [_labelIndex setFont:[UIFont systemFontOfSize:20]];
        [_labelIndex setBackgroundColor:[UIColor redColor]];
        [_labelIndex setClipsToBounds:YES];
        [_labelIndex.layer setCornerRadius:indexH/2];
        
    }
    return _labelIndex;
}

- (UIButton *)buttonSave
{
    if (!_buttonSave) {
        _buttonSave = [[UIButton alloc]init];
        [_buttonSave setBackgroundColor:[UIColor blackColor]];
        [_buttonSave setTitle:@"保存" forState:UIControlStateNormal];
        [_buttonSave setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [_buttonSave setClipsToBounds:YES];
        [_buttonSave.layer setCornerRadius:2];
        [_buttonSave.layer setBorderWidth:0.5];
        [_buttonSave.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_buttonSave addTarget:self
                        action:@selector(saveImage)
              forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _buttonSave;
}

@end

