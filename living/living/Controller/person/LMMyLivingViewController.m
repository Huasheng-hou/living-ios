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
#import "LMActivityCell.h"
#import "WJLoopView.h"
#import "LMLivingLivingInfo.h"
#import "LMLivingMap.h"

@interface LMMyLivingViewController ()
<UITableViewDelegate,
UITableViewDataSource,
LMMyLivingHomeCellDelegate,
WJLoopViewDelegate
>
{
    NSMutableArray *listArray;
    BOOL ifRefresh;
    int total;
    UIImageView *homeImage;
    UITableView *_tableView;
    LMLivingLivingInfo*livingInfo;
    LMLivingMap *numInfo;
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
    [self getLivingHomeListData];
    listArray = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLivingHomeListData) name:@"reloadEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLivingHomeListData) name:@"rechargeMoney" object:nil];

}

-(void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


#pragma mark  --生活馆数据列表请求
-(void)getLivingHomeListData
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    NSLog(@"%@",_livImgUUid);
    
    LMLivingHomeListRequest *request = [[LMLivingHomeListRequest alloc] initWithLivingUuid:_livImgUUid];
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
        
        livingInfo = [[LMLivingLivingInfo alloc] initWithDictionary:bodyDic[@"livingInfo"]];
        numInfo = [[LMLivingMap alloc] initWithDictionary:bodyDic[@"map"]];
        
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
        
        [_tableView addSubview:homeImage];
    }
    [_tableView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)];
        WJLoopView *loopView = [[WJLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5) delegate:self imageURLs:livingInfo.livingImage placeholderImage:nil timeInterval:2 currentPageIndicatorITintColor:nil pageIndicatorTintColor:nil];
        loopView.location = WJPageControlAlignmentRight;
        
        
        [headView addSubview:loopView];
        
        return headView;
    }
    if (section==1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *publicV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/4-10, 10, 20, 20)];
        publicV.backgroundColor = [UIColor lightGrayColor];
        [headView addSubview:publicV];
        
        UILabel *publicLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth/2, 20)];
        if (numInfo.publishNums) {
            publicLb.text = [NSString stringWithFormat:@"共发布%.0f次活动",numInfo.publishNums];
        }
        publicLb.textAlignment = NSTextAlignmentCenter;
        publicLb.textColor = TEXT_COLOR_LEVEL_3;
        publicLb.font = TEXT_FONT_BOLD_14;
        [headView addSubview:publicLb];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-0.25, 15, 0.5, 30)];
        line.backgroundColor = LINE_COLOR;
        [headView addSubview:line];
        
        
        UIImageView *joinV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*3/4-10, 10, 20, 20)];
        joinV.backgroundColor = [UIColor lightGrayColor];
        [headView addSubview:joinV];
        
        UILabel *joinLb = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 35, kScreenWidth/2, 20)];
//        if (numInfo.joinNums) {
            joinLb.text = [NSString stringWithFormat:@"共参与%.0f次活动",numInfo.joinNums];
        joinLb.textAlignment = NSTextAlignmentCenter;

        joinLb.textColor = TEXT_COLOR_LEVEL_3;
        joinLb.font = TEXT_FONT_BOLD_14;
        [headView addSubview:joinLb];
        return headView;
    }
    
    
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return kScreenWidth*3/5;
    }
    return 60;
}


#pragma mark scrollview代理函数
- (void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 210;
    }
    
    return 235;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return listArray.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        return cell;
    }
    
    if (indexPath.section==1) {
        static NSString *cellId = @"cellId";
        LMActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LMActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        LMActivityList *list = [listArray objectAtIndex:indexPath.row];
        [cell setValue:list];
        [cell setXScale:self.xScale yScale:self.yScaleNoTab];
        
        return cell;
    }
    return nil;
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
