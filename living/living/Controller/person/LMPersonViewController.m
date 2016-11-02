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
#import "LMMy2dcodeViewController.h"
#import "LMMyLivingViewController.h"
#import "LMMyFriendViewController.h"
#import "LMPersonInfoRequest.h"
#import "FitUserManager.h"
#import "LMUserInfo.h"
#import "LMScanViewController.h"

@interface LMPersonViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
//    LMUserInfo *infoModel;
    NSString *gender;
    NSMutableDictionary *infoDic;
}


@end

@implementation LMPersonViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor  = LIVING_COLOR;

}

- (void)viewDidLoad {
    [super viewDidLoad];


    infoDic = [NSMutableDictionary new];
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
//        infoModel = [[LMUserInfo alloc] initWithDictionary:[bodyDict objectForKey:@"userInfo"]];
        infoDic =[bodyDict objectForKey:@"userInfo"];
        
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
        return 1;
    }
    if (section==1) {
        return 4;
    }
    if (section==2) {
        return 2;
    }
    if (section==3) {
        return 1;
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
    return 4;
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

        LMUserInfo *infoModel = [[LMUserInfo alloc] initWithDictionary:infoDic];
        
        if (indexPath.row==0) {
            //头像
            UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
            headerView.layer.cornerRadius = 35;
            headerView.backgroundColor = BG_GRAY_COLOR;
            headerView.contentMode = UIViewContentModeScaleAspectFill;
            headerView.clipsToBounds = YES;
            
            
            if (infoModel.avatar ==nil) {
                if ([infoModel.gender isEqual:@"1"]) {
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
            [question sizeToFit];
            question.frame = CGRectMake(100, 50, question.bounds.size.width, 20);
            [cell.contentView addSubview:question];
            
            
            
            //订单
            UILabel *reward = [[UILabel alloc] initWithFrame:CGRectMake(180, 50, 80, 20)];
            reward.text = [NSString stringWithFormat:@"订单 %.0f",infoModel.orderNumber];
            reward.font = TEXT_FONT_LEVEL_2;
            reward.textColor = TEXT_COLOR_LEVEL_3;
            [reward sizeToFit];
            reward.frame = CGRectMake(120+question.bounds.size.width, 50, reward.bounds.size.width, 20);
            [cell.contentView addSubview:reward];
            
            //生活馆
            UILabel *living = [[UILabel alloc] initWithFrame:CGRectMake(180, 50, 80, 20)];
            living.text = [NSString stringWithFormat:@"生活馆 %.0f",infoModel.orderNumber];
            living.font = TEXT_FONT_LEVEL_2;
            living.textColor = TEXT_COLOR_LEVEL_3;
            [living sizeToFit];
            living.frame = CGRectMake(140+question.bounds.size.width+reward.bounds.size.width, 50, living.bounds.size.width, 20);
            [cell.contentView addSubview:living];
            
            UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20, 53, 7, 14)];
            right.image = [UIImage imageNamed:@"turnright"];
            [cell.contentView addSubview:right];
            
            
            
        }
        
//        switch (indexPath.row) {
//                
//            case 1:
//                cell.textLabel.text = @" 绑定号码";
//                if ([FitUserManager sharedUserManager].phone==nil) {
//                    cell.detailTextLabel.text = @"- -";
//                }else{
//                    cell.detailTextLabel.text = [FitUserManager sharedUserManager].phone;
//                }
//                break;
//                
//            case 2:
//                cell.textLabel.text = @" 出生年月";
//                if (infoModel.birthday==nil) {
//                    cell.detailTextLabel.text = @"- -";
//                }else{
//                    cell.detailTextLabel.text = infoModel.birthday;
//                }
//                break;
//                
//            case 3:
//                cell.textLabel.text = @" 所在城市";
//                if (infoModel.province==nil && infoModel.city==nil) {
//                    cell.detailTextLabel.text = @"- -";
//                }else{
//                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",infoModel.province,infoModel.city];
//                }
//                
//                break;
//                
//            default:
//                break;
//        }


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
            case 3:
                cell.textLabel.text = @"我的好友";
                cell.imageView.image = [UIImage imageNamed:@"friend"];
                
                
                break;
                
            default:
                break;
        }
        
    }
    
    if (indexPath.section==2) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"扫一扫";
                cell.imageView.image = [UIImage imageNamed:@"scanIcon"];
                break;
            case 1:
                cell.textLabel.text = @"我的二维码";
                cell.imageView.image = [UIImage imageNamed:@"2Dcode"];
                break;
            default:
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        

 
        
        
    }
    if (indexPath.section==3) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
        cell.textLabel.text = @"设置";
        cell.imageView.image = [UIImage imageNamed:@"setting"];
        
    }
    
    
    return cell;

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //修改资料
    LMUserInfo *infoModel = [[LMUserInfo alloc] initWithDictionary:infoDic];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            
            LMChangeDataViewController *changeVC = [[LMChangeDataViewController alloc] init];
            changeVC.hidesBottomBarWhenPushed = YES;
            changeVC.avartStr = infoModel.avatar;
            changeVC.nickStr = infoModel.nickName;
            changeVC.ageStr = infoModel.birthday;
            changeVC.cityStr = infoModel.city;
            changeVC.provinceStr = infoModel.province;
            changeVC.genderStr = infoModel.gender;
            
            [self.navigationController pushViewController:changeVC animated:YES];
        }
    }
    
    
    if (indexPath.section==1) {
        //余额
        if (indexPath.row==0) {
            LMBalanceViewController *baVC = [[LMBalanceViewController alloc] init];
            [baVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:baVC animated:YES];
        }
        //订单
        if (indexPath.row==1) {
            LMOrderViewController *orderVC = [[LMOrderViewController alloc] init];
            [orderVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
        //生活馆
        if (indexPath.row ==2) {
            LMMyLivingViewController *myVC = [[LMMyLivingViewController alloc] init];
            myVC.hidesBottomBarWhenPushed = YES;
            myVC.livImgUUid = infoModel.livingUuid;
            [self.navigationController pushViewController:myVC animated:YES];
        }
        //我的好友
        if (indexPath.row ==3) {
            LMMyFriendViewController *myfVC = [[LMMyFriendViewController alloc] init];
            [self.navigationController pushViewController:myfVC animated:YES];
        }
        
    }
    
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            LMScanViewController *setVC = [[LMScanViewController alloc] init];
            [setVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:setVC animated:YES];
        }
        if (indexPath.row==1) {
            LMMy2dcodeViewController *setVC = [[LMMy2dcodeViewController alloc] init];
            [setVC setHidesBottomBarWhenPushed:YES];
            
            if (infoModel.province!=nil) {
               setVC.address = [NSString stringWithFormat:@"%@-%@",infoModel.province,infoModel.city];
            }
            setVC.name = infoModel.nickName;
            setVC.gender = infoModel.gender;
            setVC.headURL = infoModel.avatar;
            
            
            [self.navigationController pushViewController:setVC animated:YES];
        }
    }

    
    
    if (indexPath.section==3) {
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
