//
//  LMBalanceViewController.m
//  living
//
//  Created by Ding on 16/10/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBalanceViewController.h"
#import "LMRechargeViewController.h"
#import "LMBalanceRequest.h"
#import "LMBalanceListRequest.h"
#import "LMBlanceDetailController.h"
#import "LMBlanceListCell.h"
#import "LMBalanceList.h"


@interface LMBalanceViewController ()
<UITableViewDelegate,
UITableViewDataSource>
{
    UITableView *_tableView;
    NSString *balanceStr;
    NSMutableArray *listArray;
    NSMutableArray *monthArray;
}

@end

@implementation LMBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额明细";
    [self getData];
 
    [self creatUI];
    listArray = [NSMutableArray new];
    monthArray = [NSMutableArray new];

    
    //请求获取余额
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(getData)
     
                                                 name:@"rechargeMoney"
     
                                               object:nil];
}

-(void)getData
{
    [self getBlanceData];
    [self getBalancelistData];
}

-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        return 60;
    }
    
    return 75;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    if (section==1) {
        return 30;
    }
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        
 
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    
         UILabel *headLb = [UILabel new];
        for (int i = 0; i<monthArray.count; i++) {
            if (section==i) {
                headLb.text =@"本月";
            }
        }

    headLb.font = TEXT_FONT_LEVEL_2;
    headLb.textColor = TEXT_COLOR_LEVEL_2;
    [headLb sizeToFit];
    headLb.frame = CGRectMake(15, 0, headLb.bounds.size.width, 30);
    [headView addSubview:headLb];
    
    
    UILabel *detal = [UILabel new];
    detal.text = @"本月明细";
    detal.font = TEXT_FONT_LEVEL_2;
    detal.textColor = TEXT_COLOR_LEVEL_2;
    [detal sizeToFit];
    detal.frame = CGRectMake(kScreenWidth-27-detal.bounds.size.width, 0, detal.bounds.size.width, 30);
    [headView addSubview:detal];
    
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20, 8, 7, 14)];
    right.image = [UIImage imageNamed:@"turnright"];
    [headView addSubview:right];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionclickAction:)];
        [headView addGestureRecognizer:tap];
        tap.view.tag = section;
    return headView;
        
    }
    return nil;
        
}

-(void)sectionclickAction:(UITapGestureRecognizer *)tap
{
    LMBlanceDetailController *DetailVC = [[LMBlanceDetailController alloc] init];
    DetailVC.monthArr = monthArray;
    [self.navigationController pushViewController:DetailVC animated:YES];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return monthArray.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0) {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = TEXT_FONT_LEVEL_2;
        cell.textLabel.textColor = TEXT_COLOR_LEVEL_2;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"当前余额";
                cell.detailTextLabel.text = balanceStr;
                cell.detailTextLabel.textColor = LIVING_REDCOLOR;
                cell.imageView.image = [UIImage imageNamed:@"balance"];
                break;
                case 1:
                cell.textLabel.text = @"余额充值";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = [UIImage imageNamed:@"recharge"];
                break;
            default:
                break;
        }
        return cell;
        
        
    }else{
        static NSString *cellID = @"cellId";
        LMBlanceListCell *cell = [[LMBlanceListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        LMBalanceList *list = [listArray objectAtIndex:indexPath.row];
//        [cell setModel:list];
        return cell;
        
    }
    
    return nil;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            LMRechargeViewController *reVC = [[LMRechargeViewController alloc] init];
            
            [reVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:reVC animated:YES];
        }
    }
    
}

#pragma mark  --获取余额数据
-(void)getBlanceData
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    LMBalanceRequest *request = [[LMBalanceRequest alloc] init];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getBlanceDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取余额数据失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];

    
}
-(void)getBlanceDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"获取余额失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            NSDictionary *dic = [bodyDic objectForKey:@"wallet"];

            balanceStr =[NSString stringWithFormat:@"%@元",[dic objectForKey:@"balance"]];

            
            [_tableView reloadData];
        }
    }
}

#pragma mark --余额明细列表

-(void)getBalancelistData
{
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    
    LMBalanceListRequest *request = [[LMBalanceListRequest alloc] initWithPageIndex:1 andPageSize:20];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getBlanceListDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取余额数据失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];

}

-(void)getBlanceListDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    NSLog(@"===========余额明细=bodyDic==============%@",bodyDic);
    
    if (!bodyDic) {
        [self textStateHUD:@"获取余额列表失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        NSMutableArray *array=bodyDic[@"list"];


            for (int i=0; i<array.count; i++) {
                LMBalanceList *list=[[LMBalanceList alloc]initWithDictionary:array[i]];
                NSString *month = [array[i] objectForKey:@"month"];
                [monthArray addObject:month];
                if (![listArray containsObject:list]) {
                    [listArray addObject:list];
                }
                
                
                
            }
            
            
        }
        [_tableView reloadData];
    }
    
}





@end
