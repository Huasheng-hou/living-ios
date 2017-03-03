//
//  LMActivityViewController.m
//  dirty
//
//  Created by Ding on 16/9/22.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMActivityViewController.h"
#import "LMActivityDetailController.h"
#import "LMPublishViewController.h"
#import "LMActivityListRequest.h"
#import "LMActivityCell.h"

#import "LMActivityDeleteRequest.h"
#import "SQMenuShowView.h"
#import "ActivityListVO.h"
#import "LMMyPublicViewController.h"
#import "SXButton.h"
#import "SearchViewController.h"

#define PAGER_SIZE      20

@interface LMActivityViewController ()
{
    UIBarButtonItem *backItem;
    UIImageView *homeImage;
    
    NSIndexPath *deleteIndexPath;
    
    NSInteger        totalPage;
    NSInteger        currentPageIndex;
    NSMutableArray   *pageIndexArray;
    BOOL                reload;
    SXButton     *letfButton;
    NSString         *city;
}
@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;

@end

@implementation LMActivityViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
//        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadNewer)
                                                     name:@"reloadEvent"
                                                   object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatUI];
    [self creatImage];

    [self loadNewer];
    __weak typeof(self) weakSelf = self;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
        if (index==0) {
            LMPublishViewController *publicVC = [[LMPublishViewController alloc] init];
            [publicVC setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:publicVC animated:YES];
        }
        
        if (index==1) {
            LMMyPublicViewController *myfVC = [[LMMyPublicViewController alloc] init];
            [myfVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myfVC animated:YES];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.listData.count == 0) {
        
        [self loadNoState];
    }
}

- (void)creatUI
{
    [super createUI];
    
    if ([[FitUserManager sharedUserManager].privileges isEqual:@"special"]) {
    
        UIBarButtonItem     *rightItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publicIcon"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(publicAction)];
        
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 49, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 49, 0);
    
    NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityArr"];
    NSString *cityStr;
    for (NSString *string in searchArr) {
        cityStr = string;
    }
    
    // 设置导航栏左侧按钮
    letfButton = [SXButton buttonWithType:UIButtonTypeCustom];
    letfButton.frame = CGRectMake(-10, 0, 55, 20);
    [letfButton addTarget:self action:@selector(screenAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (cityStr&&![cityStr isEqual:@""]) {
        if (cityStr.length > 3) {
            
            letfButton.width = 80+24*(cityStr.length-3);
        }else{
            
            if (cityStr.length == 3) {
                
                letfButton.width = 80;
            }else{
                
                letfButton.width = 55;

            }
        }
        
       [letfButton setTitle:cityStr forState:UIControlStateNormal];
    }else{
        [letfButton setTitle:@"全部" forState:UIControlStateNormal];
    }
    
    
    [letfButton setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
    UIBarButtonItem *LeftBarButton = [[UIBarButtonItem alloc] initWithCustomView:letfButton];
    self.navigationItem.leftBarButtonItem = LeftBarButton;
    
    
}

- (void)screenAction:(UIButton *)sender
{
    SearchViewController *searchV = [[SearchViewController alloc]init];
    UINavigationController *naV = [[UINavigationController alloc]initWithRootViewController:searchV];
    [searchV setSucceed:^(NSString *str) {
        
        if (str.length > 3) {
            
            letfButton.width = 80+24*(str.length-3);
            letfButton.titleLabel.width = letfButton.titleLabel.bounds.size.width;
            letfButton.imageView.originX = letfButton.width*0.5+15;
        }else{
            
            if (str.length == 3) {
                
                letfButton.width = 80;
                letfButton.titleLabel.width = letfButton.titleLabel.bounds.size.width;
                letfButton.imageView.originX = letfButton.width*0.5+15;
                
            }else{
                
                letfButton.width = 55;
                letfButton.titleLabel.width = letfButton.titleLabel.bounds.size.width;
                letfButton.imageView.originX = letfButton.width*0.5+15;
            }
        }
        
        [letfButton setTitle:str forState:UIControlStateNormal];
        
        NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:str, nil];
        
        //存入数组并同步
        
        [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"cityArr"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
    [self presentViewController:naV animated:YES completion:^{
        
    }];
    
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

- (FitBaseRequest *)request
{
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
                
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publicIcon"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(publicAction)];
                
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h   = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (h) {
        
        return h;
    }
    
    return 220;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    
    UITableViewCell     *cell;
    
    cell    = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        
        return cell;
    }
    
    cell    = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell = [[LMActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.listData.count > indexPath.row) {
        
        ActivityListVO  *vo = [self.listData objectAtIndex:indexPath.row];
        
        if (vo && [vo isKindOfClass:[ActivityListVO class]]) {
            
            [(LMActivityCell *)cell setActivityList:vo index:0] ;
        }
    }
    
    [(LMActivityCell *)cell setXScale:self.xScale yScale:self.yScaleWithAll];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listData.count > indexPath.row) {
        
        ActivityListVO  *vo = [self.listData objectAtIndex:indexPath.row];
        
        if (vo && [vo isKindOfClass:[ActivityListVO class]]) {
            
            LMActivityDetailController *detailVC = [[LMActivityDetailController alloc] init];
            
            detailVC.hidesBottomBarWhenPushed = YES;
            
            detailVC.eventUuid  = vo.EventUuid;
            detailVC.titleStr   = vo.EventName;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (fabs(self.tableView.contentSize.height - (self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.frame) - 49)) < 44.0
        && self.statefulState == FitStatefulTableViewControllerStateIdle
        && [self canLoadMore]) {
        [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _isShow = NO;
    [self.showView dismissView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.showView dismissView];
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



@end
