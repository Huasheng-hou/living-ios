//
//  LMYGBDetailController.m
//  living
//
//  Created by hxm on 2017/3/21.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYGBDetailController.h"
#import "FitConsts.h"
#import "LMYGBDetailRequest.h"
#import "LMYGBDetailVO.h"
#import "LMYGBDetailCell.h"


@interface LMYGBDetailController ()

@end

@implementation LMYGBDetailController

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
    self.navigationItem.title = @"果币收支明细";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BG_GRAY_COLOR;
    
}
#pragma mark - 请求腰果币明细数据
- (FitBaseRequest *)request{
    
    LMYGBDetailRequest * request = [[LMYGBDetailRequest alloc] initWithPageIndex:self.current andPageSize:20];
    
    return request;
}
- (NSArray *)parseResponse:(NSString *)resp{
    
    NSData * respData = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * headDict = [respDict objectForKey:@"head"];
    if (![[headDict objectForKey:@"returnCode"] isEqualToString:@"000"]) {
        [self textStateHUD:@"请求失败"];
        return nil;
    }
    NSDictionary * bodyDict = [VOUtil parseBody:resp];
    if ([bodyDict[@"result"] isEqualToString:@"0"]) {
        
        
        NSArray * resultArr = [LMYGBDetailVO LMYGBDetailVOListWithArray:bodyDict[@"list"]];
        if (resultArr && resultArr.count > 0) {
            return resultArr;
        }
        
    }
    return nil;
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.listData.count > 0) {
        return self.listData.count;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LMYGBDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LMYGBDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listData.count > indexPath.row) {
        LMYGBDetailVO * vo = self.listData[indexPath.row];
        [cell setValue:vo];
    }
    return cell;
}

@end
