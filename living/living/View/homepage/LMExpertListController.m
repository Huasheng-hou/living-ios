//
//  LMExpertListController.m
//  living
//
//  Created by hxm on 2017/3/10.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertListController.h"
#import "LMAllExpertListCell.h"
#import "LMExpertDetailController.h"
#import "LMHomelistequest.h"
#import "LMExpertListRequest.h"
#import "LMExpertListVO.h"


#define PAGE_SIZE 20
@interface LMExpertListController ()

@end

@implementation LMExpertListController

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
}
#pragma mark - 网络请求
- (FitBaseRequest *)request{
    
    LMExpertListRequest * request = [[LMExpertListRequest alloc] initWithPageIndex:1 andPageSize:PAGE_SIZE andCategory:_category];
    return request;

}
- (NSArray *)parseResponse:(NSString *)resp{
    
    NSData * data = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * headDic = [dic objectForKey:@"head"];
    if (![headDic[@"returnCode"] isEqualToString:@"000"]) {
        return nil;
    }
    NSDictionary * body = [VOUtil parseBody:resp];
    if (![body[@"result"] isEqualToString:@"0"]) {
        return nil;
    }
    NSArray * listArr = [body objectForKey:@"list"];
    NSArray * resultArr = [LMExpertListVO LMExpertListVOListWithArray:listArr];
    if (resultArr.count == 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:@"后台没数据"];
        });
    }
    return resultArr;
}

#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.listData.count > 0) {
        return self.listData.count;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LMAllExpertListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LMAllExpertListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listData.count > indexPath.row) {
        LMExpertListVO * vo = self.listData[indexPath.row];
        if (vo) {
            [cell setCellWithVO:vo];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LMExpertDetailController * vc = [[LMExpertDetailController alloc] init];
    vc.title = @"李莺莺的空间";
    if (self.listData.count > indexPath.row) {
        LMExpertListVO * vo = self.listData[indexPath.row];
        vc.userUuid = vo.userUuid;
        vc.title = [NSString stringWithFormat:@"%@的空间", vo.nickName];
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
