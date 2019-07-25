//
//  UIImage+fixOrientation.h
//  WowoMerchant
//
//  Created by kaiwei Xu on 2018/9/13.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (fixOrientation)

/**
 修复照片方向
 
 @return return value description
 */
- (UIImage *)fixOrientation;

+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 * 压缩图片到指定尺寸大小
 * @param size 尺寸大小（最大值）
 * @return 返回的图片文件
 */
- (NSData *)compressImageToSize:(CGSize)size;

/**
 * 压缩图片到指定文件大小
 * @param size 目标大小（最大值）
 * @return 返回的图片文件
 */
- (NSData *)compressImageToMaxKBytes:(CGFloat)size;

@end
