//
//  LMFindViewController.m
//  dirty
//
//  Created by Ding on 16/9/22.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMFindViewController.h"
#import "LMFindCell.h"
#import "WJLoopView.h"
#import "LMWebViewController.h"
#import "LMFindBannerRequest.h"

#import "LMFindListRequest.h"
#import "LMFindVO.h"
#import "UIImageView+WebCache.h"

#import "LMfindPraiseRequest.h"
#import "LMLessonViewController.h"
#import "LMSegmentViewController.h"

#define PAGER_SIZE      20

@interface LMFindViewController ()
<
WJLoopViewDelegate,
LMFindCellDelegate
>
{
    NSArray *imagearray;
    NSArray *titlearray;
    NSArray *contentarray;
    NSArray *imageURLs;
    
    NSMutableArray *cellDataArray;
    NSInteger        totalPage;
    NSInteger        currentPageIndex;
    NSMutableArray   *pageIndexArray;
    BOOL                reload;
    UIView *headView;
}

@end

@implementation LMFindViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![[FitUserManager sharedUserManager] isLogin]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"发现页需要对新功能进行投票，请登录"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction*action) {
                                                    
                                                    [[FitUserManager sharedUserManager] logout];
                                                    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
                                                    
                                                    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
                                                    
                                                    [self.navigationController popViewControllerAnimated:NO];
                                                    
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:FIT_LOGOUT_NOTIFICATION object:nil];
                                                    
                                                    
                                                    
                                                }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction*action) {
                                                    
                                                }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.listData.count == 0) {
        
        [self loadNoState];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cellDataArray=[NSMutableArray arrayWithCapacity:0];
    pageIndexArray=[NSMutableArray arrayWithCapacity:0];
    
    [self creatUI];
    [self loadNewer];
    
    imagearray = @[@"12.jpg",@"13.jpg",@"14.jpg"];
    titlearray = @[@"腰果 财富现金流养成记",@"腰果 语言课堂",@"腰果 商城"];
    contentarray = @[@"现金流：游戏升级打怪，财商创业思维和个人成长也需要升级，现实版的自我成长养成记，想一起来么。",@"语音课堂：想听倾心已久讲师的经典课程，邀约腰果生活，随时随地用声音传递生活。",@"商场：在商城找到帮助品质生活体验的优质商品，不用到处淘而耗费时间啦."];
}

- (void)creatUI
{
    [super createUI];
    
    self.tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 49, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    
    imageURLs =@[@"http://yaoguo.oss-cn-hangzhou.aliyuncs.com/9f8d96ce455e3ce4c168a1a087cfab44.jpg",@"http://yaoguo.oss-cn-hangzhou.aliyuncs.com/dba0b35d39f1513507f0bbac17e90d21.jpg",@"http://yaoguo.oss-cn-hangzhou.aliyuncs.com/c643d748dc1a7c128a8d052def67a92e.jpg",@"http://yaoguo.oss-cn-hangzhou.aliyuncs.com/24437ada0e0fec458a4d4b7bcd6d3b03.jpg"];
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)];
    headView.backgroundColor = BG_GRAY_COLOR;
    
    WJLoopView *loopView = [[WJLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)
                                                    delegate:self
                                                   imageURLs:imageURLs
                                            placeholderImage:nil
                                                timeInterval:8
                              currentPageIndicatorITintColor:nil
                                      pageIndicatorTintColor:nil];
    
    loopView.location = WJPageControlAlignmentRight;
    
    [headView addSubview:loopView];
    self.tableView.tableHeaderView = headView;
}

- (FitBaseRequest *)request
{
    LMFindListRequest    *request    = [[LMFindListRequest alloc] initWithPageIndex:self.current andPageSize:PAGER_SIZE];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSString    *result         = [bodyDic objectForKey:@"result"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        
        return [LMFindVO LMFindVOListWithArray:[bodyDic objectForKey:@"list"]];
        
    } else if (description && ![description isEqual:[NSNull null]] && [description isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:description waitUntilDone:NO];
    }
    
    return nil;
}

#pragma mark scrollview代理函数

- (void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index
{
    if (index == 3) {
        
        return;
    }
    
    NSArray *arr = @[@"『腰·美』",@"『腰·吃』",@"『腰·活』",@"『腰·乐』"];
    NSArray *urlRrray = @[@"http://yaoguo1818.com/living-web/mentor-introduce-beauty.html",
                          @"http://yaoguo1818.com/living-web/mentor-introduce-food.html",
                          @"http://yaoguo1818.com/living-web/mentor-introduce-health.html"];
    
    LMWebViewController *webView    = [[LMWebViewController alloc] init];
    
    webView.urlString       = urlRrray[index];
    webView.titleString     = arr[index];
    webView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:webView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h   = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (h) {
        
        return h;
    }
    
    return 175;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
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
        
        cell    = [[LMFindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.listData.count > indexPath.row) {
        
        LMFindVO     *vo = self.listData[indexPath.row];
        
        if (vo && [vo isKindOfClass:[LMFindVO class]]) {
            
            [(LMFindCell *)cell setValue:vo];
        }
    }
    
    cell.tag = indexPath.row;
    [(LMFindCell *)cell setDelegate:self];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listData&&self.listData.count>0) {
        NSLog(@"语言课堂");
        LMSegmentViewController *lessonVC = [[LMSegmentViewController alloc] init];
        lessonVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lessonVC animated:YES];
    }
}




- (void)cellWillClick:(LMFindCell *)cell
{
    if (self.listData.count > cell.tag) {
        
        LMFindVO *vo     = [self.listData objectAtIndex:cell.tag];
        
        if (vo && [vo isKindOfClass:[LMFindVO class]]) {
            
            [self praiseRequest:vo.findUuid];
        }
    }
}

#pragma mark

- (void)praiseRequest:(NSString *)uuid
{
    if ([[FitUserManager sharedUserManager] isLogin]) {
        if (![CheckUtils isLink]) {
            
            [self textStateHUD:@"无网络连接"];
            return;
        }
        
        LMfindPraiseRequest *request = [[LMfindPraiseRequest alloc] initWithPageFindUUID:uuid];
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(praiseDataResponse:)
                                                                          withObject:resp
                                                                       waitUntilDone:YES];
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"网络错误"
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];
        
    }else{
        
        [self IsLoginIn];
    }
}

- (void)praiseDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self textStateHUD:@"投票成功"];
        
         [self loadNoState];
        
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

@end
