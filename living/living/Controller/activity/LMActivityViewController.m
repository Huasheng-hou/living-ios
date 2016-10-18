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

@interface LMActivityViewController ()<UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView *_tableView;
    NSMutableArray *listArray;
    
    UIBarButtonItem *backItem;
    
}

@end

@implementation LMActivityViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getActivityListDataRequest) name:@"reloadEvent" object:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    listArray = [NSMutableArray new];
    [self getActivityListDataRequest];
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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publicIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(publicAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

-(void)publicAction
{
    
    LMPublicActivityController *publicVC = [[LMPublicActivityController alloc] init];
    [publicVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:publicVC animated:YES];
    
    NSLog(@"********发布活动");
}

-(void)getActivityListDataRequest
{
    NSLog(@"%@", [FitUserManager sharedUserManager].uuid);
    NSLog(@"%@", [FitUserManager sharedUserManager].password);
    LMActivityListRequest *request = [[LMActivityListRequest alloc] initWithPageIndex:1 andPageSize:20];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getActivityListResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取列表失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

-(void)getActivityListResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        NSLog(@"%@",bodyDic);
        NSMutableArray *array=bodyDic[@"list"];
        for (int i=0; i<array.count; i++) {
            LMActivityList *list=[[LMActivityList alloc]initWithDictionary:array[i]];
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
