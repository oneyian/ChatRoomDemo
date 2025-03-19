//
//  EABaseTableView.m
//  oneyian
//

#import "EABaseTableView.h"
#import "EABaseListViewProtocol.h"

#pragma mark - < EABaseTableView >
@interface EABaseTableView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
/// 数据源
@property (nonatomic, strong) NSArray<EABaseListViewSection *> * sections;

/// 事件回调
@property (nonatomic, copy) EABaseTableViewCellForRowAtIndexPathBlock cellDidLoadForRowAtIndexPathBlock;
@property (nonatomic, copy) EABaseTableViewHeaderFooterInSectionBlock headerFooterDidLoadInSectionBlock;

/// 点击事件
@property (nonatomic, copy) EABaseTableViewDidSelectRowBlock didSelectRowBlock;
@property (nonatomic, copy) EABaseTableViewRespondsToActionBlock respondsToActionBlock;

/// 滚动手势
@property (nonatomic, copy) EABaseTableViewDidScrollBlock scrollViewDidScrollBlock;
@property (nonatomic, copy) EABaseTableViewTriggerConditionBlock triggerConditionBlock;
@end

@implementation EABaseTableView

#pragma mark - < 初始化 >
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _sections = [NSArray array];
        
        self.dataSource = self;
        self.delegate = self;
        
        // 预估高度
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 系统版本适配
        if (@available(iOS 15.0, *)) {
            self.sectionHeaderTopPadding = 0;
        }
        
        // 默认注册
        [self registerSectionWithTemplateClass:UITableViewHeaderFooterView.class];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame style:(UITableViewStylePlain)];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

+ (instancetype)tableViewWithFrame:(CGRect)frame {
    EABaseTableView *tableView = [[EABaseTableView alloc] initWithFrame:frame];
    return tableView;
}

+ (instancetype)tableView {
    EABaseTableView *tableView = [[EABaseTableView alloc] init];
    return tableView;
}

#pragma mark - < 更新 tableview 数据源 >
/// 更新 tableview，根据 Section 传入的 models
- (void)updateTableViewWithSections:(NSArray<EABaseListViewSection *> *)sections
{
    for (EABaseListViewSection *section in sections) {
        // cell
        for (EABaseListViewBinder *item in section.cellModels) {
            [self registerCellWithTemplateClass:item.templateClass];
        }
        
        // section
        [self registerSectionWithTemplateClass:section.headerModel.templateClass];
        [self registerSectionWithTemplateClass:section.footerModel.templateClass];
    }
    
    self.sections = sections.mutableCopy;
    [self reloadData];
}

#pragma mark - < 注册 cell >
- (void)registerCellWithTemplateClass:(Class)templateClass {
    NSAssert(templateClass, @"Cell 为 nil : return nil!");
    if (!templateClass) return;
    
    [self registerClass:templateClass forCellReuseIdentifier:NSStringFromClass(templateClass)];
}

#pragma mark - < 注册 Section >
- (void)registerSectionWithTemplateClass:(Class)templateClass {
    if (!templateClass) return;
    
    if ([templateClass isSubclassOfClass:UITableViewHeaderFooterView.class]) {
        [self registerClass:templateClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(templateClass)];
    }
}

