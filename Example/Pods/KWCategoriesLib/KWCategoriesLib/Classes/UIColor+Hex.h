//
//  UIColor+Hex.h
//  WowoMerchant
//
//  Created by 许开伟 on 2018/5/29.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)hexString:(NSString *)color;

+ (UIColor *)hexString:(NSString *)color alpha:(CGFloat)alpha;

@end
