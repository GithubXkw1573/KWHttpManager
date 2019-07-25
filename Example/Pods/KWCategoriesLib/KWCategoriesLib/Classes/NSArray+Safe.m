//
//  NSArray+Safe.m
//  WowoMerchant
//
//  Created by 许开伟 on 2018/5/29.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index{
    if (self.count > index) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}

@end


@implementation NSMutableArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index{
    if (self.count > index) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}

- (void)safeAddObject:(id)anObject{
    if (anObject) {
        [self addObject:anObject];
    }
}

- (void)addNonNullObject:(id)anObject{
    if (anObject) {
        [self addObject:anObject];
    }else {
        [self addObject:[NSNull null]];
    }
}

- (void)safeAddObjectsFromArray:(NSArray *)otherArray{
    if (otherArray.count) {
        [self addObjectsFromArray:otherArray];
    }
}

@end;
