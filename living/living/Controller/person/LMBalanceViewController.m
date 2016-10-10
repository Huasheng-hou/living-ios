//
//  LMBalanceViewController.m
//  living
//
//  Created by Ding on 16/10/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBalanceViewController.h"

@interface LMBalanceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}


@end

@implementation LMBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额明细";
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
        return 3;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        cell.imageView.image = [UIImage imageNamed:@"balance"];
        cell.textLabel.font = TEXT_FONT_LEVEL_2;
        cell.textLabel.textColor = TEXT_COLOR_LEVEL_2;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"当前余额";
                cell.detailTextLabel.text = @"1000元";
                cell.detailTextLabel.textColor = LIVING_COLOR;
                break;
                case 1:
                cell.textLabel.text = @"余额充值";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
                case 2:
                cell.textLabel.text = @"余额提现";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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


@end
