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
#import "LMExpertListCell.h"
#import "LMNewHotArticleCell.h"
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
    self.tableView.backgroundColor = BG_GRAY_COLOR;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(publicAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    LMExpertDetailView * headerView = [[LMExpertDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth+10)];
    self.tableView.tableHeaderView = headerView;
    
    
    
}
#pragma mark 发布文章
- (void)publicAction
{
    LMPublicArticleController *publicVC = [[LMPublicArticleController alloc] init];
    [self.navigationController pushViewController:publicVC animated:YES];
}

#pragma mark UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 175;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray * titles = @[@"丨 文章", @"丨 活动", @"丨 课堂"];
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 70, 14)];
    title.textColor = TEXT_COLOR_LEVEL_4;
    title.font = TEXT_FONT_BOLD_12;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:titles[section]];
    [attr addAttribute:NSForegroundColorAttributeName value:ORANGE_COLOR range:NSMakeRange(0, 2)];
    title.attributedText = attr;
    [backView addSubview:title];
    
    UILabel * lookMore = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-60-10, 15, 60, 10)];
    lookMore.text = @"更多 >";
    lookMore.textAlignment = NSTextAlignmentRight;
    lookMore.textColor = TEXT_COLOR_LEVEL_4;
    lookMore.font = TEXT_FONT_LEVEL_3;
    lookMore.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMore:)];
    [lookMore addGestureRecognizer:tap];
    [backView addSubview:lookMore];
    
    
    return backView;
    
}
- (void)lookMore:(UITapGestureRecognizer *)tap{
    NSLog(@"查看更多");
    //文章
    
    //活动
    
    //课程
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        LMNewHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotArticleCell"];
        if (!cell) {
            cell = [[LMNewHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotArticleCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if (indexPath.section == 1) {
        LMExpertHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotEventCell"];
        if (!cell) {
            cell = [[LMExpertHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotEventCell"];
        }
        cell.type = 1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2) {
        LMExpertHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotClassCell"];
        if (!cell) {
            cell = [[LMExpertHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotClassCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}



@end
