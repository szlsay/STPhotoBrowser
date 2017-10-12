//
//  TableViewController.m
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/25.
//  Copyright © 2016年 ST. All rights reserved.
//

#import "TableViewController.h"
#import "STPhotoBrowserController.h"
#import "STConfig.h"
#import <UIButton+WebCache.h>
@class TestCell;
@protocol TestCellDelegate <NSObject>

- (void)testCell:(TestCell *)cell currentItem:(NSInteger)currentItem;

@end


@interface TestCell : UITableViewCell
@property (nonatomic, strong, nullable)NSArray *arrayImageUrl;
@property ( nonatomic, weak, nullable) id <TestCellDelegate>delegate;
@end

@interface TestCell()
@property (nonatomic, strong, nullable)NSMutableArray *arrayButton;
@end

@implementation TestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView.layer setCornerRadius:4];
        [self.contentView.layer setMasksToBounds:YES];
        
        [self.layer setCornerRadius:4];
        [self.layer setMasksToBounds:YES];
    }
    return self;
}

- (void)setArrayImageUrl:(NSArray *)arrayImageUrl
{
    _arrayImageUrl = arrayImageUrl;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.arrayButton removeAllObjects];
    
    [arrayImageUrl enumerateObjectsUsingBlock:^(NSString *imageUrl, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat buttonW = (CGRectGetWidth(self.contentView.frame) - STMargin * 3)/3;
        CGFloat buttonH = buttonW;
        CGFloat buttonX = STMargin + (idx % 3) * (buttonW + STMarginSmall);
        CGFloat buttonY = (idx / 3) * (buttonH + STMarginSmall) + STMarginSmall;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonX,
                                                                     buttonY,
                                                                     buttonW,
                                                                     buttonH)];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.clipsToBounds = YES;
        [button sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          forState:UIControlStateNormal
                  placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [button addTarget:self
                   action:@selector(buttonClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [self.arrayButton addObject:button];
    }];
}

- (void)buttonClick:(UIButton *)button
{
    [self.arrayButton enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn == button) {
            NSLog(@"%s, %lu, %@", __FUNCTION__, (unsigned long)idx, self.contentView);
            
            [self.delegate testCell:self currentItem:idx];
        }
    }];
}

- (NSMutableArray *)arrayButton
{
    if (!_arrayButton) {
        _arrayButton = [NSMutableArray array];
    }
    return _arrayButton;
}

@end


@interface TableViewController ()<UITableViewDataSource, UITableViewDelegate, TestCellDelegate, STPhotoBrowserDelegate>
@property (nonatomic, strong, nullable)UITableView *tableView; //
@property (nonatomic, strong, nullable)NSDictionary *dictionaryImage; //

@property (nonatomic, strong, nullable)UIView *currentView; //
@property (nonatomic, strong, nullable)NSArray *currentArray; //
@end

@implementation TableViewController

#pragma mark - --- lift cycle 生命周期 ---

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}
#pragma mark - --- delegate 视图委托 ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell"];
    NSString *key = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    [cell setArrayImageUrl:self.dictionaryImage[key]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat buttonH = (CGRectGetWidth(self.view.frame) - STMargin * 3)/3;
    NSString *key = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    NSArray *array = self.dictionaryImage[key];
    return  ((array.count - 1) / 3 + 1) * (buttonH) + STMargin;
}

- (void)testCell:(TestCell *)cell currentItem:(NSInteger)currentItem
{
    //启动图片浏览器
    STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
    browserVc.sourceImagesContainerView = cell.contentView; // 原图的父控件
    browserVc.countImage = cell.arrayImageUrl.count; // 图片总数
    
    self.currentView = cell.contentView;
    self.currentArray = cell.arrayImageUrl;
    
    browserVc.currentPage = currentItem;
    browserVc.delegate = self;
    [browserVc show];
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(STPhotoBrowserController *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.currentView.subviews[index] currentImage];
}

- (NSURL *)photoBrowser:(STPhotoBrowserController *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.currentArray[index];
    return [NSURL URLWithString:urlStr];
}
#pragma mark - --- event response 事件相应 ---

#pragma mark - --- private methods 私有方法 ---

#pragma mark - --- getters and setters 属性 ---

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor:[UIColor colorWithRed:243.0/255 green:242.0/255 blue:240.0/255 alpha:1]];
        [_tableView registerClass:[TestCell class] forCellReuseIdentifier:@"TestCell"];
    }
    return _tableView;
}

- (NSDictionary *)dictionaryImage
{
    return @{@"0": @[@"http://img5.duitang.com/uploads/item/201406/11/20140611041659_jjNvG.thumb.700_0.jpeg",
                     @"http://img3.3lian.com/2014/f1/1/d/32.jpg",
                     @"http://img4.duitang.com/uploads/item/201406/27/20140627004739_nQwxv.jpeg"],
             @"1": @[@"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1205/02/c0/11459868_1335958865509.jpg",
                     @"http://img2.mtime.com/mg/2009/36/9a1d9903-71c6-4654-8b42-673bdad3aaef.jpg",
                     @"http://d.3987.com/yjyy_131018/001.jpg",
                     @"http://img5q.duitang.com/uploads/item/201309/05/20130905161817_5UwYS.thumb.700_0.jpeg",
                     @"http://pic1.nipic.com/2008-12-09/200812910493588_2.jpg"],
             @"2": @[@"http://img2.mtime.com/mg/2009/36/f8ff8963-57d7-4d06-aa50-4c1218184de4.jpg",
                     @"http://pic30.nipic.com/20130618/11860366_201437262000_2.jpg"],
             @"3": @[@"http://imgsrc.baidu.com/forum/pic/item/38dbb6fd5266d016b20e89b1972bd40735fa3517.jpg",
                     @"http://img10.3lian.com/sc6/show02/38/65/386515.jpg"],
             @"4": @[@"http://img4q.duitang.com/uploads/item/201409/08/20140908013757_NfuS2.jpeg",
                     @"http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg"],
             @"5": @[@"http://b.zol-img.com.cn/sjbizhi/images/8/208x312/1435742799400.jpg",
                     @"http://img2.mtime.com/mg/2009/36/2998bcfa-95b7-42a0-b353-5d2997b12ef2.jpg",
                     @"http://img4.duitang.com/uploads/item/201409/13/20140913140903_xKGFa.thumb.700_0.jpeg",
                     @"http://a0.att.hudong.com/15/08/300218769736132194086202411_950.jpg",
                     @"http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg"],
             @"6": @[@"http://www.qqpk.cn/Article/UploadFiles/201201/20120109144324964.jpg",
                     @"http://pic2.ooopic.com/11/79/98/31bOOOPICb1_1024.jpg"],
             @"7": @[@"http://att.0xy.cn/attachment/Mon_1307/176_81500_8e0dcd19553b7f3.jpg?34"],
             @"8": @[@"http://www.qqpk.cn/Article/UploadFiles/201201/20120109144324964.jpg",
                     @"http://pic2.ooopic.com/11/79/98/31bOOOPICb1_1024.jpg",
                     @"http://b.zol-img.com.cn/sjbizhi/images/8/208x312/1435742799400.jpg",
                     @"http://img2.mtime.com/mg/2009/36/2998bcfa-95b7-42a0-b353-5d2997b12ef2.jpg",
                     @"http://img4.duitang.com/uploads/item/201409/13/20140913140903_xKGFa.thumb.700_0.jpeg",
                     @"http://a0.att.hudong.com/15/08/300218769736132194086202411_950.jpg",
                     @"http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg"]};
}

@end
