//
//  LMSpecialRechargeController.m
//  living
//
//  Created by hxm on 2017/4/17.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMSpecialRechargeController.h"
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
#import "LMCouponCell.h"


#import "LMSpecialRechargeRequest.h"


@interface LMSpecialRechargeController ()
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
    
    NSDictionary * _dataBody;
    NSArray * _dataArray;
    NSArray * _listArray;
}

@end

@implementation LMSpecialRechargeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    
    [self getListData];
    
    
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
        _liveRoomName=@"选择所属生活馆";
    }
    
    table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [table setBackgroundColor:BG_GRAY_COLOR];
    [table setDelegate:self];
    [table setDataSource:self];
    [self.view addSubview:table];
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //尾部
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.frame = CGRectMake(15, 5, 45, 30);
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
    
    agreeLabel.frame = CGRectMake(60, 5, agreeLabel.bounds.size.width, 30);
    [footView addSubview:agreeLabel];
    
    UIButton *loginOut = [[UIButton alloc] initWithFrame:CGRectMake(15, 35, kScreenWidth-30, 45)];
    [loginOut setTitle:@"立即充值" forState:UIControlStateNormal];
    loginOut.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginOut.titleLabel.font = [UIFont systemFontOfSize:17];
    loginOut.layer.cornerRadius=5.0f;
    [loginOut addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    loginOut.backgroundColor = LIVING_COLOR;
    [footView addSubview:loginOut];
    [table setTableFooterView:footView];
}
#pragma mark - 获取大礼包内容
- (void)getListData{
    
    LMSpecialRechargeRequest * request = [[LMSpecialRechargeRequest alloc] init];
    
    HTTPProxy * proxy = [HTTPProxy loadWithRequest:request
                                         completed:^(NSString *resp, NSStringEncoding encoding) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [self parseResp:resp];
                                             });
                                         }
                                            failed:^(NSError *error) {
                                                NSLog(@"%@", error.localizedDescription);
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self textStateHUD:@"网络错误"];
                                                });
                                            }];
    [proxy start];
}

- (void)parseResp:(NSString *)resp{
    
    NSData * respData = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * respDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary * headDic = [respDic objectForKey:@"head"];
    if (![headDic[@"returnCode"] isEqualToString:@"000"]) {
        
        [self textStateHUD:@"身份验证失败"];
        return;
    }
    
    NSDictionary * bodyDic = respDic[@"body"];
    if (![bodyDic[@"result"] isEqualToString:@"0"]) {
        [self textStateHUD:@"请求失败"];
        return;
    }
    
    if (bodyDic[@"gifts"]) {
        _dataArray = bodyDic[@"gifts"];
    }
    if (bodyDic[@"list"]) {
        _listArray = bodyDic[@"list"];
    }
    _dataBody = bodyDic;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [table reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)] withRowAnimation:UITableViewRowAnimationFade];

    });
    
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
#pragma mark - tableview代理方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section == 3) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        headView.backgroundColor = [UIColor whiteColor];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 15)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"   大礼包内容：";
        label.textColor = TEXT_COLOR_LEVEL_2;
        label.font = TEXT_FONT_LEVEL_3;
        
        return label;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 2;
    }
    if (section == 3) {
        return _dataArray.count + _listArray.count;
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
    
    if (indexPath.section == 3) {
        return 100;
    }
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 3) {
        return 30;
    }
    return 0;
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
        headcell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!headcell) {
            
            headcell = [[LMRePayCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            headcell.payNum.text = [NSString stringWithFormat:@"%@", _dataBody[@"amount"]];
            headcell.payNum.enabled = NO;
            
        }
        return headcell;
    }
    if (indexPath.section == 3) {
        
        LMCouponCell * listCell = [[LMCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        listCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_dataArray.count > indexPath.row) {
            listCell.type = 1;
            [listCell setData:_dataArray[indexPath.row]];
            return listCell;
        }
        listCell.type = 2;
        [listCell setData:_listArray[indexPath.row-_dataArray.count]];
        
        return listCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
