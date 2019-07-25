//
//  UIImage+YWCompress.m
//  WowoMerchant
//
//  Created by kaiwei Xu on 2018/12/18.
//  Copyright © 2018 NanjingYunWo. All rights reserved.
//

#import "UIImage+YWCompress.h"
#import <KWCategoriesLib/UIImage+fixOrientation.h>
#import <objc/runtime.h>

@implementation UIImage (YWCompress)


- (void)startCompress {
    //异步线程压缩
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.onCompress = YES;
        self.compressedData = [self compressImageToSize:CGSizeMake(720, 1080)];
        self.onCompress = NO;
    });
}


static NSString *onImageCompressKey = @"com.merchant.onImageCompressKey";

- (void)setOnCompress:(BOOL)onCompress {
    NSNumber *number = [NSNumber numberWithBool:onCompress];
    objc_setAssociatedObject(self, &onImageCompressKey, number, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)onCompress {
    NSNumber *number = objc_getAssociatedObject(self, &onImageCompressKey);
    return [number boolValue];
}

static NSString *compressedDataKey = @"com.merchant.compressedDataKey";

- (void)setCompressedData:(NSData *)compressedData {
    objc_setAssociatedObject(self, &compressedDataKey, compressedData, OBJC_ASSOCIATION_COPY);
}

- (NSData *)compressedData {
    return objc_getAssociatedObject(self, &compressedDataKey);
}

@end
