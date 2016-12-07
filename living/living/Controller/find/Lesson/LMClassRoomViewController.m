//
//  LMClassRoomViewController.m
//  living
//
//  Created by JamHonyZ on 2016/12/7.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMClassRoomViewController.h"
#import "LMSegmentView.h"

#import "FitChatExpressionView.h"
#import "FitChatFunctionView.h"

#define PAGER_SIZE  20

@interface LMClassRoomViewController ()
<
itemTypeDelegate
>
{
    UITextView      *_inputTxtView;             //输入框
    UIToolbar       *_toolBar;                  //输入框工具栏
    CGFloat         keyboardHeight;             //动态适应高度
    NSIndexPath     *_resentIndexPath;
    BOOL            _shouldScroll;
    NSMutableArray          *_atName;           //存储@的所有名字
    UIButton                *_expressionBtn;    //切换表情按钮
    FitChatExpressionView   *_expressionView;   //表情图
    
    BOOL            _isScrollToFoot; //toolbar是否要移动到最低部
    UIImage         *_currentImg;   //选择的表情图片
    NSDictionary    *_selectedLinkDic;
    NSInteger       _imgIndex;
    UIButton        *_addImgBtn;
    BOOL            _ifAllTaked;
    UIBarButtonItem *_detailItem;
    // * 点击隐藏键盘的蒙层
    //
    UIView          *_hideKeyboardMask;
    UIButton * btntui;
}
@property (retain, nonatomic)   FitChatFunctionView     *functionView;

@end

@implementation LMClassRoomViewController

-(void)selectedItem:(NSInteger)item
{
    NSLog(@"===================item==================%ld",item);
    if (item==0) {//讲师主持
        
    }
    if (item==1) {//全部消息
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)creatUI
{
    self.title=@"语音教室";
     [super createUI];
    
     LMSegmentView *segmentView=[[LMSegmentView alloc]initWithViewHeight:40];
    [segmentView setDelegate:self];
    [self.view addSubview:segmentView];
    
   
    [self.tableView setFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-40)];
    
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    [self initInputControl];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.tableView.delegate = self;
    
    
    // * 添加隐藏键盘的蒙层
    //
    _hideKeyboardMask   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    [_hideKeyboardMask addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignCurrentFirstResponder)]];
    _hideKeyboardMask.userInteractionEnabled    = YES;
    _hideKeyboardMask.hidden                    = YES;
    
    UISwipeGestureRecognizer    *swipeGR    = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(resignCurrentFirstResponder)];
    
    swipeGR.direction   = UISwipeGestureRecognizerDirectionDown;
    
    [_hideKeyboardMask addGestureRecognizer:swipeGR];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_hideKeyboardMask];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    _shouldScroll   = YES;
    [self.tableView reloadData];
    
    if (!_atName) {
        _atName = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    _isScrollToFoot = YES;
    _imgIndex = 0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [MobClick endLogPageView:@"chat"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
    
    self.tableView.delegate = nil;
    _shouldScroll   = NO;
    
    // * 将隐藏键盘的蒙层从window中移除
    //
    [_hideKeyboardMask removeFromSuperview];
    _hideKeyboardMask   = nil;
    
    // * 隐藏“我也要上课”按钮
    //
    
    btntui.hidden   = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    btntui.hidden   = YES;
}

- (void)loadNewer
{
    
}

- (void)createUI
{
    [super createUI];
    
    self.tableView.frame            = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44-kNaviHeight-kStatuBarHeight);
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    [self initInputControl];
    
    
    [self performSelectorOnMainThread:@selector(loadMessages) withObject:nil waitUntilDone:NO];
    //self.navigationController.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems      = nil;
    
    _detailItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"group_icon"]
                                                   style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(detailItemPressed)];
    
    self.navigationItem.rightBarButtonItem  = _detailItem;
    
    btntui.hidden = YES;
}

- (void)refreshData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}


#pragma mark - TableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"chatCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
       return 50;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   
}

