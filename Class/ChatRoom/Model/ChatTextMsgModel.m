//
//  ChatTextMsgModel.m
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import "ChatTextMsgModel.h"
#import "SugarMarcos.h"

@implementation ChatTextMsgModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textSize = CGSizeMake(20, 20);
    }
    return self;
}

- (Class)templateClass {
    return NSClassFromString(@"ChatTextMsgCell");
}

- (void)setData:(id)data
{
    [super setData:data];
    
    if (!data || ![data isKindOfClass:NSString.class]) return;
    NSString *textValue = (NSString *)data;
    
    UIFont *font = Font(14);
    CGSize maxSize = CGSizeMake(150, ScreenHeight());
    
    self.textSize = [textValue boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil].size;
}


@end
