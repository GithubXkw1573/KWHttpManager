//
//  UIButton+ClickBounds.m
//  Kevin_Study
//
//  Created by kaiwei Xu on 2019/1/28.
//  Copyright © 2019 kaiwei Xu. All rights reserved.
//

#import "UIButton+ClickBounds.h"
#import <objc/runtime.h>

static const void *extendBoundKey = &extendBoundKey;

@implementation UIButton (ClickBounds)


- (void)setExtendClickInsets:(UIEdgeInsets)extendClickInsets {
    NSValue *insetsValue = [NSValue valueWithUIEdgeInsets:extendClickInsets];
    objc_setAssociatedObject(self, extendBoundKey, insetsValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)extendClickInsets {
    NSValue *insetsValue = objc_getAssociatedObject(self, extendBoundKey);
    if (insetsValue) {
        return [insetsValue UIEdgeInsetsValue];
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect clickBounds = CGRectMake(-self.extendClickInsets.left,
                                    -self.extendClickInsets.top,
                                    self.bounds.size.width + self.extendClickInsets.left + self.extendClickInsets.right, self.bounds.size.height + self.extendClickInsets.top + self.extendClickInsets.bottom);
    return CGRectContainsPoint(clickBounds, point);
}

@end
