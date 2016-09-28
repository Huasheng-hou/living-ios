//
//  DYLoginViewController.m
//  dirty
//
//  Created by Ding on 16/8/23.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMLoginViewController.h"
#import "FitNavigationController.h"
#import "NSString+StringHelper.h"

#import "DYGetCaptchaRequest.h"
#import "DYloginRequest.h"

#import "LMRegisterViewController.h"


#define TOKEN @"dirty2016"
@interface LMLoginViewController ()<UITextFieldDelegate>
{
    UITextField     *_phoneTF;
    UITextField     *_codeTF;
    NSString        *_uuid;
    NSString        *_password;
    BOOL            _ifEdit;
    
    UILabel         *codeBtn;
    NSTimer         *_timer;
    
    int              _number;
    UIImageView     *_doneImg;
    UIButton        *_loginBtn;
    NSString        *gender;
}

@end

@implementation LMLoginViewController


+ (void)presentInViewController:(UIViewController *)viewController Animated:(BOOL)animated
{
    if (!viewController) {
        return;
    }
    
    LMLoginViewController      *loginVC    = [[LMLoginViewController alloc] init];
    FitNavigationController *navVC      = [[FitNavigationController alloc] initWithRootViewController:loginVC];
    
    [viewController presentViewController:navVC animated:animated completion:^{
        
    }];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title  = @"登录";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    _number=60;
}

- (void)createUI
{
    [super createUI];
    
    self.tableView.keyboardDismissMode  = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorInset   = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
//    self.tableView.backgroundColor  = [UIColor whiteColor];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    self.tableView.tableHeaderView = headView;
    
//    self.navigationController.navigationBar.tintColor  = ;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(submitBtnPressed)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UIView  *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    UILabel *hintLbl    = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 15)];
    hintLbl.textAlignment   = NSTextAlignmentCenter;
    hintLbl.font            = TEXT_FONT_LEVEL_3;

    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"点击登录即理解并且同意《生活馆服务协议》"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:91.0/255.0 green:115.0/255.0 blue:192.0/255.0 alpha:1.0] range:NSMakeRange(11,str.length-11)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,11)];
    
    hintLbl.attributedText = str;
    
    
    
    
    [footerView addSubview:hintLbl];
       [footerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(lookProtocol)]];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.tableView.tableFooterView  = footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70+kScreenHeight/3;
    }
    if (indexPath.row == 1) {
        return 90;
    }
    if (indexPath.row == 2) {
        return 100;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString    *CELL_IDENTIFI  = @"CELL_IDENTIFI";
    
    UITableViewCell *cell   = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFI];
    
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = YES;
    
    if (indexPath.row == 0) {

        
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight/3)];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, kScreenHeight/6-50, 100, 100)];
        iconView.image = [UIImage imageNamed:@"editMsg"];
        [headView addSubview:iconView];
        [cell.contentView addSubview:headView];
        
        
        
        
        
        _phoneTF                = [[UITextField alloc] initWithFrame:CGRectMake(20, 30+kScreenHeight/3, kScreenWidth - 120, 50)];
        _phoneTF.keyboardType   = UIKeyboardTypePhonePad;
        _phoneTF.placeholder    = @"请输入手机号码";
        _phoneTF.delegate       = self;
        _phoneTF.textColor      = [UIColor blackColor];
        [_phoneTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        [cell.contentView addSubview:_phoneTF];
        
        UIView *botLine = [[UIView alloc] initWithFrame:CGRectMake(20, 79+kScreenHeight/3, kScreenWidth - 40, 0.5)];
        
        botLine.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:botLine];
    }
    if (indexPath.row == 1) {
        _codeTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth - 140, 50)];
        _codeTF.placeholder     = @"请输入验证号码";
        _codeTF.font = [UIFont systemFontOfSize:17];
        _codeTF.keyboardType    = UIKeyboardTypePhonePad;
        _codeTF.delegate = self;
        _codeTF.tag = 0412;
        [_codeTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        _codeTF.textColor       = [UIColor blackColor];
        
        [cell.contentView addSubview:_codeTF];
        
        UILabel     *lbl    = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 118, 10, 10, 50)];
        
        lbl.text            = @"/";
        lbl.font            = [UIFont boldSystemFontOfSize:18];
        lbl.textColor       = [UIColor colorWithRed:91.0/255.0 green:115.0/255.0 blue:192.0/255.0 alpha:1.0];
        lbl.textAlignment   = NSTextAlignmentCenter;
        [cell.contentView addSubview:lbl];
        
        codeBtn                    = [[UILabel alloc]init];
        codeBtn.layer.cornerRadius = 5;
        codeBtn.frame              = CGRectMake(kScreenWidth - 115, 10, 100, 50);
        codeBtn.text               = @"获取验证码";
        codeBtn.textColor          = [UIColor colorWithRed:91.0/255.0 green:115.0/255.0 blue:192.0/255.0 alpha:1.0];
        codeBtn.userInteractionEnabled = YES;
        codeBtn.clipsToBounds      = YES;
        codeBtn.textAlignment      = NSTextAlignmentCenter;
        codeBtn.font                = TEXT_FONT_LEVEL_1;
        UITapGestureRecognizer      *codeButTap    = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginBtnPressed)];
        [codeBtn addGestureRecognizer:codeButTap];
        [cell.contentView addSubview:codeBtn];
        
        UIView *botLine = [[UIView alloc] initWithFrame:CGRectMake(20, 59, kScreenWidth - 40, 0.5)];
        
        botLine.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:botLine];
        
    }
    if (indexPath.row == 2) {
        cell.backgroundColor = [UIColor clearColor];
        _loginBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _loginBtn.titleLabel.textColor  = [UIColor whiteColor];
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0]];
        _loginBtn.frame  = CGRectMake(15, 40, kScreenWidth - 30, 45);
        _loginBtn.layer.cornerRadius    = 5.0f;
        _loginBtn.clipsToBounds         = YES;
        
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(submitBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:_loginBtn];
    }
    return cell;
}

