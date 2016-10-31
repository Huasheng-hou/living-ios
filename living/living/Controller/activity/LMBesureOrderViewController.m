//
//  LMBesureOrderViewController.m
//  living
//
//  Created by Ding on 2016/10/28.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBesureOrderViewController.h"
#import "LMOrederDeleteRequest.h"
#import "APChooseView.h"
#import "LMOrderpayRequest.h"
#import "LMOrderDataOrderInfo.h"
#import "LMOrderDataOrderBody.h"

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
#import "LMEventDetailEventBody.h"
#import "UIImageView+WebCache.h"

@interface LMBesureOrderViewController ()
{
    LMOrderDataOrderInfo *orderInfos;
    LMOrderDataOrderBody *orderdata;
    NSString *rechargeOrderUUID;
    LMEventDetailEventBody *eventDic;
}

@end

@implementation LMBesureOrderViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void)createUI
{
    [super createUI];
    self.title = @"确认订单";
    
    
    eventDic =[[LMEventDetailEventBody alloc] initWithDictionary:_dict];
    
    [self getOrderData];
    
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

-(void)getOrderData
{
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LMOrderpayRequest *request = [[LMOrderpayRequest alloc] initWithOrder_uuid:_orderUUid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getOrderDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"订单详情获取失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}


-(void)getOrderDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"获取数据失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            orderInfos = [[LMOrderDataOrderInfo alloc] initWithDictionary:[bodyDic objectForKey:@"orderInfo"]];
            orderdata = [[LMOrderDataOrderBody alloc] initWithDictionary:[bodyDic objectForKey:@"order_body"]];
            [self.tableView reloadData];
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
            
    }
    
    
    

    
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 8;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 150;
    }
    if (indexPath.section==1) {
        if (indexPath.row==5) {
            return 75;
        }
    }
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        UILabel *msgLabel = [UILabel new];
        msgLabel.text = @"订单信息";
        msgLabel.font = TEXT_FONT_LEVEL_2;
        msgLabel.textColor = TEXT_COLOR_LEVEL_3;
        [msgLabel sizeToFit];
        msgLabel.frame = CGRectMake(15, 0, kScreenWidth-30, 30);
        [headView addSubview:msgLabel];
        return headView;
    }
    
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }
    return 30;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";

    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(25, 0, 0.5, 35)];
        line1.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:line1];
        
        UILabel *payLabel = [UILabel new];
        payLabel.text = @"待支付";
        payLabel.font = TEXT_FONT_LEVEL_1;
        [payLabel sizeToFit];
        payLabel.frame = CGRectMake(40, 0, payLabel.bounds.size.width, 35);
        [cell.contentView addSubview:payLabel];
        
        
        
        UILabel *timeLabel = [UILabel new];
        timeLabel.text = orderdata.orderTime;
        timeLabel.font = TEXT_FONT_LEVEL_2;
        timeLabel.textColor = TEXT_COLOR_LEVEL_3;
        [timeLabel sizeToFit];
        timeLabel.frame = CGRectMake(kScreenWidth-15-timeLabel.bounds.size.width, 0, timeLabel.bounds.size.width, 35);
        [cell.contentView addSubview:timeLabel];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(12, 40, 20, 20)];
        image.image = [UIImage imageNamed:@"rechage-2"];
        [cell.contentView addSubview:image];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, kScreenWidth-55, 60)];
        titleLabel.text = orderdata.eventName;
        titleLabel.numberOfLines = 0;
        titleLabel.font = TEXT_FONT_LEVEL_2;
        titleLabel.textColor = TEXT_COLOR_LEVEL_2;
        [cell.contentView addSubview:titleLabel];
        
        UILabel *perCost = [UILabel new];
        perCost.textColor = TEXT_COLOR_LEVEL_3;
        
        NSString *string = [NSString stringWithFormat:@"￥%@",orderdata.price];
        NSString *string2 = [NSString stringWithFormat:@"%.0f/人",orderdata.number];
        
