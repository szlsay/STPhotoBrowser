//
//  STIndicatorView.h
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/15.
//  Copyright © 2016年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, STIndicatorViewMode ) {
    STIndicatorViewModeLoopDiagram = 0, // 环型
    STIndicatorViewModePieDiagram  = 1  // 饼型
};

@interface STIndicatorView : UIView

/** 1.图片下载的进度 */
@property (nonatomic, assign)CGFloat progress;

/** 2.指示器的显示模式 */
@property (nonatomic, assign)STIndicatorViewMode viewMode;

@end


