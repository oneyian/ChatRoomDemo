//
//  ChatBaseModel.h
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import "EABaseListViewBinder.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 基本模型
@interface ChatBaseModel : EABaseListViewBinder
/// 四周间距
@property (nonatomic, assign) UIEdgeInsets edges;

/// 0: 无发送方，1：自己，2：他人
@property (nonatomic, assign) NSInteger msgDirection;



@end

NS_ASSUME_NONNULL_END
