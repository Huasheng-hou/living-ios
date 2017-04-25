//
//  LMMoreEventsController.m
//  living
//
//  Created by hxm on 2017/3/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMMoreEventsController.h"
#import "LMExpertEventsRequest.h"
#import "LMMoreEventsVO.h"
#import "LMExpertHotArticleCell.h"
#import "LMEventDetailViewController.h"
#import "LMActivityDetailController.h"
@interface LMMoreEventsController ()

@end

@implementation LMMoreEventsController
- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self loadNewer];
}

- (void)createUI{
    [super createUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"活动";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
#pragma mark - 请求文章
- (FitBaseRequest *)request{
    LMExpertEventsRequest * request = [[LMExpertEventsRequest alloc] initWithPageIndex:self.current andPageSize:20 andUserUuid:self.userUuid];
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp{
    
    NSData * respData = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * respDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * headDic = [respDic objectForKey:@"head"];
    if (![headDic[@"returnCode"] isEqualToString:@"000"]) {
        return nil;
    }
    
    NSDictionary * bodyDic = [VOUtil parseBody:resp];
    if (![bodyDic[@"result"] isEqualToString:@"0"]) {
        return nil;
    }
    NSArray * listArr = [LMMoreEventsVO LMMoreEventsVOListWithArray:bodyDic[@"list"]];
    if (listArr.count > 0) {
        return listArr;
    }
    return nil;
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LMExpertHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    if (!cell) {
        cell = [[LMExpertHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listData.count > indexPath.row) {
        LMMoreEventsVO * vo = self.listData[indexPath.row];
        [cell setVO:vo];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.listData.count > indexPath.row) {
        LMMoreEventsVO * vo = self.listData[indexPath.row];
        if (vo.type && [vo.type isEqualToString:@"event"]) {
            LMActivityDetailController * detailVC = [[LMActivityDetailController alloc] init];
            detailVC.eventUuid = vo.eventUuid;
            detailVC.titleStr = vo.eventName;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        if (vo.type && [vo.type isEqualToString:@"item"]) {
            LMEventDetailViewController * detailVC = [[LMEventDetailViewController alloc] init];
            detailVC.eventUuid = vo.eventUuid;
            detailVC.titleStr = vo.eventName;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

@end
