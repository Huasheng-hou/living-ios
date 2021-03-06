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
#import "LMHomeDetailController.h"
#import "LMHomeVoiceDetailController.h"
#import "LMWebViewController.h"
#import "LMClassroomDetailViewController.h"
#import "LMAllActivityController.h"
#import "LMAllEventController.h"
#import "LMPublicArticleController.h"
#import "LMEventListRequest.h"
#import "LMEventListVO.h"
#import "LMEventDetailViewController.h"
#import "LMPublicEventController.h"
#import "LMSpecialRechargeController.h"

#import "LMSegmentViewController.h"


#define PAGER_SIZE      20

@interface LMActivityViewController ()
<
WJLoopViewDelegate
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
    NSArray * _eventsArray;
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.showView dismissView];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatUI];
    //[self creatImage];

    [self loadNewer];
    
    __weak typeof(self) weakSelf = self;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
        if (index==0) {
            LMPublishViewController *publicVC = [[LMPublishViewController alloc] init];
            [publicVC setHidesBottomBarWhenPushed:YES];
            publicVC.title = @"发布活动";
            [self.navigationController pushViewController:publicVC animated:YES];
        }
        
        if (index==1) {
            LMPublicEventController *publicVC = [[LMPublicEventController alloc] init];
            publicVC.title = @"发布项目";
            [publicVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:publicVC animated:YES];
        }
        
        if (index==2) {
            LMMyPublicViewController *myfVC = [[LMMyPublicViewController alloc] init];
            [myfVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myfVC animated:YES];
        }
    }];
}


- (void)creatUI
{
    [super createUI];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:TEXT_COLOR_LEVEL_2};
    self.navigationController.navigationBar.tintColor = TEXT_COLOR_LEVEL_2;
    if ([[FitUserManager sharedUserManager].privileges isEqual:@"special"]) {
    
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
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
}

#pragma mark - 请求轮播图数据
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
                                                   [self parseBannerResp:resp];
                                               });
                                               
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}
- (void)parseBannerResp:(NSString *)resp{
    
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
    }else{
        
    }
}
#pragma mark - WJLoopViewDelegate
-(void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index
{
    if (_bannerArray.count>index) {
        
        BannerVO *vo = _bannerArray[index];
        //活动
        if ([vo.Type isEqualToString:@"event"]) {
            
            if (vo.KeyUUID && [vo.KeyUUID isKindOfClass:[NSString class]] && ![vo.KeyUUID isEqual:@""]){
                
                LMActivityDetailController *eventVC = [[LMActivityDetailController alloc] init];
                
                eventVC.hidesBottomBarWhenPushed = YES;
                eventVC.eventUuid = vo.KeyUUID;
                
                [self.navigationController pushViewController:eventVC animated:YES];
            }
        }
        //项目
        if ([vo.Type isEqualToString:@"item"]) {
            
            if (vo.KeyUUID && [vo.KeyUUID isKindOfClass:[NSString class]] && ![vo.KeyUUID isEqual:@""]){
                
                LMEventDetailViewController *eventVC = [[LMEventDetailViewController alloc] init];
                
                eventVC.hidesBottomBarWhenPushed = YES;
                eventVC.eventUuid = vo.KeyUUID;
                
                [self.navigationController pushViewController:eventVC animated:YES];
            }
        }
        //文章
        if ([vo.Type isEqualToString:@"article"]) {
            
            if (vo.KeyUUID && [vo.KeyUUID isKindOfClass:[NSString class]] && ![vo.KeyUUID isEqual:@""]) {
                
                LMHomeDetailController *eventVC = [[LMHomeDetailController alloc] init];
                
                eventVC.hidesBottomBarWhenPushed = YES;
                eventVC.artcleuuid = vo.KeyUUID;
                
                [self.navigationController pushViewController:eventVC animated:YES];
            }
        }
        //web
        if ([vo.Type isEqualToString:@"web"]) {
            
            if (vo.webUrl && [vo.webUrl isKindOfClass:[NSString class]] && ![vo.webUrl isEqualToString:@""]) {
                
                LMWebViewController *webVC = [[LMWebViewController alloc] init];
                
                webVC.hidesBottomBarWhenPushed  = YES;
                webVC.titleString               = vo.webTitle ;
                webVC.urlString                 = vo.webUrl;
                
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
        //语音课堂
        if ([vo.Type isEqualToString:@"voice"]) {
            
//            if (vo.KeyUUID && [vo.KeyUUID isKindOfClass:[NSString class]] && ![vo.KeyUUID isEqual:@""]) {
            
                LMSegmentViewController *segmentVC = [[LMSegmentViewController alloc] init];
                
//                eventVC.hidesBottomBarWhenPushed = YES;
//                eventVC.voiceUUid = vo.KeyUUID;
                segmentVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:segmentVC animated:YES];
//            }
        }
        //大礼包
        if ([vo.Type isEqualToString:@"recharge"]) {
            
            LMSpecialRechargeController *reVC = [[LMSpecialRechargeController alloc] init];
            
            [reVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:reVC animated:YES];
        
        }

    }

}
#pragma  mark - 请求活动数据
- (FitBaseRequest *)request
{
    [self getBannerDataRequest];
    [self getEventsRequest];
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
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
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
#pragma mark - 请求项目数据
- (void)getEventsRequest{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LMEventListRequest * request = [[LMEventListRequest alloc] initWithPageIndex:1 andPageSize:PAGER_SIZE andCity:nil];
    HTTPProxy * proxy = [HTTPProxy loadWithRequest:request
                                         completed:^(NSString *resp, NSStringEncoding encoding) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 
                                                 [self parseEventsResponse:resp];
                                             });
                                         }
                                            failed:^(NSError *error) {
                                                [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                       withObject:@"网络错误"
                                                                    waitUntilDone:YES];
                                            }];
    
    
    [proxy start];
}
- (void)parseEventsResponse:(NSString *)resp{
    
    NSData * respData = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * respDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * headDic = [respDic objectForKey:@"head"];
    if (![headDic[@"returnCode"] isEqualToString:@"000"]) {
        [self textStateHUD:@"验证失败"];
        
        return;
    }
    
    NSDictionary * bodyDic = [VOUtil parseBody:resp];
    if (![bodyDic[@"result"] isEqualToString:@"0"]) {
        [self textStateHUD:@"请求数据失败"];
        
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideStateHud];
    });
    NSArray * list = [bodyDic objectForKey:@"list"];
    _eventsArray = [LMEventListVO EventListVOListWithArray:list];
    
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

