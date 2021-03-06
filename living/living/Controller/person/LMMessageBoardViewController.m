//
//  LMMessageBoardViewController.m
//  living
//
//  Created by Ding on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMMessageBoardViewController.h"

#import "LMFriendMessageRequest.h"

#import "LMFriendVO.h"

#import "LMLevavingMessageRequest.h"

#import "LMFriendMessageCell.h"


#define PAGER_SIZE      20

@interface LMMessageBoardViewController ()<UITextViewDelegate>
{
    UIToolbar *toolBar;
    UITextView *textcView;
    UIButton *zanButton;
    UILabel  *tipLabel;
    NSInteger _rows;
    CGFloat bgViewY;
    CGFloat contentSize;
}

@end

@implementation LMMessageBoardViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMessage:) name:@"message_notice" object:nil];
 
    }
    
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.listData.count == 0) {
        
        [self loadNoState];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"留言";
    
    [self creatUI];
    [self loadNewer];
    [self registerForKeyboardNotifications];
    

}

- (void)creatUI
{
    
    [super createUI];
    self.tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 50, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 50, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 50, 0);
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    
    [self creatFootView];
    
}


- (void)creatFootView
{
    toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, kScreenHeight-45, kScreenWidth, 45)];
    toolBar. barStyle = UIBarButtonItemStylePlain ;
    toolBar.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview :toolBar];
    
    textcView = [[UITextView alloc] initWithFrame:CGRectMake(15, 7.5, kScreenWidth-65, 30)];
    [textcView setDelegate:self];
    textcView.font = TEXT_FONT_LEVEL_2;
    textcView.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    textcView.layer.borderWidth = 1;
    
    textcView.backgroundColor = [UIColor whiteColor];
    textcView.layer.cornerRadius    = 4;
    
    textcView.keyboardType=UIKeyboardTypeDefault;
    [textcView setReturnKeyType:UIReturnKeySend];
    
    zanButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 0, 50, 45)];
    zanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [zanButton setTitle:@"发送" forState:UIControlStateNormal];
    [zanButton setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
    [zanButton addTarget:self action:@selector(sendMessageDataRequest) forControlEvents:UIControlEventTouchUpInside];
    zanButton.titleLabel.font = TEXT_FONT_LEVEL_3;
    
    [toolBar addSubview:zanButton];
    
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kScreenWidth-60, 30)];
    tipLabel.text = @"说点什么吧";
    tipLabel.textColor =TEXT_COLOR_LEVEL_3;
    tipLabel.font = TEXT_FONT_LEVEL_3;
    [textcView addSubview:tipLabel];
    
    [toolBar addSubview:textcView];
    
}


- (FitBaseRequest *)request
{
    LMFriendMessageRequest    *request    = [[LMFriendMessageRequest alloc] initWithPageIndex:self.current andPageSize:PAGER_SIZE user_uuid:_friendUUid];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    NSString    *result         = [bodyDic objectForKey:@"result"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];

        
        return [LMFriendVO LMFriendVOListWithArray:[bodyDic objectForKey:@"list"]];
        
    } else if (description && ![description isEqual:[NSNull null]] && [description isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:description waitUntilDone:NO];
    }
    
    return nil;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat conHigh = 0;
    LMFriendVO *vo = self.listData[indexPath.row];
        NSString *string;
        
        if (vo.content) {
            string =[NSString stringWithFormat:@"%@：%@",vo.nickname,vo.content];

        }else{
            string =[NSString stringWithFormat:@"%@回复%@：%@",vo.myNickname,vo.nickname,vo.myContent];


        }
    NSDictionary *attributes    = @{NSFontAttributeName:TEXT_FONT_LEVEL_1};
    conHigh = [string boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000)
                                   options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:attributes
                                   context:nil].size.height;

    
    
    return conHigh +20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    
    LMFriendMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LMFriendMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
   
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    LMFriendVO *list =[self.listData objectAtIndex:indexPath.row];
    
    cell.friendVO = list;
    
    return cell;
}

