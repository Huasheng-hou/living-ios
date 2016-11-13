//
//  LMMyFriendViewController.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyFriendViewController.h"
#import "LMFriendListRequest.h"
#import "LMFriendCell.h"
#import "LMScanViewController.h"
#import "MJRefresh.h"
#import "LMFriendVO.h"

@interface LMMyFriendViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    NSMutableArray *listArray;
    UIView *homeImage;
    
    NSInteger        totalPage;
    NSInteger        currentPageIndex;
    NSMutableArray   *pageIndexArray;
    BOOL                reload;
    
    NSMutableArray *stateArray;
    
    NSIndexPath *deleteIndexPath;
}

@property (nonatomic,retain)UITableView *tableView;

@end

@implementation LMMyFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    
    pageIndexArray=[NSMutableArray arrayWithCapacity:0];
    
    stateArray=[NSMutableArray arrayWithCapacity:0];
    
}

- (void)createUI
{
    self.title = @"我的好友";
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    listArray = [NSMutableArray new];
    
    [self setupRefresh];
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

- (void)reloadCellData
{
    reload=YES;
    [self getFriendListRequest:1];
}

- (void)headerRereshing
{
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
        [self reloadCellData];
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    currentPageIndex=listArray.count/20+1;
    
    if (currentPageIndex>=totalPage) {
        [self.tableView footerEndRefreshing];
        [self textStateHUD:@"没有更多好友了"];
        return;
    }
    
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (listArray.count>0) {
            
            [self getFriendListRequest:currentPageIndex];
        }
        [_tableView footerEndRefreshing];
    });
}

- (void)getFriendListRequest:(NSInteger)page
{
    LMFriendListRequest *request = [[LMFriendListRequest alloc] initWithPageIndex:page andPageSize:20];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getFriendListDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取好友列表失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getFriendListDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if (!bodyDic) {
        [self textStateHUD:@"获取好友列表失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            
            if (reload) {
                reload=NO;
                pageIndexArray=[NSMutableArray arrayWithCapacity:0];
                currentPageIndex=1;
                listArray=[NSMutableArray arrayWithCapacity:0];
            }
            
            if (![pageIndexArray containsObject:@(currentPageIndex)]) {
                [pageIndexArray addObject:@(currentPageIndex)];
            }else{
                
                return;
            }

            NSArray *array = bodyDic[@"list"];
            
            for (int i = 0; i < array.count; i++) {
             
                LMFriendVO *list=[[LMFriendVO alloc]initWithDictionary:array[i]];
                [listArray addObject:list];
            }
            
            if (listArray.count==0) {
                homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-150, kScreenHeight/2-160, 300, 100)];
                
                UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 90, 75)];
                homeImg.image = [UIImage imageNamed:@"NO-friend"];
                [homeImage addSubview:homeImg];
                UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 300, 60)];
                imageLb.numberOfLines = 0;
                imageLb.text = @"手牵手，一起走，如此优秀可爱的你\n怎么可以这么孤单呢";
                imageLb.textColor = TEXT_COLOR_LEVEL_3;
                imageLb.font = TEXT_FONT_LEVEL_2;
                imageLb.textAlignment = NSTextAlignmentCenter;
                [homeImage addSubview:imageLb];
                
                [_tableView addSubview:homeImage];
                
//                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan"] style:UIBarButtonItemStylePlain target:self action:@selector(sweepAction)];
//                self.navigationItem.rightBarButtonItem = rightItem;
                
                
            }
            [_tableView reloadData];
            
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];

        }
    }
    
}

- (void)sweepAction
{
    LMScanViewController *setVC = [[LMScanViewController alloc] init];
    [setVC setHidesBottomBarWhenPushed:YES];
  
    [self.navigationController pushViewController:setVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
  
    LMFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[LMFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LMFriendVO *list = [listArray objectAtIndex:indexPath.row];
    
    cell.tintColor = LIVING_COLOR;
    [cell  setData:list];
    
    return cell;
}

@end
