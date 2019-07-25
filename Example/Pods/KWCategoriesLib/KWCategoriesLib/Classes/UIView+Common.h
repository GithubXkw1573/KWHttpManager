//
//  UIView+Common.h
//  Fast
//
//  Created by 詹姆斯 on 2017/8/28.
//  Copyright © 2017年 詹姆斯. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickTapGesture)(void);
@interface UIView (Common)

#pragma mark  坐标相关


@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat bottom;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic, copy) ClickTapGesture successTap;
/**
 *  获取View所在的ViewController
 *
 *  @return ViewController
 */
- (UIViewController *)getViewController;




/**
 添加分割线
 
 @param frame 尺寸
 
 */
- (void)addDivideLineView:(CGRect)frame lineColor:(UIColor *)temColor;


/**
 为view添加点击手势并用block返回

 @param clickTap 点击手势
 */
- (void)addTapGestureWithBlock:(ClickTapGesture) clickTap;



/**
 为当前的view添加阴影
 */
- (void)addShadowForCurrentView;





@end
