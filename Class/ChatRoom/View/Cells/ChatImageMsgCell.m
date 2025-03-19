//
//  ChatImageMsgCell.m
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import "ChatImageMsgCell.h"
#import "ChatImageMsgModel.h"

@interface ChatImageMsgCell ()
/// 文本展示
@property (nonatomic, strong) UIImageView * imgView;
@end

@implementation ChatImageMsgCell

/// 注册子视图
- (void)initSubViews {
    [self.contentView addSubview:self.avatarImgView];
    [self.contentView addSubview:self.containerView];
    
    // 实际展示 UI
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [self.imgView setContentMode:(UIViewContentModeScaleAspectFill)];
    [self.imgView setupCorners:(UIRectCornerAllCorners) radius:8 size:self.imgView.frame.size];
    [self.containerView addSubview:self.imgView];
}

#pragma mark - < 数据展示 >
/// 配置数据
/// - Parameter data: 绑定的数据
- (void)configureWithModel:(id _Nullable)data {
    if (![data isKindOfClass:ChatImageMsgModel.class]) return;
    [super configureWithModel:data];
    
    ChatImageMsgModel *model = (ChatImageMsgModel *)data;
    BOOL isMyMsg = model.msgDirection == 1;
    
    // frame
    CGRect frame = self.imgView.frame;
    if (isMyMsg && self.containerView.frame.size.width > frame.size.width) {
        frame.origin.x = self.containerView.frame.size.width - frame.size.width - 8;
    }else {
        frame.origin.x = 8;
    }
    self.imgView.frame = frame;
    
    // data
    if (model.data && [model.data isKindOfClass:UIImage.class]) {
        self.imgView.image = model.data;
    }else {
        self.imgView.image = nil;
    }
}

/// 配置高度
/// - Parameter data: 绑定的数据
+ (CGFloat)heightWithModel:(id _Nullable)data {
    if (![data isKindOfClass:ChatImageMsgModel.class]) return [self heightWithModel:data];
    ChatImageMsgModel *model = (ChatImageMsgModel *)data;
    
    CGFloat vHeight = 150;
    return model.edges.top + vHeight + model.edges.bottom;
}

@end
