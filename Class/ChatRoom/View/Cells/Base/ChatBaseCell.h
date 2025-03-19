//
//  ChatBaseCell.h
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import <UIKit/UIKit.h>
#import "SugarMarcos.h"
#import "UIView+EA.h"

#import "EABaseListViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN
/// cell 基类
@interface ChatBaseCell : UITableViewCell <EABaseTableViewProtocol>
/// 头像
@property (nonatomic, strong) UIImageView * avatarImgView;
/// 实际内容区
@property (nonatomic, strong) UIView * containerView;

/// 注册子视图
- (void)initSubViews;
@end

NS_ASSUME_NONNULL_END
