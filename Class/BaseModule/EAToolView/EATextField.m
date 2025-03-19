//
//  EATextField.m
//  FishBa
//
//  Created by iOS_Dev on 2025/1/3.
//

#import "EATextField.h"

@implementation EATextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxCount = 100;
        [self addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

// 限制字数
- (void)textFieldEditingChanged:(UITextField *)textView
{
    NSString *lang = [textView textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 输入简体中文内容
        // 获取高亮部分，如拼音
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            [self handleTextFieldCharLength:textView];
        }
    }else {
        // 输入简体中文以外的内容
        [self handleTextFieldCharLength:textView];
    }
}

/// 处理高亮拼音
- (void)handleTextFieldCharLength:(UITextField *)textView
{
    NSInteger wordsNumber = self.maxCount;
    NSString *toBeString = textView.text;
    
    if (textView.text.length > wordsNumber) {
        // 获取超过最大字符数的多余字符 range
        NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:wordsNumber];
        if (rangeIndex.length == 1) {
            // 如果多余字符的 length = 1，则直接截取最大字符数
            textView.text = [toBeString substringToIndex:wordsNumber];
        }else {
            // 如果多余字符的 length > 1，则截取位置为（0.wordsNumber），按输入内容单位截取
            NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, wordsNumber)];
            textView.text = [toBeString substringWithRange:rangeRange];
        }
    }
}

@end
