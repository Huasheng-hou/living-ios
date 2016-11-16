//
//  LMMyPublicViewController.m
//  living
//
//  Created by Ding on 2016/11/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyPublicViewController.h"
#import "LMActivityDetailController.h"
#import "LMMemberListViewController.h"
#import "LMCreaterListRequest.h"
#import "ActivityListVO.h"
#import "LMMypublicEventCell.h"

#define PAGER_SIZE      20
@interface LMMyPublicViewController ()<
LMMypublicEventCellDelegate
>

@end

@implementation LMMyPublicViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"我的活动";
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
    
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (FitBaseRequest *)request
{
    LMCreaterListRequest   *request    = [[LMCreaterListRequest alloc] initWithPageIndex:self.current andPageSize:PAGER_SIZE];
    
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
    
    return 165;
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
        
        cell = [[LMMypublicEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (self.listData.count > indexPath.row) {
        
        ActivityListVO  *vo = [self.listData objectAtIndex:indexPath.row];
       
        
        if (vo && [vo isKindOfClass:[ActivityListVO class]]) {
            
            [(LMMypublicEventCell *)cell setActivityList:vo] ;
        
        }
    }
    [(LMMypublicEventCell *)cell setDelegate:self];
    [(LMMypublicEventCell *)cell setXScale:self.xScale yScale:self.yScaleWithAll];
    
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

- (void)cellWillclick:(LMMypublicEventCell *)cell
{
    LMMemberListViewController *memberVC = [[LMMemberListViewController alloc] init];
    
    [self.navigationController pushViewController:memberVC animated:YES];
    
}




@end
