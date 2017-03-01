//
//  LMSubmitSuccessController.m
//  living
//
//  Created by Huasheng on 2017/2/25.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMSubmitSuccessController.h"
#import "LMSubmitSuccessView.h"
#import "LMNearbyLifeMuseumCell.h"
@interface LMSubmitSuccessController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LMSubmitSuccessController
{
    LMSubmitSuccessView * _headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self createUI];
    
}

- (void)createUI{
    [super createUI];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _headerView = [[LMSubmitSuccessView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    _headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = _headerView;
    
}
- (void)complete{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    head.backgroundColor = [UIColor whiteColor];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 10)];
    title.textColor = TEXT_COLOR_LEVEL_3;
    title.font = TEXT_FONT_LEVEL_4;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"丨 就近生活馆查询"];
    [attr addAttribute:NSForegroundColorAttributeName value:ORANGE_COLOR range:NSMakeRange(0, 2)];
    title.attributedText = attr;
    [head addSubview:title];
    
    return head;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LMNearbyLifeMuseumCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LMNearbyLifeMuseumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
