//
//  LMBannerDetailExpertController.m
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMBannerDetailExpertController.h"
#import "LMExpertListCell.h"
#import "LMExpertHotArticleCell.h"
#import "LMExpertDetailController.h"

#import "LMNewHotArticleCell.h"
#import "LMExpertListController.h"
#import "LMArtcleTypeListRequest.h"
@interface LMBannerDetailExpertController ()<UITableViewDelegate,UITableViewDataSource,LMExpertListDelegate>

@end

@implementation LMBannerDetailExpertController
- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createUI];
}

- (void)createUI{
    
    [super createUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 102, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 102, 0);
    self.pullToRefreshView.defaultContentInset = UIEdgeInsetsMake(0, 0, 102, 0);
    
}
#pragma mark - 数据请求
- (FitBaseRequest *)request{
    
    LMArtcleTypeListRequest *request = [[LMArtcleTypeListRequest alloc] initWithPageIndex:self.current andPageSize:20 andType:@"幸福情商"];
    
    
    return request;
    
}

#pragma mark tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 100;
    }
    
    return 210-35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nameList = @[@"| 腰果达人", @"| 热门文章", @"| 热门活动", @"| 热门课程"];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 10)];
    titleLabel.textColor = TEXT_COLOR_LEVEL_3;
    titleLabel.font = TEXT_FONT_LEVEL_4;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:nameList[section]];
    [attr addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0, 2)];
    titleLabel.attributedText = attr;
    [headerView addSubview:titleLabel];
    if (section == 0) {
        UILabel * lookMore = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-60-10, 15, 60, 10)];
        lookMore.text = @"更多 >";
        lookMore.textAlignment = NSTextAlignmentRight;
        lookMore.textColor = TEXT_COLOR_LEVEL_3;
        lookMore.font = TEXT_FONT_LEVEL_4;
        lookMore.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMore:)];
        [lookMore addGestureRecognizer:tap];
        [headerView addSubview:lookMore];

    }
    
    return headerView;
}
- (void)lookMore:(UITapGestureRecognizer *)tap{
    
    NSLog(@"查看更多");
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    LMExpertListController * listVC = [[LMExpertListController alloc] init];
    listVC.title = @"达人";
    [self.navigationController pushViewController:listVC animated:YES];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        LMExpertListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[LMExpertListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.count = 8;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        LMNewHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotArticleCell"];
        if (!cell) {
            cell = [[LMNewHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotArticleCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    if (indexPath.section == 2) {
        LMExpertHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotEventCell"];
        if (!cell) {
            cell = [[LMExpertHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotEventCell"];
        }
        cell.type = 1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 3) {
        LMExpertHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotClassCell"];
        if (!cell) {
            cell = [[LMExpertHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotClassCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

#pragma mark 点击达人头像进入详情代理方法
- (void)gotoNextPage:(NSInteger)index{
    
    LMExpertDetailController * vc = [[LMExpertDetailController alloc] init];
    vc.title = @"李莺莺的空间";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
