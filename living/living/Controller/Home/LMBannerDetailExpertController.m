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
    
    
}

#pragma mark tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 5;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 100;
    }
    if (indexPath.section == 1) {
        return 210;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nameList = @[@"| 腰美达人", @"| 热门课程"];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 10)];
    titleLabel.textColor = TEXT_COLOR_LEVEL_3;
    titleLabel.font = TEXT_FONT_LEVEL_4;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:nameList[section]];
    [attr addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0, 2)];
    titleLabel.attributedText = attr;
    [headerView addSubview:titleLabel];
    
    return headerView;
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
        LMExpertHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
        if (!cell) {
            cell = [[LMExpertHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCell"];
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
