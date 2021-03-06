//
//  LMRechargeViewController.m
//  living
//
//  Created by Ding on 16/10/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMRechargeViewController.h"
#import "LMChangeLivingController.h"
#import "LMRechargeCell.h"
#import "LMRePayCell.h"

#import "LMChargeButton.h"

//支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "LMAliRechargeRequest.h"
#import "LMAliRechargeResultRequest.h"

//微信支付
#import "WXApiObject.h"
#import "WXApi.h"

#import "WXApiRequestHandler.h"

#import "LMWXRechargrRequest.h"
#import "LMWXRechargeResultRequest.h"
#import "LMWebViewController.h"
@interface LMRechargeViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
UIAlertViewDelegate,
liveNameProtocol
>
{
    LMRechargeCell *cell;
    NSInteger selectedIndex;
    UITableView *table;
    LMRePayCell *headcell;
    NSString *rechargeOrderUUID;
    UIView *footView;
    NSString *type;
}

@end

@implementation LMRechargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    
    // * 微信支付被用户取消
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wxPayCanceled)
                                                 name:LM_WECHAT_PAY_CANCEL_NOTIFICATION
                                               object:nil];
    
    // * 微信支付失败
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wxPayFailed)
                                                 name:LM_WECHAT_PAY_FAILED_NOTIFICATION
                                               object:nil];
    
    // * 微信支付结果确认
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(weixinPayEnsure)
                                                 name:LM_WECHAT_PAY_CALLBACK_NOTIFICATION
                                               object:nil];
    
    // * 支付宝支付结果确认
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(aliPayEnsure:)
                                                 name:@"aliPayEnsure"
                                               object:nil];
}

