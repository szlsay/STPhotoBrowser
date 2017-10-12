//
//  STPhotoBrowserController.m
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/15.
//  Copyright © 2016年 ST. All rights reserved.
//

#import "STPhotoBrowserController.h"
#import "STPhotoBrowserView.h"
#import "UIView+STPhotoBrowser.h"
#import "STPhotoBrowserUI.h"
#import "STIndicatorView.h"
#import "STAlertView.h"
#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
@interface STPhotoBrowserController ()<UIScrollViewDelegate>
/** 1.内部容器视图 */
@property (nonatomic, strong, nullable)UIScrollView *scrollView;
/** 2.上方分页Label */
@property (nonatomic, strong, nullable)UILabel *labelIndex;
/** 3.下方保存按钮 */
@property (nonatomic, strong, nullable)UIButton *buttonSave;
/** 4.保存时候的指示器 */
@property (nonatomic, strong, nullable)UIActivityIndicatorView *indicatorView;
/** 5.图片视图数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayPhotoBrowserView;

@property (nonatomic,assign) BOOL hasShowedPhotoBrowser;


@end

@implementation STPhotoBrowserController

#pragma mark - --- lift cycle 生命周期 ---

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.设置背景色
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.hasShowedPhotoBrowser = NO;
    
    // 2.添加图片
    [self.arrayPhotoBrowserView removeAllObjects];
    for (int i = 0; i < self.countImage; i++) {
        STPhotoBrowserView *photoBrowserView = [STPhotoBrowserView new];
        [self.arrayPhotoBrowserView addObject:photoBrowserView];
        
        //处理单击
        __weak __typeof(self)weakSelf = self;
        photoBrowserView.singleTapBlock = ^(UITapGestureRecognizer *recognizer){
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf hidePhotoBrowser:recognizer];
        };
        
        [self.scrollView addSubview:photoBrowserView];
    }
    [self.view addSubview:self.scrollView];
    
    // 3.添加上方标题
    if (self.countImage > 1) {
        self.labelIndex.text = [NSString stringWithFormat:@"1/%ld", (long)self.countImage];
        [self.labelIndex setHidden:NO];
        [self.view addSubview:self.labelIndex];
    } else {
        [self.labelIndex setHidden:YES];
    }
    
    
    
    
    // 4.添加保存按钮
    [self.view addSubview:self.buttonSave];
    
    
    [self setupImageOfImageViewForIndex:self.currentPage];
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

#pragma mark - --- Delegate 视图委托  ---

#pragma mark - 1.scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.获取当前页数
    NSInteger pageCurrent = scrollView.contentOffset.x / scrollView.st_width + 0.5;
    
    if (pageCurrent ==  self.countImage || pageCurrent < 0) {
        return;
    }
    
    // 2.设置标题
    self.labelIndex.text = [NSString stringWithFormat:@"%ld/%ld", (long)(pageCurrent + 1), (long)self.countImage];
    
    // 3.还原其他图片的尺寸
    if (pageCurrent != self.currentPage) {
        self.currentPage = pageCurrent;
        for (STPhotoBrowserView *photoBrowserView in scrollView.subviews) {
            if (photoBrowserView != self.arrayPhotoBrowserView[self.currentPage]) {
                photoBrowserView.scrollView.zoomScale = 1.0;
                if (ScreenWidth > ScreenHeight) {
                    photoBrowserView.imageView.st_origin = CGPointMake(0, 0);
                }else {
                photoBrowserView.imageView.center = photoBrowserView.scrollView.center;
                } 
            }else {
                if (ScreenWidth > ScreenHeight) {
                    photoBrowserView.imageView.st_origin = CGPointMake(0, 0);
                }else {
                    photoBrowserView.imageView.center = photoBrowserView.scrollView.center;
                }

                if (photoBrowserView.isLoadedImage) {
                    [self.buttonSave setTitleColor:[UIColor whiteColor]
                                          forState:UIControlStateNormal];
                    [self.buttonSave setEnabled:YES];
                }else {
                    [self.buttonSave setTitleColor:[UIColor redColor]
                                          forState:UIControlStateNormal];
                    [self.buttonSave setEnabled:NO];
                }
            }
        }
    }
    
    // 4.预加载图片数据
    NSInteger left = pageCurrent - 2;
    NSInteger right = pageCurrent + 2;
    left = left > 0 ? left : 0;
    right = right > self.countImage ? self.countImage : right;
    
    for (NSInteger i =  left; i < right; i++) {
        [self setupImageOfImageViewForIndex:i];
    }
    
}

#pragma mark - --- event response 事件相应 ---
#pragma mark - 1.保存图片
- (void)saveImage:(UIButton *)button
{
    STPhotoBrowserView *currentView = self.scrollView.subviews[self.currentPage];

    UIImageWriteToSavedPhotosAlbum(currentView.imageView.image,
                                   self,
                                   @selector(savedPhotosAlbumWithImage:didFinishSavingWithError:contextInfo:),
                                   NULL);
    [[UIApplication sharedApplication].keyWindow addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
}

- (void)changeButtonStatus
{
    [self.buttonSave setEnabled:YES];
}

#pragma mark - 2.保存到相册
- (void)savedPhotosAlbumWithImage:(UIImage *)image
         didFinishSavingWithError:(NSError *)error
                      contextInfo:(void *)contextInfo
{
    
    [self.indicatorView removeFromSuperview];
    
    STAlertView *alert = [[STAlertView alloc]init];
    if (error) {
        [alert setStyle:STAlertViewStyleError];
    }else {
        [alert setStyle:STAlertViewStyleSuccess];
    }
    [alert show];
}

#pragma mark - 3.显示图片浏览器
- (void)showPhotoBrowser
{
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentPage];
    UIView *parentView = [self.view getParsentView:sourceView];
    CGRect rect = [sourceView.superview convertRect:sourceView.frame toView:parentView];
    
    // 1.如果是tableview，要减去偏移量
    if ([parentView isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)parentView;
        rect.origin.y =  rect.origin.y - tableview.contentOffset.y;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.frame = rect;
    tempImageView.image = [self placeholderImageForIndex:self.currentPage];
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
    
    self.scrollView.hidden = YES;
    self.labelIndex.hidden = YES;
    self.buttonSave.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished) {
        [tempImageView removeFromSuperview];
        self.hasShowedPhotoBrowser = YES;
        self.scrollView.hidden = NO;
        self.labelIndex.hidden = NO;
        self.buttonSave.hidden = NO;
    }];
}

#pragma mark - 4.单击隐藏图片浏览器
- (void)hidePhotoBrowser:(UITapGestureRecognizer *)recognizer
{
    STPhotoBrowserView *photoBrowserView = (STPhotoBrowserView *)recognizer.view;
    UIImageView *currentImageView = photoBrowserView.imageView;
    
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentPage];
    UIView *parentView = [self.view getParsentView:sourceView];
    CGRect targetTemp = [sourceView.superview convertRect:sourceView.frame toView:parentView];
    
    // 减去偏移量
    if ([parentView isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)parentView;
        targetTemp.origin.y =  targetTemp.origin.y - tableview.contentOffset.y;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = currentImageView.image;
    if (tempImageView.image) {
    } else {
        tempImageView.backgroundColor = [UIColor whiteColor];
    }
    
    tempImageView.frame = currentImageView.frame;
    
    [self.view.window addSubview:tempImageView];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         tempImageView.frame = targetTemp;
                     } completion:^(BOOL finished) {
                         [tempImageView removeFromSuperview];
                     }];
}
#pragma mark - --- private methods 私有方法 ---

#pragma mark - 1.显示视图
- (void)show
{
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self
                                                                                     animated:NO
                                                                                   completion:nil];
}

#pragma mark - 2.屏幕方向
- (BOOL)shouldAutorotate
{
    return STSupportLandscape;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (STSupportLandscape) {
        return UIInterfaceOrientationMaskAll;
    }else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

#pragma mark - 3.隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - 4.设置视图的框架
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
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.subviews.count * self.scrollView.st_width,
                                             ScreenHeight);
    self.scrollView.contentOffset = CGPointMake(self.currentPage * self.scrollView.st_width, 0);
    
    
    CGFloat indexW = 66;
    CGFloat indexH = 28;
    CGFloat indexCenterX = ScreenWidth / 2;
    CGFloat indexCenterY = indexH / 2 + STMarginBig;
    
    self.labelIndex.bounds = CGRectMake(0, 0, indexW, indexH);
    self.labelIndex.center = CGPointMake(indexCenterX, indexCenterY);
    [self.labelIndex.layer setCornerRadius:indexH/2];
    
    CGFloat saveW = 40;
    CGFloat saveH = 28;
    CGFloat saveX = STMarginBig;
    CGFloat saveY = ScreenHeight - saveH - STMarginBig;
    self.buttonSave.frame = CGRectMake(saveX, saveY, saveW, saveH);
}

#pragma mark - 5.加载视图的图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    STPhotoBrowserView *photoBrowserView = self.scrollView.subviews[index];
    if (photoBrowserView.beginLoadingImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [photoBrowserView setImageWithURL:[self highQualityImageURLForIndex:index]
                         placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        photoBrowserView.imageView.image = [self placeholderImageForIndex:index];
    }
    photoBrowserView.beginLoadingImage = YES;
}

#pragma mark - 6.获取低分辨率（占位）图片
- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

#pragma mark - 7.获取高分辨率图片url
- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    //    self.currentPage = index;
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - --- getters and setters 属性 ---

#pragma mark - 1.内部容器视图
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

#pragma mark - 2.上方分页Label
- (UILabel *)labelIndex
{
    if (!_labelIndex) {
        _labelIndex = [[UILabel alloc]init];
        [_labelIndex setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:50.0/255]];
        [_labelIndex setTextAlignment:NSTextAlignmentCenter];
        [_labelIndex setTextColor:[UIColor whiteColor]];
        [_labelIndex setFont:[UIFont boldSystemFontOfSize:17]];
        
        [_labelIndex setClipsToBounds:YES];
        [_labelIndex setShadowOffset:CGSizeMake(0, -0.5)];
        [_labelIndex setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:110.0/255]];
    }
    return _labelIndex;
}

#pragma mark - 3.下方保存按钮
- (UIButton *)buttonSave
{
    if (!_buttonSave) {
        _buttonSave = [[UIButton alloc]init];
        [_buttonSave setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:50.0/255]];
        [_buttonSave setTitle:@"保存" forState:UIControlStateNormal];
        [_buttonSave setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [_buttonSave.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [_buttonSave setClipsToBounds:YES];
        [_buttonSave.layer setCornerRadius:2];
        [_buttonSave.layer setBorderWidth:0.5];
        [_buttonSave.layer setBorderColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:60.0/255].CGColor];
        [_buttonSave addTarget:self
                        action:@selector(saveImage:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonSave;
}

#pragma mark - 4.保存时候的指示器
- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc]init];
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicatorView setCenter:self.view.center];
        [_indicatorView setBackgroundColor:[UIColor redColor]];
    }
    return _indicatorView;
}

#pragma mark - 5.图片视图数组
- (NSMutableArray *)arrayPhotoBrowserView
{
    if (!_arrayPhotoBrowserView) {
        _arrayPhotoBrowserView = [NSMutableArray array];
    }
    return _arrayPhotoBrowserView;
}

@end

