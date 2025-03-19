//
//  ChatInputBar.m
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import "ChatInputBar.h"
#import "SugarMarcos.h"

@implementation ChatInputBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    // textView
    EATextField * textView = self.textView = [[EATextField alloc] initWithFrame:CGRectMake(10, 8, ScreenWidth() - 10 * 2 - 44, self.frame.size.height - 8 * 2)];
    [self addSubview:textView];
    
    textView.maxCount = 1000;
    textView.font = Font(14);
    textView.textColor = UIColor.blackColor;
    textView.backgroundColor = UIColor.lightGrayColor;
    
    textView.placeholder = @"输入内容，iOS 发送键在键盘内";
    textView.returnKeyType = UIReturnKeySend;
    textView.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //  图片选择器
    UIButton *imageItem = self.imageItem = [[UIButton alloc] initWithFrame:CGRectMake(textView.frame.origin.x + textView.frame.size.width + 10, 8, 34, textView.frame.size.height)];
    [imageItem setImage:[UIImage imageNamed:@"chat_photo"] forState:(UIControlStateNormal)];
    [self addSubview:imageItem];
}

@end