- (void)initInputControl
{
    _toolBar  = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44)];
    _toolBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_toolBar];
    
    _inputTxtView   = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth - 110, 34)];
    _inputTxtView.delegate      = self;
    _inputTxtView.layer.cornerRadius    = 4;
    _inputTxtView.layer.borderWidth     = 0.5;
    _inputTxtView.layer.borderColor     = [UIColor lightGrayColor].CGColor;
    _inputTxtView.showsVerticalScrollIndicator  = NO;
    _inputTxtView.backgroundColor               = [UIColor whiteColor];
    _inputTxtView.returnKeyType         = UIReturnKeySend;
    _inputTxtView.font                  = TEXT_FONT_LEVEL_2;
    
    [_toolBar addSubview:_inputTxtView];
    
    _expressionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _expressionBtn.frame = CGRectMake(kScreenWidth - 90, 7, 40, 30);
    _expressionBtn.imageView.contentMode    = UIViewContentModeScaleAspectFit;
    [_expressionBtn setImage:[UIImage imageNamed:@"iconfont-biaoqing"] forState:UIControlStateNormal];
    [_expressionBtn addTarget:self action:@selector(showExpressionView) forControlEvents:UIControlEventTouchUpInside];
    _expressionBtn.tintColor = [UIColor grayColor];
    
    [_toolBar addSubview:_expressionBtn];
    
    _addImgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _addImgBtn.frame = CGRectMake(kScreenWidth - 50, 7, 40, 30);
    _addImgBtn.imageView.contentMode         = UIViewContentModeScaleAspectFit;
    _addImgBtn.tintColor                     = [UIColor grayColor];
    [_addImgBtn setImage:[UIImage imageNamed:@"iconfont-jia"] forState:UIControlStateNormal];
    [_addImgBtn addTarget:self action:@selector(showFunctionView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolBar addSubview:_addImgBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideExpressionView)];
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hideExpressionView)];
//    pan.delegate = self;
    [self.tableView addGestureRecognizer:tap];
//    [self.tableView addGestureRecognizer:pan];
}

#pragma mark - expressionViewDelegate
- (void)passValueImage:(UIImage *)image imageID:(NSString *)imageID
{
}

- (void)resetInputControl
{
    CGRect frame = _toolBar.frame;
    
    _toolBar.frame      = CGRectMake(0, CGRectGetMaxY(frame) - 44, kScreenWidth, 44);
    _inputTxtView.frame = CGRectMake(10, 5, _inputTxtView.frame.size.width, 34);
    self.tableView.frame    = CGRectMake(0, 0, kScreenWidth, self.tableView.frame.size.height + frame.size.height - 44);
}

- (void)showFunctionView:(UIButton *)sender
{
    NSLog(@"=======================showFunctionView====================");
    
    [_inputTxtView resignFirstResponder];
    [sender removeTarget:self action:@selector(showFunctionView:) forControlEvents:UIControlEventTouchUpInside];
    [sender addTarget:self action:@selector(hideFunctionView:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - _toolBar.frame.size.height - _functionView.frame.size.height);
        _functionView.frame = CGRectMake(0, kScreenHeight - _functionView.frame.size.height, kScreenWidth, _functionView.frame.size.height);
        _expressionView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 220);
        _toolBar.frame = CGRectMake(0, kScreenHeight - _toolBar.frame.size.height, kScreenWidth, _toolBar.frame.size.height);
    }];
    _isScrollToFoot = YES;
}

- (void)hideFunctionView:(UIButton *)sender
{
    
     NSLog(@"================hideFunctionView=======showFunctionView====================");
    [_inputTxtView becomeFirstResponder];
    if (_expressionView.frame.origin.y != kScreenHeight || _functionView.frame.origin.y != kScreenHeight) {
        [UIView animateWithDuration:0.3 animations:^{
            _expressionView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _expressionView.frame.size.height);
            _functionView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _functionView.frame.size.height);
            _toolBar.frame = CGRectMake(0, kScreenHeight - _toolBar.frame.size.height, _toolBar.frame.size.width, _toolBar.frame.size.height);
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - _toolBar.frame.size.height-kNaviHeight-kStatuBarHeight);
        }];
    }
}

// UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

//收起表情图-ios
- (void)hideExpressionView
{
    if (_expressionView.frame.origin.y != kScreenHeight || _functionView.frame.origin.y != kScreenHeight) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - _toolBar.frame.size.height);
            _expressionView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _expressionView.frame.size.height);
            _functionView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _functionView.frame.size.height);
            _toolBar.frame = CGRectMake(0, kScreenHeight - _toolBar.frame.size.height-kNaviHeight-kStatuBarHeight, _toolBar.frame.size.width, _toolBar.frame.size.height);
        }];
    }
}

//切换成表情键盘时 修改切换表情按钮的属性
- (void)showExpressionView
{
    [_expressionBtn removeTarget:self action:@selector(showExpressionView) forControlEvents:UIControlEventTouchUpInside];
    [_expressionBtn setImage:[UIImage imageNamed:@"iconfont-jianpan"] forState:UIControlStateNormal];
    [_expressionBtn addTarget:self action:@selector(backToKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    _isScrollToFoot = NO;
    [_inputTxtView resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - _toolBar.frame.size.height - _expressionView.frame.size.height);
        _expressionView.frame = CGRectMake(0, kScreenHeight - _expressionView.frame.size.height, kScreenWidth, _expressionView.frame.size.height);
        _functionView.frame = CGRectMake(0, kScreenHeight, _functionView.frame.size.width, _functionView.frame.size.height);
        _toolBar.frame = CGRectMake(0, kScreenHeight - _expressionView.frame.size.height - _toolBar.frame.size.height, kScreenWidth, _toolBar.frame.size.height);
    }];
    
    _isScrollToFoot = YES;
}

