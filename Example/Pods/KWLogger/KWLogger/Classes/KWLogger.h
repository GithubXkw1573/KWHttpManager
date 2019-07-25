//
//  KWLogger.h
//  Pods
//
//  Created by kaiwei Xu on 2019/7/25.
//

#ifndef KWLogger_h
#define KWLogger_h

//Log日志系统
#define LOG_LEVEL_DEF ddLogLevel // 要先设置宏定义
#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose; // ddLogLevel 注意大小写要一致
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif  /* DEBUG */

#import "FormatLogger.h"


#endif /* KWLogger_h */
