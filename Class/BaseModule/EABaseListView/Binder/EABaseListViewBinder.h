//
//  EABaseListViewBinder.h
//  oneyian
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 滚动状态
typedef NS_ENUM(NSInteger, EABaseScrollStatus) {
    EABaseScrollStatusWillBegin,
    EABaseScrollStatusDidScroll,
    EABaseScrollStatusDidEnd
};


#pragma mark - < EABaseListViewBinder >
@interface EABaseListViewBinder : NSObject
/// class 标识
@property (nonatomic, assign) Class _Nullable templateClass;
/// 绑定的数据
@property (nonatomic, strong) id _Nullable data;
@end


#pragma mark - < EABaseListViewSection >
@interface EABaseListViewSection : NSObject
/// 区头
@property (nonatomic, strong) EABaseListViewBinder * headerModel;
/// 区尾
@property (nonatomic, strong) EABaseListViewBinder * footerModel;
/// cell 列表
@property (nonatomic, strong) NSArray<EABaseListViewBinder *> * cellModels;
@end

NS_ASSUME_NONNULL_END
