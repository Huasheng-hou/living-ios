//
//  LMTypeListViewController.m
//  living
//
//  Created by Ding on 2016/12/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMTypeListViewController.h"
#import "LMArtcleTypeRequest.h"

@interface LMTypeListViewController ()

@end

@implementation LMTypeListViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        //        self.ifRemoveLoadNoState        = NO;
//        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.listData.count == 0) {
        
        [self loadNoState];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadNewer];
}

-(void)createUI
{
    
    [super createUI];
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (FitBaseRequest *)request
{
    LMArtcleTypeRequest *request = [[LMArtcleTypeRequest alloc] init];
    
    return request;
}


- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSString    *result         = [bodyDic objectForKey:@"result"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        NSArray *resultArr  = [bodyDic objectForKey:@"list"];
        if (resultArr && resultArr.count > 0) {
            
            return resultArr;
        }
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellIdd = @"cellIdd";
    UITableViewCell *cell   = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        
        return cell;
    }
    
    cell    = [tableView dequeueReusableCellWithIdentifier:cellIdd];
    
    if (!cell) {
        
        cell    = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdd];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.listData.count > indexPath.row) {
        
        NSDictionary *dic = self.listData[indexPath.row];
        cell.textLabel.text = dic[@"type"];
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listData.count > indexPath.row) {
        
    NSDictionary *dic = self.listData[indexPath.row];
    
    [self.delegate backLiveName:dic[@"type"]];
    
    [self.navigationController popViewControllerAnimated:YES];


    }

}




@end
