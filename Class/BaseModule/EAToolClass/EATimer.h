//
//  EATimer.h
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EATimer : NSObject

/// GCD 定时器
/// @param interval 执行间隔
/// @param maxRepeatCount 循环执行次数
/// @param complete 回调
- (void)startTimerWithInterval:(NSInteger)interval maxRepeatCount:(NSInteger)maxRepeatCount complete:(void (^)(NSInteger repeatCount))complete;
/// 停止
- (void)endTimer;

@end

NS_ASSUME_NONNULL_END
