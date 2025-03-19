//
//  UIView+EA.h
//  ChatDemo
//
//  Created by oneyian on 2025/3/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (EA)
/// 切圆角
- (void)setupCorners:(UIRectCorner)corner radius:(CGFloat)radius size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
