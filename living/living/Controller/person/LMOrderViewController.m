//
//  LMOrderViewController.m
//  living
//
//  Created by Ding on 16/10/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMOrderViewController.h"
#import "LMOrderListRequest.h"
#import "LMOrderCell.h"
#import "LMOrderList.h"
#import "LMRefundRequest.h"
#import "LMOrederDeleteRequest.h"


//支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LMAliPayRequest.h"
#import "LMAlipayResultRequest.h"

//微信支付
#import "WXApiObject.h"
#import "WXApi.h"

#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "LMWXPayRequest.h"
#import "LMWXPayResultRequest.h"

@interface LMOrderViewController ()<UITableViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate,
LMOrderCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *orderArray;
    NSString *Orderuuid;
    NSString *rechargeOrderUUID;
}

@end

@implementation LMOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单";
    [self creatUI];
    [self getOrderListRequest];
    orderArray = [NSMutableArray new];
    
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

-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+36) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去分割线
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
}

-(void)getOrderListRequest
{
    LMOrderListRequest *request = [[LMOrderListRequest alloc] initWithPageIndex:1 andPageSize:20];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getOrderListResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取列表失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

-(void)getOrderListResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        [orderArray removeAllObjects];
        
        NSArray *array = bodyDic[@"list"];
        for (int i =0; i<array.count; i++) {
            LMOrderList *list=[[LMOrderList alloc]initWithDictionary:array[i]];
            if (![orderArray containsObject:list]) {
                [orderArray addObject:list];
            }
            
        }
        
        [_tableView reloadData];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    LMOrderCell *cell = [[LMOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    LMOrderList *list =[orderArray objectAtIndex:indexPath.row];
    [cell setValue:list];
    cell.Orderuuid = list.orderUuid;
    cell.priceStr = list.orderAmount;
    cell.delegate = self;
    
    [cell setXScale:self.xScale yScale:self.yScaleNoTab];
    
    return cell;
}


#pragma mark - LMOrderCell delegate -
- (void)cellWilldelete:(LMOrderCell *)cell
{
    NSLog(@"%@",cell.Orderuuid);
    NSLog(@"**********删除");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除"
                                                                   message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self OrderDeleteRequest:cell.Orderuuid];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [alert dismissViewControllerAnimated:YES completion:nil];      }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)OrderDeleteRequest:(NSString *)string
{
    NSLog(@"%@",string);
    
    LMOrederDeleteRequest *request = [[LMOrederDeleteRequest alloc] initWithOrder_uuid:string];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getdeleteDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"删除失败，请重试！"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

-(void)getdeleteDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"删除失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"订单删除成功"];
            [self getOrderListRequest];
        }else{
            [self textStateHUD:bodyDic[@"description"]];
        }
    }
}




- (void)cellWillpay:(LMOrderCell *)cell
{
    NSLog(@"**********付款");
    Orderuuid = cell.Orderuuid;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择支付方式"
                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];      [alert addAction:[UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"******微信支付");
        [self wxRechargeRequest];

    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"支付宝支付"
                                                        style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                NSLog(@"******支付宝支付");
                                                [self aliRechargeRequest];
                                                        }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [alert dismissViewControllerAnimated:YES completion:nil];      }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
- (void)cellWillfinish:(LMOrderCell *)cell
{
    NSLog(@"**********完成");
}
- (void)cellWillRefund:(LMOrderCell *)cell
{
    NSLog(@"**********退款");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否退款"
                                                                   message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"******确定");
        LMRefundRequest *request = [[LMRefundRequest alloc] initWithOrder_uuid:cell.Orderuuid];
        
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(getrefundDataResponse:)
                                                                          withObject:resp
                                                                       waitUntilDone:YES];
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"退款失败"
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];
        
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [alert dismissViewControllerAnimated:YES completion:nil];      }]];
    [self presentViewController:alert animated:YES completion:nil];

    
}
- (void)cellWillrebook:(LMOrderCell *)cell
{
    NSLog(@"**********再订");
}


#pragma mark  --退款
-(void)getrefundDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"退款申请失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"退款成功"];
            [self getOrderListRequest];
        }else{
            [self textStateHUD:bodyDic[@"description"]];
        }
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
    LMWXPayRequest *request=[[LMWXPayRequest alloc]initWithWXRecharge:Orderuuid];
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
            
            if (bodyDict[@"map"][@"myOrderUuid"]) {
                rechargeOrderUUID=bodyDict[@"map"][@"myOrderUuid"];
                NSLog(@"==微信支付下单后货物的uuid:%@",rechargeOrderUUID);
            }
            if (bodyDict[@"map"][@"wxOrder"]) {
                [self senderWeiXinPay:bodyDict[@"map"][@"wxOrder"]];
            }

            
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
    LMWXPayResultRequest *request=[[LMWXPayResultRequest alloc]initWithMyOrderUuid:rechargeOrderUUID];
    
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
                //更新余额
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
    LMAliPayRequest *request=[[LMAliPayRequest alloc]initWithAliRecharge:Orderuuid];
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
    LMAlipayResultRequest *request=[[LMAlipayResultRequest alloc]initWithMyOrderUuid:rechargeOrderUUID andAlipayResult:dic.object];
    
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






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
