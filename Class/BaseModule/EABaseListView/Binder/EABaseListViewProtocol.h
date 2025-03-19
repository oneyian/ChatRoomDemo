//
//  EABaseListViewProtocol.h
//  oneyian
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EARespondsToAction)(id _Nullable actionType);

#pragma mark - < TableViewProtocol >
@protocol EABaseTableViewProtocol <NSObject>
@optional

/// 配置数据
/// - Parameter data: 绑定的数据
- (void)configureWithModel:(id _Nullable)data;

/// 响应事件
/// - Parameter actionBlock: 绑定的 Block
- (void)configureActionBlock:(EARespondsToAction)actionBlock;

/// 配置高度
/// - Parameter data: 绑定的数据
+ (CGFloat)heightWithModel:(id _Nullable)data;

@end

NS_ASSUME_NONNULL_END
