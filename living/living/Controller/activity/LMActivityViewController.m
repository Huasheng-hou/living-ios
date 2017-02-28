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

#import "LMBannerrequest.h"
#import "BannerVO.h"
#import "WJLoopView.h"

#import "LMActivityLifeHouseCell.h"
#import "LMActivityApplyCell.h"
#import "LMActivityExperienceCell.h"

#import "LMEvaluateViewController.h"

#define PAGER_SIZE      20

@interface LMActivityViewController ()
<
WJLoopViewDelegate,
doSomethingForActivityDelegate
>
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
    
    UIView *headView; //头部视图
    NSArray         *_bannerArray;
    NSMutableArray  *stateArray;
}
@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;

@end

@implementation LMActivityViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
//    self = [super initWithStyle:UITableViewStyleGrouped];
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
    
    [self getBannerDataRequest];

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
    
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)];
    headView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headView;
    
    NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityArr"];
    NSString *cityStr;
    for (NSString *string in searchArr) {
        cityStr = string;
    }
    
    // 设置导航栏左侧按钮
    /*
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
     */
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
}

// rightBarButton selected
- (void)rightBarButtonPressed:(UIBarButtonItem *)barButtonItem
{
    printf("aaa");
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

#pragma mark - 网络连接

- (void)getBannerDataRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    LMBannerrequest *request = [[LMBannerrequest alloc] init];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   NSDictionary *bodyDict   = [VOUtil parseBody:resp];
                                                   
                                                   NSString     *result     = [bodyDict objectForKey:@"result"];
                                                   
                                                   if (result && ![result isEqual:[NSNull null]] && [result isEqualToString:@"0"]) {
                                                       
                                                       _bannerArray = [BannerVO BannerVOListWithArray:[bodyDict objectForKey:@"banners"]];
                                                       
                                                       if (!_bannerArray || ![_bannerArray isKindOfClass:[NSArray class]] || _bannerArray.count < 1) {
                                                           
                                                           headView.backgroundColor = BG_GRAY_COLOR;
                                                       } else {
                                                           
                                                           for (UIView *subView in headView.subviews) {
                                                               
                                                               [subView removeFromSuperview];
                                                           }
                                                           
                                                           NSMutableArray   *imgUrls    = [NSMutableArray new];
                                                           stateArray  = [NSMutableArray new];
                                                           
                                                           for (BannerVO *vo in _bannerArray) {
                                                               
                                                               if (vo && [vo isKindOfClass:[BannerVO class]] && vo.LinkUrl) {
                                                                   
                                                                   [imgUrls addObject:vo.LinkUrl];
                                                               }
                                                               if (vo && [vo isKindOfClass:[BannerVO class]] && vo.KeyUUID) {
                                                                   
                                                                   [stateArray addObject:vo.KeyUUID];
                                                               }
                                                           }
                                                           
                                                           WJLoopView *loopView = [[WJLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)
                                                                                                           delegate:self
                                                                                                          imageURLs:imgUrls
                                                                                                   placeholderImage:nil
                                                                                                       timeInterval:8
                                                                                     currentPageIndicatorITintColor:nil
                                                                                             pageIndicatorTintColor:nil];
                                                           
                                                           loopView.location = WJPageControlAlignmentRight;
                                                           
                                                           [headView addSubview:loopView];
                                                       }
                                                   }
                                               });
                                               
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

#pragma mark - WJLoopViewDelegate
-(void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index
{
    NSLog(@"---------------%ld",(long)index);
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    if (section == 1) {
        count = 2;
    }else{
        count = 1;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h   = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        h = 144;
    }
    
    if (h) {
        
        return h;
    }
    
    return 220;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    sectionTitleView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 22, 2, 12)];
    imageView.backgroundColor = ORANGE_COLOR;
    [sectionTitleView addSubview:imageView];
    
    UILabel *sectionTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 20, kScreenWidth - 17, 15)];
    switch (section) {
        case 0:
            sectionTitleLbl.text = @"遇见生活馆";
            break;
        case 1:
            sectionTitleLbl.text = @"活动报名";
            break;
        case 2:
            sectionTitleLbl.text = @"项目体验";
            break;
            
        default:
            break;
    }
    sectionTitleLbl.font = TEXT_FONT_LEVEL_2;
    sectionTitleLbl.textColor = TEXT_COLOR_LEVEL_3;
    [sectionTitleView addSubview:sectionTitleLbl];
    
    
    return sectionTitleView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
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
     */
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil){
        switch (indexPath.section) {
            case 0:{
                static NSString * LifeHouseCellId = @"LifeHouseCell";
                LMActivityLifeHouseCell *lifeHousecell = [[LMActivityLifeHouseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LifeHouseCellId];
                __weak __block LMActivityViewController *copy_self = self;
                lifeHousecell.btnPressedBlock = ^(NSInteger btnTag){
//                    [copy_self ]
                    // 选择生活馆活动
//                    [copy_self pushEvaluateSuccessView];
                    printf("%ld",btnTag);
                };
                cell = lifeHousecell;
                break;
            }
            case 1:{
                static NSString *ApplyCellId = @"ApplyCell";
                LMActivityApplyCell *applycell = [[LMActivityApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ApplyCellId];
                cell = applycell;
                break;
            }
            case 2:{
                static NSString *ExperienceCellId = @"ExperienceCell";
                LMActivityExperienceCell *experiencecell = [[LMActivityExperienceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ExperienceCellId];
                experiencecell.delegate = self;
                cell = experiencecell;
                
                break;
            }
                
            default:
                break;
        }
        
    }
    return  cell;
    
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


#pragma mark - doSomethingForActivityDelegate

- (void)like
{
    printf("aaa");
}

- (void)share
{
    printf("aa");
}

- (void)comment
{
    printf("a");
}

- (void)grade
{
    LMEvaluateViewController *vc =[[LMEvaluateViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
