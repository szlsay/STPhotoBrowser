//
//  ViewController.m
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/14.
//  Copyright © 2016年 ST. All rights reserved.
//

#import "ViewController.h"
#import "STIndicatorView.h"
#import "STPhotoBrowserController.h"
#import "STImagesGroupView.h"
#import "STPhotoItem.h"
@interface ViewController ()<STPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet STIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet STImagesGroupView *groupView;

@property (nonatomic, strong, nullable)NSArray *arrayImage; //



@end

@implementation ViewController




#pragma mark - lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.indicatorView setViewMode:STIndicatorViewModePieDiagram];
    
    NSMutableArray *arrayModel = [NSMutableArray array];
    for (NSString *urlString in self.arrayImage) {
        STPhotoItem *item = [STPhotoItem new];
        item.thumbnail_pic = urlString;
        [arrayModel addObject:item];
    }
    
    self.groupView.photoItemArray = arrayModel;
    

}

#pragma mark - Delegate 视图委托

#pragma mark - event response 事件相应

- (IBAction)changedNum:(UISlider *)sender {
    NSLog(@"%s, %f", __FUNCTION__, sender.value);
    [self.indicatorView setProgress:sender.value];
}




#pragma mark - private methods 私有方法

#pragma mark - getters and setters 属性

- (NSArray *)arrayImage
{
    return @[@"http://img3.3lian.com/2013/s1/20/d/57.jpg", @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=790098218,638143216&fm=21&gp=0.jpg"];
}
@end
