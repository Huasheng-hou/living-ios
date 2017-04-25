//
//  LMMoreClassController.m
//  living
//
//  Created by hxm on 2017/3/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMMoreClassController.h"
#import "LMMoreVoicesVO.h"
#import "LMHomeVoiceDetailController.h"
#import "LMExpertHotArticleCell.h"
#import "LMExpertVoicesRequest.h"
#import "LMClassroomDetailViewController.h"
@interface LMMoreClassController ()

@end

@implementation LMMoreClassController

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
    self.navigationItem.title = @"课程";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
#pragma mark - 请求文章
- (FitBaseRequest *)request{
    LMExpertVoicesRequest * request = [[LMExpertVoicesRequest alloc] initWithPageIndex:self.current andPageSize:20 andUserUuid:self.userUuid];
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
    NSArray * listArr = [LMMoreVoicesVO LMMoreVoicesVOWithArray:bodyDic[@"list"]];
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
    LMExpertHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"voiceCell"];
    if (!cell) {
        cell = [[LMExpertHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"voiceCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listData.count > indexPath.row) {
        LMMoreVoicesVO * vo = self.listData[indexPath.row];
        [cell setVO:vo];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.listData.count > indexPath.row) {
        LMMoreVoicesVO * vo = self.listData[indexPath.row];
        LMClassroomDetailViewController * detailVC = [[LMClassroomDetailViewController alloc] init];
        detailVC.voiceUUid = vo.voiceUuid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    
}

@end
