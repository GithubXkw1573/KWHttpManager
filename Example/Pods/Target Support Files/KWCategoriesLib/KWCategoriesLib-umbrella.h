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

#import "NSArray+Safe.h"
#import "NSMutableDictionary+Safe.h"
#import "NSString+Addition.h"
#import "NSString+Predicate.h"
#import "UIButton+ClickBounds.h"
#import "UIColor+Hex.h"
#import "UIImage+fixOrientation.h"
#import "UITextField+RestrictLength.h"
#import "UITextView+RestrictLength.h"
#import "UIView+Common.h"
#import "UIView+Corner.h"
#import "UIView+EqualMargin.h"

FOUNDATION_EXPORT double KWCategoriesLibVersionNumber;
FOUNDATION_EXPORT const unsigned char KWCategoriesLibVersionString[];

