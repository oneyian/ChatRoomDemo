//
//  ChatSystemMsgCell.m
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import "ChatSystemMsgCell.h"
#import "ChatSystemMsgModel.h"

@interface ChatSystemMsgCell ()
@property (nonatomic, strong) UILabel * titleLab;
@end

@implementation ChatSystemMsgCell

/// 注册子视图
- (void)initSubViews
{
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth(), 44)];
    self.titleLab.font = Font(14);
    self.titleLab.textColor = UIColor.redColor;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLab];
}

#pragma mark - < 数据展示 >
/// 配置数据
/// - Parameter data: 绑定的数据
- (void)configureWithModel:(id _Nullable)data {
    if (!data || [data isKindOfClass:NSNull.class] || ![data isKindOfClass:ChatSystemMsgModel.class]) return;
    ChatSystemMsgModel *model = (ChatSystemMsgModel *)data;
    
    // frame
    CGRect frame = self.titleLab.frame;
    frame.origin.y = model.edges.top;
    self.titleLab.frame = frame;
    
    // data
    if (model.data && [model.data isKindOfClass:NSString.class]) {
        self.titleLab.text = model.data;
    }else {
        self.titleLab.text = nil;
    }
}

/// 配置高度
/// - Parameter data: 绑定的数据
+ (CGFloat)heightWithModel:(id _Nullable)data {
    return [super heightWithModel:data];
}

@end
