//
//  LMAllActivityController.m
//  living
//
//  Created by hxm on 2017/3/13.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMAllActivityController.h"
#import "FitConsts.h"
#import "LMActivityListRequest.h"
#import "LMActivityApplyCell.h"
#import "LMActivityDetailController.h"
#import "ActivityListVO.h"
#import "SXButton.h"
#import "SearchViewController.h"
#import "SQMenuShowView.h"

#define PAGER_SIZE 20

@interface LMAllActivityController ()
@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;
@end

@implementation LMAllActivityController
{
    UIImageView  *homeImage;
    SXButton     *leftButton;
    NSString     *city;
    
    
}

- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadNewer)
                                                     name:@"reloadEvent"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [self creatImage];
    [self loadNewer];
}

- (void)createUI{
    [super createUI];
    
    self.view.backgroundColor =[UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor whiteColor];
    
    NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityArr"];
    NSString *cityStr;
    for (NSString *string in searchArr) {
        cityStr = string;
    }
    // 设置导航栏左侧按钮
     leftButton = [SXButton buttonWithType:UIButtonTypeCustom];
     leftButton.frame = CGRectMake(-30, 0, 55, 20);
    [leftButton setTitleColor:COLOR_BLACK_LIGHT forState:UIControlStateNormal];

     [leftButton addTarget:self action:@selector(screenAction:) forControlEvents:UIControlEventTouchUpInside];
     
     if (cityStr&&![cityStr isEqual:@""]) {
         if (cityStr.length > 3) {
     
                leftButton.width = 80+24*(cityStr.length-3);
         }else{
     
             if (cityStr.length == 3) {
     
                leftButton.width = 80;
             }else{
     
                 leftButton.width = 55;
     
             }
         }
     
         [leftButton setTitle:cityStr forState:UIControlStateNormal];
     }else{
         [leftButton setTitle:@"全部" forState:UIControlStateNormal];
     }
    
     [leftButton setImage:[UIImage imageNamed:@"下1"] forState:UIControlStateNormal];
     UIBarButtonItem *LeftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
     self.navigationItem.rightBarButtonItem = LeftBarButton;
    
}

- (void)screenAction:(UIButton *)sender
{
    SearchViewController *searchV = [[SearchViewController alloc]init];
    UINavigationController *naV = [[UINavigationController alloc]initWithRootViewController:searchV];
    [searchV setSucceed:^(NSString *str) {
        
        if (str.length > 3) {
            
            leftButton.width = 80+24*(str.length-3);
            leftButton.titleLabel.width = leftButton.titleLabel.bounds.size.width;
            leftButton.imageView.originX = leftButton.width*0.5+15;
        }else{
            
            if (str.length == 3) {
                
                leftButton.width = 80;
                leftButton.titleLabel.width = leftButton.titleLabel.bounds.size.width;
                leftButton.imageView.originX = leftButton.width*0.5+15;
                
            }else{
                
                leftButton.width = 55;
                leftButton.titleLabel.width = leftButton.titleLabel.bounds.size.width;
                leftButton.imageView.originX = leftButton.width*0.5+15;
            }
        }
        
        [leftButton setTitle:str forState:UIControlStateNormal];
        
        NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:str, nil];
        
        //存入数组并同步
        
        [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"cityArr"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
    [self presentViewController:naV animated:YES completion:^{
        
    }];
    
}
-(void)creatImage
{
    homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-160, kScreenWidth, 100)];
    
    UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-41, 5, 82, 91)];
    homeImg.image = [UIImage imageNamed:@"eventload"];
    [homeImage addSubview:homeImg];
    UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-150, 95, 300, 60)];
    imageLb.numberOfLines = 0;
    imageLb.text = @"您选择的城市还没有活动哦\n选择其它城市看看吧";
    imageLb.textColor = TEXT_COLOR_LEVEL_3;
    imageLb.font = TEXT_FONT_LEVEL_2;
    imageLb.textAlignment = NSTextAlignmentCenter;
    [homeImage addSubview:imageLb];
    homeImage.hidden = YES;
    [self.tableView addSubview:homeImage];
}

