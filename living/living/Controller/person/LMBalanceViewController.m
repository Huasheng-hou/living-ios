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

@interface LMBalanceViewController ()
<UITableViewDelegate,
UITableViewDataSource>
{
    UITableView *_tableView;
    NSString *balanceStr;
}


@end

@implementation LMBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额明细";
    [self getBlanceData];
    [self creatUI];
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
    return 60;
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
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    
    UILabel *headLb = [UILabel new];
    if (section==1) {
        headLb.text =@"本月明细";
    }
    if (section==2) {
        headLb.text = @"9月明细";
    }
    headLb.font = TEXT_FONT_LEVEL_2;
    headLb.textColor = TEXT_COLOR_LEVEL_2;
    [headLb sizeToFit];
    headLb.frame = CGRectMake(15, 0, headLb.bounds.size.width, 30);
    [headView addSubview:headLb];
    
    return headView;
}






-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        
        cell.textLabel.font = TEXT_FONT_LEVEL_2;
        cell.textLabel.textColor = TEXT_COLOR_LEVEL_2;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"当前余额";
                cell.detailTextLabel.text = balanceStr;
                cell.detailTextLabel.textColor = LIVING_COLOR;
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
    }
    
    if (indexPath.section==1) {
        cell.textLabel.font = TEXT_FONT_LEVEL_2;
        cell.textLabel.textColor = TEXT_COLOR_LEVEL_2;
        cell.textLabel.text = @"*******************活动已退款";
        cell.detailTextLabel.textColor = LIVING_COLOR;
        cell.detailTextLabel.font = TEXT_FONT_LEVEL_2;
        cell.detailTextLabel.text = @"+300";
    }
    if (indexPath.section==2) {
        cell.textLabel.font = TEXT_FONT_LEVEL_2;
        cell.textLabel.textColor = TEXT_COLOR_LEVEL_2;
        cell.textLabel.text = @"*******************活动已支付";
        cell.detailTextLabel.textColor = TEXT_COLOR_LEVEL_2;
        cell.detailTextLabel.font = TEXT_FONT_LEVEL_2;
        cell.detailTextLabel.text = @"-300";
    }
    
    
    //        [cell setXScale:self.xScale yScale:self.yScaleWithAll];
    
    return cell;
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

            balanceStr =[NSString stringWithFormat:@"%@",[dic objectForKey:@"balance"]];

            
            [_tableView reloadData];
        }
    }
}


@end
