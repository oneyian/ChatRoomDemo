//
//  ChatTextMsgCell.m
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import "ChatTextMsgCell.h"
#import "ChatTextMsgModel.h"

@interface ChatTextMsgCell ()
/// 文本展示
@property (nonatomic, strong) UILabel * textLab;
@end

@implementation ChatTextMsgCell

/// 注册子视图
- (void)initSubViews {
    [self.contentView addSubview:self.avatarImgView];
    [self.contentView addSubview:self.containerView];
    
    self.textLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    self.textLab.font = Font(14);
    self.textLab.textColor = UIColor.blackColor;
    self.textLab.numberOfLines = 0;
    self.textLab.backgroundColor = UIColor.grayColor;
    [self.containerView addSubview:self.textLab];
}

#pragma mark - < 数据展示 >
/// 配置数据
/// - Parameter data: 绑定的数据
- (void)configureWithModel:(id _Nullable)data
{
    if (![data isKindOfClass:ChatTextMsgModel.class]) return;
    [super configureWithModel:data];
    
    ChatTextMsgModel *model = (ChatTextMsgModel *)data;
    BOOL isMyMsg = model.msgDirection == 1;
    
    // frame
    CGRect frame = self.textLabel.frame;
    frame.size = model.textSize;
    
    if (isMyMsg && self.containerView.frame.size.width > frame.size.width) {
        frame.origin.x = self.containerView.frame.size.width - frame.size.width - 8;
    }else {
        frame.origin.x = 8;
    }
    
    self.textLab.frame = frame;
    
    // data
    if (model.data && [model.data isKindOfClass:NSString.class]) {
        self.textLab.text = model.data;
    }else {
        self.textLab.text = nil;
    }
}

/// 配置高度
/// - Parameter data: 绑定的数据
+ (CGFloat)heightWithModel:(id _Nullable)data {
    if (![data isKindOfClass:ChatTextMsgModel.class]) return [self heightWithModel:data];
    ChatTextMsgModel *model = (ChatTextMsgModel *)data;
    
    CGFloat vHeight = MAX(model.textSize.height, 44);
    return model.edges.top + vHeight + model.edges.bottom;
}

@end
