//
//  EABaseListViewBinder.m
//  oneyian
//

#import "EABaseListViewBinder.h"

@implementation EABaseListViewBinder

@end


@implementation EABaseListViewSection

- (EABaseListViewBinder *)headerModel {
    if (_headerModel == nil) {
        _headerModel = [EABaseListViewBinder new];
    }
    return _headerModel;
}

- (EABaseListViewBinder *)footerModel {
    if (_footerModel == nil) {
        _footerModel = [EABaseListViewBinder new];
    }
    return _footerModel;
}

- (NSArray<EABaseListViewBinder *> *)cellModels {
    if (_cellModels == nil) {
        _cellModels = [NSArray array];
    }
    return _cellModels;
}

@end
