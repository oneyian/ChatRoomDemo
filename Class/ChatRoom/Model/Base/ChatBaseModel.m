//
//  ChatBaseModel.m
//  ChatDemo
//
//  Created by oneyian on 2025/3/19.
//

#import "ChatBaseModel.h"

@implementation ChatBaseModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.edges = UIEdgeInsetsMake(10, 14, 10, 14);
    }
    return self;
}

- (Class)templateClass {
    return NSClassFromString(@"ChatBaseCell");
}

@end
