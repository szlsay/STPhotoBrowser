//
//  STPhotoBrowserView.h
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/15.
//  Copyright © 2016年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STPhotoBrowserView : UIView

@property (nonatomic, strong, nullable)UIScrollView *scrollView;
@property (nonatomic, strong, nullable)UIImageView *imageView;
@property (nonatomic, assign)CGFloat progress;
@property (nonatomic, assign)BOOL beginLoadingImage;
//单击回调
@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);

- (void)setImageWithURL:(NSURL*)url
       placeholderImage:(UIImage *)placeholderImage;
@end