//点击按钮返回键盘
- (void)backToKeyboard
{
    [_inputTxtView becomeFirstResponder];
}


- (void)scrollToFoot
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
}


#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        
        if (buttonIndex == 1) {
        }
    }
}

#pragma mark ImagePicker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = textView.contentSize;
    size.height -= 2;
    
    if ( size.height >= 68 ) {
        
        size.height = 68;
    }
    else if ( size.height <= 34 ) {
        
        size.height = 34;
    }
    
    if ( size.height != textView.frame.size.height ) {
        
        CGFloat span = size.height - textView.frame.size.height;
        
        CGRect frame = _toolBar.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        _toolBar.frame = frame;
        
        CGFloat centerY = frame.size.height / 2;
        
        frame = textView.frame;
        frame.size = size;
        textView.frame = frame;
        
        CGPoint center = textView.center;
        center.y = centerY;
        textView.center = center;
        
        frame = self.tableView.frame;
        frame.size.height -= span;
        self.tableView.frame = frame;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        NSLog(@"============发送消息的内容==============%@",textView.text);
        
        return NO;
    }
    
    //判断是否是删除操作
    if ([text isEqualToString:@""]) {
        
        NSRange range = textView.selectedRange; //获取光标的位置
        
        if (range.location != _inputTxtView.text.length) {
            
            return YES;
        }
        
        for (int i = 0; i < _atName.count; i++) {
            
            NSString    *name   = [_atName objectAtIndex:i];
            
            if (name && [name isKindOfClass:[NSString class]] && _inputTxtView.text.length >= name.length + 2) {
                
                NSString    *lastStr    = [_inputTxtView.text substringWithRange:NSMakeRange(_inputTxtView.text.length - name.length - 2, name.length + 2)];
                
                if ([lastStr isEqualToString:[NSString stringWithFormat:@"@%@ ", name]]) {
                    
                    _inputTxtView.text  = [_inputTxtView.text substringWithRange:NSMakeRange(0, _inputTxtView.text.length - name.length - 2)];
                    [_atName removeObjectAtIndex:i];
                    
                    [self textViewDidChange:_inputTxtView];
                    
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

#pragma mark - FitAtPersonControllerDelegate

- (void)passValue:(NSString *)name
{
    [_atName addObject:name];
    _inputTxtView.text = [NSString stringWithFormat:@"%@@%@ ",_inputTxtView.text, name];
    
    [self textViewDidChange:_inputTxtView];
}

#pragma mark Keyboard events

- (void)keyboardWillShow:(NSNotification *)notification
{
    _hideKeyboardMask.hidden    = NO;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGRect  frame   = CGRectMake(0, kScreenHeight - keyboardRect.size.height - _toolBar.frame.size.height, kScreenWidth, _toolBar.frame.size.height);
    [_expressionBtn removeTarget:self action:@selector(backToKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [_expressionBtn setImage:[UIImage imageNamed:@"iconfont-biaoqing"] forState:UIControlStateNormal];
    [_expressionBtn addTarget:self action:@selector(showExpressionView) forControlEvents:UIControlEventTouchUpInside];
    
    [_addImgBtn removeTarget:self action:@selector(hideFunctionView:) forControlEvents:UIControlEventTouchUpInside];
    [_addImgBtn addTarget:self action:@selector(showFunctionView:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         _toolBar.frame = frame;
                         self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - keyboardRect.size.height - _toolBar.frame.size.height);
                         _functionView.frame = CGRectMake(0, kScreenHeight-kStatuBarHeight-kNaviHeight, kScreenWidth, _functionView.frame.size.height);
                         keyboardHeight = keyboardRect.size.height;
                         _expressionView.frame = CGRectMake(0, kScreenHeight-kStatuBarHeight-kNaviHeight, kScreenWidth, _expressionView.frame.size.height);
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _hideKeyboardMask.hidden    = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGRect frame = _toolBar.frame;
    frame.origin.y += keyboardHeight;
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         if (_isScrollToFoot) {
                             
                             _toolBar.frame = frame;
                             
                             // * 在收起键盘时先禁掉tableView的滑动属性，防止在整个渲染过程中出现视图错乱（此解决办法与微信相同）
                             //
                             self.tableView.scrollEnabled   = NO;
                             self.tableView.frame           = CGRectMake(0, 0, kScreenWidth, kScreenHeight - _toolBar.frame.size.height);
                         }
                         keyboardHeight = 0;
                     } completion:^(BOOL finished) {
                         
                         // * 动画结束，回复tableView的滑动属性
                         //
                         self.tableView.scrollEnabled   = YES;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    
}


@end