- (void)createUI
{
    self.title=@"余额充值";
    
    if (_index!=1) {
        _liveRoomName=@"添加充值生活馆";
    }
    
    table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [table setBackgroundColor:BG_GRAY_COLOR];
    [table setDelegate:self];
    [table setDataSource:self];
    [self.view addSubview:table];
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //尾部
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 375)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 40)];
    title.text = @"直接选择支付（获取优惠券将在确认订单中直接抵扣金额）";
    title.font = TEXT_FONT_LEVEL_3;
    title.textColor = TEXT_COLOR_LEVEL_2;
    [footView addSubview:title];
    
    
    LMChargeButton *button1 = [[LMChargeButton alloc] initWithFrame:CGRectMake(15, 40, (kScreenWidth-45)/2, 80)];
    button1.backgroundColor = [UIColor whiteColor];
    button1.tag = 1;
    button1.layer.borderWidth = 0.5;
    button1.layer.borderColor = LINE_COLOR.CGColor;
    button1.upLabel.text = @"1000元";
    button1.downLabel.text = @"优惠券50元";
    [button1 addTarget:self action:@selector(changeMoney:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button1];
    
    
    
    LMChargeButton *button2 = [[LMChargeButton alloc] initWithFrame:CGRectMake((kScreenWidth-45)/2+30, 40, (kScreenWidth-45)/2, 80)];
    button2.backgroundColor = [UIColor whiteColor];
    button2.tag = 2;
    button2.layer.borderWidth = 0.5;
    button2.layer.borderColor = LINE_COLOR.CGColor;
    button2.upLabel.text = @"3000元";
    button2.downLabel.text = @"优惠券188元";
    [button2 addTarget:self action:@selector(changeMoney:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button2];
    
    LMChargeButton *button3 = [[LMChargeButton alloc] initWithFrame:CGRectMake(15, 130, (kScreenWidth-45)/2, 80)];
    button3.backgroundColor = [UIColor whiteColor];
    button3.tag = 3;
    button3.layer.borderWidth = 0.5;
    button3.layer.borderColor = LINE_COLOR.CGColor;
    button3.upLabel.text = @"5000元";
    button3.midLabel.text = @"永久会员";
    button3.downLabel.text = @"优惠券388元";
    button3.type = 1;
    [button3 addTarget:self action:@selector(changeMoney:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button3];
    
    
    LMChargeButton *button4 = [[LMChargeButton alloc] initWithFrame:CGRectMake((kScreenWidth-45)/2+30, 130, (kScreenWidth-45)/2, 80)];
    button4.backgroundColor = [UIColor whiteColor];
    button4.layer.borderWidth = 0.5;
    button4.tag = 4;
    button4.layer.borderColor = LINE_COLOR.CGColor;
    button4.upLabel.text = @"10000元";
    button4.midLabel.text = @"永久会员";
    button4.downLabel.text = @"优惠券888元";
    button4.type = 1;
    [button4 addTarget:self action:@selector(changeMoney:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button4];
    
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.frame = CGRectMake(15, 238, 45, 30);
    NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"payArr"];
    if (searchArr==nil) {
        [agreeButton setImage:[UIImage imageNamed:@"disagree"] forState:UIControlStateNormal];

    }else{
        for (NSString *string in searchArr) {
            if ([string isEqual:@"agree"]) {
               [agreeButton setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
            }else{
                [agreeButton setImage:[UIImage imageNamed:@"disagree"] forState:UIControlStateNormal];
            }
        }
    }
    
    [agreeButton addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:agreeButton];
    
    UILabel *agreeLabel = [UILabel new];
    NSString *string = @"同意并接受《腰果生活支付协议》";
    agreeLabel.font = TEXT_FONT_LEVEL_2;
    agreeLabel.textColor = LIVING_COLOR;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_LEVEL_2 range:NSMakeRange(0,6)];
    [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(6,6)];
    agreeLabel.attributedText = str;
    [agreeLabel sizeToFit];

    agreeLabel.frame = CGRectMake(60, 238, agreeLabel.bounds.size.width, 30);
    agreeLabel.userInteractionEnabled = YES;
    [footView addSubview:agreeLabel];

    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(agreeLabel.frame)/3, 0, CGRectGetWidth(agreeLabel.frame)*2/3, CGRectGetHeight(agreeLabel.frame))];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(lookProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [agreeLabel addSubview:btn];
    
    
    
    UIButton *loginOut = [[UIButton alloc] initWithFrame:CGRectMake(15, 288, kScreenWidth-30, 45)];
    [loginOut setTitle:@"立即充值" forState:UIControlStateNormal];
    loginOut.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginOut.titleLabel.font = [UIFont systemFontOfSize:17];
    loginOut.layer.cornerRadius=5.0f;
    [loginOut addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    loginOut.backgroundColor = LIVING_COLOR;
    [footView addSubview:loginOut];
    [table setTableFooterView:footView];
}
- (void)lookProtocol:(UIButton *)btn{
    
    LMWebViewController * webVC = [[LMWebViewController alloc] init];
    webVC.titleString = @"支付协议";
    webVC.urlString = PAY_PROTOCOL_LINK;
    [self.navigationController pushViewController:webVC animated:YES];
}
-(void)agreeAction:(UIButton *)button{
    
    NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"payArr"];
    if (searchArr==nil) {
        NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:@"agree", nil];
        
        //存入数组并同步
        
        [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"payArr"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [button setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
        
    }else{
        for (NSString *string in searchArr) {
            if ([string isEqual:@"agree"]) {
                NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:@"disagree", nil];
                
                [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"payArr"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                [button setImage:[UIImage imageNamed:@"disagree"] forState:UIControlStateNormal];
            }else{
                NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:@"agree", nil];

                [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"payArr"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [button setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
            }
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [HcbAmountChecker textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGFloat     amount  = [textField.text floatValue];
    
    for (UIView *view in footView.subviews) {
        
        if ([view isKindOfClass:[LMChargeButton class]]) {
            
            LMChargeButton *btn = (LMChargeButton *)view;
            
            btn.upLabel.textColor       = TEXT_COLOR_LEVEL_2;
            btn.downLabel.textColor     = TEXT_COLOR_LEVEL_2;
            btn.layer.borderColor       = LINE_COLOR.CGColor;
        }
    }
    
    if (amount == 1000 || amount == 3000 || amount == 5000 || amount == 10000) {
        
        for (UIView *view in footView.subviews) {
            
            if ([view isKindOfClass:[LMChargeButton class]]) {
                
                LMChargeButton *btn = (LMChargeButton *)view;
                
                NSString *string = [btn.upLabel.text substringToIndex:[btn.upLabel.text length] - 1];
                
                if ([string isEqualToString:[NSString stringWithFormat:@"%d", (int)amount]]) {
                    
                    btn.upLabel.textColor = LIVING_COLOR;
                    btn.downLabel.textColor = LIVING_COLOR;
                    btn.layer.borderColor = LIVING_COLOR.CGColor;
                }
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        headView.backgroundColor = [UIColor clearColor];
        UILabel *label = [UILabel new];
        label.text = @"选择支付方式";
        label.font = TEXT_FONT_LEVEL_2;
        label.textColor = TEXT_COLOR_LEVEL_2;
        [label sizeToFit];
        label.frame = CGRectMake(15, 0, label.bounds.size.width, 30);
        [headView addSubview:label];
        
        return headView;
    }
    if (section == 2) {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        headView.backgroundColor = [UIColor clearColor];
        UILabel *label = [UILabel new];
        label.text = @"您的资金会很安全";
        label.font = TEXT_FONT_LEVEL_2;
        label.textColor = TEXT_COLOR_LEVEL_2;
        [label sizeToFit];
        label.frame = CGRectMake(15, 0, label.bounds.size.width, 30);
        [headView addSubview:label];
        
        return headView;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        return 70;
    }
    if (indexPath.section==1) {
        
        return 65;
    }
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellIds = @"cellIds";
        
        UITableViewCell * addcell= [tableView dequeueReusableCellWithIdentifier:cellIds];
        if (!addcell) {
            addcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIds];
        }
        addcell.imageView.image = [UIImage imageNamed:@"addLiving"];
        
        addcell.textLabel.text = _liveRoomName;
        addcell.textLabel.textColor = LIVING_COLOR;
        [addcell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return addcell;
    }
    
    if (indexPath.section==1) {
        static NSString *cellId = @"cellId";
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LMRechargeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSArray *arrayImg=@[@"alipay",@"weichatpay"];
        NSArray *arrayWord=@[@"支付宝",@"微信"];
        
        [cell.payImg setImage:[UIImage imageNamed:arrayImg[indexPath.row]]];
        [cell.payLabel setText:arrayWord[indexPath.row]];
        [cell.payButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.payButton setTag:indexPath.row];
        
        if (indexPath.row==selectedIndex) {
            [cell.payButton setSelected:YES];
        }else{
            [cell.payButton setSelected:NO];
        }
        return cell;
        
    }
    if (indexPath.section == 2) {
        
        static NSString *cellId = @"cellId";
        headcell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!headcell) {
            
            headcell = [[LMRePayCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            headcell.payNum.delegate            = self;
            headcell.payNum.clearButtonMode     = UITextFieldViewModeAlways;
            
            
            
        }
        
        return headcell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        LMChangeLivingController *livingVC = [[LMChangeLivingController alloc] init];
        livingVC.delegate=self;
        
        [self.navigationController pushViewController:livingVC animated:YES];
    }
    if (indexPath.section==1) {
        
        NSInteger index=indexPath.row;
        selectedIndex=index;
        [table reloadData];
    }
}

#pragma mark LMChangeLivingController&&liveNameProtocol代理协议

- (void)backLiveName:(NSString *)liveRoom andLiveUuid:(NSString *)live_uuid
{
    _liveRoomName   = liveRoom;
    _liveUUID       = live_uuid;
    
    [table reloadData];
}

- (void)selectedButton:(UIButton *)sender
{
    NSInteger   index = sender.tag;
    
    selectedIndex   = index;
    [table reloadData];
}

#pragma mark 立即充值按钮方法

- (void)rechargeAction
{
    if ([headcell.payNum.text isEqualToString:@""]) {
        
        [self textStateHUD:@"请输入充值的金额"];
        return;
    }
    
    [self.view endEditing:YES];
    
    if (selectedIndex==0) {//支付宝
        
        NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"payArr"];
        if (searchArr==nil) {
            [self textStateHUD:@"请同意支付协议"];
            return;
        }else{
            for (NSString *string in searchArr) {
                if ([string isEqualToString:@"agree"]) {
                    [self aliRechargeRequest];
                }else{
                    [self textStateHUD:@"请同意支付协议"];
                    return;
                }
                
            }
        }

    }
    if (selectedIndex==1) {//微信
        
        NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"payArr"];
        if (searchArr==nil) {
            [self textStateHUD:@"请同意支付协议"];
            return;
        }else{
            for (NSString *string in searchArr) {
                if ([string isEqualToString:@"agree"]) {
                    [self wxRechargeRequest];
                }else{
                    [self textStateHUD:@"请同意支付协议"];
                    return;
                }
                
            }
        }
    }
}

#pragma mark 微信充值下单请求

- (void)wxRechargeRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
        return;
    }
    
    [self initStateHud];
    
    LMWXRechargrRequest *request=[[LMWXRechargrRequest alloc]initWithWXRecharge:headcell.payNum.text andLivingUuid:_liveUUID];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(wxRechargeResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self textStateHUD:@"网络错误"];
                                           }];
    [proxy start];
}

-(void)wxRechargeResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    if (!bodyDict) {
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]]){
        
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            [self textStateHUD:@"微信充值下单成功"];
            
            rechargeOrderUUID=bodyDict[@"myOrderUuid"];
            [self senderWeiXinPay:bodyDict[@"wxOrder"]];
            
        }else{

            [self textStateHUD:[bodyDict objectForKey:@"description"]];
            
            
        }
    }
}

