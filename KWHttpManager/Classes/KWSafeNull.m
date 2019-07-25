// Auther: kaiwei Xu.
// Created Date: 2019/3/22.
// Version: 1.0.6
// Since: 1.0.0
// Copyright © 2019 NanjingYunWo Infomation technology co.LTD. All rights reserved.
// Descriptioin: 文件描述.


#import "KWSafeNull.h"

@implementation KWSafeNull

//类型识别:将所有的NSNull类型转化成@""
+ (id)safeNull:(id)myObj {
    
    if ([myObj isKindOfClass:[NSDictionary class]]) return [self nullDic:myObj];
    
    else if([myObj isKindOfClass:[NSArray class]]) return [self nullArr:myObj];
    
    else if([myObj isKindOfClass:[NSString class]]) return [self stringToString:myObj];
    
    else if([myObj isKindOfClass:[NSNull class]]) return [self nullToNil];
    
    else return myObj;
    
}
#pragma mark - 私有方法
//将NSDictionary中的Null类型的项目转化成@""
+ (NSDictionary *)nullDic:(NSDictionary *)myDic {
    
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc] init];
    
    [myDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        id Obj = [self safeNull:obj];
        if (Obj) {
            [resDic setObject:Obj forKey:key];
        }
    }];
    
    return resDic;
    
}
//将NSArray中的Null类型的项目转化成@""
+ (NSArray *)nullArr:(NSArray *)myArr {
    
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    
    [myArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id Obj = [self safeNull:obj];
        if (Obj) {
            [resArr addObject:Obj];
        }
    }];
    
    return resArr;
    
}
//将NSString类型的原路返回
+ (NSString *)stringToString:(NSString *)string{
    
    return string;
    
}
//将Null类型的项目转化成nil
+ (id)nullToNil {
    
    return nil;
}


@end
