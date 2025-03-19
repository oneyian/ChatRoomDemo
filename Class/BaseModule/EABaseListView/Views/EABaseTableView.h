//
//  EABaseTableView.h
//  oneyian
//

#import <UIKit/UIKit.h>
#import "EABaseListViewBinder.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - < EABaseTableView >
/*
 * @author oneyian
 * @tip 只需三步即可创建并展示 cell
 
 * @1. 随意初始化
 * @2. cell 遵循 EABaseTableViewProtocol 处理数据
 * @3. [ - (void)updateTableViewWithSections:(NSArray<EABaseListViewSection *> *)sections ] 方法传入数据
 
 */
@interface EABaseTableView : UITableView

/// 初始化
+ (instancetype)tableView;
+ (instancetype)tableViewWithFrame:(CGRect)frame;

#pragma mark - < 更新数据源 >
/// 更新 tableview，根据传入的 Sections
- (void)updateTableViewWithSections:(NSArray<EABaseListViewSection *> *)sections;

#pragma mark - < Block >
/// cell 初始化完成
typedef void(^EABaseTableViewCellForRowAtIndexPathBlock)(UITableViewCell *cell, NSIndexPath *indexPath, id _Nullable cellModel);
/// headerFooter 初始化完成
typedef void(^EABaseTableViewHeaderFooterInSectionBlock)(UIView *view, NSInteger section, id _Nullable cellModel);

/// 点击 cell
typedef void(^EABaseTableViewDidSelectRowBlock)(EABaseTableView *tableView, NSIndexPath *indexPath, id _Nullable cellModel);
/// 响应 cell 上事件
typedef void(^EABaseTableViewRespondsToActionBlock)(NSIndexPath *indexPath, id _Nullable cellModel, id _Nullable actionData);

/// 滚动监听
typedef void(^EABaseTableViewDidScrollBlock)(UIScrollView *scrollView, EABaseScrollStatus status);
/// 手势过滤
typedef BOOL(^EABaseTableViewTriggerConditionBlock)(EABaseTableView *tableView, UIGestureRecognizer *gestureRecognizer, UIGestureRecognizer *otherGestureRecognizer);

#pragma mark - < 事件回调 >
/// cell 初始化完成
- (void)setCellDidLoadForRowAtIndexPathBlock:(EABaseTableViewCellForRowAtIndexPathBlock)block;
/// headerFooter 初始化完成
- (void)setHeaderFooterDidLoadInSectionBlock:(EABaseTableViewHeaderFooterInSectionBlock)block;

/// 点击 cell
- (void)setDidSelectRowBlock:(EABaseTableViewDidSelectRowBlock)block;
/// 响应 cell 上事件
- (void)setRespondsToActionBlock:(EABaseTableViewRespondsToActionBlock)respondsToActionBlock;

/// 滚动监听
- (void)setScrollViewDidScrollBlock:(EABaseTableViewDidScrollBlock)block;
/// 手势过滤
- (void)setTriggerConditionBlock:(EABaseTableViewTriggerConditionBlock)block;

/// 滑动到最下方
- (void)scrollToBottomRow:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
