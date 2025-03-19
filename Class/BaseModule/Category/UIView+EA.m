//
//  UIView+EA.m
//  ChatDemo
//
//  Created by oneyian on 2025/3/20.
//

#import "UIView+EA.h"

@implementation UIView (EA)

/// 切圆角
- (void)setupCorners:(UIRectCorner)corner radius:(CGFloat)radius size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
