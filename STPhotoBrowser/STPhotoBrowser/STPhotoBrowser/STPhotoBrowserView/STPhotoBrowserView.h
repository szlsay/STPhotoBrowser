//
//  STPhotoBrowserView.h
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/15.
//  Copyright © 2016年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STPhotoBrowserView : UIView
/** 1.内部容器视图 */
@property (nonatomic, strong, nullable)UIScrollView *scrollView;
/** 2.图片 */
@property (nonatomic, strong, nullable)UIImageView *imageView;
/** 3.图片下载进度 */
@property (nonatomic, assign)CGFloat progress;
/** 4.是否开始载入图片 */
@property (nonatomic, assign)BOOL beginLoadingImage;
/** 5.单击回调 */
@property (nonatomic, copy) void (^ _Nonnull singleTapBlock)(UITapGestureRecognizer * _Nonnull recognizer);
/** 6.是否已经载入图片 */
@property (nonatomic, assign, getter=isLoadedImage)BOOL  hasLoadedImage;
/**
 *  7.设置图片
 *
 *  @param url              <#url description#>
 *  @param placeholderImage <#placeholderImage description#>
 */
- (void)setImageWithURL:(NSURL*_Nonnull)url
       placeholderImage:(UIImage *_Nonnull)placeholderImage;

@end
