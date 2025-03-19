//
//  ChatViewModel.m
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import "ChatViewModel.h"
#import "SugarMarcos.h"

#import "ChatMsgModelHeader.h"
#import "EATimer.h"

@interface ChatViewModel ()
/// sectionModel
@property (nonatomic, strong) EABaseListViewSection * sectionModel;
/// 系统消息定时器
@property (nonatomic, strong) EATimer * systemTimer;
/// 对方消息定时器
@property (nonatomic, strong) EATimer * otherTimer;
@end

@implementation ChatViewModel {
    dispatch_semaphore_t _lock; // 信号量 加锁
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = dispatch_semaphore_create(1);
        self.sectionModel = [EABaseListViewSection new];
    }
    return self;
}

/// 加载初始数据
- (void)loadInitDataList
{
    kWeakS(ws);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("Queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        NSMutableArray<EABaseListViewBinder *> *dataList = [NSMutableArray array];
        
        // 循环 1 次
        for (NSInteger i = 0; i < 1; i++) {
            // text
            {
                ChatTextMsgModel *model1 = [ChatTextMsgModel new];
                model1.msgDirection = 1;
                model1.data = @"这是我的初始消息1这是我的初始消息2这是我的初始消息3这是我的初始消息4这是我的初始消息5";
                [dataList addObject:model1];
                
                ChatTextMsgModel *model2 = [ChatTextMsgModel new];
                model2.msgDirection = 2;
                model2.data = @"这是他的初始消息1这是他的初始消息2这是他的初始消息3这是他的初始消息4这是他的初始消息5";
                [dataList addObject:model2];
            }
            
            // system
            {
                ChatSystemMsgModel *model1 = [ChatSystemMsgModel new];
                model1.data = [NSString stringWithFormat:@"%@", NSDate.date];
                [dataList addObject:model1];
            }
            
            // image
            {
                ChatImageMsgModel *model1 = [ChatImageMsgModel new];
                model1.msgDirection = 1;
                model1.data = [UIImage imageNamed:@"chat_photo"];
                [dataList addObject:model1];
                
                ChatImageMsgModel *model2 = [ChatImageMsgModel new];
                model2.msgDirection = 2;
                model2.data = [UIImage imageNamed:@"chat_photo"];
                [dataList addObject:model2];
            }
        }
        
        // update
        [ws updateDataList:dataList.copy];
        
        // refresh ui
        dispatch_main_async(^{
            if (ws.delegate) [ws.delegate reloadDataList:@[ws.sectionModel]]; // 单个 section
            [ws fb_startTimer];
        });
    });
}

/// 发送文本消息
- (void)sendTextMsg:(NSString *)text
{
    ChatTextMsgModel *model = [ChatTextMsgModel new];
    model.msgDirection = 1;
    model.data = text;
    
    [self updateDataList:@[model]];
    if (self.delegate) [self.delegate reloadDataList:@[self.sectionModel]]; // 单个 section
}

/// 发送图片消息
- (void)sendImageMsg:(UIImage *)image
{
    ChatImageMsgModel *model = [ChatImageMsgModel new];
    model.msgDirection = 1;
    model.data = image;
    
    [self updateDataList:@[model]];
    if (self.delegate) [self.delegate reloadDataList:@[self.sectionModel]]; // 单个 section
}

/// 发送系统消息
- (void)sendSystemMsg
{
    ChatSystemMsgModel *model = [ChatSystemMsgModel new];
    model.data = [NSString stringWithFormat:@"%@", NSDate.date];
    
    [self updateDataList:@[model]];
    if (self.delegate) [self.delegate reloadDataList:@[self.sectionModel]]; // 单个 section
}

/// 发送对方消息
- (void)sendOtherMsg
{
    ChatTextMsgModel *model1 = [ChatTextMsgModel new];
    model1.msgDirection = 2;
    model1.data = [NSString stringWithFormat:@"%@", NSDate.date];
    
    ChatImageMsgModel *model2 = [ChatImageMsgModel new];
    model2.msgDirection = 2;
    model2.data = [UIImage imageNamed:@"chat_photo"];
    
    [self updateDataList:@[model1, model2]];
    if (self.delegate) [self.delegate reloadDataList:@[self.sectionModel]]; // 单个 section
}

/// 更新数据源
- (void)updateDataList:(NSArray<EABaseListViewBinder *> *)data
{
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); // 同时多次调用，后续的会锁定等待
    NSMutableArray<EABaseListViewBinder *> *dataList = [NSMutableArray arrayWithArray:self.sectionModel.cellModels];
    [dataList addObjectsFromArray:data];
    self.sectionModel.cellModels = dataList;
    dispatch_semaphore_signal(_lock); // 解锁
}

#pragma mark - < 定时器 >
/// 开启定时器
- (void)fb_startTimer
{
    kWeakS(ws);
    
    if (!_systemTimer) {
        _systemTimer = [EATimer new];
        /// 每隔 5s 发送系统消息
        [_systemTimer startTimerWithInterval:5 maxRepeatCount:0 complete:^(NSInteger repeatCount) {
            [ws sendSystemMsg];
        }];
    }
    
    if (!_otherTimer) {
        _otherTimer = [EATimer new];
        /// 每隔 7s 发送对方消息
        [_otherTimer startTimerWithInterval:7 maxRepeatCount:0 complete:^(NSInteger repeatCount) {
            [ws sendOtherMsg];
        }];
    }
}

/// 关闭定时器
- (void)stopAnimationTimer {
    if (_systemTimer) {
        [_systemTimer endTimer];
        _systemTimer = nil;
    }
    
    if (_otherTimer) {
        [_otherTimer endTimer];
        _otherTimer = nil;
    }
}

- (void)dealloc {
    [self stopAnimationTimer];
}

@end
