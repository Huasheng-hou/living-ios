//
//  DYAddviceViewController.m
//  dirty
//
//  Created by Ding on 16/8/23.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMAddviceViewController.h"
#import "LMFeedBackRequest.h"
#import "FitConsts.h"

@interface LMAddviceViewController ()<UITextViewDelegate>
{
    UITextView *textView;
    UILabel *tip;
}

@end

@implementation LMAddviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    self.title=@"意见反馈";
    [self.view setBackgroundColor:BG_GRAY_COLOR];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, kNaviHeight+kStatuBarHeight, kScreenWidth, kScreenHeight/3)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    textView=[[UITextView alloc]initWithFrame:CGRectMake(10,
                                                         kNaviHeight+kStatuBarHeight+5,
                                                         kScreenWidth-20,
                                                         kScreenHeight/3-10)];
    
    textView.delegate=self;
    [textView setTextColor:[UIColor blackColor]];
    textView.font = TEXT_FONT_LEVEL_2;
    [textView setShowsVerticalScrollIndicator:NO];
    textView.keyboardType=UIKeyboardTypeDefault;
    [textView setReturnKeyType:UIReturnKeyDone];
    [self.view addSubview:textView];
    
    tip = [[UILabel alloc]initWithFrame:CGRectMake(15, kNaviHeight+kStatuBarHeight+10, kScreenWidth-20, 22)];
    
    [tip setText:@"您的建议，是我们改动的动力"];
    tip.font = TEXT_FONT_LEVEL_2;
    [tip setTextColor:TEXT_COLOR_LEVEL_3];
    [self.view addSubview:tip];
    
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15, headView.frame.size.height-25, 60, 25)];
    number.text = @"400";
    number.textColor = TEXT_COLOR_LEVEL_3;
    number.textAlignment = NSTextAlignmentRight;
    number.font = TEXT_FONT_LEVEL_2;
    [headView addSubview:number];
    
    UIButton *sendButton =[[UIButton alloc] initWithFrame:CGRectMake(15, headView.frame.size.height+kNaviHeight+kStatuBarHeight+30, kScreenWidth-30, 45)];
    [sendButton setTitle:@"提 交" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:17];
    sendButton.layer.cornerRadius=5.0f;
    [sendButton setClipsToBounds:YES];
    [sendButton addTarget:self action:@selector(senderFeedBackData) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundColor:LIVING_COLOR];
    [self.view addSubview:sendButton];
}

- (void)textViewDidChange:(UITextView *)textView1
{
    if (!textView1.text||textView1.text.length==0)
    {
        [tip setHidden:NO];
    }else{
        [tip setHidden:YES];
    }
}

- (BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (textView == textView1)
    {
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
        
        if ([aString length] > 300) {
            textView1.text = [aString substringToIndex:300];
            [self textStateHUD:@"意见反馈内容最多300个字"];
            return NO;
        }
    }
    return YES;
}

- (void)senderFeedBackData
{
    [textView resignFirstResponder];
    if ([textView.text isEqual:@""]) {
        [self textStateHUD:@"请输入反馈信息"];
        return;
    }
    
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        [self textStateHUD:@"反馈信息不能为空"];
        return;
    }
    
    if (textView.text.length<5){
        [self textStateHUD:@"要大于5个字"];
        return;
    }
    
    if (textView.text.length>400) {
        [self textStateHUD:@"反馈信息最多400个字"];
        return;
    }
    
//    [self uploadFeedback];
}

- (void)uploadFeedback
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }

    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *descriptionString = [[NSString alloc]initWithString:[textView.text stringByTrimmingCharactersInSet:whiteSpace]];

        LMFeedBackRequest *request=[[LMFeedBackRequest alloc]initWithFeedbackcontent:descriptionString];
    
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding)
                               {
                                   [self performSelectorOnMainThread:@selector(parseResponse:)
                                                          withObject:resp waitUntilDone:YES];
                               } failed:^(NSError *error) {
                                   [self textStateHUD:@"发送失败"];
                               }];
        [proxy start];
}

- (void)parseResponse:(NSString *)resp
{
    NSDictionary  *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict)
    {
        [self textStateHUD:@"发送失败"];
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]])
    {
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"])
        {
            [self textStateHUD:@"发送成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }else
    {
        [self textStateHUD:@"发送失败"];
    }
}


@end
