//
//  STAlertView.h
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/17.
//  Copyright © 2016年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, STAlertViewStyle) {
    STAlertViewStyleSuccess,
    STAlertViewStyleError
};

@interface STAlertView : UIView
/** 1.风格类型 */
@property (nonatomic, assign)STAlertViewStyle style;
/** 2.显示 */
- (void)show;
@end
