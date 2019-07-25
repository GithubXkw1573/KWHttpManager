#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FormatLogger.h"
#import "KWLogger.h"

FOUNDATION_EXPORT double KWLoggerVersionNumber;
FOUNDATION_EXPORT const unsigned char KWLoggerVersionString[];

