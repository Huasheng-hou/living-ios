//
//  LMMoreArticlesController.m
//  living
//
//  Created by hxm on 2017/3/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMMoreArticlesController.h"
#import "LMNewHotArticleCell.h"
#import "LMExpertArticlesRequest.h"
#import "LMHomeDetailController.h"
@interface LMMoreArticlesController ()

@end

@implementation LMMoreArticlesController
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
    self.navigationItem.title = @"文章";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
#pragma mark - 请求文章
- (FitBaseRequest *)request{
    LMExpertArticlesRequest * request = [[LMExpertArticlesRequest alloc] initWithPageIndex:self.current andPageSize:20 andUserUuid:self.userUuid];
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
    NSArray * listArr = [LMMoreArticlesVO LMMoreArticlesVOListWithArray:bodyDic[@"list"]];
    if (listArr.count > 0) {
        return listArr;
    }
    return nil;
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.listData.count > 0) {
        return self.listData.count;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LMNewHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotArticleCell"];
    if (!cell) {
        cell = [[LMNewHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ArticleCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listData.count > indexPath.row) {
        LMMoreArticlesVO * vo = self.listData[indexPath.row];
        [cell setVO:vo];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.listData.count > indexPath.row) {
        LMMoreArticlesVO * vo = self.listData[indexPath.row];
        LMHomeDetailController * detailVC = [[LMHomeDetailController alloc] init];
        detailVC.artcleuuid = vo.articleUuid;
        detailVC.title = vo.articleTitle;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    
}



@end
