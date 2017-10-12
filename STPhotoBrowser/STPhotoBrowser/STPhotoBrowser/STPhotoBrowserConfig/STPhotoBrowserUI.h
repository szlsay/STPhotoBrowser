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

/** 4.图片最大的放大比例 */
UIKIT_EXTERN CGFloat const STScaleMax;

/** 5.图片最小的缩放比例 */
UIKIT_EXTERN CGFloat const STScaleMin;

/** 6.是否允许横屏*/
UIKIT_EXTERN BOOL const STSupportLandscape;

/** 7.是否在横屏的时候充满宽度，，一般是在有长图需求的时候设置为YES*/
UIKIT_EXTERN BOOL const STFullWidthForLandScape;