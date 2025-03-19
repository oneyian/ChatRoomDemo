//
//  ChatInputBar.h
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import <UIKit/UIKit.h>
#import "EATextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatInputBar : UIView
/// 输入框
@property (nonatomic, strong) EATextField * textView;
/// 图片按钮
@property (nonatomic, strong) UIButton * imageItem;
@end

NS_ASSUME_NONNULL_END
