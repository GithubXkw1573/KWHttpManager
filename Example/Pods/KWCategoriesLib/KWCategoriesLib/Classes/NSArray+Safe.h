//
//  NSArray+Safe.h
//  WowoMerchant
//
//  Created by 许开伟 on 2018/5/29.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Safe)


/**
 防止数组越界崩溃

 @param index index description
 @return return value description
 */
- (id)safeObjectAtIndex:(NSUInteger)index;

@end


@interface NSMutableArray (Safe)


/**
 防止数组越界崩溃

 @param index index description
 @return return value description
 */
- (id)safeObjectAtIndex:(NSUInteger)index;


/**
 防止添加nil到数组导致崩溃

 @param anObject anObject description
 */
- (void)safeAddObject:(id)anObject;

- (void)addNonNullObject:(id)anObject;

- (void)safeAddObjectsFromArray:(NSArray *)otherArray;

@end
