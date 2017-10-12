//
//  STUI.m
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/15.
//  Copyright © 2016年 ST. All rights reserved.
//

#import "STPhotoBrowserUI.h"

/** 1.统一的较小间距 5*/
CGFloat const STMarginSmall = 5;

/** 2.统一的间距 10*/
CGFloat const STMargin = 10;

/** 3.统一的较大间距 16*/
CGFloat const STMarginBig = 16;

/** 4.图片最大的放大比例 */
CGFloat const STScaleMax = 2.0;

/** 5.图片最小的缩放比例 */
CGFloat const STScaleMin = 0.8;

/** 6.是否允许横屏*/
BOOL const STSupportLandscape = YES;

/** 7.是否在横屏的时候充满宽度，，一般是在有长图需求的时候设置为YES(新浪微博的效果)*/
BOOL const STFullWidthForLandScape = YES;
