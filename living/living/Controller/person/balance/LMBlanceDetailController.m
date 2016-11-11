//
//  LMBlanceDetailController.m
//  living
//
//  Created by Ding on 2016/10/30.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBlanceDetailController.h"
#import "LMBlanceHeadCell.h"
#import "LMBlanceListCell.h"
#import "SQMenuShowView.h"
#import "LMBanlanceVO.h"
#import "LMBalanceMonthRequest.h"
#import "LMBalanceBillVO.h"
#import "MJRefresh.h"
#import "LMMonthDetailDataModels.h"

@interface LMBlanceDetailController ()<LMBlanceHeadCellDelegate>
{
    NSString *DateString;
    LMMonthDetailBody *bodyData;
    BOOL ifRefresh;
    int total;
    NSString *month;
    
}
@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSDictionary *billDic;

@end

@implementation LMBlanceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DateString=self.curMonth;
    
    [self createUI];
    [self getBlanceData:self.curMonth andPage:self.current];
    [self setupRefresh];
    
}

-(void)createUI
{
    [super createUI];
    self.title = @"本月明细";
    __weak typeof(self) weakSelf = self;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
        NSLog(@"点击第%ld个item",index);
        DateString=_monthArr[index];
        [self getBlanceData:_monthArr[index] andPage:self.current];
        
        
    }];
    
    _listArray = [NSMutableArray new];
    _billDic = [NSDictionary new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    
    return _listArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 280;
    }
    return 75;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 45;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *deal = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-10, 45)];
        deal.text = @"交易详细";
        deal.font = TEXT_FONT_LEVEL_2;
        deal.textColor = TEXT_COLOR_LEVEL_2;
        [headView addSubview:deal];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 44.5, kScreenWidth-10, 0.5)];
        lineView.backgroundColor = LINE_COLOR;
        [headView addSubview:lineView];
        
        return headView;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellId = @"cellId";
        LMBlanceHeadCell *cell = [[LMBlanceHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        //        [cell setDic:_billDic];
        
        [cell setValue:bodyData.bill];
        
        cell.timeLabel.text=DateString;
        
        return cell;
    }
    if (indexPath.section==1) {
        static NSString *cellID = @"cellID";
        LMBlanceListCell *cell = [[LMBlanceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //        for (int i=0; i<_listArray.count; i++) {
        
        LMBanlanceVO  *list=_listArray[indexPath.row];
        [cell setModel:list];
        //        }
        
        return cell;
    }
    return nil;
    
}

-(void)cellWillclick:(LMBlanceHeadCell *)cell
{
    _isShow = !_isShow;
    
    if (_isShow) {
        [self.showView showView];
        
    }else{
        [self.showView dismissView];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _isShow = NO;
    [self.showView dismissView];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.showView dismissView];
}


- (SQMenuShowView *)showView{
    
    if (_showView) {
        return _showView;
    }
    
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:0];
    
    for (int i=0; i<_monthArr.count; i++) {
        NSString *timeString=_monthArr[i];
        NSString *needStr=[timeString stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
        NSString *needString=[NSString stringWithFormat:@"%@月",needStr];
        [array addObject:needString];
    }
    
    if (array.count<1) {
        return nil;
    }
    
    
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){CGRectGetWidth(self.view.frame)-100-10,64+35,100,0}
                                               items:array
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-25,10}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    return _showView;
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //tableView刚出现时，进行刷新操作
    [self.tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    //    self.tableView.headerPullToRefreshText = @"下拉可以刷新";
    //    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
    //    self.tableView.headerRefreshingText = @"正在帮你刷新...";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    self.tableView.footerRefreshingText = @"正在帮你加载...";
}


- (void)footerRereshing
{
    
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.current = self.current+1;
        
        ifRefresh=NO;
        
        if (total<self.current) {
            [self textStateHUD:@"没有更多信息"];
        }else{
            [self getBlanceData:DateString andPage:self.current];
        }
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}




#pragma mark  --获取余额数据
-(void)getBlanceData:(NSString *)timeDate andPage:(NSInteger)page
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    LMBalanceMonthRequest *request = [[LMBalanceMonthRequest alloc] initWithPageIndex:1 andPageSize:20 andMonth:timeDate];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getBlanceDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取余额数据失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
    
}
-(void)getBlanceDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"获取余额失败"];
    }else{
        
        //        NSLog(@"==============余额明细详情===bodyDic============%@",bodyDic);
        total = [[bodyDic objectForKey:@"total"] intValue];
        bodyData=[[LMMonthDetailBody alloc]initWithDictionary:bodyDic];
        _listArray = [NSMutableArray new];
        
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            NSMutableArray *array=bodyDic[@"list"];
            for (int i=0; i<array.count; i++) {
                LMBanlanceVO *vo=[[LMBanlanceVO alloc]initWithDictionary:array[i]];
                if (![_listArray containsObject:vo]) {
                    [_listArray addObject:vo];
                }
            }
            _billDic = [bodyDic objectForKey:@"bill"];
            
            
            
            [self.tableView reloadData];
        }
    }
}

@end
