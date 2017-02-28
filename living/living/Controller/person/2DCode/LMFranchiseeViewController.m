//
//  LMFranchiseeViewController.m
//  living
//
//  Created by Ding on 2016/11/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMFranchiseeViewController.h"
#import "LMChangeLivingController.h"
#import "LMRechargeCell.h"
#import "LMBusinessCell.h"

//支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

//微信支付
#import "WXApiObject.h"
#import "WXApi.h"

#import "WXApiRequestHandler.h"

#import "LMFranchiseeResultWchatRequest.h"
#import "LMFranchiseeWchatPayRequest.h"
#import "LMFranchiseeAliPayRequest.h"
#import "LMFranchiseeResultAliRequest.h"

@interface LMFranchiseeViewController ()
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
    LMBusinessCell *headcell;
    NSString *rechargeOrderUUID;
    UIView *footView;
    NSString *type;
}

@end

@implementation LMFranchiseeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor  = LIVING_COLOR;
}

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
    self.title=@"申请加盟商";
    
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
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 185)];
    UIButton *loginOut = [[UIButton alloc] initWithFrame:CGRectMake(15, 95, kScreenWidth-30, 45)];
    [loginOut setTitle:@"确认并支付" forState:UIControlStateNormal];
    loginOut.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginOut.titleLabel.font = [UIFont systemFontOfSize:17];
    loginOut.layer.cornerRadius=5.0f;
    [loginOut addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    loginOut.backgroundColor = LIVING_COLOR;
    [footView addSubview:loginOut];
    
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
    agreeLabel.frame = CGRectMake(60, 45, agreeLabel.bounds.size.width, 30);
    [footView addSubview:agreeLabel];
    
    
    
    [table setTableFooterView:footView];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        headView.backgroundColor = [UIColor clearColor];
        UILabel *label = [UILabel new];
        label.text = @"个人信息";
        label.font = TEXT_FONT_LEVEL_2;
        label.textColor = TEXT_COLOR_LEVEL_2;
        [label sizeToFit];
        label.frame = CGRectMake(15, 0, label.bounds.size.width, 30);
        [headView addSubview:label];
        
        return headView;
    }
    if (section==2) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        headView.backgroundColor = [UIColor clearColor];
        UILabel *label = [UILabel new];
        label.text = @"选择付款";
        label.font = TEXT_FONT_LEVEL_1;
        label.textColor = TEXT_COLOR_LEVEL_2;
        [label sizeToFit];
        label.frame = CGRectMake(15, 0, label.bounds.size.width, 30);
        [headView addSubview:label];
        
        return headView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 70;
    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            return 70;
        }
        return 65;
    }
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
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
    
    if (indexPath.section==2) {
        
        if (indexPath.row==0) {
            static NSString *cellID = @"cellID";
            
            UITableViewCell * addcell= [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!addcell) {
                addcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            }
            
            UILabel *label = [UILabel new];
            label.text = @"轻创客包年学习费";
            [addcell.contentView addSubview:label];
            
            UILabel *price = [UILabel new];
            price.text = @"￥3600";
            price.textColor = LIVING_REDCOLOR;
            [addcell.contentView addSubview:price];
            
            UILabel *content = [UILabel new];
            content.text = @"提示：加盟之后将不得取消";
            content.textColor = [UIColor colorWithRed:255.0/255.0 green:180.0/255.0 blue:21.0/255.0 alpha:1.0];
            content.font = TEXT_FONT_LEVEL_2;
            [addcell.contentView addSubview:content];
            
            [label sizeToFit];
            [price sizeToFit];
            [content sizeToFit];
            label.frame = CGRectMake(15, 5, label.bounds.size.width, 30);
            price.frame = CGRectMake(20+label.bounds.size.width, 5, price.frame.size.width, 30);
            content.frame = CGRectMake(15, 35, content.bounds.size.width, 30);
            
            return addcell;
            
            
        }else{
            static NSString *cellId = @"cellId";
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[LMRechargeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            NSArray *arrayImg=@[@"alipay",@"weichatpay"];
            NSArray *arrayWord=@[@"支付宝",@"微信"];
            
            [cell.payImg setImage:[UIImage imageNamed:arrayImg[indexPath.row-1]]];
            [cell.payLabel setText:arrayWord[indexPath.row-1]];
            [cell.payButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.payButton setTag:indexPath.row-1];
            
            if (indexPath.row-1==selectedIndex) {
                [cell.payButton setSelected:YES];
            }else{
                [cell.payButton setSelected:NO];
            }
            return cell;
            
        }
    }
    if (indexPath.section==1) {
        static NSString *cellId = @"cellId";
        headcell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!headcell) {
            headcell = [[LMBusinessCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
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
    if (indexPath.section==2) {
        if (indexPath.row>0) {
            NSInteger index=indexPath.row-1;
            selectedIndex=index;
            [table reloadData];
        }
    }
}

#pragma mark LMChangeLivingController&&liveNameProtocol代理协议

-(void)backLiveName:(NSString *)liveRoom andLiveUuid:(NSString *)live_uuid
{
    _liveRoomName=liveRoom;
    _liveUUID=live_uuid;
    [table reloadData];
}

-(void)selectedButton:(UIButton *)sender
{
    NSInteger index=sender.tag;
    selectedIndex=index;
    [table reloadData];
}

#pragma mark 立即充值按钮方法

-(void)rechargeAction
{
    
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

-(void)wxRechargeRequest
{
    type = @"wx";
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
        return;
    }
    
    [self initStateHud];
    
    LMFranchiseeWchatPayRequest *request=[[LMFranchiseeWchatPayRequest alloc] initWithWXRecharge:@"3600" andLivingUuid:_liveUUID andPhone:headcell.NumTF.text andName:headcell.NameTF.text];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(wxRechargeResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                               
                                           } failed:^(NSError *error) {
                                               
                                               [self textStateHUD:@"微信充值下单失败"];
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
    LMFranchiseeResultWchatRequest *request=[[LMFranchiseeResultWchatRequest alloc]initWithMyOrderUuid:rechargeOrderUUID];
    
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
                
                
                if ([_xufei isEqualToString:@"xufei"]) {
                    [self textStateHUD:@"续费成功！"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"xufei_dot"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                    });
                }else{
                   [self textStateHUD:@"加盟成功！"];
                }
                

            }else{
                [self textStateHUD:@"加盟失败！"];
            }
        }else{
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
    LMFranchiseeAliPayRequest   *request = [[LMFranchiseeAliPayRequest alloc] initWithAliRecharge:@"3600"
                                                                                    andLivingUuid:_liveUUID
                                                                                         andPhone:headcell.NumTF.text
                                                                                          andName:headcell.NameTF.text];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(aliRechargeResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               [self textStateHUD:@"数据请求失败"];
                                           }];
    [proxy start];
}

- (void)aliRechargeResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
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
            
        }else{

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

- (void)aliPayEnsure:(NSNotification *)dic
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LMFranchiseeResultAliRequest *request=[[LMFranchiseeResultAliRequest alloc]initWithMyOrderUuid:rechargeOrderUUID andAlipayResult:dic.object];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(aliPaySuccessEnsureResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                           }];
    [proxy start];
}

-(void)aliPaySuccessEnsureResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict) {
        
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]]){
        
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            
            if ([_xufei isEqualToString:@"xufei"]) {
                [self textStateHUD:@"续费成功！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"xufei_dot"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                });
            }else{
                [self textStateHUD:@"加盟成功！"];
            }
            
        } else {
            
            [self textStateHUD:bodyDict[@"description"]];
        }
    }
}

#pragma mark  UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[FitUserManager sharedUserManager] logout];
    FitTabbarController     *tab =[[FitTabbarController alloc]init];
    
    [self presentViewController:tab animated:YES completion:nil];
}




@end
