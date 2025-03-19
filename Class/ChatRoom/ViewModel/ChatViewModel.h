//
//  ChatViewModel.h
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import <UIKit/UIKit.h>
#import "ChatSystemMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChatViewModelDelegate <NSObject>
/// 刷新数据
- (void)reloadDataList:(NSArray<EABaseListViewSection *> *)dataList;
@end

@interface ChatViewModel : NSObject
/// 代理
@property (nonatomic, weak) id<ChatViewModelDelegate> delegate;

/// 加载初始数据
- (void)loadInitDataList;

/// 发送文本消息
- (void)sendTextMsg:(NSString *)text;
/// 发送图片消息
- (void)sendImageMsg:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
