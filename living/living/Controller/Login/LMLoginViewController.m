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
#import "LMWebViewController.h"
#import "LMGetCaptchaRequest.h"
#import "LMloginRequest.h"

#import "LMRegisterViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"

#define TOKEN @"dirty2016"

//微信授权

#import "LMWXLoginRequest.h"
#import "WechatInfoVO.h"
#import "CncpStartTime.h"

@interface LMLoginViewController ()
<
UITextFieldDelegate,
WXApiDelegate
>
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
    NSString        *privileges;
    NSString        *franchisee;
    NSString        *vipString;
    
    NSString        *_Id;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didFinishedWechatLogin:)
                                                     name:LM_WECHAT_LOGIN_CALLBACK_NOTIFICATION
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userLoginCancel)
                                                     name:LM_WECHAT_LOGIN_CANCEL_NOTIFICATION
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(wxLoginFailed)
                                                     name:LM_WECHAT_LOGIN_FAILED_NOTIFICATION
                                                   object:nil];
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
    self.tableView.separatorInset       = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:TEXT_COLOR_LEVEL_2};
    self.navigationController.navigationBar.tintColor = TEXT_COLOR_LEVEL_2;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"浏览看看" style:UIBarButtonItemStylePlain target:self action:@selector(justLook:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIImageView * leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"turnright"]];
    leftImage.transform = CGAffineTransformMakeRotation(M_PI);
    UIBarButtonItem *leftItem     = [[UIBarButtonItem alloc] initWithCustomView:leftImage];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)justLook:(UIBarButtonItem *)item{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( [WXApi isWXAppInstalled ]) {
        return 5;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }
    if (indexPath.row == 1) {
        return 90;
    }
    if (indexPath.row == 2) {
        return 60;
    }
    if (indexPath.row == 3) {
        return 40;
    }
    if (indexPath.row == 4) {
        return 200;
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
        
        UIImageView * phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 15, 20)];
        phoneView.image = [UIImage imageNamed:@""];
        phoneView.backgroundColor = BG_GRAY_COLOR;
        [cell.contentView addSubview:phoneView];
        
        _phoneTF                = [[UITextField alloc] initWithFrame:CGRectMake(40, 40, kScreenWidth - 50, 20)];
        _phoneTF.keyboardType   = UIKeyboardTypePhonePad;
        _phoneTF.placeholder    = @"请输入手机号码";
        _phoneTF.delegate       = self;
        _phoneTF.font           = TEXT_FONT_LEVEL_3;
        _phoneTF.textColor      = TEXT_COLOR_LEVEL_4;
        [_phoneTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        [cell.contentView addSubview:_phoneTF];
        
        UIView *botLine = [[UIView alloc] initWithFrame:CGRectMake(10, 70, kScreenWidth - 20, 0.5)];
        
        botLine.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:botLine];
    }
    if (indexPath.row == 1) {
        
        UIImageView * codeView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 15, 20)];
        codeView.image = [UIImage imageNamed:@""];
        codeView.backgroundColor = BG_GRAY_COLOR;
        [cell.contentView addSubview:codeView];
        
        _codeTF = [[UITextField alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth - 95, 20)];
        _codeTF.placeholder     = @"请输入验证号码";
        _codeTF.font = [UIFont systemFontOfSize:17];
        _codeTF.keyboardType    = UIKeyboardTypePhonePad;
        _codeTF.delegate = self;
        _codeTF.tag = 0412;
        _codeTF.font = TEXT_FONT_LEVEL_3;
        _codeTF.textColor = TEXT_COLOR_LEVEL_4;
        [_codeTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        [cell.contentView addSubview:_codeTF];
        
        UILabel     *lbl    = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 85, 10, 10, 20)];
        
        lbl.text            = @"/";
        lbl.font            = [UIFont boldSystemFontOfSize:16];
        lbl.textColor       = ORANGE_COLOR;
        lbl.textAlignment   = NSTextAlignmentCenter;
        [cell.contentView addSubview:lbl];
        
        codeBtn                    = [[UILabel alloc]init];
        codeBtn.layer.cornerRadius = 5;
        codeBtn.frame              = CGRectMake(kScreenWidth - 75, 10, 65, 20);
        codeBtn.text               = @"获取验证码";
        codeBtn.textColor          = ORANGE_COLOR;
        codeBtn.userInteractionEnabled = YES;
        codeBtn.clipsToBounds      = YES;
        codeBtn.textAlignment      = NSTextAlignmentCenter;
        codeBtn.font                = TEXT_FONT_LEVEL_3;
        UITapGestureRecognizer      *codeButTap    = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginBtnPressed)];
        [codeBtn addGestureRecognizer:codeButTap];
        [cell.contentView addSubview:codeBtn];
        
        UIView *botLine = [[UIView alloc] initWithFrame:CGRectMake(10, 40, kScreenWidth - 20, 0.5)];
        
        botLine.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:botLine];
        
    }
    if (indexPath.row == 2) {
        //cell.backgroundColor = [UIColor clearColor];
        _loginBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _loginBtn.titleLabel.textColor  = [UIColor whiteColor];
        [_loginBtn setBackgroundColor:BTN_ORANGE_COLOR];
        _loginBtn.frame  = CGRectMake(15, 15, kScreenWidth - 30, 45);
        _loginBtn.layer.cornerRadius    = 5.0f;
        _loginBtn.clipsToBounds         = YES;
        
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(submitBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:_loginBtn];
    }
    
    if (indexPath.row == 3) {
        UIView  *protocol = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        UILabel *hintLbl    = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 15)];
        hintLbl.textAlignment   = NSTextAlignmentCenter;
        hintLbl.font            = TEXT_FONT_LEVEL_3;
        
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"点击登录即理解并且同意《腰果生活服务协议》"];
        [str addAttribute:NSForegroundColorAttributeName value:ORANGE_COLOR range:NSMakeRange(11,str.length-11)];
        [str addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_LEVEL_4 range:NSMakeRange(0,11)];
        
        hintLbl.attributedText = str;
        
        [protocol addSubview:hintLbl];
        [protocol addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(lookProtocol)]];
        [cell.contentView addSubview:protocol];
        

    }
    
    if (indexPath.row == 4) {
        
        CGFloat lineW = 40;
        CGFloat lineGap = 10;
        
        
        UILabel * other = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, 15)];
        other.center = CGPointMake(cell.contentView.center.x, 110);
        other.text = @"其它方式登录";
        other.textColor = TEXT_COLOR_LEVEL_4;
        other.font = TEXT_FONT_LEVEL_4;
        [cell.contentView addSubview:other];
        
        UILabel * leftLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(other.frame)-lineGap-lineW, CGRectGetMinY(other.frame)+CGRectGetHeight(other.frame)/2-0.25, lineW, 0.5)];
        leftLine.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:leftLine];
        
        UILabel * rightLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(other.frame)+lineGap, CGRectGetMinY(other.frame)+CGRectGetHeight(other.frame)/2-0.25, lineW, 0.5)];
        rightLine.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:rightLine];
        
        
        NSArray *imageNames = @[@"share-1", @"share-1", @"share-1"];
        CGFloat w = 40;
        CGFloat gap = 20;
        CGFloat mainW = w*3 + gap*2;
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, mainW, w)];
        backView.center = CGPointMake(cell.contentView.center.x, 150);
        for (int i=0; i<3; i++) {
            UIButton * thirdLogin = [[UIButton alloc] initWithFrame:CGRectMake(i*(w+gap), 0, w, w)];
            [thirdLogin setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
            thirdLogin.tag = 300+i;
            [thirdLogin addTarget:self action:@selector(loginByOtherType:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:thirdLogin];
        }
        [cell.contentView addSubview:backView];

    }
    return cell;
}

