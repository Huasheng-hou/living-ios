//
//  LMExpertDetailController.m
//  living
//
//  Created by Huasheng on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertDetailController.h"
#import "LMPublicArticleController.h"
#import "LMExpertDetailView.h"
#import "LMExpertHotArticleCell.h"


@interface LMExpertDetailController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LMExpertDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    
}

- (void)createUI{
    [super createUI];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(publicAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    LMExpertDetailView * headerView = [[LMExpertDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    self.tableView.tableHeaderView = headerView;
    
    
    
}
#pragma mark 发布文章
- (void)publicAction
{
    LMPublicArticleController *publicVC = [[LMPublicArticleController alloc] init];
    [self.navigationController pushViewController:publicVC animated:YES];
}

#pragma mark UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 205;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 21, 70, 13)];
    title.textColor = TEXT_COLOR_LEVEL_4;
    title.font = TEXT_FONT_BOLD_12;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"丨 热门文章"];
    [attr addAttribute:NSForegroundColorAttributeName value:ORANGE_COLOR range:NSMakeRange(0, 2)];
    title.attributedText = attr;
    [backView addSubview:title];
    
    return backView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LMExpertHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LMExpertHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end
