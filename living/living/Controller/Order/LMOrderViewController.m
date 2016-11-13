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

#import "LMOrderVO.h"


#import "LMRefundRequest.h"
#import "LMOrederDeleteRequest.h"

#import "LMBalanceChargeRequest.h"

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

#import "LMWXPayRequest.h"
#import "LMWXPayResultRequest.h"

#import "MJRefresh.h"

#import "LMActivityDetailController.h"

#import "LMCouponMsgRequest.h"

@interface LMOrderViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate,
LMOrderCellDelegate
>
{
    UITableView *_tableView;
    NSMutableArray *orderArray;
    NSString *Orderuuid;
    NSString *rechargeOrderUUID;
    
    UIImageView *homeImage;
    BOOL ifRefresh;
    int total;
}

@end

@implementation LMOrderViewController

- (NSMutableArray *)orderArray
{
    if (!orderArray) {
        orderArray = [NSMutableArray array];
    }
    return orderArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"订单";
    [self creatUI];
    
    orderArray = [NSMutableArray new];
    
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

- (void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+36) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去分割线
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
    homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, kScreenWidth*2/5, 200, 130)];
    
    UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(55, 10, 90, 90)];
    homeImg.image = [UIImage imageNamed:@"NO-order"];
    [homeImage addSubview:homeImg];
    
    UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 111, 200, 60)];
    
    imageLb.numberOfLines   = 0;
    imageLb.text            = @"没订单,好枯燥,快来参与活动 享受美好生活";
    imageLb.font            = TEXT_FONT_LEVEL_2;
    imageLb.textColor       = TEXT_COLOR_LEVEL_3;
    imageLb.textAlignment   = NSTextAlignmentCenter;
    
    [homeImage addSubview:imageLb];
    
    [_tableView addSubview:homeImage];
    homeImage.hidden = YES;
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //tableView刚出现时，进行刷新操作
    [_tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.headerPullToRefreshText = @"下拉可以刷新";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新";
    _tableView.headerRefreshingText = @"正在帮你刷新...";
    
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    _tableView.footerRefreshingText = @"正在帮你加载...";
}

- (void)headerRereshing
{
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
        [_tableView headerEndRefreshing];
        ifRefresh = YES;
        self.current=1;
        [self getOrderListRequest:self.current];
        ifRefresh=YES;
        
    });
}

- (void)footerRereshing
{
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.current = self.current+1;
        
        ifRefresh = NO;
        
        if (total < self.current) {
            
            [self textStateHUD:@"没有更多订单"];
        } else {
            
            [self getOrderListRequest:self.current];
        }
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}

- (void)reloadingHomePage
{
    [self headerRereshing];
}

- (void)getOrderListRequest:(int)page
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
        return;
    }
    
    [self initStateHud];
    
    LMOrderListRequest  *request    = [[LMOrderListRequest alloc] initWithPageIndex:page andPageSize:20];
    
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

