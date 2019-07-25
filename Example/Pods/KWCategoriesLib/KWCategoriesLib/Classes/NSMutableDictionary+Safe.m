//
//  NSMutableDictionary+Safe.m
//  WowoMerchant
//
//  Created by 许开伟 on 2018/5/29.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"

@implementation NSMutableDictionary (Safe)

- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
}

@end
