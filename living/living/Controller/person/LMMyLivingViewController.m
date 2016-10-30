//
//  LMMyLivingViewController.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyLivingViewController.h"
#import "LMMyLivingHomeCell.h"
#import "LMLivingHomeListRequest.h"
#import "LMRechargeViewController.h"
#import "MJRefresh.h"

@interface LMMyLivingViewController ()<LMMyLivingHomeCellDelegate>
{
    NSMutableArray *listArray;
    BOOL ifRefresh;
    int total;
    UIImageView *homeImage;
}

@end

@implementation LMMyLivingViewController

- (NSMutableArray *)taskArr
{
    if (!listArray) {
        listArray = [NSMutableArray array];
    }
    return listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的生活馆";
    [self createUI];
     [self setupRefresh];
    listArray = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadingEvent) name:@"reloadEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadingEvent) name:@"rechargeMoney" object:nil];

    

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

- (void)headerRereshing
{
    
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
        [self.tableView headerEndRefreshing];
        ifRefresh = YES;
        self.current=1;
        [self getLivingHomeListData:self.current];
        ifRefresh=YES;
        
    });
}


- (void)footerRereshing
{
    
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.current = self.current+1;
        
        ifRefresh=NO;
        
        if (total<self.current) {
            [self textStateHUD:@"没有更多生活馆"];
        }else{
            [self getLivingHomeListData:self.current];
        }
        
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}

-(void)reloadingEvent
{
    [listArray removeAllObjects];
    [self getLivingHomeListData:1];
}



#pragma mark  --生活馆数据列表请求
-(void)getLivingHomeListData:(int)page
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    
    LMLivingHomeListRequest *request = [[LMLivingHomeListRequest alloc] initWithPageIndex:page andPageSize:20];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getLivingHomeListDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取数据失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];

}

-(void)getLivingHomeListDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        NSLog(@"%@",bodyDic);
        
        [listArray removeAllObjects];
        NSMutableArray *array=bodyDic[@"list"];
        for (int i=0; i<array.count; i++) {
//            LMActivityList *list=[[LMActivityList alloc]initWithDictionary:array[i]];
//            if (![listArray containsObject:list]) {
//                [listArray addObject:list];
//            }
        }
        [self.tableView reloadData];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
        
        [homeImage removeFromSuperview];
        
    }
    if (listArray.count>0) {
        [homeImage removeFromSuperview];
    }else{
        homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, kScreenHeight/2-130, 200, 100)];
        
        UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20, 80, 80)];
        homeImg.image = [UIImage imageNamed:@"NO-living"];
        [homeImage addSubview:homeImg];
        UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 200, 60)];
        imageLb.numberOfLines = 0;
        imageLb.text = @"拥有属于自己的生活馆，绝对是很高大上的感觉哦，快来参与吧";
        imageLb.textColor = TEXT_COLOR_LEVEL_3;
        imageLb.font = TEXT_FONT_LEVEL_2;
        imageLb.textAlignment = NSTextAlignmentCenter;
        [homeImage addSubview:imageLb];
        
        [self.tableView addSubview:homeImage];
    }
    [self.tableView reloadData];
}



-(void)createUI
{
    [super createUI];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 235;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    LMMyLivingHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LMMyLivingHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    
    [cell setXScale:self.xScale yScale:self.yScaleNoTab];

    return cell;
}

-(void)cellWillpay:(LMMyLivingHomeCell *)cell
{
    NSLog(@"***********立即支付");
    LMRechargeViewController *chargeVC = [[LMRechargeViewController alloc] init];
    chargeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chargeVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
