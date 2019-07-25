//
//  UIView+Corner.m
//  WormwormLife
//
//  Created by kaiwei Xu on 2018/10/18.
//  Copyright © 2018年 张文彬. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)


/**
 指定4个角某几个角圆角

 @param corners 组合值
 @param radius 圆角度
 */
- (void)roundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)radius{
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    //设置大小
    maskLayer.frame = self.bounds;
    
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}

@end