#pragma mark 发起第三方微信支付

- (void)senderWeiXinPay:(NSDictionary *)dic
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [WXApiRequestHandler jumpToBizPay:dic];
    });
}

#pragma mark 微信支付结果确认

// * 微信支付被取消

- (void)wxPayCanceled
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self textStateHUD:@"支付失败，用户取消"];
    });
}

// * 微信支付失败（其它原因）

- (void)wxPayFailed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self textStateHUD:@"微信支付失败"];
    });
}

- (void)weixinPayEnsure
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    LMWXRechargeResultRequest   *request    = [[LMWXRechargeResultRequest alloc] initWithMyOrderUuid:rechargeOrderUUID];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(weixinPaySuccessEnsureResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               [self textStateHUD:@"网络错误"];
                                           }];
    [proxy start];
}

- (void)weixinPaySuccessEnsureResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"数据请求失败"];
        return;
    }
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]]){
        
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            
            if ([bodyDict[@"trade_state"] isEqualToString:@"SUCCESS"]) {
                
                [self textStateHUD:@"充值成功！"];
                //刷新订单数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeMoney" object:nil];
            } else {
                
                [self textStateHUD:@"充值失败！"];
            }
        } else {
            
            [self textStateHUD:bodyDict[@"description"]];
        }
    }
}

