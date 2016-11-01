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
#import "LMBalanceList.h"
#import "LMBalanceMonthRequest.h"
#import "LMBalanceBill.h"

@interface LMBlanceDetailController ()<LMBlanceHeadCellDelegate>
@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSDictionary *billDic;

@end

@implementation LMBlanceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self getBlanceData];
}

-(void)createUI
{
    [super createUI];
    self.title = @"本月明细";
    __weak typeof(self) weakSelf = self;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
        NSLog(@"点击第%ld个item",index+1);
        
        [self getBlanceData];
        
        
    }];
    
    _listArray = [NSMutableArray new];
    _billDic = [NSDictionary new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return 6;
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
        [cell setDic:_billDic];
        
        return cell;
        
    }
    if (indexPath.section) {
        static NSString *cellID = @"cellID";
        LMBlanceListCell *cell = [[LMBlanceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        LMBalanceList *list = [_listArray objectAtIndex:indexPath.row];
//        [cell setModel:list];
        
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

- (SQMenuShowView *)showView{
    
    if (_showView) {
        return _showView;
    }
    
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){CGRectGetWidth(self.view.frame)-100-10,64+35,100,0}
                                               items:_monthArr
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-25,10}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    return _showView;
}

#pragma mark  --获取余额数据
-(void)getBlanceData
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    LMBalanceMonthRequest *request = [[LMBalanceMonthRequest alloc] initWithPageIndex:1 andPageSize:20 andMonth:@"2016-10"];
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
    if (!bodyDic) {
        [self textStateHUD:@"获取余额失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
//            NSDictionary *dic = [bodyDic objectForKey:@"wallet"];
            NSMutableArray *array=bodyDic[@"list"];
            for (int i=0; i<array.count; i++) {
                LMBalanceList *list=[[LMBalanceList alloc]initWithDictionary:array[i]];
                if (![_listArray containsObject:list]) {
                    [_listArray addObject:list];
                }

            }
            _billDic = [bodyDic objectForKey:@"bill"];

            
            
            [self.tableView reloadData];
        }
    }
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
