// Auther: kaiwei Xu.
// Created Date: 2019/2/22.
// Version: 1.0.6
// Since: 1.0.0
// Copyright © 2019 NanjingYunWo Infomation technology co.LTD. All rights reserved.
// Descriptioin: 文件描述.


#import "FormatLogger.h"
#import "KWLogger.h"

@implementation FormatLogger

+ (void)logNotification:(NSString *)notiName where:(NSString *)where toDo:(NSString *)doSomethings {
    DDLogInfo(@"【%@】收到通知：【%@】，%@",where,notiName,doSomethings);
}

+ (void)logEvent:(NSString *)event toDo:(NSString *)doSomethings {
    DDLogInfo(@"触发了【%@】事件，做出的反应是：【%@】",event,doSomethings);
}

+ (void)logError:(NSString *)error where:(NSString *)where reason:(NSString *)reason {
    DDLogError(@"【%@】报错：【%@】，详细错误描述：【%@】",where, error, reason);
}

+ (void)logWarn:(NSString *)warn where:(NSString *)where {
    DDLogWarn(@"【%@】收到警告：【%@】", where, warn);
}

@end
