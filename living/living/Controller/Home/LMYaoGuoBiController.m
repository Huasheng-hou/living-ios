//
//  LMYaoGuoBiController.m
//  living
//
//  Created by hxm on 2017/3/8.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYaoGuoBiController.h"
#import "WJLoopView.h"
#import "FitConsts.h"
#import "LMYGBConvertCell.h"
#import "LMYGBActivityCell.h"


@interface LMYaoGuoBiController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LMYaoGuoBiController
{
    UIView * headView;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];

}

- (void)createUI{
    [super createUI];
    
    self.navigationItem.title = @"Yao·果币";
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*8/15+42+10)];
    headView.backgroundColor = BG_GRAY_COLOR;
    self.tableView.tableHeaderView = headView;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame)-52, kScreenWidth, 42)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"";
    [headView addSubview:label];
    
    UIImageView * ygIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 42)];
    ygIcon.backgroundColor = [UIColor whiteColor];
    ygIcon.image = [UIImage imageNamed:@""];
    [label addSubview:ygIcon];
    
    UILabel * ygb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ygIcon.frame)+10, 11, 100, 20)];
    ygb.text = @"您的腰果币";
    ygb.textColor = TEXT_COLOR_LEVEL_3;
    ygb.font = TEXT_FONT_LEVEL_1;
    ygb.textAlignment = NSTextAlignmentLeft;
    [label addSubview:ygb];
    
    UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-90, 11, 80, 20)];
    number.text = @"1934颗";
    number.textColor = TEXT_COLOR_LEVEL_3;
    number.font = TEXT_FONT_LEVEL_1;
    number.textAlignment = NSTextAlignmentRight;
    [label addSubview:number];
    
    UILabel * gapLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), kScreenWidth, 10)];
    gapLabel.backgroundColor = BG_GRAY_COLOR;
    [headView addSubview:gapLabel];
    
    
}


#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 125;
    }
    if (indexPath.section == 1) {
        return 97;
    }
    return 125;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray * typeNames = @[@"丨 热门兑换", @"丨 果币活动"];
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    backView.backgroundColor = [UIColor whiteColor];
    for (UIView * subView in backView.subviews) {
        [subView removeFromSuperview];
    }
        
    
    UILabel * typeName = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 15)];
    typeName.textColor = TEXT_COLOR_LEVEL_4;
    typeName.font = TEXT_FONT_LEVEL_3;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:typeNames[section]];
    [attr addAttribute:NSForegroundColorAttributeName value:ORANGE_COLOR range:NSMakeRange(0, 2)];
    typeName.attributedText = attr;
    [backView addSubview:typeName];
    
    UILabel * lookMore = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-60-10, 15, 60, 15)];
    lookMore.text = @"查看更多 >";
    lookMore.textAlignment = NSTextAlignmentRight;
    lookMore.textColor = TEXT_COLOR_LEVEL_5;
    lookMore.font = TEXT_FONT_LEVEL_3;
    lookMore.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMore:)];
    [lookMore addGestureRecognizer:tap];
    [backView addSubview:lookMore];
    
    return  backView;
    
}
- (void)lookMore:(UITapGestureRecognizer *)tap{
    NSLog(@"查看更多");
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        LMYGBConvertCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[LMYGBConvertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        return cell;
    }
    if (indexPath.section == 1) {
        LMYGBActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"aCell"];
        if (!cell) {
            cell = [[LMYGBActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aCell"];
        }
        return cell;
    }
    return nil;
}

@end
