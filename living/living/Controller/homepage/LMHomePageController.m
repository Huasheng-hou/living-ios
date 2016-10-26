//
//  DYHomePageController.m
//  dirty
//
//  Created by Ding on 16/8/23.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMHomePageController.h"
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

@interface LMHomePageController ()<UITableViewDelegate,
UITableViewDataSource,
WJLoopViewDelegate
>
{
    UITableView *_tableView;
    UIView *headView;
    
    UIBarButtonItem *backItem;
    NSMutableArray *imageUrls;
    NSMutableArray *listArray;
    
}

@end

@implementation LMHomePageController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBannerDataRequest) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBannerDataRequest) name:@"reloadHomePage" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    [self creatUI];
    imageUrls = [NSMutableArray new];
    listArray = [NSMutableArray new];
    [self getHomeDataRequest];
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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Sweep"] style:UIBarButtonItemStylePlain target:self action:@selector(sweepAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    _tableView.tableHeaderView = headView;
    
    
}

-(void)sweepAction
{
    NSLog(@"********扫描");
    
    LMPublicArticleController *scanVC = [[LMPublicArticleController alloc] init];
    
    [scanVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:scanVC animated:YES];
}

-(void)getBannerDataRequest
{
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
        NSLog(@"%@",bodyDic);
        NSMutableArray *array = [NSMutableArray new];
        array = bodyDic[@"banners"];
        for (NSDictionary *dic in array) {
            NSString *url = dic[@"linkUrl"];
            [imageUrls addObject:url];
        }
        NSLog(@"%@",imageUrls);
        if (imageUrls.count==0) {
            headView.backgroundColor = LINE_COLOR;
        }else{
            WJLoopView *loopView = [[WJLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160) delegate:self imageURLs:imageUrls placeholderImage:nil timeInterval:2 currentPageIndicatorITintColor:nil pageIndicatorTintColor:nil];
            loopView.location = WJPageControlAlignmentRight;
            
            
            [headView addSubview:loopView];
        }
        [_tableView reloadData];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

-(void)getHomeDataRequest
{
    NSLog(@"%@", [FitUserManager sharedUserManager].uuid);
    NSLog(@"%@", [FitUserManager sharedUserManager].password);
    LMHomelistequest *request = [[LMHomelistequest alloc] initWithPageIndex:1 andPageSize:20];
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
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        NSLog(@"%@",bodyDic);
        [listArray removeAllObjects];
        NSMutableArray *array=bodyDic[@"list"];
        for (int i=0; i<array.count; i++) {
            LMActicleList *list=[[LMActicleList alloc]initWithDictionary:array[i]];
            if (![listArray containsObject:list]) {
                [listArray addObject:list];
            }
        }
        
        [_tableView reloadData];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
    
    
}


#pragma mark scrollview代理函数
- (void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index {
    NSLog(@"%ld",index);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LMActicleList *list = [listArray objectAtIndex:indexPath.row];
    [cell setValue:list];
    [cell setXScale:self.xScale yScale:self.yScaleWithAll];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMActicleList *list = [listArray objectAtIndex:indexPath.row];
    LMHomeDetailController *detailVC = [[LMHomeDetailController alloc] init];
    detailVC.artcleuuid = list.articleUuid;
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
