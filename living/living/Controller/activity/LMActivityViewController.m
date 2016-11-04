//
//  LMActivityViewController.m
//  dirty
//
//  Created by Ding on 16/9/22.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMActivityViewController.h"
#import "LMActivityDetailController.h"

#import "LMPublicActivityController.h"
#import "LMActivityListRequest.h"
#import "LMActivityCell.h"
#import "LMActivityList.h"
#import "MJRefresh.h"
#import "LMActivityDeleteRequest.h"

@interface LMActivityViewController ()<UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView *_tableView;
    NSMutableArray *listArray;
    
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

- (NSMutableArray *)taskArr
{
    if (!listArray) {
        listArray = [NSMutableArray array];
    }
    return listArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadingEvent) name:@"reloadEvent" object:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    listArray = [NSMutableArray new];
     pageIndexArray=[NSMutableArray arrayWithCapacity:0];
    
    [self setupRefresh];
    NSLog(@"********%@",[FitUserManager sharedUserManager].privileges);
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
    
    NSLog(@"[FitUserManager sharedUserManager].privileges:%@",[FitUserManager sharedUserManager].privileges);
    
    if ([[FitUserManager sharedUserManager].privileges isEqual:@"special"]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publicIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(publicAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    
    homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, kScreenHeight/2-130, 200, 100)];
    
//    UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20, 80, 80)];
//    homeImg.image = [UIImage imageNamed:@"eventload"];
//    [homeImage addSubview:homeImg];
    UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 200, 60)];
    imageLb.numberOfLines = 0;
    imageLb.text = @"正在加载。。。";
    imageLb.textColor = TEXT_COLOR_LEVEL_3;
    imageLb.font = TEXT_FONT_LEVEL_2;
    imageLb.textAlignment = NSTextAlignmentCenter;
    [homeImage addSubview:imageLb];
    homeImage.hidden = YES;
    
    [_tableView addSubview:homeImage];
}

#pragma mark 发布活动

-(void)publicAction
{
    LMPublicActivityController *publicVC = [[LMPublicActivityController alloc] init];
    [publicVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:publicVC animated:YES];
    
    NSLog(@"********发布活动");
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //tableView刚出现时，进行刷新操作
    [_tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
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
    [self getActivityListDataRequest:1];
}

- (void)headerRereshing
{
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
       [self reloadCellData];
       [_tableView headerEndRefreshing];
    });
}


- (void)footerRereshing
{
    currentPageIndex=listArray.count/20+1;
    
    if (currentPageIndex>=totalPage) {
        [_tableView footerEndRefreshing];
        [self textStateHUD:@"没有活动了"];
        return;
    }

    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (listArray.count>0) {
            [self getActivityListDataRequest:(int)currentPageIndex];
            NSLog(@"=============当前请求的页数=%ld",currentPageIndex);
        }
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}

-(void)reloadingEvent
{
    [listArray removeAllObjects];
    [self getActivityListDataRequest:1];
}

-(void)getActivityListDataRequest:(int)page
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    LMActivityListRequest *request = [[LMActivityListRequest alloc] initWithPageIndex:page andPageSize:20];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getActivityListResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                               
                                               [homeImage removeFromSuperview];
                                               
                                               homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, kScreenHeight/2-130, 200, 100)];
                                               
                                               //    UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20, 80, 80)];
                                               //    homeImg.image = [UIImage imageNamed:@"eventload"];
                                               //    [homeImage addSubview:homeImg];
                                               UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 200, 60)];
                                               imageLb.numberOfLines = 0;
                                               imageLb.text = @"请点击页面重新加载...";
                                               imageLb.textColor = TEXT_COLOR_LEVEL_3;
                                               imageLb.font = TEXT_FONT_LEVEL_2;
                                               imageLb.textAlignment = NSTextAlignmentCenter;
                                               [homeImage addSubview:imageLb];
                                               
                                               UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadingEvent)];
                                               [_tableView addGestureRecognizer:tap];
                                               [_tableView addSubview:homeImage];
                                               
                                               
                                               
                                           }];
    [proxy start];
    
}

