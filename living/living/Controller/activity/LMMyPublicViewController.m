//
//  LMMyPublicViewController.m
//  living
//
//  Created by Ding on 2016/11/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyPublicViewController.h"
#import "LMActivityDetailController.h"
#import "LMEventDetailViewController.h"
#import "LMMemberListViewController.h"
#import "LMCreaterListRequest.h"
#import "ActivityListVO.h"
#import "LMMypublicEventCell.h"
#import "LMEventStartRequest.h"
#import "LMEventEndRequest.h"
#import "LMActivityDeleteRequest.h"

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

#pragma mark - 请求我的活动列表
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

#pragma mark - tableView代理方法
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
    cell    = [[LMMypublicEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self.listData.count > indexPath.row) {
        
        ActivityListVO  *vo = [self.listData objectAtIndex:indexPath.row];    
        if (vo && [vo isKindOfClass:[ActivityListVO class]]) {
            
            [(LMMypublicEventCell *)cell setActivityList:vo] ;
        
        }
    }
    [(LMMypublicEventCell *)cell setDelegate:self];
    [(LMMypublicEventCell *)cell setTag:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listData.count > indexPath.row) {
        
        ActivityListVO  *vo = [self.listData objectAtIndex:indexPath.row];
        
        if (vo && [vo isKindOfClass:[ActivityListVO class]]) {
            if ([vo.type isEqualToString:@"event"]) {
                LMActivityDetailController *detailVC = [[LMActivityDetailController alloc] init];
                
                detailVC.hidesBottomBarWhenPushed = YES;
                int payNum = [vo.status intValue];
                switch (payNum) {
                    case 1:
                        detailVC.type = @"正报名";
                        
                        break;
                    case 2:
                        detailVC.type = @"正报名";
                        
                        break;
                    case 3:
                        detailVC.type = @"已开始";
                        
                        break;
                    case 4:
                        detailVC.type = @"已结束";
                        
                        break;
                    case 5:
                        detailVC.type = @"已结束";
                        
                        break;
                        
                    default:
                        break;
                }
                detailVC.eventUuid  = vo.eventUuid;
                detailVC.titleStr   = vo.eventName;
                
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            if ([vo.type isEqualToString:@"item"]) {
                LMEventDetailViewController *detailVC = [[LMEventDetailViewController alloc] init];
                
                detailVC.hidesBottomBarWhenPushed = YES;
                int payNum = [vo.status intValue];
                switch (payNum) {
                    case 1:
                        detailVC.type = @"正报名";
                        
                        break;
                    case 2:
                        detailVC.type = @"正报名";
                        
                        break;
                    case 3:
                        detailVC.type = @"已开始";
                        
                        break;
                    case 4:
                        detailVC.type = @"已结束";
                        
                        break;
                    case 5:
                        detailVC.type = @"已结束";
                        
                        break;
                        
                    default:
                        break;
                }
                detailVC.eventUuid  = vo.eventUuid;
                detailVC.titleStr   = vo.eventName;
                
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            
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
    ActivityListVO *vo =[self.listData objectAtIndex:cell.tag];
    LMMemberListViewController *memberVC = [[LMMemberListViewController alloc] init];
    memberVC.eventUuid = vo.eventUuid;
    
    [self.navigationController pushViewController:memberVC animated:YES];
    
}

#pragma mark  - -开始活动
-(void)cellWillbegin:(LMMypublicEventCell *)cell
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    ActivityListVO *vo =[self.listData objectAtIndex:cell.tag];
    LMEventStartRequest *request = [[LMEventStartRequest alloc] initWithEvent_uuid:vo.eventUuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getstartEventResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

-(void)getstartEventResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"活动开启失败请重试"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"活动开启成功"];
            
            [self loadNoState];
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

#pragma mark   - -结束活动

- (void)cellWillfinish:(LMMypublicEventCell *)cell
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    ActivityListVO *vo =[self.listData objectAtIndex:cell.tag];

    
    LMEventEndRequest *request = [[LMEventEndRequest alloc] initWithEvent_uuid:vo.eventUuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getendEventResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getendEventResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"活动结束失败请重试"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"活动结束成功"];
            
            [self loadNoState];
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

#pragma mark - 删除活动  LMActivityDeleteRequest

- (void)cellWilldelete:(LMMypublicEventCell *)cell
{
    ActivityListVO *vo =[self.listData objectAtIndex:cell.tag];
    NSString *uuid = vo.eventUuid;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"是否删除"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                [self deleteActivityRequest:uuid];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteActivityRequest:(NSString *)_eventUuid
{
    LMActivityDeleteRequest *request = [[LMActivityDeleteRequest alloc] initWithEvent_uuid:_eventUuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(deleteActivityResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

- (void)deleteActivityResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self textStateHUD:@"删除成功"];
        [self loadNoState];
        
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}




@end
