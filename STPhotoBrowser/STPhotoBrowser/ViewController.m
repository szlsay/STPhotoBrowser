//
//  ViewController.m
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/14.
//  Copyright © 2016年 ST. All rights reserved.
//

#import "ViewController.h"

#import "STPhotoBrowserController.h"
#import "STConfig.h"
#import <UIButton+WebCache.h>
@interface ViewController ()<STPhotoBrowserDelegate>

@property (nonatomic, strong, nullable)NSArray *arrayImageUrl; //

@property (nonatomic, strong, nullable)UIScrollView *scrollView; //
@end

@implementation ViewController

#pragma mark - lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    
    
    __block CGFloat buttonW = (ScreenWidth - STMargin * 3)/3;
    __block CGFloat buttonH = buttonW;
    __block CGFloat buttonX = 0;
    __block CGFloat buttonY = 0;
    [self.arrayImageUrl enumerateObjectsUsingBlock:^(NSString *imageUrl, NSUInteger idx, BOOL * _Nonnull stop) {
        buttonX = STMargin + (idx % 3) * (buttonW + STMarginSmall);
        buttonY = (idx / 3) * (buttonH + STMarginSmall);
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonX,
                                                                     buttonY,
                                                                     buttonW,
                                                                     buttonH)];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.clipsToBounds = YES;
        [button sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          forState:UIControlStateNormal
                  placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [button setTag:idx];
        [button addTarget:self
                   action:@selector(buttonClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }];
    
    
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth,
                                               (self.arrayImageUrl.count / 3 + 1)* (buttonH +
                                                                                    STMarginSmall))];
}

#pragma mark - Delegate 视图委托


#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(STPhotoBrowserController *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.scrollView.subviews[index] currentImage];
}

- (NSURL *)photoBrowser:(STPhotoBrowserController *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.arrayImageUrl[index];
    return [NSURL URLWithString:urlStr];
}


#pragma mark - event response 事件相应

- (void)buttonClick:(UIButton *)button
{
    //启动图片浏览器
    STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
    browserVc.sourceImagesContainerView = self.scrollView; // 原图的父控件
    browserVc.countImage = self.arrayImageUrl.count; // 图片总数
    browserVc.currentPage = (int)button.tag;
    browserVc.delegate = self;
    [browserVc show];
}

#pragma mark - private methods 私有方法



#pragma mark - getters and setters 属性

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                    20,
                                                                    ScreenWidth,
                                                                    ScreenHeight - 20)];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
    }
    return _scrollView;
}

- (NSArray *)arrayImageUrl
{
    return @[@"http://img.jj20.com/up/allimg/911/121215132T8/151212132T8-1-lp.jpg",
             @"http://b.zol-img.com.cn/sjbizhi/images/6/208x312/1396940684766.jpg",
             @"http://b.zol-img.com.cn/sjbizhi/images/6/208x312/1394701139813.jpg",
             @"http://img.jj20.com/up/allimg/911/0P315132137/150P3132137-1-lp.jpg",
             @"http://b.zol-img.com.cn/sjbizhi/images/1/208x312/1350915106394.jpg",
             @"http://b.zol-img.com.cn/sjbizhi/images/8/208x312/1427966117121.jpg",
             @"http://img.jj20.com/up/allimg/811/052515103222/150525103222-1-lp.jpg",
             @"http://b.zol-img.com.cn/sjbizhi/images/8/208x312/1435742799400.jpg",
             @"http://imga1.pic21.com/bizhi/131016/02507/s11.jpg"];
}


@end
