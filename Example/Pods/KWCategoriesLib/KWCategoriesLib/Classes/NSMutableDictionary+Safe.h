//
//  NSMutableDictionary+Safe.h
//  WowoMerchant
//
//  Created by 许开伟 on 2018/5/29.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Safe)

- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
