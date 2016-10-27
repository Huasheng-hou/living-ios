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
    self.navigationItem.title = @"版本信息";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-30, 60, 70, 71)];
    imageView.image = [UIImage imageNamed:@"editMsg"];
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-40, 134, 80, 30)];
    msg.text = @"腰 果";
    msg.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:msg];
    [headView addSubview:imageView];
    
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200;
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
