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
#import "LMNearbyLivingRequest.h"
#import "LMLivingVenueVO.h"

@interface LMSubmitSuccessController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LMSubmitSuccessController
{
    LMSubmitSuccessView * _headerView;
    
    NSArray * _dataArr;
}

- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self createUI];
    [self loadNewer];
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

#pragma mark - 请求就近生活馆数据
- (FitBaseRequest *)request{

    LMNearbyLivingRequest * request = [[LMNearbyLivingRequest alloc] initWithCity:_city];
    return request;
}
- (NSArray *)parseResponse:(NSString *)resp{
    NSData * respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary * respDic = [NSJSONSerialization JSONObjectWithData:respData
                                                             options:NSJSONReadingMutableLeaves
                                                               error:nil];
    NSDictionary * headDic = [respDic objectForKey:@"head"];
    if (![[headDic objectForKey:@"returnCode"] isEqualToString:@"000"]) {
        [self textStateHUD:@""];
        return nil;
    }
    NSDictionary * bodyDic = [VOUtil parseBody:resp];
    if (![[bodyDic objectForKey:@"result"] isEqualToString:@"0"]) {
        [self textStateHUD:@""];
        return nil;
    }
    NSArray * resultArr = [LMLivingVenueVO LMLivingVenueVOWithArray:bodyDic[@"list"]];
    _dataArr = resultArr;
    if (resultArr.count > 0) {
        return resultArr;
    }
    return nil;
}

#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listData.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    head.backgroundColor = [UIColor whiteColor];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 20)];
    title.textColor = TEXT_COLOR_LEVEL_3;
    title.font = TEXT_FONT_LEVEL_3;
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
    if (self.listData.count > indexPath.row) {
        LMLivingVenueVO * vo = self.listData[indexPath.row];
        [cell setVO:vo];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //进入生活馆
    
    
}
@end
