//
//  DYHomePageController.m
//  dirty
//
//  Created by Ding on 16/8/23.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMHomePageController.h"
#import "LMActivityDetailController.h"
#import "LMHomeDetailController.h"
#import "LMBannerrequest.h"
#import "LMHomelistequest.h"
#import "UIView+frame.h"
#import "LMhomePageCell.h"

#import "LMActicleVO.h"

#import "WJLoopView.h"
//#import "FitUserManager.h"
#import "LMScanViewController.h"
#import "LMPublicArticleController.h"
#import "MJRefresh.h"
#import "LMWriterViewController.h"
#import "LMHomeDetailController.h"

#import "BannerVO.h"

#define PAGER_SIZE      20

@interface LMHomePageController ()
<
UITableViewDelegate,
UITableViewDataSource,
WJLoopViewDelegate,
LMhomePageCellDelegate
>
{
    UIView *headView;
    UIBarButtonItem *backItem;

    NSIndexPath *deleteIndexPath;
    
    NSInteger        totalPage;
    NSInteger        currentPageIndex;
    
    NSArray         *_bannerArray;
}

@end

@implementation LMHomePageController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNoState) name:@"reloadHomePage" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNoState) name:@"reloadlist" object:nil];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadNoState];
    [self getBannerDataRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"首页";
    
    [self creatUI];

    [self getBannerDataRequest];
    [self loadNewer];
}

- (void)creatUI
{
    [super createUI];
    
    self.tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 49, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)];
    headView.backgroundColor = BG_GRAY_COLOR;
    self.tableView.tableHeaderView = headView;
}

- (void)publicAction
{

    [LMPublicArticleController presentInViewController:self Animated:NO];
    
}

- (void)getBannerDataRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    LMBannerrequest *request = [[LMBannerrequest alloc] init];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {

                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   NSDictionary *bodyDict   = [VOUtil parseBody:resp];
                                                   
                                                   NSString     *result     = [bodyDict objectForKey:@"result"];
                                                   
                                                   if (result && ![result isEqual:[NSNull null]] && [result isEqualToString:@"0"]) {
                                                       
                                                       _bannerArray = [BannerVO BannerVOListWithArray:[bodyDict objectForKey:@"banners"]];
                                                   
                                                       if (!_bannerArray || ![_bannerArray isKindOfClass:[NSArray class]] || _bannerArray.count < 1) {
                                                           
                                                           headView.backgroundColor = BG_GRAY_COLOR;
                                                       } else {
                                                           
                                                           for (UIView *subView in headView.subviews) {
                                                               
                                                               [subView removeFromSuperview];
                                                           }
                                                           
                                                           NSMutableArray   *imgUrls    = [NSMutableArray new];
                                                           
                                                           for (BannerVO *vo in _bannerArray) {
                                                               
                                                               if (vo && [vo isKindOfClass:[BannerVO class]] && vo.LinkUrl) {
                                                                   
                                                                   [imgUrls addObject:vo.LinkUrl];
                                                               }
                                                            }
                                                           
                                                           WJLoopView *loopView = [[WJLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)
                                                                                                           delegate:self
                                                                                                          imageURLs:imgUrls
                                                                                                   placeholderImage:nil
                                                                                                       timeInterval:8
                                                                                     currentPageIndicatorITintColor:nil
                                                                                             pageIndicatorTintColor:nil];
                                                           
                                                           loopView.location = WJPageControlAlignmentRight;
                                                           
                                                           [headView addSubview:loopView];
                                                       }
                                                   }
                                               });
                                               
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取轮播图失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (FitBaseRequest *)request
{
    LMHomelistequest    *request    = [[LMHomelistequest alloc] initWithPageIndex:self.current andPageSize:PAGER_SIZE];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSString    *result         = [bodyDic objectForKey:@"result"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        if ([[FitUserManager sharedUserManager].franchisee isEqual:@"yes"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publicIcon"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(publicAction)];
                
                self.navigationItem.rightBarButtonItem = rightItem;
            });
        }
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        
        return [LMActicleVO LMActicleVOListWithArray:[bodyDic objectForKey:@"list"]];
        
    } else if (description && ![description isEqual:[NSNull null]] && [description isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:description waitUntilDone:NO];
    }
    
    return nil;
}

#pragma mark scrollview代理函数

- (void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index
{
//    if ([stateArray[index] isEqualToString:@"event"]) {
//        LMActivityDetailController *eventVC = [[LMActivityDetailController alloc] init];
//        eventVC.hidesBottomBarWhenPushed = YES;
//        eventVC.eventUuid = eventArray[index];
//        [self.navigationController pushViewController:eventVC animated:YES];
//    }else{
//        LMHomeDetailController *eventVC = [[LMHomeDetailController alloc] init];
//        eventVC.hidesBottomBarWhenPushed = YES;
//        eventVC.artcleuuid = eventArray[index];
//        [self.navigationController pushViewController:eventVC animated:YES];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h   = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (h) {
        
        return h;
    }
    
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
  
    UITableViewCell *cell   = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        
        return cell;
    }
    
    cell    = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell    = [[LMhomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.listData.count > indexPath.row) {
        
        LMActicleVO     *vo = self.listData[indexPath.row];
        
        if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
            
            [(LMhomePageCell *)cell setValue:vo];
        }
    }
    
    cell.tag = indexPath.row;
    [(LMhomePageCell *)cell setDelegate:self];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listData.count > indexPath.row) {
        
        LMActicleVO *vo     = [self.listData objectAtIndex:indexPath.row];
    
        if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
            
            LMHomeDetailController *detailVC = [[LMHomeDetailController alloc] init];
            
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.artcleuuid = vo.articleUuid;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark  --cell click delegat

- (void)cellWillClick:(LMhomePageCell *)cell
{
    if (self.listData.count > cell.tag) {
        
        LMActicleVO *vo     = [self.listData objectAtIndex:cell.tag];
        
        if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
            
            LMWriterViewController *writerVC = [[LMWriterViewController alloc] initWithUUid:vo.userUuid];
            writerVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:writerVC animated:YES];
        }
    }
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