#pragma mark 第三方登录
- (void)loginByOtherType:(UIButton *)btn{
    
    switch (btn.tag) {
        case 300:
        {
            //新浪登录
            
        }
            break;
        case 301:
        {
            //微信登录
            [self wxinLoginAction];
            
        }
            break;
        case 302:
        {
            //支付宝登录
            
        }
            break;
        default:
            break;
    }
}


#pragma mark 验证码60s倒计时

- (void)timeFireMethod
{
    codeBtn.font                  = [UIFont systemFontOfSize:13];
    codeBtn.text                  = [NSString stringWithFormat:@"%ds后重新发送",_number--];
    
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
        

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的手机号码"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        return;
    }
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];
    
    LMGetCaptchaRequest   *request    = [[LMGetCaptchaRequest alloc] initWithPhone:_phoneTF.text];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(parseResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

#pragma mark  获取验证码响应方法

- (void)parseResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"获取验证码失败"];
        return;
    }
    
    NSString *result    = [bodyDict objectForKey:@"result"];
    
    if (result && [result intValue] == 0) {
        
        [self textStateHUD:@"验证码已发送"];
        
        //    倒计时60秒 同时 发送验证码按钮失去响应
        _timer  = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(timeFireMethod)
                                                 userInfo:nil
                                                  repeats:YES];
        
        codeBtn.userInteractionEnabled      = NO ;
        
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
    if ([_phoneTF.text isEqualToString:@""]) {
        [self textStateHUD:@"请输入手机号"];
        return;
    }
    
    //      验证码正则
    NSString    *verCodeRegex     = @"[0-9]{6}";
    NSPredicate *verCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verCodeRegex];
    
    _password   = [self generatePassword:_phoneTF.text];
    
    if (!_codeTF.text || ![verCodePredicate evaluateWithObject:_codeTF.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码有误"
                                                        message:@"验证码为六位数字"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self initStateHud];
    
    LMloginRequest *request    = [[LMloginRequest alloc] initWithPhone:_phoneTF.text andPassword:_password andCaptcha:_codeTF.text];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                                   [self parseCodeResponse:resp];
                                               });
                                               
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

