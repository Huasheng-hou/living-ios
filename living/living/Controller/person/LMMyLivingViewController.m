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

#import "LMLivingInfoVO.h"

#import "LMLivingMap.h"

#import "LMLiveRoomCell.h"

#import "LMLiveRoomBody.h"
#import "LMLiveRoomLivingInfo.h"
#import "LMLiveRoomMap.h"

#import <CoreLocation/CoreLocation.h>

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
    UITableView *_tableView;
    LMLivingInfoVO *livingInfo;
    LMLivingMap *numInfo;
    
    LMLiveRoomBody *bodyData;
    
    NSString *selectType;
    NSMutableArray *cellDataArray;
    
    LMLiveRoomCell *cellInfo;
    
    UIView *homeImage;
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
    selectType=@"left";
    cellDataArray=[NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (_livImgUUid==nil ) {
        homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, kScreenHeight/2-150, 200, 100)];
        
        UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20, 80, 80)];
                homeImg.image = [UIImage imageNamed:@"NO-living"];
                [homeImage addSubview:homeImg];
                UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, 200, 60)];
                imageLb.numberOfLines = 0;
                imageLb.text = @"拥有属于自己的生活馆，绝对是很高大上的感觉哦，\n快来参与吧";
                imageLb.textColor = TEXT_COLOR_LEVEL_3;
                imageLb.font = TEXT_FONT_LEVEL_2;
                imageLb.textAlignment = NSTextAlignmentCenter;
                [homeImage addSubview:imageLb];
                
                [self.view addSubview:homeImage];

    }else{
        [self getLivingHomeListData];
        [self createUI];
    }
    
    
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
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


#pragma mark  --生活馆数据列表请求
-(void)getLivingHomeListData
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    NSLog(@"================_livImgUUid=============%@",_livImgUUid);
    
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
    
    [self logoutAction:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        NSLog(@"我的生活馆信息bodyDic：%@",bodyDic);
        
//        bodyData=[[LMLiveRoomBody alloc]initWithDictionary:bodyDic];
        
         NSLog(@"==============bodyData.list=============：%@",bodyData.list);
        
        cellDataArray=(NSMutableArray *)bodyData.list;
        
        
        livingInfo = [[LMLivingInfoVO alloc] initWithDictionary:bodyDic[@"livingInfo"]];
        numInfo = [[LMLivingMap alloc] initWithDictionary:bodyDic[@"map"]];
        
        NSMutableArray *array=bodyDic[@"list"];
        for (int i=0; i<array.count; i++) {
            LMActivityList *list=[[LMActivityList alloc]initWithDictionary:array[i]];
            if (![listArray containsObject:list]) {
                [listArray addObject:list];
            }
        }
        [_tableView reloadData];
        
        [self locationWithName:livingInfo.address];
        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
        
    }

}

-(void)locationWithName:(NSString *)name
{
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    
    [geocoder geocodeAddressString:name completionHandler:^(NSArray *placemarks, NSError *error) {
//        NSLog(@"%@",placemarks);
        CLPlacemark *placemark=[placemarks firstObject];
        CLLocation *location=placemark.location;//位置
        
        
        CLLocationCoordinate2D curLocation;
        curLocation.latitude = location.coordinate.latitude;
        curLocation.longitude = location.coordinate.longitude;
        
        //设置地图跨度
        MKCoordinateSpan span;
        span.latitudeDelta = 0.008;
        span.longitudeDelta = 0.008;
        
        //显示地图
        MKCoordinateRegion region = {curLocation, span};
        [cellInfo.mapView setRegion:region animated:NO];
        
        //点
        MKPointAnnotation *annotation0 = [[MKPointAnnotation alloc] init];
        [annotation0 setCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
        [annotation0 setTitle:name];
        
        [cellInfo.mapView addAnnotation:annotation0];
    }];
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
        
        
        LMLiveRoomMap *map=bodyData.map;
        
        UIImageView *publicV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/4-10, 10, 22, 22)];
        [publicV setImage:[UIImage imageNamed:@"personTotalAct"]];
//        publicV.backgroundColor = [UIColor lightGrayColor];
        [headView addSubview:publicV];
        
        UILabel *publicLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth/2, 20)];
//        if (numInfo.publishNums) {
        publicLb.text = [NSString stringWithFormat:@"共发布%.0f次活动",map.publishNums];
//        }
        publicLb.textAlignment = NSTextAlignmentCenter;
        publicLb.textColor = TEXT_COLOR_LEVEL_3;
        publicLb.font = TEXT_FONT_LEVEL_3;
        [headView addSubview:publicLb];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-0.25, 15, 0.5, 30)];
        line.backgroundColor = LINE_COLOR;
        [headView addSubview:line];
        
        UIImageView *joinV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*3/4-10, 10, 20, 23)];
         [joinV setImage:[UIImage imageNamed:@"personJoinAct"]];
        
        [headView addSubview:joinV];
        
        UILabel *joinLb = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 35, kScreenWidth/2, 20)];
//        if (numInfo.joinNums) {
            joinLb.text = [NSString stringWithFormat:@"共参与%.0f次活动",map.joinNums];
        joinLb.textAlignment = NSTextAlignmentCenter;

        joinLb.textColor = TEXT_COLOR_LEVEL_3;
        joinLb.font = TEXT_FONT_LEVEL_3;
        [headView addSubview:joinLb];
        
        for (int i=0; i<2; i++) {
            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2*i, 0, kScreenWidth/2, 60)];
            [button setTag:10+i];
            [button addTarget:self action:@selector(selectCellType:) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:button];
        }
        return headView;
    }
    
    return nil;
}

-(void)selectCellType:(UIButton *)sender
{
    if (sender.tag==10) {
        selectType=@"left";
    }
    
    if (sender.tag==11) {
        selectType=@"right";
    }
    
    cellDataArray=[NSMutableArray arrayWithCapacity:0];
    
    if ([selectType isEqualToString:@"left"])
    {
        cellDataArray=(NSMutableArray *)bodyData.list;
    }
    if ([selectType isEqualToString:@"right"])
    {
       cellDataArray=(NSMutableArray *)bodyData.listofUser;
    }
    
    [_tableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return kScreenWidth*3/5;
    }
    return 60;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return [LMLiveRoomCell cellHigth:livingInfo.livingTitle];
    }
    
    if (indexPath.section==1) {
        return 210;
    }
    
    return 340;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    [view setBackgroundColor:BG_GRAY_COLOR];
    
    return view;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        
        return cellDataArray.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        static NSString *cellID = @"cellID";
        cellInfo =[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cellInfo==nil) {
             cellInfo = [[LMLiveRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            [cellInfo setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        [cellInfo setCellData:livingInfo];
        [cellInfo.payButton addTarget:self action:@selector(cellbuttonPay) forControlEvents:UIControlEventTouchUpInside];
        
        return cellInfo;
    }
    
    if (indexPath.section==1) {
        static NSString *cellId = @"cellId";
        LMActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LMActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        return cell;
    }
    return nil;
}

#pragma mark scrollview代理函数
- (void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
}

-(void)cellbuttonPay
{
    NSLog(@"***********立即支付");
    LMRechargeViewController *chargeVC = [[LMRechargeViewController alloc] init];
    chargeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chargeVC animated:YES];
}

@end
