//
//  UIView+Corner.h
//  WormwormLife
//
//  Created by kaiwei Xu on 2018/10/18.
//  Copyright © 2018年 张文彬. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIView (Corner)

/**
 指定4个角某几个角圆角
 
 @param corners 组合值
 @param radius 圆角度
 */
- (void)roundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