#pragma mark 验证码60s倒计时

- (void)timeFireMethod
{
    
    codeBtn.font                  = [UIFont systemFontOfSize:13];
    codeBtn.text                  = [NSString stringWithFormat:@"%d后重新发送",_number--];
    if (_number == 0)
    {
        [_timer invalidate];
        codeBtn.userInteractionEnabled = YES;
        codeBtn.text        = @"发送验证码";
        codeBtn.font        = TEXT_FONT_LEVEL_1;
        _number             = 60;
    }
}

#pragma mark 获取验证码按钮执行函数

- (void)loginBtnPressed
{
    //  手机号正则
    NSString *mobileRegex = @"[1][34578][0-9]{9}";
    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    
    if (!_phoneTF.text || ![mobilePredicate evaluateWithObject:_phoneTF.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的手机号码"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];
    
    //    倒计时60秒 同时 发送验证码按钮失去响应
    _timer                                            = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    codeBtn.userInteractionEnabled                    = NO ;
    
    DYGetCaptchaRequest    *request    = [[DYGetCaptchaRequest alloc] initWithPhone:_phoneTF.text];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(parseResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取验证码失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

#pragma mark  获取验证码响应方法

- (void)parseResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"获取验证码失败"];
        return;
    }
    
    NSString *result    = [bodyDict objectForKey:@"result"];
    
    if (result && [result intValue] == 0) {
        
        [self textStateHUD:@"验证码已发送"];
        
        [_codeTF becomeFirstResponder];
        
    } else {
        
        if ([bodyDict objectForKey:@"description"] && [[bodyDict objectForKey:@"description"] isKindOfClass:[NSString class]]) {
            
            [self textStateHUD:[bodyDict objectForKey:@"description"]];
        } else {
            [self textStateHUD:@"获取验证码失败"];
        }
    }
}

#pragma mark 立即登录按钮执行函数


- (void)submitBtnPressed
{
    //      验证码正则
    NSString    *verCodeRegex     = @"[0-9]{4}";
    NSPredicate *verCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verCodeRegex];
    
    _password   = [self generatePassword:_phoneTF.text];
    
    if (!_codeTF.text || ![verCodePredicate evaluateWithObject:_codeTF.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码有误"
                                                        message:@"验证码为四位数字"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self initStateHud];
    
    
    DYloginRequest *request    = [[DYloginRequest alloc] initWithPhone:_phoneTF.text
                                                                      andCode:_codeTF.text andPassword:_password];
    
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(parseCodeResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"登录失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

#pragma mark 立即登录按钮的响应函数

- (void)parseCodeResponse:(NSString *)resp
{
    [self hideStateHud];
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"登录失败"];
        return;
    }
    
    NSString *result    = [bodyDict objectForKey:@"result"];
    
    if (result && [result intValue] == 0)
    {
        
        _uuid       = [bodyDict objectForKey:@"user_uuid"];
        NSString *is_exist = [bodyDict objectForKey:@"is_exist"];
        if (is_exist && [is_exist intValue] == 0) {
            LMRegisterViewController *registerVC = [[LMRegisterViewController alloc] init];
            registerVC.userId = _uuid;
            registerVC.passWord = _password;
            registerVC.numberString = _phoneTF.text;
            [self.navigationController pushViewController:registerVC animated:YES];
        }else{
            gender      = [bodyDict objectForKey:@"gender"];
            [self setUserInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login"
             
                                                                object:nil];

             [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
       
    } else {
        [self textStateHUD:@"登录失败"];
    }
}


#pragma mark  密码生成方法

- (NSString *)generatePassword:(NSString *)phone
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-DD hh:ii:ss"];
    NSString    *password   = [NSString stringWithFormat:@"%@%@%@", [formatter stringFromDate:[NSDate date]], phone, TOKEN];
    return password.md5;
}


#pragma mark 登记用户信息

- (void)setUserInfo{
    NSMutableDictionary *userInfo   = [NSMutableDictionary new];
    
    if (_uuid) {
        [userInfo setObject:_uuid forKey:@"uuid"];
    }
    
    if (_phoneTF.text) {
        [userInfo setObject:_phoneTF.text forKey:@"phone"];
    }
    
    if (_password) {
        [userInfo setObject:_password forKey:@"password"];
    }
    
    if (gender) {
        [userInfo setObject:gender forKey:@"gender"];
    }
    
    [[FitUserManager sharedUserManager] updateUserInfo:userInfo];
}

#pragma mark 隐私条款执行方法

- (void)lookProtocol
{
//    FirWEBViewController *webVC = [[FirWEBViewController alloc] init];
//    
//    webVC.urlString = @"http://test.appring.cn:8080/fastask/user-cn.html";
//    webVC.titleString = @"隐私协议";
//    
//    [self.navigationController pushViewController:webVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
