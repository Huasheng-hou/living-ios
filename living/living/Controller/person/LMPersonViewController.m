//
//  DYPersonViewController.m
//  dirty
//
//  Created by Ding on 16/8/23.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMPersonViewController.h"
#import "LMChangeDataViewController.h"
#import "LMSettingViewController.h"
#import "LMNoticViewController.h"
#import "LMBalanceViewController.h"
#import "LMOrderViewController.h"
#import "LMPersonInfoRequest.h"
#import "FitUserManager.h"
#import "LMUserInfo.h"

@interface LMPersonViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    LMUserInfo *infoModel;
    NSString *gender;
}


@end

@implementation LMPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self getUserInfoData];
    [self creatUI];
    
    //请求获取余额
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(getUserInfoData)
     
                                                 name:@"rechargeMoney"
     
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(getUserInfoData)
     
                                                 name:@"reloadData"
     
                                               object:nil];
    
    
    
}

-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notic"] style:UIBarButtonItemStylePlain target:self action:@selector(noticAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    

}

-(void)noticAction
{
    NSLog(@"*******通知");
    LMNoticViewController *noticVC = [[LMNoticViewController alloc] init];
    [noticVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:noticVC animated:YES];
    
}


#pragma mark  请求个人数据
-(void)getUserInfoData
{
    NSLog(@"**************%@",[FitUserManager sharedUserManager].uuid);
    LMPersonInfoRequest *request = [[LMPersonInfoRequest alloc] initWithUserUUid:[FitUserManager sharedUserManager].uuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getUserInfoResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取数据失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    

}

-(void)getUserInfoResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"获取数据失败"];
        return;
    }
    
    NSString *result    = [bodyDict objectForKey:@"result"];
    
    if (result && [result intValue] == 0)
    {
        infoModel = [[LMUserInfo alloc] initWithDictionary:[bodyDict objectForKey:@"userInfo"]];
        [_tableView reloadData];

        

    } else {
        [self textStateHUD:bodyDict[@"description"]];
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 20;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    }
    if (section==1) {
        return 3;
    }
    if (section==2) {
        return 2;
    }

    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 100;
        }
        return 45;
    }
    return 45;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:TEXT_FONT_LEVEL_1];
    cell.textLabel.textColor = TEXT_COLOR_LEVEL_2;
    [cell.detailTextLabel setFont:TEXT_FONT_LEVEL_2];
    if (indexPath.section==0) {

        if (indexPath.row==0) {
            //头像
            UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
            headerView.layer.cornerRadius = 35;
            headerView.backgroundColor = [UIColor grayColor];
            headerView.contentMode = UIViewContentModeScaleAspectFill;
            headerView.clipsToBounds = YES;
            
            
            if (infoModel.avatar ==nil) {
                if ([[FitUserManager sharedUserManager].gender isEqual:@1]) {
                    headerView.image = [UIImage imageNamed:@"placeholder-man"];
                }else{
                    headerView.image = [UIImage imageNamed:@"placeholder-woman"];
                }
                
            }else{
                [headerView setImageWithURL:[NSURL URLWithString:infoModel.avatar]];
            }
            [cell.contentView addSubview:headerView];
            
            //nick
            UILabel *nicklabel = [[UILabel alloc] initWithFrame:CGRectMake(100,10,30,30)];
            nicklabel.font = TEXT_FONT_LEVEL_1;
            nicklabel.textColor = TEXT_COLOR_LEVEL_2;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],};
            
            NSString *str = infoModel.nickName;
            CGSize textSize = [str boundingRectWithSize:CGSizeMake(600, 30) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
            [nicklabel setFrame:CGRectMake(100, 10, textSize.width, 30)];
            nicklabel.text = str;
            [cell.contentView addSubview:nicklabel];
            
            
            //gender icon
            UIImageView *genderImage = [[UIImageView alloc] initWithFrame:CGRectMake(textSize.width+5+100, 17, 16, 16)];
            if (infoModel.gender) {
                if ([infoModel.gender isEqual:@"1"]) {
                    [genderImage setImage:[UIImage imageNamed:@"gender-man"]];
                }else{
                    [genderImage setImage:[UIImage imageNamed:@"gender-woman"]];
                }
            }
            [cell.contentView addSubview:genderImage];
            
            //下划线
            UILabel *lineLabel =[[UILabel alloc] initWithFrame:CGRectMake(100, 40, kScreenWidth-100, 1.0)];
            lineLabel.backgroundColor = LINE_COLOR;
            [cell.contentView addSubview:lineLabel];
            
            //余额
            UILabel *question = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 80, 20)];
            question.text = [NSString stringWithFormat:@"余额 ￥%.0f",infoModel.balance];
            question.font = TEXT_FONT_LEVEL_2;
            question.textColor = TEXT_COLOR_LEVEL_3;
            [cell.contentView addSubview:question];
            
            
            
            //订单
            UILabel *reward = [[UILabel alloc] initWithFrame:CGRectMake(180, 50, 80, 20)];
            reward.text = [NSString stringWithFormat:@"订单 %.0f",infoModel.orderNumber];
            reward.font = TEXT_FONT_LEVEL_2;
            reward.textColor = TEXT_COLOR_LEVEL_3;
            [cell.contentView addSubview:reward];
            
        }
        
        switch (indexPath.row) {
                
            case 1:
                cell.textLabel.text = @" 绑定号码";
                if ([FitUserManager sharedUserManager].phone==nil) {
                    cell.detailTextLabel.text = @"- -";
                }else{
                    cell.detailTextLabel.text = [FitUserManager sharedUserManager].phone;
                }
                break;
                
            case 2:
                cell.textLabel.text = @" 出生年月";
                if (infoModel.birthday==nil) {
                    cell.detailTextLabel.text = @"- -";
                }else{
                    cell.detailTextLabel.text = infoModel.birthday;
                }
                break;
                
            case 3:
                cell.textLabel.text = @" 所在城市";
                if (infoModel.province==nil && infoModel.city==nil) {
                    cell.detailTextLabel.text = @"- -";
                }else{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",infoModel.province,infoModel.city];
                }
                
                break;
                
            default:
                break;
        }


    }
    if (indexPath.section==1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        switch (indexPath.row) {
                
            case 0:
                cell.textLabel.text = @"余额";
                cell.imageView.image = [UIImage imageNamed:@"balance"];

                break;
                
            case 1:
                cell.textLabel.text = @"订单";
                cell.imageView.image = [UIImage imageNamed:@"order"];

                break;
                
            case 2:
                cell.textLabel.text = @"生活馆";
                cell.imageView.image = [UIImage imageNamed:@"living"];

                
                break;
                
            default:
                break;
        }
        
    }
    
    if (indexPath.section==2) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
                
            case 0:
                cell.textLabel.text = @"设置";
                cell.imageView.image = [UIImage imageNamed:@"setting"];
                
                break;
                
            case 1:
                cell.textLabel.text = @"我的二维码";
                cell.imageView.image = [UIImage imageNamed:@"2Dcode"];
                
                break;
                
            default:
                break;
        }
        
    }
    
    
    return cell;

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //修改资料
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            LMChangeDataViewController *changeVC = [[LMChangeDataViewController alloc] init];
            changeVC.hidesBottomBarWhenPushed = YES;
            changeVC.avartStr = infoModel.avatar;
            changeVC.nickStr = infoModel.nickName;
            changeVC.ageStr = infoModel.birthday;
            changeVC.cityStr = infoModel.city;
            changeVC.provinceStr = infoModel.province;
            
            [self.navigationController pushViewController:changeVC animated:YES];
        }
    }
    
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            LMBalanceViewController *baVC = [[LMBalanceViewController alloc] init];
            [baVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:baVC animated:YES];
        }
        if (indexPath.row==1) {
            LMOrderViewController *orderVC = [[LMOrderViewController alloc] init];
            [orderVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            LMSettingViewController *setVC = [[LMSettingViewController alloc] init];
            
            [self.navigationController pushViewController:setVC animated:YES];
        }
    }
}








-(void)action
{
    
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
