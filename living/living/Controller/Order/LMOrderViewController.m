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
#import "LMClassroomDetailViewController.h"

#import "LMCouponMsgRequest.h"

#import "LMEventDetailViewController.h"


#define PAGER_SIZE      20

@interface LMOrderViewController ()
<
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
    NSString *type;
}

@end

@implementation LMOrderViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
    }
    
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.listData.count == 0) {
        
        [self loadNoState];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"订单";
    
    [self creatUI];
    [self loadNewer];
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
    
    [super createUI];
    self.tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    
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
    
}
- (void)adjustIndicator:(UIView *)loadingView
{
    if (loadingView) {
        
        for (UIView * subView in loadingView.subviews) {
            
            if ([subView isKindOfClass:[UIActivityIndicatorView class]]) {
                
                subView.center  = CGPointMake(subView.center.x, subView.center.y + 100);
            }
        }
    }
}
- (FitBaseRequest *)request
{
    LMOrderListRequest    *request    = [[LMOrderListRequest alloc] initWithPageIndex:self.current andPageSize:PAGER_SIZE];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    NSString    *result         = [bodyDic objectForKey:@"result"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        NSArray *array = [LMOrderVO LMOrderVOListWithArray:[bodyDic objectForKey:@"list"]];
        for (LMOrderVO *vo in array) {
            if (vo &&[vo isKindOfClass:[LMOrderVO class]]) {
                [orderArray addObject:vo];
            }
        }
        if (orderArray.count==0) {
            homeImage.hidden = NO;
        }else{
            homeImage.hidden = YES;
        }
        
        return [LMOrderVO LMOrderVOListWithArray:[bodyDic objectForKey:@"list"]];
        
    } else if (description && ![description isEqual:[NSNull null]] && [description isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:description waitUntilDone:NO];
    }
    
    return nil;
    
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
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    
    LMOrderCell *cell = [[LMOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    LMOrderVO *list =[self.listData objectAtIndex:indexPath.row];
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
    if (indexPath.row >= self.listData.count) {
        
        return;
    }
    
    LMOrderVO *list =[self.listData objectAtIndex:indexPath.row];
    
    if (list && [list isKindOfClass:[LMOrderVO class]]) {
        
        if (list.type && [list.type isKindOfClass:[NSString class]] && [list.type isEqualToString:@"event"]) {
            
            LMActivityDetailController *detailVC = [[LMActivityDetailController alloc] init];
            detailVC.eventUuid = list.eventUuid;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        if (list.type && [list.type isKindOfClass:[NSString class]] && [list.type isEqualToString:@"item"]) {
            
            LMEventDetailViewController *detailVC = [[LMEventDetailViewController alloc] init];
            detailVC.eventUuid = list.eventUuid;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        if (list.type && [list.type isKindOfClass:[NSString class]] && [list.type isEqualToString:@"voice"]) {
            
            LMClassroomDetailViewController *voiceVC = [[LMClassroomDetailViewController alloc] init];
            voiceVC.voiceUUid = list.voiceUuid;

            [voiceVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:voiceVC animated:YES];
        }
    }
}

#pragma mark - LMOrderCell delegate

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
                                                                      withObject:@"网络错误"
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
    
    } else {
    
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
            [self textStateHUD:@"订单删除成功"];
            
            if (self.listData.count == 1) {
                
                [self.listData removeAllObjects];
                [self.tableView reloadData];
                
            } else {
                
                [self loadNoState];
            }
            
        }else{
            [self textStateHUD:bodyDic[@"description"]];
        }
    }
}

- (void)cellWillpay:(LMOrderCell *)cell
{
    Orderuuid = cell.Orderuuid;
    LMOrderVO *list =[self.listData objectAtIndex:cell.tag];
    
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
        
        NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"payArr"];
        if (searchArr==nil) {
            [self getagreementCharge:@"wx"];
        }else{
            for (NSString *string in searchArr) {
                if ([string isEqualToString:@"agree"]) {
                    [self wxRechargeRequest];
                }else{
                    [self getagreementCharge:@"wx"];
                }
                
            }
        }

    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"支付宝支付"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                
                                                NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"payArr"];
                                                if (searchArr==nil) {
                                                    [self getagreementCharge:@"ali"];
                                                }else{
                                                    for (NSString *string in searchArr) {
                                                        if ([string isEqualToString:@"agree"]) {
                                                            [self aliRechargeRequest];
                                                        }else{
                                                            [self getagreementCharge:@"ali"];
                                                        }
                                                        
                                                    }
                                                }

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
    LMOrderVO *list =[self.listData objectAtIndex:cell.tag];
    
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
        
        [self initStateHud];
        
        LMRefundRequest *request = [[LMRefundRequest alloc] initWithOrder_uuid:cell.Orderuuid];
        
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(getrefundDataResponse:)
                                                                          withObject:resp
                                                                       waitUntilDone:YES];
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"网络错误"
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
    LMOrderVO *list =[self.listData objectAtIndex:cell.tag];
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
    } else {
        
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            
            [self textStateHUD:@"退款申请成功"];
            [self loadNoState];
            
        } else {
            
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
                                               [self textStateHUD:@"网络错误"];
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
            
            if ([[bodyDict objectForKey:@"description"] isEqual:@"用户不同意支付协议"]) {
                [self getagreementCharge:@"wx"];
            }else{
                [self textStateHUD:[bodyDict objectForKey:@"description"]];
            }
            
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
                                               [self textStateHUD:@"网络错误"];
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
                
                [self loadNoState];
                
                
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
            if ([[bodyDict objectForKey:@"description"] isEqual:@"用户不同意支付协议"]) {
                [self getagreementCharge:@"alipay"];
            }else{
                [self textStateHUD:[bodyDict objectForKey:@"description"]];
            }
            
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
            [self loadNoState];
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
                
                [self loadNoState];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            [self textStateHUD:@"支付失败，请重试"];
        }
    }
}

//支付协议
-(void)getagreementCharge:(NSString *)string
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"是否同意支付协议"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"不同意"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction*action) {
                                                return ;
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"同意"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                
                                                if ([string isEqual:@"wx"]) {
                                                    [self wxRechargeRequest];
                                                }else{
                                                    [self aliRechargeRequest];
                                                }
                                                NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:@"agree", nil];
                                                
                                                //存入数组并同步
                                                
                                                [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"payArr"];
                                                
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}





@end