#pragma mark 立即登录按钮的响应函数

- (void)parseCodeResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"登录失败"];
        return;
    }
    
    NSString *result    = [bodyDict objectForKey:@"result"];
    
    if (result && [result intValue] == 0) {
        
        _uuid       = [bodyDict objectForKey:@"user_uuid"];
        _password   = [bodyDict objectForKey:@"password"];
        
        NSString *is_exist = [bodyDict objectForKey:@"has_profile"];
         privileges = [bodyDict objectForKey:@"privileges"];
        
        _Id         = [bodyDict objectForKey:@"userId"];
        
        franchisee = [bodyDict objectForKey:@"franchisee"];
        vipString =[bodyDict objectForKey:@"sign"];

        [self setUserInfo];
        [self textStateHUD:@"登录成功"];
        
        [self performSelector:@selector(loginSuccessed:) withObject:is_exist afterDelay:0.8];
        
    } else {
        
        NSString *string = [bodyDict objectForKey:@"description"];
        [self textStateHUD:string];
    }
}

- (void)loginSuccessed:(NSString *)is_exist
{
    if (is_exist && [is_exist intValue] == 0) {
        
        LMRegisterViewController *registerVC = [[LMRegisterViewController alloc] init];
        
        registerVC.userId = _uuid;
        registerVC.passWord = _password;
        registerVC.numberString = _phoneTF.text;
        
        [self.navigationController pushViewController:registerVC animated:YES];
    } else {
        
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:nil];
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

- (void)setUserInfo
{
    NSMutableDictionary *userInfo   = [NSMutableDictionary new];
    
    if (_uuid) {
        [userInfo setObject:_uuid forKey:@"uuid"];
    }
    if (privileges) {
        [userInfo setObject:privileges forKey:@"privileges"];
    }
    
    if (_phoneTF.text) {
        [userInfo setObject:_phoneTF.text forKey:@"phone"];
    }
    
    if (_password) {
        [userInfo setObject:_password forKey:@"password"];
    }
    
    if (franchisee) {
        [userInfo setObject:franchisee forKey:@"franchisee"];
    }
    
    if (vipString) {
        [userInfo setObject:vipString forKey:@"vipString"];
    }
    
    if (_Id) {
        [userInfo setObject:_Id forKey:@"userId"];
    }
    
    [[FitUserManager sharedUserManager] updateUserInfo:userInfo];
}

#pragma mark 隐私条款执行方法

- (void)lookProtocol
{
    LMWebViewController *webVC = [[LMWebViewController alloc] init];
    
    webVC.urlString = @"http://120.26.64.40:8080/living/user-cn.html";
    webVC.titleString = @"隐私协议";
    
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark --微信授权登陆

- (void)wxinLoginAction
{
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];
    [self performSelector:@selector(hideStateHud) withObject:nil afterDelay:7];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;//获取用户个人信息字段
        req.state = @"wx" ;
        
        [WXApi sendReq:req];
    });
}

