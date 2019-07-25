//
//  UITextView+RestrictLength.m
//  WowoMerchant
//
//  Created by kaiwei Xu on 2018/9/14.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import "UITextView+RestrictLength.h"

@implementation UITextView (RestrictLength)

/**
 最大输入字符长度限制(支持中文拼音过滤限制)
 
 @param maxLength eg:15
 */
- (void)yw_maxInputLength:(NSUInteger)maxLength{
    
    NSString *toBeString = self.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
                if (rangeIndex.length == 1)
                {
                    self.text = [toBeString substringToIndex:maxLength];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                    self.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                self.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0,maxLength)];
                self.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (CGFloat)yw_heightForTextViewWithfont:(UIFont *)font {
    CGSize constraint = CGSizeMake(self.contentSize.width , CGFLOAT_MAX);
//    CGSize constraint = CGSizeMake(self.frame.size.width , CGFLOAT_MAX);
    CGRect size = [self.text boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: font}
                                        context:nil];
    CGFloat textHeight = size.size.height + 1;
    return textHeight;
}

@end