#pragma mark 支付宝充值下单请求

- (void)aliRechargeRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];
    
    LMAliRechargeRequest    *request    = [[LMAliRechargeRequest alloc] initWithAliRecharge:headcell.payNum.text andLivingUuid:_liveUUID];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(aliRechargeResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               [self textStateHUD:@"网络错误"];
                                           }];
    [proxy start];
}

- (void)aliRechargeResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"数据请求失败"];
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]]){
        
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            [self textStateHUD:@"下单成功"];
            //支付宝支付下单后货物的uuid
            if (bodyDict[@"myOrderUuid"]) {
                rechargeOrderUUID=bodyDict[@"myOrderUuid"];
            }
            
            if (bodyDict[@"aliSignedOrder"]) {
                [self senderAliPay:bodyDict[@"aliSignedOrder"]];
            }
            
        } else {
            
                [self textStateHUD:[bodyDict objectForKey:@"description"]];
            
        }
    }
}

#pragma mark 发起第三方支付宝支付

- (void)senderAliPay:(NSString *)payOrderStr
{
    NSString *appScheme = @"livingApp";
    [[AlipaySDK defaultService] payOrder:payOrderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
    }];
}

#pragma mark 支付宝支付结果确认

-(void)aliPayEnsure:(NSNotification *)dic
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LMAliRechargeResultRequest *request=[[LMAliRechargeResultRequest alloc]initWithMyOrderUuid:rechargeOrderUUID andAlipayResult:dic.object];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(aliPaySuccessEnsureResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                           }];
    
    [proxy start];
}

- (void)aliPaySuccessEnsureResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict) {
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]]){
        
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            
            [self textStateHUD:@"充值成功！"];
            //刷新订单数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeMoney" object:nil];
        
        }else{
            
            [self textStateHUD:bodyDict[@"description"]];
        }
    }
}

- (void)changeMoney:(LMChargeButton *)button
{
    for (UIView *view in footView.subviews) {
        
        if ([view isKindOfClass:[LMChargeButton class]]) {
            LMChargeButton *btn = (LMChargeButton *)view;
            btn.upLabel.textColor = TEXT_COLOR_LEVEL_2;
            btn.downLabel.textColor = TEXT_COLOR_LEVEL_2;
            btn.layer.borderColor = LINE_COLOR.CGColor;
        }
    }
    
    button.upLabel.textColor = LIVING_COLOR;
    button.downLabel.textColor = LIVING_COLOR;
    button.layer.borderColor = LIVING_COLOR.CGColor;
    NSString *string =[button.upLabel.text substringToIndex:[button.upLabel.text length] - 1];
    headcell.payNum.text = string;
}

#pragma mark  UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[FitUserManager sharedUserManager] logout];
    FitTabbarController *tab=[[FitTabbarController alloc]init];
    [self presentViewController:tab animated:YES completion:nil];
}



@end
