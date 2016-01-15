//
//  STUI.h
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/15.
//  Copyright © 2016年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 1.统一的较小间距 5 */
UIKIT_EXTERN CGFloat const STMarginSmall;

/** 2.统一的间距 10 */
UIKIT_EXTERN CGFloat const STMargin;

/** 3.统一的较大间距 16 */
UIKIT_EXTERN CGFloat const STMarginBig;

/** 4.导航栏的最大的Y值 64 */
UIKIT_EXTERN CGFloat const STNavigationBarY;

/** 5.控件的系统高度 44 */
UIKIT_EXTERN CGFloat const STControlSystemHeight;

/** 6.控件的普通高度 34 */
UIKIT_EXTERN CGFloat const STControlNormalHeight;

/** 7.状态栏高度值 20 */
UIKIT_EXTERN CGFloat const STStatusBarHeight;

/** 8.图片最大的放大比例 */
UIKIT_EXTERN CGFloat const STScaleMax;

/** 9.图片最小的缩放比例 */
UIKIT_EXTERN CGFloat const STScaleMin;

/** 10.是否允许横屏*/
UIKIT_EXTERN BOOL const STSupportLandscape;

/** 11.是否在横屏的时候充满宽度，，一般是在有长图需求的时候设置为YES*/
UIKIT_EXTERN BOOL const STFullWidthForLandScape;