//
//  NSString+Predicate.h
//  WowoMerchant
//
//  Created by Rocco on 2018/6/6.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Predicate)

/*
 校验手机号
 */
- (BOOL)worm_checkPhoneNum;

/**
 校验身份证
 
 @return return value description
 */
- (BOOL)worm_checkIDCard;

/**
 只允许数字和字母
 
 @return return value description
 */
- (BOOL)worm_onlyNumAndWords;

/**
 是否纯数字
 
 @return return value description
 */
- (BOOL)worm_pureNum;

/**
 是否纯中文
 
 @return return value description
 */
- (BOOL)isChinese;

/**
 是否含有中文
 
 @return return value description
 */
- (BOOL)includeChinese;

/**
 邮箱校验
 
 @return return value description
 */
- (BOOL)worm_checkEmail;

/**
 MD5加密

 @return 加密数据
 */
- (NSString *)md5;

@end
