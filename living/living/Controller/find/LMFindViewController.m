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
#import "LMFindDataModels.h"

#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "LMfindPraiseRequest.h"

@interface LMFindViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
WJLoopViewDelegate
>
{
    UITableView *_tableView;
    NSArray *imagearray;
    NSArray *titlearray;
    NSArray *contentarray;
    NSArray *imageURLs;
    
    NSMutableArray *cellDataArray;
    NSInteger        totalPage;
    NSInteger        currentPageIndex;
    NSMutableArray   *pageIndexArray;
    BOOL                reload;
    
}

@end

@implementation LMFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cellDataArray=[NSMutableArray arrayWithCapacity:0];
    pageIndexArray=[NSMutableArray arrayWithCapacity:0];
    
    [self creatUI];
    
    [self getFindDataRequest:1];
    
    imagearray = @[@"12.jpg",@"13.jpg",@"14.jpg"];
    titlearray = @[@"腰果 财富现金流养成记",@"腰果 语言课堂",@"腰果 商城"];
    contentarray = @[@"现金流：游戏升级打怪，财商创业思维和个人成长也需要升级，现实版的自我成长养成记，想一起来么。",@"语音课堂：想听倾心已久讲师的经典课程，邀约腰果生活，随时随地用声音传递生活。",@"商场：在商城找到帮助品质生活体验的优质商品，不用到处淘而耗费时间啦."];

    imageURLs =@[@"http://yaoguo.oss-cn-hangzhou.aliyuncs.com/9f8d96ce455e3ce4c168a1a087cfab44.jpg",@"http://yaoguo.oss-cn-hangzhou.aliyuncs.com/dba0b35d39f1513507f0bbac17e90d21.jpg",@"http://yaoguo.oss-cn-hangzhou.aliyuncs.com/c643d748dc1a7c128a8d052def67a92e.jpg",@"http://yaoguo.oss-cn-hangzhou.aliyuncs.com/24437ada0e0fec458a4d4b7bcd6d3b03.jpg"];
    
    
    
}

-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupRefresh];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)];
    
    WJLoopView *loopView = [[WJLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5) delegate:self imageURLs:imageURLs placeholderImage:nil timeInterval:3 currentPageIndicatorITintColor:nil pageIndicatorTintColor:nil];
    loopView.location = WJPageControlAlignmentRight;
    [headView addSubview:loopView];
    return headView;
}

#pragma mark scrollview代理函数
- (void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index
{
    NSLog(@"************");
    
    if (index==3) {
        return;
    }
    
    NSArray *arr = @[@"『腰·美』",@"『腰·吃』",@"『腰·活』",@"『腰·乐』"];
    NSArray *urlRrray = @[@"http://120.27.147.167/living-web/apparticle/daoshi3",@"http://120.27.147.167/living-web/apparticle/daoshi2",@"http://120.27.147.167/living-web/apparticle/daoshi1"];
    
    LMWebViewController *webView = [[LMWebViewController alloc] init];
    webView.urlString = urlRrray[index];
    webView.titleString = arr[index];
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kScreenWidth*3/5;
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
    return cellDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    LMFindCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[LMFindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
    LMFindList *list=cellDataArray[indexPath.row];
    
    cell.titleLabel.text=list.title;
    cell.contentLabel.text=list.descrition;
    cell.numLabel.text=[NSString stringWithFormat:@"%.0f",list.numberOfVotes];
    
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString:list.images]];
    
    
    [cell.praiseBt addTarget:self action:@selector(praiseBtton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.praiseBt setTag:indexPath.row];
    
    if (list.hasPraised==0) {
       
        [cell.thumbIV setImage:[UIImage imageNamed:@"zanIcon"]];
    }else{
        
        [cell.thumbIV setImage:[UIImage imageNamed:@"zanIcon-click"]];
    }
    
    return cell;
}

- (void)praiseBtton:(UIButton *)button{
    
    NSInteger row=button.tag;
    LMFindList *list=cellDataArray[row];
    
    [self praiseRequest:list.findUuid];
}

#pragma mark 刷新加载部分

- (void)setupRefresh
{
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.headerPullToRefreshText = @"下拉可以刷新";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新";
    _tableView.headerRefreshingText = @"正在帮你刷新...";
    
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    _tableView.footerRefreshingText = @"正在帮你加载...";
}

#pragma mark 重新请求单元格数据（通知  投票）

-(void)reloadCellData
{
    reload=YES;
   [self getFindDataRequest:1];
}


#pragma mark 开始进入刷新状态

- (void)headerRereshing{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self reloadCellData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    currentPageIndex=cellDataArray.count/20+1;
    
    if (currentPageIndex>=totalPage) {
        [_tableView footerEndRefreshing];
        [self textStateHUD:@"没有内容了"];
        return;
    }
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (cellDataArray.count>0) {
           [self getFindDataRequest:currentPageIndex];
            NSLog(@"=============当前请求的页数=%ld",(long)currentPageIndex);
        }
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}

#pragma mark 数据列表

-(void)getFindDataRequest:(NSInteger)page
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    LMFindListRequest *request = [[LMFindListRequest alloc] initWithPageIndex:page andPageSize:20];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(findDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取数据失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

-(void)findDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSLog(@"============发现数据请求结果===========%@",bodyDic);
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        if (reload) {
            reload=NO;
            pageIndexArray=[NSMutableArray arrayWithCapacity:0];
            currentPageIndex=1;
            cellDataArray=[NSMutableArray arrayWithCapacity:0];
        }
        
        if (![pageIndexArray containsObject:@(currentPageIndex)]) {
            [pageIndexArray addObject:@(currentPageIndex)];
        }else{
            NSLog(@"数组中有该数据");
            return;
        }

        LMFindBody *bodyData=[[LMFindBody alloc]initWithDictionary:bodyDic];
        
        totalPage=bodyData.total;
        
        NSArray *array=bodyData.list;
        
        for (int i=0; i<array.count; i++) {
            LMFindList *list=array[i];
            [cellDataArray addObject:list];
        }
        
        [_tableView reloadData];
        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

#pragma mark

-(void)praiseRequest:(NSString *)uuid
{
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
                                                                      withObject:@"投票失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

-(void)praiseDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSLog(@"============点赞数据请求结果===========%@",bodyDic);
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self textStateHUD:@"投票成功"];
        
         [self reloadCellData];
        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}


@end