#pragma mark - < Datesource >
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    EABaseListViewSection *sectionObject = self.sections[section];
    return sectionObject.cellModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EABaseListViewSection *sectionObject = self.sections[indexPath.section];
    EABaseListViewBinder *cellModel = sectionObject.cellModels[indexPath.row];
    
    Class cellClass = cellModel.templateClass;
    NSString *identifier = NSStringFromClass(cellClass);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if ([cellClass conformsToProtocol:@protocol(EABaseTableViewProtocol)]) {
        // 响应事件
        if ([cell respondsToSelector:@selector(configureActionBlock:)]) {
           
            __weak typeof(self) weakSelf = self;
            EARespondsToAction actionBlock = ^(id actionType) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                if (strongSelf.respondsToActionBlock) {
                    strongSelf.respondsToActionBlock(indexPath, cellModel, actionType);
                }
            };
            
            [cell performSelector:@selector(configureActionBlock:) withObject:actionBlock];
        }
        
        // 数据源
        if ([cell respondsToSelector:@selector(configureWithModel:)]) {
            [cell performSelector:@selector(configureWithModel:) withObject:cellModel];
        }
    }
    
    if (self.cellDidLoadForRowAtIndexPathBlock) {
        self.cellDidLoadForRowAtIndexPathBlock(cell, indexPath, cellModel);
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView;
    EABaseListViewBinder * sectionModel;
    
    EABaseListViewSection * sectionObject = self.sections[section];
    sectionModel = sectionObject.headerModel;
    
    Class sectionClass = sectionModel.templateClass;
    if (sectionClass == nil) sectionClass = UITableViewHeaderFooterView.class;
    
    // 初始化
    if ([sectionClass isSubclassOfClass:UITableViewHeaderFooterView.class])
    {
        NSString *identifier = NSStringFromClass(sectionClass);
        sectionView = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        
        if (sectionView == nil) {
            sectionView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        }
    }else {
        sectionView = [[sectionClass alloc] init];
    }
    
    // 填充数据
    if ([sectionClass conformsToProtocol:@protocol(EABaseTableViewProtocol)]) {
        // 响应事件
        if ([sectionView respondsToSelector:@selector(configureActionBlock:)]) {
           
            __weak typeof(self) weakSelf = self;
            EARespondsToAction actionBlock = ^(id actionType) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                if (strongSelf.respondsToActionBlock) {
                    strongSelf.respondsToActionBlock([NSIndexPath indexPathForRow:-1 inSection:section], sectionModel, actionType);
                }
            };
            
            [sectionView performSelector:@selector(configureActionBlock:) withObject:actionBlock];
        }
        
        // 数据源
        if ([sectionView respondsToSelector:@selector(configureWithModel:)]) {
            [sectionView performSelector:@selector(configureWithModel:) withObject:sectionModel];
        }
    }
    
    // 加载完成回调
    if (self.headerFooterDidLoadInSectionBlock) {
        self.headerFooterDidLoadInSectionBlock(sectionView, section, sectionModel);
    }
    
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView;
    EABaseListViewBinder * sectionModel;
    
    EABaseListViewSection * sectionObject = self.sections[section];
    sectionModel = sectionObject.footerModel;
    
    Class sectionClass = sectionModel.templateClass;
    if (sectionClass == nil) sectionClass = UITableViewHeaderFooterView.class;
    
    // 初始化
    if ([sectionClass isSubclassOfClass:UITableViewHeaderFooterView.class])
    {
        NSString *identifier = NSStringFromClass(sectionClass);
        sectionView = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        
        if (sectionView == nil) {
            sectionView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        }
    }else {
        sectionView = [[sectionClass alloc] init];
    }
    
    // 填充数据
    if ([sectionClass conformsToProtocol:@protocol(EABaseTableViewProtocol)]) {
        // 响应事件
        if ([sectionView respondsToSelector:@selector(configureActionBlock:)]) {
           
            __weak typeof(self) weakSelf = self;
            EARespondsToAction actionBlock = ^(id actionType) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                if (strongSelf.respondsToActionBlock) {
                    strongSelf.respondsToActionBlock([NSIndexPath indexPathForRow:-1 inSection:section], sectionModel, actionType);
                }
            };
            
            [sectionView performSelector:@selector(configureActionBlock:) withObject:actionBlock];
        }
        
        // 数据源
        if ([sectionView respondsToSelector:@selector(configureWithModel:)]) {
            [sectionView performSelector:@selector(configureWithModel:) withObject:sectionModel];
        }
    }
    
    // 加载完成回调
    if (self.headerFooterDidLoadInSectionBlock) {
        self.headerFooterDidLoadInSectionBlock(sectionView, section, sectionModel);
    }
    
    return sectionView;
}

#pragma mark - < Delegate >
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EABaseListViewSection *sectionObject = self.sections[indexPath.section];
    EABaseListViewBinder *cellModel = sectionObject.cellModels[indexPath.row];
    
    // 继承协议
    Class cellClass = cellModel.templateClass;
    BOOL conformsToProtocol = [cellClass conformsToProtocol:@protocol(EABaseTableViewProtocol)];
    Class <EABaseTableViewProtocol> cellClassProtocol = cellClass;
    
    // 优先取 block 高度
    CGFloat cellHeight = 0;
    
    // 取协议高度
    if (cellHeight <= 0 && conformsToProtocol && [cellClassProtocol respondsToSelector:@selector(heightWithModel:)]) {
        cellHeight = [cellClassProtocol heightWithModel:cellModel];
    }
    
    cellHeight = MAX(cellHeight, CGFLOAT_MIN);
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    EABaseListViewSection * sectionObject = self.sections[section];
    EABaseListViewBinder * sectionModel = sectionObject.headerModel;
    Class sectionClass = sectionModel.templateClass;
    
    // 取协议高度
    if (sectionClass && [sectionClass conformsToProtocol:@protocol(EABaseTableViewProtocol)])
    {
        Class <EABaseTableViewProtocol> sectionClassProtocol = sectionClass;
        if ([sectionClassProtocol respondsToSelector:@selector(heightWithModel:)]) {
            return [sectionClassProtocol heightWithModel:sectionModel];
        }
    }
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    EABaseListViewSection * sectionObject = self.sections[section];
    EABaseListViewBinder * sectionModel = sectionObject.footerModel;
    Class sectionClass = sectionModel.templateClass;
    
    // 取协议高度
    if (sectionClass && [sectionClass conformsToProtocol:@protocol(EABaseTableViewProtocol)])
    {
        Class <EABaseTableViewProtocol> sectionClassProtocol = sectionClass;
        if ([sectionClassProtocol respondsToSelector:@selector(heightWithModel:)]) {
            return [sectionClassProtocol heightWithModel:sectionModel];
        }
    }
    
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EABaseListViewSection *sectionObject = self.sections[indexPath.section];
    EABaseListViewBinder *cellModel = sectionObject.cellModels[indexPath.row];
    
    // 点击回调
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(self, indexPath, cellModel);
    }
}

#pragma mark - < ScrollViewDelegate >
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView, EABaseScrollStatusWillBegin);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView, EABaseScrollStatusDidScroll);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView, EABaseScrollStatusDidEnd);
    }
}

/// 滑动到最下方
- (void)scrollToBottomRow:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger count = [self numberOfSectionsInTableView:self];
        if (count <= 0) return;
        
        for (NSInteger section = (count - 1); section >= 0; section--) {
            NSInteger row = [self tableView:self numberOfRowsInSection:section];
            if (row > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row - 1 inSection:section];
                [self scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:animated];
                return;
            }
        }
    });
}

#pragma mark - < UIGestureRecognizerDelegate >
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.triggerConditionBlock) {
        return self.triggerConditionBlock(self, gestureRecognizer, otherGestureRecognizer);
    }else {
        return NO;
    }
}

@end
