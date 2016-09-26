//
//  DYPersonViewController.m
//  dirty
//
//  Created by Ding on 16/8/23.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMPersonViewController.h"
#import "LMSettingViewController.h"
#import "FitUserManager.h"
#import "DYUserInfo.h"

@interface LMPersonViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    DYUserInfo *infoModel;
    NSString *gender;
}


@end

@implementation LMPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self getUserInfoData];
    [self creatUI];
}

-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.navigationController.navigationBar.tintColor  = COLOR_DIRTY_COLOR;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(action)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    

}

#pragma mark  请求个人数据
-(void)getUserInfoData
{
    NSLog(@"**************%@",[FitUserManager sharedUserManager].uuid);
    

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
        infoModel = [[DYUserInfo alloc] initWithDictionary:[bodyDict objectForKey:@"user_info"]];
        [_tableView reloadData];

        

    } else {
        [self textStateHUD:@"登录失败"];
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
            
            NSString *str = infoModel.nickname;
            CGSize textSize = [str boundingRectWithSize:CGSizeMake(600, 30) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
            [nicklabel setFrame:CGRectMake(100, 10, textSize.width, 30)];
            nicklabel.text = str;
            [cell.contentView addSubview:nicklabel];
            
            
            //gender icon
            UIImageView *genderImage = [[UIImageView alloc] initWithFrame:CGRectMake(textSize.width+5+100, 17, 16, 16)];
            if (infoModel.gender) {
                NSLog(@"%.0f",infoModel.gender);
                if (infoModel.gender==1) {
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
            question.text = [NSString stringWithFormat:@"余额 %.0f",infoModel.todayQuestions];
            question.font = TEXT_FONT_LEVEL_2;
            question.textColor = TEXT_COLOR_LEVEL_3;
            [cell.contentView addSubview:question];
            
            
            
            //订单
            UILabel *reward = [[UILabel alloc] initWithFrame:CGRectMake(180, 50, 80, 20)];
            reward.text = [NSString stringWithFormat:@"订单 %.0f",infoModel.todayRewards];
            reward.font = TEXT_FONT_LEVEL_2;
            reward.textColor = TEXT_COLOR_LEVEL_3;
            [cell.contentView addSubview:reward];
            
        }
        
        switch (indexPath.row) {
                
            case 1:
                cell.textLabel.text = @" 绑定号码";
                if (infoModel.phone==nil) {
                    cell.detailTextLabel.text = @"- -";
                }else{
                    cell.detailTextLabel.text = infoModel.phone;
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
        
        
        switch (indexPath.row) {
                
            case 0:
                cell.textLabel.text = @" 余额";

                break;
                
            case 1:
                cell.textLabel.text = @" 订单";

                break;
                
            case 2:
                cell.textLabel.text = @" 生活馆";

                
                break;
                
            default:
                break;
        }
        
    }
    
    if (indexPath.section==2) {
        
        
        switch (indexPath.row) {
                
            case 0:
                cell.textLabel.text = @" 设置";
                
                break;
                
            case 1:
                cell.textLabel.text = @" 我的二维码";
                
                break;
                
            default:
                break;
        }
        
    }
    
    
    return cell;

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
