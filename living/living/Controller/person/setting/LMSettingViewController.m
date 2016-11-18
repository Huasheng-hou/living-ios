//
//  DYSettingViewController.m
//  dirty
//
//  Created by Ding on 16/8/23.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMSettingViewController.h"
#import "LMAddviceViewController.h"
#import "LMWebViewController.h"
#import "LMVersionViewController.h"

@interface LMSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation LMSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}

-(void)createUI
{
    
    self.navigationItem.title = @"设置";
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
    UIButton *loginOut = [[UIButton alloc] initWithFrame:CGRectMake(15, 40, kScreenWidth-30, 45)];
    [loginOut setTitle:@"退出" forState:UIControlStateNormal];
    loginOut.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginOut.titleLabel.font = [UIFont systemFontOfSize:17];
    loginOut.layer.cornerRadius=5.0f;
    [loginOut addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
    loginOut.backgroundColor = LIVING_COLOR;
    [footView addSubview:loginOut];
    
    [self.tableView setTableFooterView:footView];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    [cell.textLabel setFont:TEXT_FONT_LEVEL_1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section ==0) {
        
        if (indexPath.row==0) {
            cell.imageView.image = [UIImage imageNamed:@"userdeal"];
            [cell.textLabel setText:@"用户协议"];
        }
        if (indexPath.row==1) {
            cell.imageView.image = [UIImage imageNamed:@"opinion"];
            [cell.textLabel setText:@"意见反馈"];
        }
    }
    if (indexPath.section==1) {
        
        cell.imageView.image = [UIImage imageNamed:@"versionmsg"];
        [cell.textLabel setText:@"关于腰果"];
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            LMWebViewController *webVC = [[LMWebViewController alloc] init];
            webVC.hidesBottomBarWhenPushed = YES;
            webVC.urlString = @"http://120.26.64.40:8080/living/user-cn.html";
            webVC.titleString = @"用户协议";
            [self.navigationController pushViewController:webVC animated:YES];
        }
        if (indexPath.row==1) {
            LMAddviceViewController *addvice = [[LMAddviceViewController alloc] init];
            [self.navigationController pushViewController:addvice animated:YES];
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            LMVersionViewController *verVC = [[LMVersionViewController alloc] init];
            verVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:verVC animated:YES];
        }
    }
}

// * 退出登录
//
- (void)logOutAction
{
    [[FitUserManager sharedUserManager] logout];
    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
    
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
    
    [self.navigationController popViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FIT_LOGOUT_NOTIFICATION object:nil];
}

@end
