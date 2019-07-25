// Auther: kaiwei Xu.
// Created Date: 2019/3/22.
// Version: 1.0.6
// Since: 1.0.0
// Copyright © 2019 NanjingYunWo Infomation technology co.LTD. All rights reserved.
// Descriptioin: 文件描述.


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWSafeNull : NSObject


/**
 将接口返回的数据的null转化为nil

 @param myObj 接口返回的数据
 @return 返回不含null的数据
 */
+ (id)safeNull:(id)myObj;

@end

NS_ASSUME_NONNULL_END