-(void)getActivityListResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
     NSLog(@"============活动数据请求结果===========%@",bodyDic);
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
      
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
        
        NSMutableArray *array=bodyDic[@"list"];
        for (int i=0; i<array.count; i++) {
            LMActivityList *list=[[LMActivityList alloc]initWithDictionary:array[i]];
            if (![listArray containsObject:list]) {
                [listArray addObject:list];
            }
        }
        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
        
        [homeImage removeFromSuperview];
        
        homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, kScreenHeight/2-130, 200, 100)];
        
        //    UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20, 80, 80)];
        //    homeImg.image = [UIImage imageNamed:@"eventload"];
        //    [homeImage addSubview:homeImg];
        UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 200, 60)];
        imageLb.numberOfLines = 0;
        imageLb.text = @"请点击页面重新加载...";
        imageLb.textColor = TEXT_COLOR_LEVEL_3;
        imageLb.font = TEXT_FONT_LEVEL_2;
        imageLb.textAlignment = NSTextAlignmentCenter;
        [homeImage addSubview:imageLb];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadingEvent)];
        [_tableView addGestureRecognizer:tap];
        [_tableView addSubview:homeImage];
        
        
        
    }
    if (listArray.count>0) {
        [homeImage removeFromSuperview];
    }else{
        [homeImage removeFromSuperview];
        homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, kScreenHeight/2-160, 200, 100)];
        
        UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20, 80, 80)];
        homeImg.image = [UIImage imageNamed:@"eventload"];
        [homeImage addSubview:homeImg];
        UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 200, 60)];
        imageLb.numberOfLines = 0;
        imageLb.text = @"没活动，心塞塞，点击右上角按钮 快来参与吧";
        imageLb.textColor = TEXT_COLOR_LEVEL_3;
        imageLb.font = TEXT_FONT_LEVEL_2;
        imageLb.textAlignment = NSTextAlignmentCenter;
        [homeImage addSubview:imageLb];
        
        [_tableView addSubview:homeImage];
    }
    [_tableView reloadData];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    LMActivityCell *cell = [[LMActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LMActivityList *list = [listArray objectAtIndex:indexPath.row];
    [cell setValue:list];
    
    [cell setXScale:self.xScale yScale:self.yScaleWithAll];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMActivityList *list = [listArray objectAtIndex:indexPath.row];
    LMActivityDetailController *detailVC = [[LMActivityDetailController alloc] init];
    detailVC.eventUuid = list.eventUuid;
    detailVC.titleStr = list.eventName;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if ([tableView isEqual:_tableView]) {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    return result;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    
    if (![CheckUtils isLink]) {
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[listArray count]) {
            
             LMActivityList *list = [listArray objectAtIndex:indexPath.row];
            NSArray *array=[NSArray arrayWithObject:list.eventUuid];
            [self deleteActivityRequest:array];
            
            deleteIndexPath=indexPath;
            
//            [listArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
    }
}

#pragma mark 删除活动  LMActivityDeleteRequest
-(void)deleteActivityRequest:(NSArray *)event_uuid
{
    LMActivityDeleteRequest *request = [[LMActivityDeleteRequest alloc] initWithEvent_uuid:event_uuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(deleteActivityResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"删除失败"
                                                                   waitUntilDone:YES];
                                                [_tableView reloadData];
                                           }];
    [proxy start];
    
}

-(void)deleteActivityResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        NSLog(@"==================删除活动bodyDic：%@",bodyDic);
       
        [self textStateHUD:@"删除成功"];
        
        [listArray removeObjectAtIndex:deleteIndexPath.row];//移除数据源的数据
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deleteIndexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        
        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
    [_tableView reloadData];
}

@end
