//
//  EATimer.h
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import "EATimer.h"

@implementation EATimer
{
    dispatch_source_t _timer;
}

- (void)startTimerWithInterval:(NSInteger)interval maxRepeatCount:(NSInteger)maxRepeatCount complete:(void (^)(NSInteger repeatCount))complete
{
    if (!_timer) {
        __block NSInteger count = 0;
        dispatch_queue_t queue = dispatch_queue_create("creatQueue", DISPATCH_QUEUE_CONCURRENT);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),interval*NSEC_PER_SEC, 0); ///每隔interval秒执行一次
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                count += 1;
                if (count > maxRepeatCount) {
                    count = 0;
                }
                if (complete) {
                    complete(count);
                }
                
            });
        });
        dispatch_resume(_timer);
    }
}

- (void)endTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

@end
