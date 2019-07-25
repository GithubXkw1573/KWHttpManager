//
//  YWPhotoResponse.h
//  WowoMerchant
//
//  Created by kaiwei Xu on 2018/7/6.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWPhotoUrl;
@interface YWPhotoResponse : NSObject

@property (nonatomic , copy) NSString *domain;
@property (nonatomic, strong) NSArray<YWPhotoUrl *> *list;

@end

@interface YWPhotoUrl:NSObject
@property (nonatomic, copy) NSString *uri;
@end
