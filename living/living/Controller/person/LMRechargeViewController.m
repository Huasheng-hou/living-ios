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
#import "WXApiManager.h"

#import "LMWXRechargrRequest.h"
#import "LMWXRechargeResultRequest.h"

@interface LMRechargeViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
UIAlertViewDelegate
>
{
    LMRechargeCell *cell;
    NSInteger selectedIndex;
    UITableView *table;
    LMRePayCell *headcell;
    NSString *rechargeOrderUUID;
}


@end

@implementation LMRechargeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    //微信支付结果确认
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(weixinPayEnsure)
     
                                                 name:@"weixinPayEnsure"
     
                                               object:nil];
    //支付宝支付结果确认
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(aliPayEnsure:)
     
                                                 name:@"aliPayEnsure"
     
                                               object:nil];
}

-(void)createUI
{
    self.title=@"余额充值";
    table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [table setBackgroundColor:BG_GRAY_COLOR];
    [table setDelegate:self];
    [table setDataSource:self];
    [self.view addSubview:table];
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    //尾部
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
    UIButton *loginOut = [[UIButton alloc] initWithFrame:CGRectMake(15, 40, kScreenWidth-30, 45)];
    [loginOut setTitle:@"立即充值" forState:UIControlStateNormal];
    loginOut.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginOut.titleLabel.font = [UIFont systemFontOfSize:17];
    loginOut.layer.cornerRadius=5.0f;
    [loginOut addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    loginOut.backgroundColor = LIVING_COLOR;
    [footView addSubview:loginOut];
    [table setTableFooterView:footView];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
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
    if (section==2) {
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




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 70;
    }
    if (indexPath.section==1) {
        return 65;
    }
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellIds = @"cellIds";
        UITableViewCell *addcell= [tableView dequeueReusableCellWithIdentifier:cellIds];
        if (!addcell) {
            addcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIds];
        }
        addcell.imageView.image = [UIImage imageNamed:@"addLiving"];
        
        addcell.textLabel.text = @"添加充值生活馆";
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
    if (indexPath.section==2) {
        static NSString *cellId = @"cellId";
        headcell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!headcell) {
            headcell = [[LMRePayCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        return headcell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NSLog(@"***");
        LMChangeLivingController *livingVC = [[LMChangeLivingController alloc] init];
        [self.navigationController pushViewController:livingVC animated:YES];
    }
    if (indexPath.section==1) {
        NSInteger index=indexPath.row;
        selectedIndex=index;
        [table reloadData];
    }

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
    if ([headcell.payNum.text isEqualToString:@""]) {
        [self textStateHUD:@"请输入充值的金额"];
        return;
    }
    
    [self.view endEditing:YES];
    
    if (selectedIndex==0) {//支付宝
        [self aliRechargeRequest];
    }
    if (selectedIndex==1) {//微信
        [self wxRechargeRequest];
    }
}

#pragma mark 微信充值下单请求

-(void)wxRechargeRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    [self initStateHud];
    LMWXRechargrRequest *request=[[LMWXRechargrRequest alloc]initWithWXRecharge:headcell.payNum.text];
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
    
    if ([bodyDict[@"returnCode"] isEqualToString:@"002"]){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil
                                                     message:reLoginTip
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag=10;
        return;
    }
    //    NSLog(@"-------微信充值下单-bodyDict-----------%@",bodyDict);
    
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

-(void)senderWeiXinPay:(NSDictionary *)dic
{
    [WXApiRequestHandler jumpToBizPay:dic];
}

#pragma mark 微信支付结果确认

-(void)weixinPayEnsure
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LMWXRechargeResultRequest *request=[[LMWXRechargeResultRequest alloc]initWithMyOrderUuid:rechargeOrderUUID];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(weixinPaySuccessEnsureResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               [self textStateHUD:@"数据请求失败"];
                                           }];
    [proxy start];
    
}
-(void)weixinPaySuccessEnsureResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if ([bodyDict[@"returnCode"] isEqualToString:@"002"]){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil
                                                     message:reLoginTip
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag=10;
        return;
    }
    
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
            }else{
                [self textStateHUD:@"充值失败！"];
            }
        }else{
            [self textStateHUD:bodyDict[@"description"]];
        }
    }
}


#pragma mark 支付宝充值下单请求

-(void)aliRechargeRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    [self initStateHud];
    LMAliRechargeRequest *request=[[LMAliRechargeRequest alloc]initWithAliRecharge:headcell.payNum.text];
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

-(void)aliRechargeResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if ([bodyDict[@"returnCode"] isEqualToString:@"002"]){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil
                                                     message:reLoginTip
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag=10;
        return;
    }
    //    NSLog(@"-----支付宝充值下单---bodyDict-----------%@",bodyDict);
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

-(void)senderAliPay:(NSString *)payOrderStr
{
    NSString *appScheme = @"livingApp";
    [[AlipaySDK defaultService] payOrder:payOrderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        //        NSLog(@"  购物车支付宝支付结果返回reslut = %@",resultDic);
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

-(void)aliPaySuccessEnsureResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if ([bodyDict[@"returnCode"] isEqualToString:@"002"]){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil
                                                     message:reLoginTip
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag=10;
        return;
    }
    if (!bodyDict) {
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]]){
        
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            [self textStateHUD:@"充值成功！"];
        }else{
            
            [self textStateHUD:bodyDict[@"description"]];
        }
    }
}

#pragma mark  UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[FitUserManager sharedUserManager] logout];
    FitTabbarController *tab=[[FitTabbarController alloc]init];
    [self presentViewController:tab animated:YES completion:nil];
}
@end
