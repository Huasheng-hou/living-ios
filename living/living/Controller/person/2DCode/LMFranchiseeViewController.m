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

#import "LMChargeButton.h"

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
}

@end

@implementation LMFranchiseeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor  = LIVING_COLOR;
}

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
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 135)];
    UIButton *loginOut = [[UIButton alloc] initWithFrame:CGRectMake(15, 45, kScreenWidth-30, 45)];
    [loginOut setTitle:@"确认并支付" forState:UIControlStateNormal];
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


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.01;
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return 3;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NSLog(@"***");
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

-(void)senderWeiXinPay:(NSDictionary *)dic
{
    NSLog(@"=========发起第三方微信支付=====dic==%@",dic);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WXApiRequestHandler jumpToBizPay:dic];
    });
}

#pragma mark 微信支付结果确认

-(void)weixinPayEnsure
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
                                               [self textStateHUD:@"数据请求失败"];
                                           }];
    [proxy start];
    
}
-(void)weixinPaySuccessEnsureResponse:(NSString *)resp
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
            
            if ([bodyDict[@"trade_state"] isEqualToString:@"SUCCESS"]) {
                [self textStateHUD:@"加盟成功！"];
            }else{
                [self textStateHUD:@"加盟失败！"];
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
    LMFranchiseeAliPayRequest *request=[[LMFranchiseeAliPayRequest alloc]initWithAliRecharge:@"3600" andLivingUuid:_liveUUID andPhone:headcell.NumTF.text andName:headcell.NameTF.text];
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

-(void)senderAliPay:(NSString *)payOrderStr
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
            
            [self textStateHUD:@"加盟成功！"];
        } else {
            
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
            button.layer.borderColor = LINE_COLOR.CGColor;
        }
    }
    
    button.upLabel.textColor = LIVING_COLOR;
    button.downLabel.textColor = LIVING_COLOR;
    button.layer.borderColor = LIVING_COLOR.CGColor;
    
    NSString *string =[button.upLabel.text substringToIndex:[button.upLabel.text length] - 1];
    headcell.NameTF.text = string;
}

#pragma mark  UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[FitUserManager sharedUserManager] logout];
    FitTabbarController     *tab =[[FitTabbarController alloc]init];

    [self presentViewController:tab animated:YES completion:nil];
}

@end