#pragma mark - 数据请求

- (FitBaseRequest *)request{
    NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityArr"];
    NSString *cityStr;
    for (NSString *string in searchArr) {
        cityStr = string;
        city = cityStr;
    }
    
    if ([city isEqual:@"其它"]) {
        city = @"其它";
    }
    if ([city isEqual:@"全部"]) {
        city = nil;
    }

    LMActivityListRequest   *request    = [[LMActivityListRequest alloc] initWithPageIndex:self.current andPageSize:PAGER_SIZE andCity:city];
    
    return request;
}
- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary *respDict = [NSJSONSerialization
                              JSONObjectWithData:respData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    
    NSDictionary *headDic = [respDict objectForKey:@"head"];
    
    NSString    *coderesult         = [headDic objectForKey:@"returnCode"];
    
    if (coderesult && ![coderesult isEqual:[NSNull null]] && [coderesult isKindOfClass:[NSString class]] && [coderesult isEqualToString:@"000"]){
        if ([headDic[@"privileges"] isEqual:@"special"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
                
                self.navigationItem.rightBarButtonItem = rightItem;
            });
        }
    }
    
    NSString        *result     = [bodyDict objectForKey:@"result"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        
        self.max    = [[bodyDict objectForKey:@"total"] intValue];
        
        NSArray *resultArr  = [ActivityListVO ActivityListVOListWithArray:[bodyDict objectForKey:@"list"]];
        
        
        if (resultArr.count==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                homeImage.hidden = NO;
            });
        }
        
        if (resultArr && resultArr.count > 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                homeImage.hidden = YES;
            });
            
            return resultArr;
        }
        
    }
    
    return nil;
}
#pragma mark 发布活动

- (void)publicAction
{
    _isShow = !_isShow;
    
    if (_isShow) {
        [self.showView showView];
        
    }else{
        [self.showView dismissView];
    }
    
}
- (SQMenuShowView *)showView{
    
    if (_showView) {
        return _showView;
    }
    NSArray *array = @[@"发布活动",@"我的活动"];
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){CGRectGetWidth(self.view.frame)-100-10,64,100,0}
                                               items:array
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-25,10}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    return _showView;
}

#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 195;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LMActivityApplyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LMActivityApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.listData.count > indexPath.row) {
    
            ActivityListVO  *vo = [self.listData objectAtIndex:indexPath.row];
    
            if (vo && [vo isKindOfClass:[ActivityListVO class]]) {
                
                [cell setVO:vo ] ;
            }
        }
    return cell;
    
//    static NSString *cellId = @"cellId";
//    
//    UITableViewCell     *cell;
//    
//    cell    = [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    
//    if (cell) {
//        
//        return cell;
//    }
//    
//    cell    = [tableView dequeueReusableCellWithIdentifier:cellId];
//    
//    if (!cell) {
//        
//        cell = [[LMActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//        
//        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    
//    if (self.listData.count > indexPath.row) {
//        
//        ActivityListVO  *vo = [self.listData objectAtIndex:indexPath.row];
//        
//        if (vo && [vo isKindOfClass:[ActivityListVO class]]) {
//            
//            [(LMActivityCell *)cell setActivityList:vo index:0] ;
//        }
//    }
//    
//    [(LMActivityCell *)cell setXScale:self.xScale yScale:self.yScaleWithAll];
//    
//    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listData.count > indexPath.row) {
        
        ActivityListVO  *vo = [self.listData objectAtIndex:indexPath.row];
        
        if (vo && [vo isKindOfClass:[ActivityListVO class]]) {
            
            LMActivityDetailController *detailVC = [[LMActivityDetailController alloc] init];
            
            detailVC.hidesBottomBarWhenPushed = YES;
            
            detailVC.eventUuid  = vo.eventUuid;
            detailVC.titleStr   = vo.eventName;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}






@end
