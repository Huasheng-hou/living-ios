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
#import "LMActicleList.h"
#import "WJLoopView.h"
#import "FitUserManager.h"
#import "LMScanViewController.h"
#import "LMPublicArticleController.h"
#import "MJRefresh.h"
#import "LMWriterViewController.h"
#import "LMHomeDetailController.h"



@interface LMHomePageController ()<UITableViewDelegate,
UITableViewDataSource,
WJLoopViewDelegate,
LMhomePageCellDelegate
>
{
    UIView *headView;
    
    UIBarButtonItem *backItem;
    NSMutableArray *imageUrls;
    NSMutableArray *listArray;
    NSMutableArray *eventArray;
    UIImageView *homeImage;
    BOOL ifRefresh;
    int total;
    
    NSMutableArray *stateArray;
    
    NSIndexPath *deleteIndexPath;
    
    NSInteger        totalPage;
    NSInteger        currentPageIndex;
    NSMutableArray   *pageIndexArray;
    BOOL                reload;
    
    
}

@end

@implementation LMHomePageController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"reloadHomePage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"reloadlist" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    pageIndexArray=[NSMutableArray arrayWithCapacity:0];
    
    stateArray=[NSMutableArray arrayWithCapacity:0];
    
    [self creatUI];
    ifRefresh = YES;
    imageUrls = [NSMutableArray new];
    listArray = [NSMutableArray new];
    eventArray = [NSMutableArray new];
    [self getBannerDataRequest];
}



-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //去分割线
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)];
    headView.backgroundColor = BG_GRAY_COLOR;
    _tableView.tableHeaderView = headView;
    
    homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, kScreenWidth*3/5+40, 200, 130)];
    
    UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(115, 10, 70, 91)];
    homeImg.image = [UIImage imageNamed:@"NO-article"];
    [homeImage addSubview:homeImg];
    UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 111, 200, 60)];
    imageLb.numberOfLines = 0;
    imageLb.text = @"暂无文章,点击右上角按钮，赶紧发布吧！";
    imageLb.textColor = TEXT_COLOR_LEVEL_3;
    imageLb.textAlignment = NSTextAlignmentCenter;
    [homeImage addSubview:imageLb];
    homeImage.hidden = YES;
    [_tableView addSubview:homeImage];
    
    [self setupRefresh];

    
}

-(void)sweepAction
{
    NSLog(@"********发布");
    
    LMPublicArticleController *scanVC = [[LMPublicArticleController alloc] init];
    
    [scanVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //tableView刚出现时，进行刷新操作
    [self.tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.tableView.headerRefreshingText = @"正在帮你刷新...";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    self.tableView.footerRefreshingText = @"正在帮你加载...";
}

#pragma mark 重新请求单元格数据（通知  投票）

-(void)reloadCellData
{
    reload=YES;
    [self getHomeDataRequest:1];
}

- (void)headerRereshing
{
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
<<<<<<< HEAD
        [self reloadCellData];
         [self.tableView headerEndRefreshing];
=======
        listArray = [NSMutableArray new];
        ifRefresh = YES;
        self.current=1;
        [self getHomeDataRequest:self.current];
        ifRefresh=YES;
        [self.tableView headerEndRefreshing];
        
>>>>>>> c49534e5fc1c54ca80ba8397c5a6cad40e686f06
    });
}


- (void)footerRereshing
{
    currentPageIndex=listArray.count/20+1;
    
    if (currentPageIndex>=totalPage) {
        [self.tableView footerEndRefreshing];
        [self textStateHUD:@"没有文章了"];
        return;
    }
    
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (listArray.count>0) {
            [self getHomeDataRequest:currentPageIndex];
            NSLog(@"=============当前请求的页数=%ld",(long)currentPageIndex);
        }        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}

-(void)getBannerDataRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    
    LMBannerrequest *request = [[LMBannerrequest alloc] init];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getBannerResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取轮播图失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

