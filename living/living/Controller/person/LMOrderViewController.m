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


//支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
//微信支付
#import "WXApiObject.h"
#import "WXApi.h"

#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

@interface LMOrderViewController ()<UITableViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate,
LMOrderCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *orderArray;
}

@end

@implementation LMOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单";
    [self creatUI];
    [self getOrderListRequest];
    orderArray = [NSMutableArray new];
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
        NSLog(@"******确定");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [alert dismissViewControllerAnimated:YES completion:nil];      }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
- (void)cellWillpay:(LMOrderCell *)cell
{
    NSLog(@"**********付款");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择支付方式"
                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];      [alert addAction:[UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"******微信支付");
        [WXApiRequestHandler jumpToBizPay:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"支付宝支付"
                                                        style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                NSLog(@"******支付宝支付");
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
    NSLog(@"*******%@",bodyDic);
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
