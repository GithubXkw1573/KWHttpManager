//
//  UIImage+YWCompress.h
//  WowoMerchant
//
//  Created by kaiwei Xu on 2018/12/18.
//  Copyright © 2018 NanjingYunWo. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YWCompress)
@property (assign,atomic) BOOL onCompress;
@property (copy, atomic) NSData *compressedData;
- (void)startCompress;
@end

NS_ASSUME_NONNULL_END
