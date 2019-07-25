//
//  NSString+Predicate.m
//  WowoMerchant
//
//  Created by Rocco on 2018/6/6.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import "NSString+Predicate.h"
#include <sys/sysctl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Predicate)

/*
 校验手机号
 */
- (BOOL)worm_checkPhoneNum {
    //手机号码，11位
    NSString *Regex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [phoneTest evaluateWithObject:self];
}


/**
 校验身份证

 @return return value description
 */
- (BOOL)worm_checkIDCard{
    if (self.length != 18) {
        return NO;
    }else{
        BOOL flag = YES;
        for(NSInteger i =0; i< self.length; i++){
            unichar cha = [self characterAtIndex:i];
            if (cha >= 48 && cha <= 57) {
                continue;
            }else if (cha >= 65 && cha <= 90){
                continue;
            }else if (cha >= 97 && cha <= 122){
                continue;
            }else{
                flag = NO;
                break;
            }
        }
        return flag;
    }
}


/**
 只允许数字和字母

 @return return value description
 */
- (BOOL)worm_onlyNumAndWords{
    BOOL flag = YES;
    for(NSInteger i =0; i< self.length; i++){
        unichar cha = [self characterAtIndex:i];
        if (cha >= 48 && cha <= 57) {
            continue;
        }else if (cha >= 65 && cha <= 90){
            continue;
        }else if (cha >= 97 && cha <= 122){
            continue;
        }else{
            flag = NO;
            break;
        }
    }
    return flag;
}


/**
 是否纯数字

 @return return value description
 */
- (BOOL)worm_pureNum{
    BOOL flag = YES;
    for(NSInteger i =0; i< self.length; i++){
        unichar cha = [self characterAtIndex:i];
        if (cha >= 48 && cha <= 57) {
            continue;
        }else{
            flag = NO;
            break;
        }
    }
    return flag;
}

/**
 是否纯中文

 @return return value description
 */
- (BOOL)isChinese{;
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return ![predicate evaluateWithObject:self];
}


/**
 是否含有中文

 @return return value description
 */
- (BOOL)includeChinese{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}


/**
 邮箱校验

 @return return value description
 */
- (BOOL)worm_checkEmail{
    if ([self isKindOfClass:[NSString class]]) {
        if (![self containsString:@"@"] ||
            [self containsString:@" "]) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return NO;
    }
}

//// md5加密
- (NSString *)md5
{
    if (self == nil || self.length == 0)
    {
        return nil;
    }
    
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [outputString appendFormat:@"%02x",outputBuffer[i]];
    }
    
    
    
    return [outputString uppercaseString];
}
@end
