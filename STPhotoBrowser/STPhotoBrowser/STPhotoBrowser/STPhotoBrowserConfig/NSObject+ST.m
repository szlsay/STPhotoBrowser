//
//  NSObject+ST.m
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/15.
//  Copyright © 2016年 ST. All rights reserved.
//

#import "NSObject+ST.h"

@implementation NSObject (ST)

static id instance_;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}
@end