-(void)sendMessageDataRequest
{
    contentSize = 0;
    [textcView resignFirstResponder];
    [self initStateHud];
    LMLevavingMessageRequest *request = [[LMLevavingMessageRequest alloc] initWithuser_uuid:_friendUUid andContent:textcView.text];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(sendMessageDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

-(void)sendMessageDataResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"留言失败~"];
        return;
    }
    
    NSString *result    = [bodyDict objectForKey:@"result"];
    
    if (result && [result intValue] == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideStateHud];
            textcView.frame = CGRectMake(15, 7.5, kScreenWidth-65, 30);
        });
        textcView.text = @"";
        tipLabel.hidden=NO;
        [self scrollTableToFoot:YES];
        [self loadNoState];
        
    } else {
        [self textStateHUD:bodyDict[@"description"]];
    }
}

#pragma mark 键盘部分

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(keyboardWasHidden:)
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)keyboardChangeFrame:(NSNotification *)notifi
{
    
    
    CGRect keyboardFrame = [notifi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:duration animations:^{
        toolBar.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - kScreenHeight);
        bgViewY = toolBar.frame.origin.y;

    }];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    CGFloat curkeyBoardHeight = [[[notif userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[notif userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notif userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        [UIView animateWithDuration:0.1f animations:^{
            [toolBar setFrame:CGRectMake(0, kScreenHeight-(curkeyBoardHeight+toolBar.height+contentSize), kScreenWidth, toolBar.height+contentSize)];
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - curkeyBoardHeight - toolBar.frame.size.height);
        }];
    }
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    
    [UIView animateWithDuration:0.1f animations:^{
        toolBar.frame = CGRectMake(0, kScreenHeight-45, kScreenWidth, 45);
        
        NSLog(@"***keyboardWasHidden*%@",toolBar);
        self.tableView.frame  = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
    
    
}

#pragma mark UITextFieldDelegate

//获取textView高度

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([textView isEqual:textcView]) {
        if (textView.text.length==0) {
            tipLabel.hidden=NO;
        }else{
            tipLabel.hidden=YES;
        }
        
        // numberlines用来控制输入的行数
        NSInteger numberLines = textView.contentSize.height / textView.font.lineHeight;
        if (numberLines != _rows) {
            NSLog(@"text = %@", textcView.text);
            _rows = numberLines;
            if  (_rows < 5){
                [self changeFrame:textView.contentSize.height];
            }else{
                textcView.scrollEnabled = YES;
            }
            
            [textView setContentOffset:CGPointZero animated:YES];
        }
    }
}

- (void)changeFrame:(CGFloat)height
{
    CGRect originalFrame = toolBar.frame;
    originalFrame.size.height = 30 + height ;
    originalFrame.origin.y = bgViewY - height + 30;
    CGRect textViewFrame = textcView.frame;
    textViewFrame.size.height = height;
    
    [UIView animateWithDuration:0.3 animations:^{
        toolBar.frame = originalFrame;
        textcView.frame = textViewFrame;
        contentSize = height-30;
    }];
}

//修改textView return键

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if ([textView isEqual:textcView]) {
            [textcView resignFirstResponder];
            [self sendMessageDataRequest];
        }

        
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)addMessage:(NSNotification *)notice
{
    
    NSDictionary *dic = notice.userInfo;
    NSLog(@"%@",dic);
    NSDictionary *message = dic[@"message"];
    NSMutableDictionary *new = [NSMutableDictionary new];
    NSMutableArray *array = [NSMutableArray new];
    [new setObject:message[@"push_dsp"] forKey:@"content"];
    [new setObject:message[@"push_title"] forKey:@"nickname"];
    [array addObject:new];
    NSArray *array2 = [LMFriendVO LMFriendVOListWithArray:array];
    [self.listData addObjectsFromArray:array2];
    [self.tableView reloadData];
    [self scrollTableToFoot:YES];
    
    
    
    
}

#pragma mark   滚动表格到底部
- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];
    if (s < 1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    
    if (r < 1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}




@end
