//
//  ChatViewController.m
//  demo
//
//  Created by oneyian on 2025/3/19.
//

#import "ChatViewController.h"
#import "SugarMarcos.h"

#import "ChatViewModel.h"
#import "EABaseTableView.h"
#import "ChatInputBar.h"

@interface ChatViewController () <ChatViewModelDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/// viewModel
@property (nonatomic, strong) ChatViewModel * viewModel;

/// 列表
@property (nonatomic, strong) EABaseTableView * tableView;
/// 输入框
@property (nonatomic, strong) ChatInputBar * inputBar;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"聊天室";
    
    [self setupSubViews];
    [self setupDefaultData];
    [self setupNotification];
}

/// 设置子视图
- (void)setupSubViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputBar];
}

/// 初始数据
- (void)setupDefaultData {
    [self.viewModel loadInitDataList];
}

/// 刷新数据
- (void)reloadDataList:(NSArray<EABaseListViewSection *> *)dataList {
    [self.tableView updateTableViewWithSections:dataList];
    [self.tableView scrollToBottomRow:NO];
}

/// 通知
- (void)setupNotification {
    // 键盘监听
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHideOrShow:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - < 事件交互 >
/// 发送文字
- (void)textFieldEditend
{
    [self.viewModel sendTextMsg:self.inputBar.textView.text];
    self.inputBar.textView.text = nil;
}

/// 选择图片
- (void)enterImagePickerController
{
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    if (![UIImagePickerController isSourceTypeAvailable:type]) { return; }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate   = self;
    picker.sourceType = type;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}

/// 选择完成 - 发送图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [self.viewModel sendImageMsg:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - < 键盘通知 >
/// 键盘显示
- (void)keyboardWillShow:(NSNotification *)sender
{
    NSDictionary *dicInfo = sender.userInfo;
    NSValue * value = dicInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    // 得到键盘弹出后的键盘视图所在 y 坐标
    CGFloat keyBoardEndY = keyboardRect.origin.y;
    
    NSNumber *duration = [dicInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [dicInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    kWeakS(ws);
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        CGRect frame = ws.inputBar.frame;
        [ws updateInputBarTop:keyBoardEndY - frame.size.height isHide:NO];
    }];
}

/// 键盘收起
- (void)keyboardWillHideOrShow:(NSNotification *)sender
{
    NSDictionary *dicInfo = sender.userInfo;
    NSNumber *duration = [dicInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [dicInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    kWeakS(ws);
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        CGRect frame = ws.inputBar.frame;
        [ws updateInputBarTop:ScreenHeight() - frame.size.height - SafeBottomHeight() isHide:YES];
    }];
}

/// 更新输入框 top
- (void)updateInputBarTop:(CGFloat)top isHide:(BOOL)isHide
{
    CGRect frame = self.inputBar.frame;
    frame.origin.y = top;
    self.inputBar.frame = frame;
    
    CGRect vframe = self.tableView.frame;
    vframe.size.height = frame.origin.y - NavigationBarHeight();
    self.tableView.frame = vframe;
    
    if (isHide) return;
    [self.tableView scrollToBottomRow:NO];
}

#pragma mark - < 懒加载 >
/// viewModel
- (ChatViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[ChatViewModel alloc] init];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

/// 列表
- (EABaseTableView *)tableView {
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, NavigationBarHeight(), ScreenWidth(), self.inputBar.frame.origin.y - NavigationBarHeight());
        _tableView = [EABaseTableView tableViewWithFrame:frame];
        _tableView.backgroundColor = UIColor.groupTableViewBackgroundColor;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDragWithAccessory;
        
        // event
        kWeakS(ws);
        [_tableView setDidSelectRowBlock:^(EABaseTableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, id  _Nullable cellModel) {
            [ws.inputBar.textView resignFirstResponder];
        }];
    }
    return _tableView;
}

/// inputBar
- (ChatInputBar *)inputBar {
    if (_inputBar == nil) {
        CGFloat height = 44;
        _inputBar = [[ChatInputBar alloc] initWithFrame:CGRectMake(0, ScreenHeight() - height - SafeBottomHeight(), ScreenWidth(), height)];
        
        // event
        [_inputBar.textView addTarget:self action:@selector(textFieldEditend) forControlEvents:(UIControlEventEditingDidEndOnExit)];
        [_inputBar.imageItem addTarget:self action:@selector(enterImagePickerController) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _inputBar;
}

@end