- (void)userLoginCancel
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self textStateHUD:@"已取消授权，请重新登录"];
    });
}

- (void)wxLoginFailed
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self textStateHUD:@"微信登录失败"];
    });
}

// * 微信登录通知响应
//
- (void)didFinishedWechatLogin:(NSNotification *)notification
{   
    NSString    *code   = [[notification userInfo] objectForKey:@"code"];
    
    if (code && [code isKindOfClass:[NSString class]]) {
        
        NSURL   *tokenUrl   = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", wxAppID, wxAppSecret, code]];
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:tokenUrl]
                                           queue:[NSOperationQueue currentQueue]
                               completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
                                   NSDictionary *responseObj    = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                   
                                   if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
                                       
                                       [self textStateHUD:@"微信授权失败"];
                                       return;
                                   }
                                   
                                   NSString     *accessToken    = [responseObj objectForKey:@"access_token"];
                                   NSString     *openId         = [responseObj objectForKey:@"openid"];
                                   NSString     *unionId        = [responseObj objectForKey:@"unionid"];
                                   
                                   if (accessToken && ![accessToken isEqual:[NSNull null]] && [accessToken isKindOfClass:[NSString class]]) {
                                       
                                       [self wechatLogin:accessToken OpenId:openId UnionId:unionId];
                                   }
                               }];
    } else {
        
        [self textStateHUD:@"微信授权失败"];
        return;
    }
}

- (void)wechatLogin:(NSString *)accessToken OpenId:(NSString *)openId UnionId:(NSString *)unionId
{
    NSURL   *infoUrl    = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", accessToken, openId]];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:infoUrl]
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               
                               NSDictionary *responseObj    = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                               
                               if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
                                   
                                   [self textStateHUD:@"微信授权失败"];
                                   return;
                               }

                               WechatInfoVO     *vo = [WechatInfoVO WechatInfoVOWithDictionary:responseObj];
                               
                               if (vo.OpenId) {
                                   
                                   NSString *password   = [self generatePassword:vo.OpenId];
                                   
                                   LMWXLoginRequest     *request    = [[LMWXLoginRequest alloc] initWithWechatResult:responseObj andPassword:password];
                                   
                                   HTTPProxy    *proxy  = [HTTPProxy loadWithRequest:request completed:^(NSString *resp, NSStringEncoding encoding) {
                                       
                                       [self performSelectorOnMainThread:@selector(parseCodeResponse:)
                                                              withObject:resp
                                                           waitUntilDone:YES];
                                       
                                   } failed:^(NSError *error) {
                                       
                                       [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                              withObject:@"网络错误"
                                                           waitUntilDone:YES];
                                   }];
                                   
                                   [proxy start];
                               }
                           }];
}

@end
