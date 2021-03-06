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
#import "LMBalanceVO.h"

#import "LMBlanceDetailController.h"

//数据
#import "LMBalanceDataModels.h"

#import "LMYaoGuoBiController.h"

#define PAGER_SIZE      20

@interface LMBalanceViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    NSString *balanceStr;
    NSMutableArray *listArray;
    NSMutableArray *monthArray;
    LMBalanceBody *bodyData;
    NSMutableArray *sectionArray;
}

@end

@implementation LMBalanceViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.ifRemoveLoadNoState        = NO;
        self.hidesBottomBarWhenPushed   = NO;
        
        self.title = @"余额明细";
        
        // * 当充值行为发生时，刷新界面
        //
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadNoState)
                                                     name:@"rechargeMoney"
                                                   object:nil];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sectionArray=[NSMutableArray arrayWithCapacity:0];
    listArray = [NSMutableArray new];
    
    [self creatUI];
    [self getBlanceData];
    [self loadNewer];
}

- (void)loadNoState
{
    [super loadNoState];
    [self getBlanceData];
}

- (void)creatUI
{
    [super createUI];
    
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.separatorInset               = UIEdgeInsetsMake(0, 15, 0, 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        return 50;
    }
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        headView.backgroundColor    = BG_GRAY_COLOR;
        UILabel *headLb = [UILabel new];
        
        NSString *str=monthArray[section-1];
        
        NSInteger lengthString=[str length];
        
        NSDate *  senddate=[NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"YYYY-MM"];
        
        NSString *  locationString=[dateformatter stringFromDate:senddate];

        
        if (section == 1) {
            if ([locationString isEqualToString:str]) {
               headLb.text = @"本月";
            }else{
                NSString *needStr=[str substringWithRange:NSMakeRange(5, lengthString-5)];
                
                headLb.text=[NSString stringWithFormat:@"%@月",needStr];
            }
           
        } else {
            
            if (lengthString>5) {
                
                NSString *needStr=[str substringWithRange:NSMakeRange(5, lengthString-5)];
                
                headLb.text=[NSString stringWithFormat:@"%@月",needStr];
            }
        }
        
        headLb.font = TEXT_FONT_LEVEL_2;
        headLb.textColor = TEXT_COLOR_LEVEL_2;
        [headLb sizeToFit];
        headLb.frame = CGRectMake(15, 0, headLb.bounds.size.width, 30);
        [headView addSubview:headLb];
        
        UILabel *detal = [UILabel new];
        
        if (section==1) {
            detal.text = @"本月明细";
        }else{
            
            if (lengthString>5) {
                
                NSString *needStr=[str substringWithRange:NSMakeRange(5, lengthString-5)];
                
                detal.text=[NSString stringWithFormat:@"%@月明细",needStr];
            }
        }
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

- (void)sectionclickAction:(UITapGestureRecognizer *)tap
{
    NSInteger row=tap.view.tag-1;
    
    LMBlanceDetailController *DetailVC = [[LMBlanceDetailController alloc] init];
    
    DetailVC.curMonth=monthArray[row];
    DetailVC.monthArr = monthArray;
    [self.navigationController pushViewController:DetailVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return monthArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    NSMutableArray *list = [NSMutableArray new];
    for (int i = 0; i<listArray.count; i++) {
        if (section == i+1) {
            NSArray *array = listArray[i];
            for (LMBanlanceVO *balanVO in array) {
                [list addObject:balanVO];
            }
        }
    }
    
    return list.count;
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
//            case 1:
//                cell.textLabel.text = @"我的腰果";
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                cell.imageView.image = [UIImage imageNamed:@"recharge"];
//                break;
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
        
        NSMutableArray *voArray = [NSMutableArray new];
        
        for (int i = 0; i<listArray.count; i++) {
            
            if (indexPath.section==i+1) {
                NSArray *array = listArray[i];
                for (LMBanlanceVO *balanVO in array) {
                    [voArray addObject:balanVO];
                }
                LMBanlanceVO *list = [voArray objectAtIndex:indexPath.row];
                [cell setModel:list];
            }
        }
        return cell;
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
//        if (indexPath.row == 1) {
//            LMYaoGuoBiController * ygbVC = [[LMYaoGuoBiController alloc] init];
//            [ygbVC setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:ygbVC animated:YES];
//        }
        if (indexPath.row==1) {
            LMRechargeViewController *reVC = [[LMRechargeViewController alloc] init];
            
            [reVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:reVC animated:YES];
        }
        
    }else{
        
    }
}

#pragma mark  --获取余额数据
-(void)getBlanceData
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
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
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getBlanceDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if (!bodyDic) {
        
        [self textStateHUD:@"获取余额失败"];
        return;
        
    } else {
        
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
            NSDictionary *dic = [bodyDic objectForKey:@"wallet"];
            
            id  balance     = [dic objectForKey:@"balance"];
            
            if (balance && ![balance isEqual:[NSNull null]] && [balance isKindOfClass:[NSNumber class]]) {
                
                balanceStr  = [NSString stringWithFormat:@"%.2f元", [(NSNumber *)balance floatValue]];
                
            } else {
                
                balanceStr  = @"0.00元";
            }
            
            [self.tableView reloadData];
        }
    }
}

#pragma mark --余额明细列表

- (FitBaseRequest *)request
{
    LMBalanceListRequest   *request    = [[LMBalanceListRequest alloc] initWithPageIndex:self.current andPageSize:PAGER_SIZE];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    NSString        *result     = [bodyDict objectForKey:@"result"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        self.max    = [[bodyDict objectForKey:@"total"] intValue];
        
        
        monthArray = [NSMutableArray new];
        listArray  = [NSMutableArray new];
        
        NSArray *resultArr  = [LMBalanceVO LMBalanceVOListWithArray:[bodyDict objectForKey:@"list"]];
        for (LMBalanceVO *vo in resultArr) {
            NSString *month = vo.month;
            [monthArray addObject:month];
            NSArray *array = vo.Banlance;
            [listArray addObject:array];
            
        }
        
        if (resultArr && resultArr.count > 0) {
            
            return resultArr;
        }
    }
    
    return nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (fabs(self.tableView.contentSize.height - (self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.frame) )) < 44.0
        && self.statefulState == FitStatefulTableViewControllerStateIdle
        && [self canLoadMore]) {
        [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
    }
}

@end