-(void)getBannerResponse:(NSString *)resp
{
   
    
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
//       NSLog(@"===========轮播图=bodyDic===============%@",bodyDic);
      
//        return;
        NSMutableArray *array = [NSMutableArray new];
        array = bodyDic[@"banners"];
        for (NSDictionary *dic in array) {

            
            NSString *url = dic[@"linkUrl"];
            if (![url isEqual:@""]&&url) {
                [imageUrls addObject:url];
            }
            
            
            NSString *event = dic[@"event_uuid"];
            if (![event isEqual:@""]&&event) {
                [eventArray addObject:event];
            }else{
                [eventArray addObject:@""];
            }

            
            NSString *state = dic[@"type"];
            if (![state isEqual:@""]&&state) {
                [stateArray addObject:state];
            }else{
                [stateArray addObject:@""];
            }

            [stateArray addObject:state];
        }
        if (imageUrls.count==0) {
            headView.backgroundColor = BG_GRAY_COLOR;
        }else{
            WJLoopView *loopView = [[WJLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5) delegate:self imageURLs:imageUrls placeholderImage:nil timeInterval:2 currentPageIndicatorITintColor:nil pageIndicatorTintColor:nil];
            loopView.location = WJPageControlAlignmentRight;
            
            
            [headView addSubview:loopView];
        }
        [_tableView reloadData];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

-(void)getHomeDataRequest:(NSInteger)page
{
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LMHomelistequest *request = [[LMHomelistequest alloc] initWithPageIndex:page andPageSize:20];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getHomeDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取列表失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

-(void)getHomeDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
   
    
    NSLog(@"============首页数据请求结果===========%@",bodyDic);
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
<<<<<<< HEAD
       
=======
//        NSLog(@"%@",bodyDic);
//        if (listArray.count>0) {
//           [listArray removeAllObjects];
//        }
        
        if ([[FitUserManager sharedUserManager].franchisee isEqual:@"yes"]) {
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publicIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(sweepAction)];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
        
        NSLog(@"%@",bodyDic);

     
        NSMutableArray *array=bodyDic[@"list"];
        for (int i=0; i<array.count; i++) {

        }
>>>>>>> c49534e5fc1c54ca80ba8397c5a6cad40e686f06
        
         totalPage = [[bodyDic objectForKey:@"total"] integerValue];
        
        if (reload) {
            reload=NO;
            pageIndexArray=[NSMutableArray arrayWithCapacity:0];
            currentPageIndex=1;
            listArray=[NSMutableArray arrayWithCapacity:0];
        }
        
        if (![pageIndexArray containsObject:@(currentPageIndex)]) {
            [pageIndexArray addObject:@(currentPageIndex)];
        }else{
            NSLog(@"数组中有该数据");
            return;
        }
        
        NSArray *array = bodyDic[@"list"];
        
        for (int i=0; i<array.count; i++) {
             LMActicleList *list=[[LMActicleList alloc]initWithDictionary:array[i]];
            [listArray addObject:list];
        }
        
        if (listArray.count!=0) {
            [homeImage removeFromSuperview];
        }else{
            homeImage.hidden = NO;
        }
        
        [_tableView reloadData];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}


#pragma mark scrollview代理函数
- (void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    LMhomePageCell *cell = [[LMhomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LMActicleList *list = [listArray objectAtIndex:indexPath.row];
    [cell setValue:list];
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LMActicleList *list = [listArray objectAtIndex:indexPath.row];
    LMHomeDetailController *detailVC = [[LMHomeDetailController alloc] init];
    detailVC.artcleuuid = list.articleUuid;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


#pragma mark  --cell click delegat

-(void)cellWillClick:(LMhomePageCell *)cell
{
    LMActicleList *list = [listArray objectAtIndex:cell.tag];
    
    NSLog(@"文章作者点击");
    LMWriterViewController *writerVC = [[LMWriterViewController alloc] init];
    writerVC.hidesBottomBarWhenPushed = YES;
    writerVC.writerUUid = list.userUuid;
    [self.navigationController pushViewController:writerVC animated:YES];
    
    
}




@end
