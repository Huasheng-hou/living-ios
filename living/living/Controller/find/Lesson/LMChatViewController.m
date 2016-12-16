//
//  MainViewController.m
//  chatting
//
//  Created by JamHonyZ on 2016/12/12.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import "LMChatViewController.h"
#import "CustomToolbar.h"
#import "KeyBoardAssistView.h"
#import "MoreFunctionView.h"
#import "ChattingCell.h"

#define assistViewHeight  200
#define toobarHeight 45

@interface LMChatViewController ()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITextViewDelegate,
selectItemDelegate,
assistViewSelectItemDelegate,
moreSelectItemDelegate
>
{
    NSTimeInterval _visiableTime;
    
    CustomToolbar *toorbar;
    KeyBoardAssistView *assistView;
    MoreFunctionView *moreView;
    
    NSMutableArray *cellListArray;
}
@end

@implementation LMChatViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
     [self extraBottomViewVisiable:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellListArray=[NSMutableArray arrayWithObjects:@"我就是人家",@"我就是人家爱华仕的发生的回复卡萨丁发货啦第三方路撒地方hi老地方和是豆腐干豆腐是厉害是电饭锅和水电费了hi方式礼服阿贾克斯地方哈市的符号看俺看见啥地方忽视的的风格和对方更好的发挥和是豆腐干豆腐是厉害是电饭锅",@"我就是人家爱华仕的发生的回复卡萨丁发货啦第三方路撒地方hi老地方和是豆腐干豆腐是厉害是电饭锅和水电费了hi方式礼服阿贾克斯地方哈市",@"我就是人家爱华仕的发生的回复卡萨丁发货啦第三方路撒地方hi老地方和是豆腐干豆腐是厉害是电饭锅和水电费了hi方式礼服阿贾克斯地方哈市的符号看俺看见啥地方忽视的的风格", nil];
    
    [self createUI];
    
    
    [self botttomView];
}

#pragma mark 初始化视图静态界面
-(void)createUI
{
    self.title=@"语音教室";
    [super createUI];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight)];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //导航栏右边按钮
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navRightIcon"] style:UIBarButtonItemStyleDone target:self action:@selector(functionAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    NSArray *titleArray=@[@"禁言",@"问题",@"屏蔽",@"主持"];
    
    NSArray *iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon"];
    
    moreView=[[MoreFunctionView alloc]initWithContentArray:titleArray andImageArray:iconArray];
    moreView.delegate=self;
    [moreView setHidden:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:moreView];
}

#pragma mark 初始化自定义工具条及附加功能视图（选择照片及提问）
-(void)botttomView
{
    toorbar=[[CustomToolbar alloc]initWithFrame:CGRectMake(0, kScreenHeight-toobarHeight, kScreenWidth, toobarHeight)];
    [toorbar.inputTextView setDelegate:self];
    [toorbar setDelegate:self];
    [self.view addSubview:toorbar];
    
    assistView=[[KeyBoardAssistView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
    assistView.delegate=self;
    [self.view addSubview:assistView];
}

#pragma mark 导航栏右边按钮执行方法
-(void)functionAction
{
    [moreView setHidden:NO];
}

#pragma mark 导航栏右边按钮的子按钮执行方法
-(void)moreViewSelectItem:(NSInteger)item
{
    NSLog(@"===============更多选择是============%ld",(long)item);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cellListArray[indexPath.row] isKindOfClass:[NSString class]]) {
        
        NSString *contentStr=cellListArray[indexPath.row];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentStr];
        
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentStr.length)];
        CGSize contenSize = [contentStr boundingRectWithSize:CGSizeMake(kScreenWidth-75, MAXFLOAT)                                           options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TEXT_FONT_LEVEL_2,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        
        return contenSize.height+55;
    }
    if ([cellListArray[indexPath.row] isKindOfClass:[UIImage class]]) {
        
        return 150+55;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChattingCell *cell=[ChattingCell cellWithTableView:tableView];
    
    [cell setCellValue:cellListArray[indexPath.row]];
    
    return cell;
}

#pragma mark 输入完成后发送消息，（数组中添加数据并重新加载cell）
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [cellListArray addObject:textView.text];
        
        toorbar.inputTextView.text=@"";
        
        [self reLoadTableViewCell];
        
        return NO;
    }
    return YES;
}

#pragma mark 重新加载cell，并让cell自动滑到最底端
-(void)reLoadTableViewCell
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self scrollTableToFoot:YES];
    });
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
}

#pragma mark 语音说话及加号的执行方法（语音收缩、增加展示）
-(void)selectItem:(NSInteger)item
{
    [self.view endEditing:YES];
    switch (item) {
        case 0://语音
        {
            [self extraBottomViewVisiable:NO];
        }
            break;
        case 1://增加
        {
            [self extraBottomViewVisiable:YES];
        }
            break;
        default:
            break;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSTimeInterval timeValue;
    if (_visiableTime) {
        timeValue=_visiableTime;
    }else{
        timeValue=0.2f;
    }
    [UIView animateWithDuration:timeValue animations:^{
        self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight);
        [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight,kScreenWidth, toobarHeight)];
        [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
    }];
}

#pragma mark 选择照片及提问的执行方法
-(void)assistViewSelectItem:(NSInteger)item
{
     NSLog(@"=========选择照片及提问的执行方法==========%ld",(long)item);
    if (item==1) {//照片
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.modalTransitionStyle = UIModalPresentationCustom;
        [self presentViewController:imagePickerController animated:YES completion:^{
        }];
    }
    if (item==2) {//提问
        
    }
}

#pragma mark 选择照片后添加数组 重新加载cell
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
     [cellListArray addObject:image];
     [self reLoadTableViewCell];
     [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark 附加功能（选择照片，提问）展示或者收缩
-(void)extraBottomViewVisiable:(BOOL)state
{
    NSTimeInterval timeValue;
    if (_visiableTime) {
        timeValue=_visiableTime;
    }else{
        timeValue=0.2f;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (state) {
            [UIView animateWithDuration:timeValue animations:^{
                
                self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-assistViewHeight-toobarHeight);
                [self scrollTableToFoot:YES];
                
                [toorbar setFrame:CGRectMake(0, kScreenHeight-assistViewHeight-toobarHeight,kScreenWidth, toobarHeight)];
                [assistView setFrame:CGRectMake(0, kScreenHeight-assistViewHeight, kScreenWidth, assistViewHeight)];
            } ];
        }else{
            [UIView animateWithDuration:timeValue animations:^{
                
                self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight);
                [self scrollTableToFoot:YES];
                
                [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight,kScreenWidth, toobarHeight)];
                [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
            }];
        }
    });
}

#pragma mark Keyboard events

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    _visiableTime=animationDuration;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
         self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - keyboardRect.size.height - toobarHeight);
        [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight-keyboardRect.size.height, kScreenWidth, toobarHeight)];
         [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
        
           }];
     [self scrollTableToFoot:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    _visiableTime=animationDuration;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight,kScreenWidth, toobarHeight)];
        [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
        
        self.tableView.frame           = CGRectMake(0, 0, kScreenWidth, kScreenHeight - toobarHeight);
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
}

#pragma mark   滚动表格到底部
- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}


@end