#pragma mark - tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.listData.count > 2 ? 2 : self.listData.count;
    }
    return _eventsArray.count > 2 ? 2 : _eventsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 195;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.listData.count > 0 ? 40 : 0;
    }
    return  _eventsArray.count > 0 ? 40 : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    sectionTitleView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 2, 12)];
    imageView.backgroundColor = ORANGE_COLOR;
    [sectionTitleView addSubview:imageView];
    
    UILabel *sectionTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 12, kScreenWidth - 17, 15)];
    switch (section) {
        case 0:
            sectionTitleLbl.text = @"活动";
            break;
        case 1:
            sectionTitleLbl.text = @"项目";
            break;
        default:
            break;
    }
    sectionTitleLbl.font = TEXT_FONT_LEVEL_2;
    sectionTitleLbl.textColor = TEXT_COLOR_LEVEL_3;
    [sectionTitleView addSubview:sectionTitleLbl];
    
    UILabel * more = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-100, 12, 90, 15)];
    more.text = @"更多 >";
    more.tag = section+100;
    more.textColor = TEXT_COLOR_LEVEL_3;
    more.font = TEXT_FONT_LEVEL_2;
    more.textAlignment = NSTextAlignmentRight;
    more.userInteractionEnabled = YES;
    [more addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allList:)]];
    [sectionTitleView addSubview:more];
    
    return sectionTitleView;
}

//进入全量列表
- (void)allList:(UITapGestureRecognizer *)tap{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    switch (tap.view.tag) {
        case 100:
        {
            //NSLog(@"更多活动");
            LMAllActivityController * allAC = [[LMAllActivityController alloc] init];
            allAC.title = @"活动";
            [self.navigationController pushViewController:allAC animated:YES];
            
            
        }
            break;
        case 101:
        {
            //NSLog(@"更多项目");
            LMAllEventController * allEvent = [[LMAllEventController alloc] init];
            allEvent.title = @"项目";
            [self.navigationController pushViewController:allEvent animated:YES];
        }
            break;
        default:
            break;
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        switch (indexPath.section) {
            case 0:{
                static NSString *ApplyCellId = @"activityCell";
                LMActivityApplyCell * cell = [tableView dequeueReusableCellWithIdentifier:ApplyCellId];
                if (!cell) {
                    cell = [[LMActivityApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ApplyCellId];
                }
                if (self.listData.count > indexPath.row) {
                    ActivityListVO * vo = self.listData[indexPath.row];
                    [cell setVO:vo];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                break;
            }
            case 1:{
                static NSString *EventCellId = @"EventCell";
                LMActivityExperienceCell * cell = [tableView dequeueReusableCellWithIdentifier:EventCellId];
                if (!cell) {
                    cell = [[LMActivityExperienceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventCellId];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (_eventsArray.count > indexPath.row) {
                    LMEventListVO * vo = _eventsArray[indexPath.row];
                    [cell setVO:vo];
                }
                return cell;
                break;
            }
            default:
                break;
        }
    
    return  nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
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
    }
    if (indexPath.section == 1) {
        if (_eventsArray.count > indexPath.row) {
            LMEventListVO * vo = _eventsArray[indexPath.row];
            LMEventDetailViewController * detailVC = [[LMEventDetailViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.eventUuid = vo.eventUuid;
            detailVC.titleStr = vo.eventName;
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

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    _isShow = NO;
//    [self.showView dismissView];
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.showView dismissView];
}

- (SQMenuShowView *)showView{
    
    if (_showView) {
        return _showView;
    }
    NSArray *array = @[@"发布活动",@"发布项目", @"我的活动"];
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){CGRectGetWidth(self.view.frame)-100-10,64,100,0}
                                               items:array
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-25,10}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    return _showView;
}


@end