- (void)getOrderListResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    total = [[bodyDic objectForKey:@"total"] intValue];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {

        [self hideStateHud];
        
        if (ifRefresh) {
            ifRefresh=NO;
            orderArray=[NSMutableArray arrayWithCapacity:0];
            
            NSArray *array = bodyDic[@"list"];
            for(int i=0;i<[array count];i++){
                
                LMOrderVO *list=[[LMOrderVO alloc]initWithDictionary:array[i]];
                if (![orderArray containsObject:list]) {
                    [orderArray addObject:list];
                }
            }
            
        }
        if (orderArray.count==0) {
            homeImage.hidden = NO;
        }
        
        [_tableView reloadData];
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    
    LMOrderCell *cell = [[LMOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    LMOrderVO *list =[orderArray objectAtIndex:indexPath.row];
    [cell setValue:list];
    cell.Orderuuid = list.orderUuid;
    cell.priceStr = list.orderAmount;
    cell.delegate = self;
    cell.tag = indexPath.row;
    
    [cell setXScale:self.xScale yScale:self.yScaleNoTab];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMOrderVO *list =[orderArray objectAtIndex:indexPath.row];
    
    LMActivityDetailController *detailVC = [[LMActivityDetailController alloc] init];
    detailVC.eventUuid = list.eventUuid;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - LMOrderCell delegate -
- (void)cellWilldelete:(LMOrderCell *)cell
{
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

- (void)OrderDeleteRequest:(NSString *)string
{
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

- (void)getdeleteDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"删除失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"订单删除成功"];
            [self reloadingHomePage];
        }else{
            [self textStateHUD:bodyDic[@"description"]];
        }
    }
}

- (void)cellWillpay:(LMOrderCell *)cell
{
    Orderuuid = cell.Orderuuid;
    LMOrderVO *list =[orderArray objectAtIndex:cell.tag];
    
    switch (list.status) {
        case 4:
            [self textStateHUD:@"活动已完结"];
            return;
            break;
        case 5:
            [self textStateHUD:@"活动已删除"];
            return;
            break;
            
        default:
            break;
    }

    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择支付方式"
                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"余额支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self balanceChargeRequest];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self wxRechargeRequest];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"支付宝支付"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                
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
    
}

- (void)cellWillRefund:(LMOrderCell *)cell
{
    LMOrderVO *list =[orderArray objectAtIndex:cell.tag];
    
    switch (list.status) {
        case 3:
            [self textStateHUD:@"活动已开始，不能进行退款"];
            return;
            break;
        case 4:
            [self textStateHUD:@"活动已结束，不能进行退款"];
            return;
            break;
        case 5:
            [self textStateHUD:@"活动已删除，不能进行退款"];
            return;
            break;
            
        default:
            break;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否申请退款"
                                                                   message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
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
                                                
                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                            
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cellWillrebook:(LMOrderCell *)cell
{
    LMOrderVO *list =[orderArray objectAtIndex:cell.tag];
    LMActivityDetailController *detailVC = [[LMActivityDetailController alloc] init];
    
    detailVC.eventUuid = list.eventUuid;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark  --退款

- (void)getrefundDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"退款申请失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"退款申请成功"];
            [self reloadingHomePage];
        }else{
            [self textStateHUD:bodyDic[@"description"]];
        }
    }
}

#pragma mark 微信充值下单请求

- (void)wxRechargeRequest
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

- (void)wxRechargeResponse:(NSString *)resp
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
            
            if (bodyDict[@"map"][@"myOrderUuid"]) {
                
                rechargeOrderUUID=bodyDict[@"map"][@"myOrderUuid"];
            }
            if (bodyDict[@"map"][@"wxOrder"]) {
                [self senderWeiXinPay:bodyDict[@"map"][@"wxOrder"]];
            }
            
        } else {
            
            [self textStateHUD:[bodyDict objectForKey:@"description"]];
        }
    }
}

#pragma mark 发起第三方微信支付

- (void)senderWeiXinPay:(NSDictionary *)dic
{
    [WXApiRequestHandler jumpToBizPay:dic];
}

#pragma mark 微信支付结果确认

- (void)weixinPayEnsure
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
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

- (void)weixinPaySuccessEnsureResponse:(NSString *)resp
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
                [self textStateHUD:@"支付成功！"];
                
                [self reloadingHomePage];
                
                
            }else{
                [self textStateHUD:@"支付失败！"];
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
    
    LMAliPayRequest     *request    = [[LMAliPayRequest alloc] initWithAliRecharge:Orderuuid];
    
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
    [self logoutAction:resp];
    if (!bodyDict) {
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]]){
        
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            [self textStateHUD:@"支付成功！"];
            [self reloadingHomePage];
        }else{
            
            [self textStateHUD:bodyDict[@"description"]];
        }
    }
}

#pragma mark  --余额支付

-(void)balanceChargeRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
        return;
    }
    
    [self textStateHUD:@"付款中..."];
    [self initStateHud];
    
    LMBalanceChargeRequest *request     = [[LMBalanceChargeRequest alloc] initWithOrder_uuid:Orderuuid
                                                                                  useBalance:_useBalance];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(balanceChargeResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"余额支付失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)balanceChargeResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if (!bodyDic) {
        
        [self textStateHUD:@"余额支付失败"];
    } else {
        
        NSString        *result     = [bodyDic objectForKey:@"result"];
        
        if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]){
            
            [self hideStateHud];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您已成功付款"
                                                                           message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self reloadingHomePage];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            [self textStateHUD:@"支付失败，请重试"];
        }
    }
}

@end
