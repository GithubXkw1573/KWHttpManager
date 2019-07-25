// Auther: kaiwei Xu.
// Created Date: 2019/2/22.
// Version: 1.0.6
// Since: 1.0.0
// Copyright © 2019 NanjingYunWo Infomation technology co.LTD. All rights reserved.
// Descriptioin: 文件描述.


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LogType) {
    LogTypeNotificatioin,
    LogTypeAction,
    LogTypeDebug,
    LogTypeError,
    LogTypeWarning,
};

NS_ASSUME_NONNULL_BEGIN

@interface FormatLogger : NSObject

+ (void)logNotification:(NSString *)notiName where:(NSString *)where toDo:(NSString *)doSomethings;

+ (void)logEvent:(NSString *)event toDo:(NSString *)doSomethings;

+ (void)logError:(NSString *)error where:(NSString *)where reason:(NSString *)reason;

+ (void)logWarn:(NSString *)warn where:(NSString *)where;

@end

NS_ASSUME_NONNULL_END
