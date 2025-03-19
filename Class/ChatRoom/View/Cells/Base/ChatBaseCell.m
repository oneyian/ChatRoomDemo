//
//  ChatBaseCell.m
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import "ChatBaseCell.h"
#import "ChatBaseModel.h"

@implementation ChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initSubViews];
    }
    return self;
}

/// 注册子视图
- (void)initSubViews { }

#pragma mark - < 数据展示 >
/// 配置数据
/// - Parameter data: 绑定的数据
- (void)configureWithModel:(id _Nullable)data {
    if (!data || [data isKindOfClass:NSNull.class] || ![data isKindOfClass:ChatBaseModel.class]) return;
    CGFloat cellHeight = [self.class heightWithModel:data];
    
    ChatBaseModel *model = (ChatBaseModel *)data;
    BOOL isMyMsg = model.msgDirection == 1;
    
    // 布局
    CGRect frame = self.avatarImgView.frame;
    frame.origin.x = isMyMsg ? (ScreenWidth() - frame.size.width - model.edges.right) : model.edges.left;
    frame.origin.y = model.edges.top;
    self.avatarImgView.frame = frame;
    self.avatarImgView.backgroundColor = isMyMsg ? UIColor.blueColor : UIColor.redColor;
    
    CGRect vframe = self.containerView.frame;
    vframe.origin.x = isMyMsg ? model.edges.left : (model.edges.left + frame.size.width);
    vframe.origin.y = model.edges.top;
    vframe.size.width = isMyMsg ? (frame.origin.x - model.edges.left) : (ScreenWidth() - vframe.origin.x - model.edges.right);
    vframe.size.height = cellHeight - model.edges.top - model.edges.bottom;
    self.containerView.frame = vframe;
}

/// 配置高度
/// - Parameter data: 绑定的数据
+ (CGFloat)heightWithModel:(id _Nullable)data {
    if (!data || [data isKindOfClass:NSNull.class] || ![data isKindOfClass:ChatBaseModel.class]) return 44;
    ChatBaseModel *model = (ChatBaseModel *)data;
    return model.edges.top + 44 + model.edges.bottom;
}

#pragma mark - < 懒加载 >
/// 头像
- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_avatarImgView setupCorners:(UIRectCornerAllCorners) radius:22 size:_avatarImgView.frame.size];
    }
    return _avatarImgView;
}

/// 实际内容区
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    }
    return _containerView;
}

@end
