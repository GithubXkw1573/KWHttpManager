//
//  NSString+Addition.h
//  WowoMerchant
//
//  Created by Rocco on 2018/6/13.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

/*
 * 字符串是否为空
 */
+ (BOOL)isEmptyString:(NSString *)_str;

/*
 * 判断字典为空
 */

+ (BOOL)isEmpty:(NSDictionary *)_dic;

//判断数组是否为空
+ (BOOL)isEmptyArr:(NSArray *)_arr;

//返回指定格式的金额字符串，如20.00||20->20, 20.5->20.50, 20.05->20.05

+ (NSString *)worm_transtToFormatPrice:(NSString *)formatStr;

//时间转毫秒数
+ (NSString *)timetoStr:(NSString *)aString;
//毫秒数转时间
+ (NSString *)stringtoTime:(NSString *)aString;
//毫秒转指定格式的时间
+ (NSString *)stringToTime:(NSString *)time formatter:(NSString *)formatter;

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)wwl_getURLParameters;


/**
 返回指定行间距的富文本

 @param space 行间距
 @return return value description
 */
- (NSAttributedString *)attributeWithLineSpace:(float)space;

/**
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
- (CGFloat)getAttributTextHeightWithSpace:(CGFloat)lineSpeace
                                 withFont:(UIFont*)font
                                withWidth:(CGFloat)width;

/**
 计算单行文本的宽度（粗略）
 
 @param font 字体大小
 @return 返回显示的宽度
 */
- (CGFloat)getTextWidthFont:(UIFont *)font;

- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing;

@end
