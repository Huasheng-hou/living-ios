//
//  LMVersionViewController.m
//  living
//
//  Created by Ding on 2016/10/21.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMVersionViewController.h"

@interface LMVersionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSString *version;
    NSString *appName;
    NSString *appCurVersion;
}

@end

@implementation LMVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于腰果";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    UILabel *copyRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    copyRight.font = [UIFont systemFontOfSize:11.0f];
    copyRight.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1.0];
    copyRight.textAlignment = NSTextAlignmentCenter;
    copyRight.text = @"Copyright © 2016 腰果控股有限公司";
    [headView addSubview:copyRight];
    _tableView.tableFooterView = headView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-30, 70, 70, 71)];
    imageView.image = [UIImage imageNamed:@"editMsg"];
    
    imageView.layer.cornerRadius = 10;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-40, 144, 90, 30)];
    msg.text = @"腰果生活";
    msg.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:msg];
    [headView addSubview:imageView];
    
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 230;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    cell.textLabel.textColor=TEXT_COLOR_LEVEL_3;
    cell.textLabel.text = @"当前版本";
    cell.detailTextLabel.textColor=TEXT_COLOR_LEVEL_3;
    cell.detailTextLabel.text = version;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
@end
