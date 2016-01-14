//
//  ViewController.m
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/14.
//  Copyright © 2016年 ST. All rights reserved.
//

#import "ViewController.h"
#import "STIndicatorView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet STIndicatorView *indicatorView;

@end

@implementation ViewController




#pragma mark - lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.indicatorView setViewMode:STIndicatorViewModePieDiagram];
}

#pragma mark - Delegate 视图委托

#pragma mark - event response 事件相应

- (IBAction)changedNum:(UISlider *)sender {
    NSLog(@"%s, %f", __FUNCTION__, sender.value);
    [self.indicatorView setProgress:sender.value];
}

#pragma mark - private methods 私有方法

#pragma mark - getters and setters 属性
@end
