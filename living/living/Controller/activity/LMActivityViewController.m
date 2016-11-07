//
//  LMActivityViewController.m
//  dirty
//
//  Created by Ding on 16/9/22.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMActivityViewController.h"
#import "LMActivityDetailController.h"

#import "LMPublishViewController.h"
#import "LMActivityListRequest.h"
#import "LMActivityCell.h"

#import "LMActivityDeleteRequest.h"

#import "ActivityListVO.h"

#define PAGER_SIZE      20

@interface LMActivityViewController ()
{
    UIBarButtonItem *backItem;
    UIImageView *homeImage;
    
    BOOL ifRefresh;
    int total;
    
    NSIndexPath *deleteIndexPath;
    
    NSInteger        totalPage;
    NSInteger        currentPageIndex;
    NSMutableArray   *pageIndexArray;
    BOOL                reload;
}

@end

@implementation LMActivityViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatUI];

    [self loadNewer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadNoState];
}

- (void)creatUI
{
    [super createUI];
    
    NSLog(@"[FitUserManager sharedUserManager].privileges:%@",[FitUserManager sharedUserManager].privileges);
    
    if ([[FitUserManager sharedUserManager].privileges isEqual:@"special"]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publicIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(publicAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 49, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 49, 0);
}

#pragma mark 发布活动

- (void)publicAction
{
    LMPublishViewController *publicVC = [[LMPublishViewController alloc] init];
    [publicVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:publicVC animated:YES];
    
    NSLog(@"********发布活动");
}

- (FitBaseRequest *)request
{
    LMActivityListRequest   *request    = [[LMActivityListRequest alloc] initWithPageIndex:self.current andPageSize:PAGER_SIZE];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    NSString        *result     = [bodyDict objectForKey:@"result"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        self.max    = [[bodyDict objectForKey:@"total"] intValue];
        
        NSArray *resultArr  = [ActivityListVO ActivityListVOListWithArray:[bodyDict objectForKey:@"list"]];
        
        if (resultArr && resultArr.count > 0) {
            
            return resultArr;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h   = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (h) {
        
        return h;
    }
    
    return 210;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    
    UITableViewCell     *cell;
    
    cell    = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        
        return cell;
    }
    
    cell    = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell = [[LMActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.listData.count > indexPath.row) {
        
        ActivityListVO  *vo = [self.listData objectAtIndex:indexPath.row];
        
        if (vo && [vo isKindOfClass:[ActivityListVO class]]) {
            
            [(LMActivityCell *)cell setActivityList:vo];
        }
    }
    
    [(LMActivityCell *)cell setXScale:self.xScale yScale:self.yScaleWithAll];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listData.count > indexPath.row) {
        
        ActivityListVO  *vo = [self.listData objectAtIndex:indexPath.row];
        
        if (vo && [vo isKindOfClass:[ActivityListVO class]]) {
            
            LMActivityDetailController *detailVC = [[LMActivityDetailController alloc] init];
            
            detailVC.hidesBottomBarWhenPushed = YES;
            
            detailVC.eventUuid  = vo.EventUuid;
            detailVC.titleStr   = vo.EventName;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (fabs(self.tableView.contentSize.height - (self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.frame) - 49)) < 44.0
        && self.statefulState == FitStatefulTableViewControllerStateIdle
        && [self canLoadMore]) {
        [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
    }
}

@end
