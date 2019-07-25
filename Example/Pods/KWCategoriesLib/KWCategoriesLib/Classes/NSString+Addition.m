//
//  NSString+Addition.m
//  WowoMerchant
//
//  Created by Rocco on 2018/6/13.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)

+ (BOOL)isEmptyString:(NSString *)_str {
    if (![_str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    NSString *str = [_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (str.length==0) {
        return YES;
    }
    if (str == nil) {
        return YES;
    }
    if ([str isEqualToString:@"<null>"]){
        return YES;
    }
    if ([str isEqualToString:@"(null)"]) {
        return YES;
    }
    
    return NO;
}

/*
 * 判断字典为空
 */

+ (BOOL)isEmpty:(NSDictionary *)_dic
{
    if ([_dic isKindOfClass:[NSNull class]])
        
    {
        return YES;
    }
    if (_dic == nil) {
        return YES;
    }
    if (_dic == NULL) {
        return YES;
    }
    if ((NSNull*)_dic == [NSNull null]) {
        return YES;
    }
    return NO;
}
//判断数组是否为空
+ (BOOL)isEmptyArr:(NSArray *)_arr{
    
    if ([_arr isKindOfClass:[NSNull class]])
        
    {
        return YES;
    }
    if (_arr == nil) {
        return YES;
    }
    if (_arr == NULL) {
        return YES;
    }
    if ((NSNull*)_arr == [NSNull null]) {
        return YES;
    }
    if ([_arr count] ==0) {
        return YES;
    }
    return NO;
}

//返回指定格式的金额字符串，如20.00||20->20, 20.5->20.50, 20.05->20.05
+ (NSString *)worm_transtToFormatPrice:(NSString *)formatStr {
    if ([NSString isEmptyString:formatStr]) {
        return @"";
    }
    NSDecimalNumber *divisor = [NSDecimalNumber decimalNumberWithString:@"1"]; //除数
    NSDecimalNumber *beDivisor = [NSDecimalNumber decimalNumberWithString:formatStr]; //被除数
    NSString *resultStr = [NSString stringWithFormat:@"%@", [beDivisor decimalNumberByDividingBy:divisor]];
    if ([resultStr containsString:@"."]) {
        resultStr = [NSString stringWithFormat:@"%.2f", [resultStr doubleValue]];
    }
    return resultStr;
}

//时间转毫秒数
+ (NSString *)timetoStr:(NSString *)aString {
    NSArray  *array = [aString componentsSeparatedByString:@":"];
    NSInteger a= [[array firstObject] integerValue]*3600000;
    NSInteger b= [[array lastObject] integerValue]*60000;
    NSInteger c= a+b-8*3600000;
    NSString *last = [NSString stringWithFormat:@"%ld",c];
    return last;
    
    
}
//毫秒数转时间
+ (NSString *)stringtoTime:(NSString *)aString {
    NSString *last;
    NSInteger ss= [aString integerValue];
    
    int houre = (int)ss/3600000;
    int value = ss % (3600000);
    int mintune= (int)value/60000;
    houre = 8+houre;
    NSString *houreStr;
    NSString *mintuneStr;
    if (mintune<0) {
        houre = houre-1;
        mintune = 60+mintune;
    }
    
    if (houre<10) {
        houreStr = [NSString stringWithFormat:@"0%d",houre];
    }else{
        houreStr = [NSString stringWithFormat:@"%d",houre];
        
    }
    if (mintune<10) {
        mintuneStr = [NSString stringWithFormat:@"0%d",mintune];
    }else{
        mintuneStr = [NSString stringWithFormat:@"%d",mintune];
        
    }
    last = [NSString stringWithFormat:@"%@:%@",houreStr,mintuneStr];
    
    
    return last;
}
+ (NSString *)stringToTime:(NSString *)time formatter:(NSString *)formatter{
    NSTimeInterval timeInterval = [time doubleValue]/1000;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = formatter;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [dateformatter stringFromDate:date];
    
}

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)wwl_getURLParameters {
    // 查找参数
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    
    if ([parametersString containsString:@"&"]) { //多个参数
        
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key,Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            if ([NSString isEmptyString:key] || [NSString isEmptyString:value]) {
                continue;
            }
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else { // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

/**
 返回指定行间距的富文本
 
 @param space 行间距
 @return return value description
 */
- (NSAttributedString *)attributeWithLineSpace:(float)space{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attributedString;
}

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
                                withWidth:(CGFloat)width {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


/**
 计算单行文本的宽度（粗略）

 @param font 字体大小
 @return 返回显示的宽度
 */
- (CGFloat)getTextWidthFont:(UIFont *)font{
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGSize size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 5) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width +1;
}

/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    return rect.size;
}

- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

@end
