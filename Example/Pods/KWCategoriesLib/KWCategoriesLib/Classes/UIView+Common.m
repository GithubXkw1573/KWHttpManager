//
//  UIView+Common.m
//  Fast
//
//  Created by 詹姆斯 on 2017/8/28.
//  Copyright © 2017年 詹姆斯. All rights reserved.
//

#import "UIView+Common.h"
#import <objc/runtime.h>
@implementation UIView (Common)

- (UIViewController *)getViewController {
    
    
    UIResponder *next = self.nextResponder;
    
    do {
        
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    } while (next != nil);
    
    return nil;
    
    
    
}



#pragma mark  坐标
- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)addDivideLineView:(CGRect)frame lineColor:(UIColor *)temColor {
    
    //红色指示器
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = frame;
    lineLayer.backgroundColor = temColor.CGColor;
    [self.layer addSublayer:lineLayer];
    
    
}

#pragma mark view添加点击手势

static void *blockKey = &blockKey;

- (void)setSuccessTap:(ClickTapGesture)successTap {
    objc_setAssociatedObject(self, &blockKey, successTap, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

- (ClickTapGesture)successTap {
    
    return objc_getAssociatedObject(self, &blockKey);
    
    
}


- (void)addTapGestureWithBlock:(ClickTapGesture)clickTap {

    self.successTap = clickTap;
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
    [self addGestureRecognizer:tap];

}


- (void)clickTap{
    
    
    if (self.successTap) {
        self.successTap();
    }
}

- (void)addShadowForCurrentView {
    self.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.layer.shadowOffset = CGSizeMake(0, 4);//偏移距离
    self.layer.shadowOpacity = 0.35;//不透明度
    self.layer.shadowRadius = 4;//半径

}
@end
