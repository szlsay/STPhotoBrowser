//
//  STPhotoBrowserController.h
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/15.
//  Copyright © 2016年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STPhotoBrowserController;
@protocol STPhotoBrowserDelegate <NSObject>

- (UIImage *)photoBrowser:(STPhotoBrowserController *)browser
    placeholderImageForIndex:(NSInteger)index;

- (NSURL *)photoBrowser:(STPhotoBrowserController *)browser
    highQualityImageURLForIndex:(NSInteger)index;
@end

@interface STPhotoBrowserController : UIViewController

@property (nonatomic, weak) UIView *sourceImagesContainerView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger countImage;//图片总数

@property ( nonatomic, weak, nullable) id <STPhotoBrowserDelegate>delegate; //

- (void)show;
@end
