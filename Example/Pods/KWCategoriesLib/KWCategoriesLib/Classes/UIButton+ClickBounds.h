//
//  UIButton+ClickBounds.h
//  Kevin_Study
//
//  Created by kaiwei Xu on 2019/1/28.
//  Copyright © 2019 kaiwei Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ClickBounds)

@property (nonatomic, assign) UIEdgeInsets extendClickInsets;//点击bounds外围4个方向扩展多少pt

@end

NS_ASSUME_NONNULL_END
