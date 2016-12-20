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
#import "LMChatRecordsRequest.h"
#import "WebsocketStompKit.h"
#import "MssageVO.h"
#import "LMVoiceQuestionViewController.h"
#import "FirUploadImageRequest.h"
#import "ImageHelpTool.h"

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
    NSString *name;
    STOMPClient *client;
}
@end

@implementation LMChatViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
    }
    
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
     [self extraBottomViewVisiable:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadNewer];
    
    [self botttomView];
    [self createWebSocket];
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

- (FitBaseRequest *)request
{
    LMChatRecordsRequest    *request    = [[LMChatRecordsRequest alloc] initWithPageIndex:self.current andPageSize:20 voice_uuid:_voiceUuid];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary *respDict = [NSJSONSerialization
                              JSONObjectWithData:respData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    
    NSDictionary *headDic = [respDict objectForKey:@"head"];
    
    NSString    *coderesult         = [headDic objectForKey:@"returnCode"];
    
    if (coderesult && ![coderesult isEqual:[NSNull null]] && [coderesult isKindOfClass:[NSString class]] && [coderesult isEqualToString:@"000"]) {
        
        if (headDic[@"nick_name"]&&![headDic[@"nick_name"] isEqual:@""]) {
            name = headDic[@"nick_name"];
        }
    }
    
    NSString    *result         = [bodyDic objectForKey:@"result"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        
        NSArray *resultArr = [MssageVO MssageVOListWithArray:[bodyDic objectForKey:@"list"]];
        
        if (resultArr&&resultArr.count>0) {
            return resultArr;
        }
        
    } else if (description && ![description isEqual:[NSNull null]] && [description isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:description waitUntilDone:NO];
    }
    
    return nil;
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
    if (item == 1) {
        LMVoiceQuestionViewController *questVC = [[LMVoiceQuestionViewController alloc] init];
        questVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:questVC animated:YES];
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.listData.count   %lu",(unsigned long)self.listData.count);
    return self.listData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MssageVO *vo = self.listData[indexPath.row];
    
    if (vo.type&&[vo.type isEqual:@"chat"]) {
        NSString *contentStr=vo.content;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentStr];
        
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentStr.length)];
        CGSize contenSize = [contentStr boundingRectWithSize:CGSizeMake(kScreenWidth-75, MAXFLOAT)                                           options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TEXT_FONT_LEVEL_2,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        
        return contenSize.height+55;
    }
    if (vo.type&&[vo.type isEqual:@"picture"]) {
        
        return 150+55;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChattingCell *cell=[ChattingCell cellWithTableView:tableView];
    
    MssageVO *vo = self.listData[indexPath.row];
    [cell setCellValue:vo];
    
    return cell;
}

#pragma mark 输入完成后发送消息，（数组中添加数据并重新加载cell）
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        if (textView.text.length==0||[textView.text isEqual:@""]) {
            [self textStateHUD:@"请输入文字"];
            return NO;
        }else{
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *time = [formatter stringFromDate:date];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        NSMutableArray *array = [NSMutableArray new];
        [dic setObject:textView.text forKey:@"content"];
        [dic setObject:time forKey:@"time"];
        [dic setObject:name forKey:@"name"];
        [dic setObject:@"chat" forKey:@"type"];
        [array addObject:dic];
        NSArray *array2 = [MssageVO MssageVOListWithArray:array];
        [self.listData addObjectsFromArray:array2];
            
        NSString *strings  = [toorbar.inputTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
        NSDictionary *dics = @{@"type":@"chat",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"content":strings};
            
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
        NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
                
        [client sendTo:@"/message/hello" body:string];
 
        toorbar.inputTextView.text=@"";
        
        [self reLoadTableViewCell];
        
        return NO;
    }
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

#pragma mark 获取头像的url

- (void)getImageURL:(UIImage*)image
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];
    
    FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];
    
    UIImage *headImage  = [ImageHelpTool scaleImage:image];
    request.imageData   = UIImageJPEGRepresentation(headImage, 1);
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding){
                                               
                                               [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                      withObject:nil
                                                                   waitUntilDone:YES];
                                               NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
                                               
                                               NSString    *result = [bodyDict objectForKey:@"result"];
                                               
                                               if (result && [result isKindOfClass:[NSString class]]
                                                   && [result isEqualToString:@"0"]) {
                                                   NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                   if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
//                                                       _imgURL=imgUrl;
                                                       NSLog(@"%@",imgUrl);
                                                   }
                                               }
                                           } failed:^(NSError *error) {
                                               [self hideStateHud];
                                           }];
    [proxy start];
}

#pragma mark 确定执行方法

- (void)saveUserInfoResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict)
    {
        [self textStateHUD:@"保存失败"];
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]])
    {
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            
            [self textStateHUD:@"保存成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        }else{
            [self textStateHUD:[bodyDict objectForKey:@"description"]];
        }
    }
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


-(void)createWebSocket
{
    NSURL *websocketUrl = [NSURL URLWithString:@"ws://121.43.40.58/live-connect/websocket"];
    client=[[STOMPClient alloc]initWithURL:websocketUrl webSocketHeaders:nil useHeartbeat:NO];

    
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"Cookie",@"session=random", nil];
    
    [client connectWithHeaders:dict completionHandler:^(STOMPFrame *connectedFrame, NSError *error) {
        if (error) {
            NSLog(@"================连接失败=============%@", error);
            return;
        }

    }];
    [client subscribeTo:@"topic/greetings" messageHandler:^(STOMPMessage *message) {
        NSLog(@"=========topic/greetings===订阅消息=============%@",message);
    }];
    
}




@end