//        NSString *strs = [NSString stringWithFormat:@"￥%@x%.0f/人",orderdata.price,orderdata.number];
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"%@",orderdata.price];
//
//        [str addAttribute:NSFontAttributeName value:TEXT_FONT_LEVEL_2 range:NSMakeRange(0,4)];
//        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4,str.length-4)];
//        perCost.attributedText = str;
        perCost.text = [NSString stringWithFormat:@"%@%@",string,string2];
        [perCost sizeToFit];
        perCost.frame = CGRectMake(40, 85, perCost.bounds.size.width, 25);
        [cell.contentView addSubview:perCost];
        
        UILabel *priceLabel = [UILabel new];
        priceLabel.text = [NSString stringWithFormat:@"￥ %@",orderdata.totalMoney];
        priceLabel.font = TEXT_FONT_LEVEL_1;
        priceLabel.textColor = LIVING_REDCOLOR;
        [priceLabel sizeToFit];
        priceLabel.frame = CGRectMake(kScreenWidth-15-priceLabel.bounds.size.width, 85, priceLabel.bounds.size.width, 25);
        [cell.contentView addSubview:priceLabel];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 115, kScreenWidth, 0.5)];
        line.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:line];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 115.5, kScreenWidth/2, 34.5);
        cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancel setTitleColor:TEXT_COLOR_LEVEL_2 forState:UIControlStateNormal];
        [cancel setTitle:@"取消订单" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:cancel];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-0.5, 115, 0.5, 35)];
        line2.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:line2];
        
        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        payButton.frame = CGRectMake(kScreenWidth/2+0.25, 115.5, kScreenWidth/2-0.25, 34.5);
        payButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [payButton setTitleColor:LIVING_REDCOLOR forState:UIControlStateNormal];
        [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        
        
        [payButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [cell.contentView addSubview:payButton];
        
        return cell;
        
    }
    
    if (indexPath.section==1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = TEXT_COLOR_LEVEL_2;
        cell.textLabel.font = TEXT_FONT_LEVEL_2;
        cell.detailTextLabel.font = TEXT_FONT_LEVEL_2;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"订单号:";
                cell.detailTextLabel.text = orderInfos.orderNumber;
                break;
            case 1:
                cell.textLabel.text = @"活动名称:";
                cell.detailTextLabel.text = orderInfos.eventName;
                break;
            case 2:
                cell.textLabel.text = @"参加人数:";
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%.0f人",orderInfos.joinNumber];
                break;
            case 3:
                cell.textLabel.text = @"平均价格:";
                if (orderInfos.averagePrice==nil) {
                    cell.detailTextLabel.text = @"";
                }else{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",orderInfos.averagePrice];
                }
                
                break;
            case 4:
                cell.textLabel.text = @"订单总价:";
                if (orderInfos.totalMoney==nil) {
                    cell.detailTextLabel.text = @"";
                }else{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",orderInfos.totalMoney];
                }
                break;
            case 5:
                cell.textLabel.text = @"活动时间:";
                cell.detailTextLabel.numberOfLines=3;
                if (orderInfos.startTime==nil) {
                    cell.detailTextLabel.text = @"";
                }else{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n至\n%@",orderInfos.startTime,orderInfos.endTime];
                }

                break;
            case 6:
                if (orderInfos.eventAddress==nil) {
                    cell.textLabel.text =@"活动地点：";
                }
                cell.textLabel.text = [NSString stringWithFormat:@"活动地点：%@",orderInfos.eventAddress];
                cell.textLabel.numberOfLines=0;
                break;
            case 7:
            {
                UILabel *label = [UILabel new];
                label.text = @"再来一单";
                [label sizeToFit];
                label.frame = CGRectMake(0, 0, kScreenWidth, 45);
                label.font = TEXT_FONT_LEVEL_2;
                label.textAlignment = NSTextAlignmentCenter;
                                  
                label.textColor = LIVING_REDCOLOR;
                [cell.contentView addSubview:label];
            }
                
                break;
                
            default:
                break;
        }
        return cell;
    }
    
    
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (indexPath.row==7) {
            APChooseView *infoView = [[APChooseView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            
            infoView.titleLabel.text = [NSString stringWithFormat:@"￥:%@", eventDic.perCost];
            
            infoView.inventory.text = [NSString stringWithFormat:@"活动人数 %.0f/%.0f人",eventDic.totalNumber,eventDic.totalNum];
            
            [infoView.productImage sd_setImageWithURL:[NSURL URLWithString:eventDic.eventImg]];
            
            infoView.orderInfo = _dict;
            
            [self.view addSubview:infoView];
            
            UIView *view = [infoView viewWithTag:1000];
            [UIView animateWithDuration:0.2 animations:^{
                view.frame = CGRectMake(0, kScreenHeight-465,self.view.bounds.size.width, 465);
            }];
        }
    }
}

-(void)cancelAction
{
    NSLog(@"取消订单");
    
    LMOrederDeleteRequest *request = [[LMOrederDeleteRequest alloc] initWithOrder_uuid:_orderUUid];
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
            [self textStateHUD:@"订单取消成功"];

        }else{
            [self textStateHUD:bodyDic[@"description"]];
        }
    }
}





-(void)payAction
{
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

#pragma mark 微信充值下单请求

-(void)wxRechargeRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    [self initStateHud];
    LMWXPayRequest *request=[[LMWXPayRequest alloc]initWithWXRecharge:orderInfos.orderUuid];
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
                [self textStateHUD:@"支付成功！"];
            
                
                
            }else{
                [self textStateHUD:@"支付失败！"];
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
    LMAliPayRequest *request=[[LMAliPayRequest alloc]initWithAliRecharge:orderInfos.orderUuid];
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
            [self textStateHUD:@"支付成功！"];
        }else{
            
            [self textStateHUD:bodyDict[@"description"]];
        }
    }
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
