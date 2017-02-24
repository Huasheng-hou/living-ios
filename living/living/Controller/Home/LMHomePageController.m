//
//  DYHomePageController.m
//  dirty
//
//  Created by Ding on 16/8/23.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMHomePageController.h"
#import "LMActivityDetailController.h"
#import "LMHomeDetailController.h"
#import "LMBannerrequest.h"
#import "LMHomelistequest.h"
#import "LMhomePageCell.h"
#import "LMActicleVO.h"

#import "WJLoopView.h"
#import "LMPublicArticleController.h"
#import "MJRefresh.h"
#import "LMWriterViewController.h"
#import "LMWebViewController.h"

#import "LMArtcleTypeViewController.h"
#import "LMHomeVoiceDetailController.h"
#import "LMClassroomDetailViewController.h"

#import "BannerVO.h"


#import "LMRecommendCell.h"
#import "HotArticleCell.h"
#import "LMHomeBannerView.h"
#import "LMBannerDetailController.h"

#define PAGER_SIZE      20

@interface LMHomePageController ()
<
UITableViewDelegate,
UITableViewDataSource,
LMHomeBannerDelegate
>
//WJLoopViewDelegate,
//LMhomePageCellDelegate

{
    UIView *headView;
    UIBarButtonItem *backItem;
    
    NSIndexPath *deleteIndexPath;
    
    NSInteger        totalPage;
    NSInteger        currentPageIndex;
    
    NSArray         *_bannerArray;
    NSMutableArray  *stateArray;
    
    
    NSArray * sectionList;
    
}

@end

@implementation LMHomePageController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNoState) name:@"reloadHomePage" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNoState) name:@"reloadlist" object:nil];
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.listData.count == 0) {
        
        [self loadNoState];
    }
    
    if (!_bannerArray || _bannerArray.count == 0) {
        
        [self getBannerDataRequest];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"首页";
    
    [self creatUI];
    
    //[self getBannerDataRequest];
    //[self loadNewer];
}

- (void)creatUI
{
    [super createUI];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 49, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    if ([[FitUserManager sharedUserManager] isLogin]) {
        
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(publicAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    sectionList = @[@"腰果推荐", @"热门文章"];
    
    LMHomeBannerView * banner = [[LMHomeBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    banner.delegate = self;
    self.tableView.tableHeaderView = banner;

}

- (void)adjustIndicator:(UIView *)loadingView
{
    if (loadingView) {
        
        for (UIView * subView in loadingView.subviews) {
            
            if ([subView isKindOfClass:[UIActivityIndicatorView class]]) {
                
                subView.center  = CGPointMake(subView.center.x, subView.center.y + 100);
            }
        }
    }
}

#pragma mark 发布文章
- (void)publicAction
{
    LMPublicArticleController *publicVC = [[LMPublicArticleController alloc] init];
    [self.navigationController pushViewController:publicVC animated:YES];
}

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

- (FitBaseRequest *)request
{
    LMHomelistequest    *request    = [[LMHomelistequest alloc] initWithPageIndex:self.current andPageSize:PAGER_SIZE];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSString        *franchisee;
    NSDictionary    *bodyDic        = [VOUtil parseBody:resp];
    
    NSData          *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary    *respDict = [NSJSONSerialization JSONObjectWithData:respData
                                                                options:NSJSONReadingMutableLeaves
                                                                  error:nil];
    
    NSDictionary *headDic = [respDict objectForKey:@"head"];
    NSString    *coderesult         = [headDic objectForKey:@"returnCode"];
    
    if (coderesult && ![coderesult isEqual:[NSNull null]] && [coderesult isKindOfClass:[NSString class]] && [coderesult isEqualToString:@"000"]) {
        
        if ([headDic objectForKey:@"franchisee"] && ![[headDic objectForKey:@"franchisee"] isEqual:[NSNull null]]
            && [[headDic objectForKey:@"franchisee"] isKindOfClass:[NSString class]] && [headDic[@"franchisee"] isEqual:@"yes"]) {
            
            franchisee = @"yes";
        }
    }
    
    NSString    *result         = [bodyDic objectForKey:@"result"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        
        return [LMActicleVO LMActicleVOListWithArray:[bodyDic objectForKey:@"list"]];
        
    } else if (description && ![description isEqual:[NSNull null]] && [description isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:description waitUntilDone:NO];
    }
    
    return nil;
}

#pragma mark banner代理函数
- (void)gotoNextPage:(NSInteger)index{
    
    switch (index) {
        case 10:
        {
            NSLog(@"Yao·美丽");
            LMBannerDetailController * bdVC = [[LMBannerDetailController alloc] init];
            bdVC.title = @"Yao·美丽";
            [self.navigationController pushViewController:bdVC animated:YES];
            break;
        }
        case 11:
        {
            NSLog(@"Yao·健康");
            
            break;
        }
        case 12:
        {
            NSLog(@"Yao·美食");
            
            break;
        }
        case 13:
        {
            NSLog(@"Yao·幸福");
            
            break;
        }
        case 14:
        {
            NSLog(@"Yao·运动");
            
            break;
        }
        case 15:
        {
            NSLog(@"Yao·学习");
            
            break;
        }
        case 16:
        {
            NSLog(@"Yao·干哈");
            
            break;
        }
        
        default:
            break;
    }
    
    
    
}

#pragma mark scrollview代理函数

- (void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index
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
            
            if (vo.KeyUUID && [vo.KeyUUID isKindOfClass:[NSString class]] && ![vo.KeyUUID isEqual:@""]) {
                
                LMClassroomDetailViewController *eventVC = [[LMClassroomDetailViewController alloc] init];
                
                eventVC.hidesBottomBarWhenPushed = YES;
                eventVC.voiceUUid = vo.KeyUUID;
                
                [self.navigationController pushViewController:eventVC animated:YES];
            }
        }
    }
}
#pragma mark tableView代理函数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 4;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        return 110;
    }
    if (indexPath.section == 1) {
        return 215;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = BG_GRAY_COLOR;
    
    if (section == 0) {
        UILabel * headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, tableView.size.width, 40)];
        headerTitle.backgroundColor = [UIColor whiteColor];
        headerTitle.textColor = TEXT_COLOR_LEVEL_3;
        headerTitle.font = TEXT_FONT_LEVEL_3;
        headerTitle.numberOfLines = 2;
        
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"\n   |  腰果推荐"];
        [attr addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0, 6)];
        headerTitle.attributedText = [[NSAttributedString alloc] initWithAttributedString:attr];
        [headerView addSubview:headerTitle];
    }else{
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel * headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, tableView.size.width, 20)];
        headerTitle.backgroundColor = [UIColor whiteColor];
        headerTitle.textColor = TEXT_COLOR_LEVEL_3;
        headerTitle.font = TEXT_FONT_LEVEL_3;
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"   |  热门文章"];
        [attr addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0, 6)];
        headerTitle.attributedText = attr;
        [headerView addSubview:headerTitle];
    }
    
    return headerView;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, 10)];
//    view.backgroundColor = [UIColor whiteColor];
//    
//    return view;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    if (indexPath.section == 0) {
        LMRecommendCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LMRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1) {
        
        HotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[HotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
//    UITableViewCell *cell   = [super tableView:tableView cellForRowAtIndexPath:indexPath];
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
//        cell    = [[LMhomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    
//    if (self.listData.count > indexPath.row) {
//        
//        LMActicleVO     *vo = self.listData[indexPath.row];
//        
//        if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
//            
//        [(LMhomePageCell *)cell setValue:vo];
//        }
//    }
//    
//    cell.tag = indexPath.row;
//    [(LMhomePageCell *)cell setDelegate:self];
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.listData.count > indexPath.row) {
//        
//        LMActicleVO *vo     = [self.listData objectAtIndex:indexPath.row];
//        
//        if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
//            
//            if (vo.group&&[vo.group isEqualToString:@"article"]) {
//                LMHomeDetailController *detailVC = [[LMHomeDetailController alloc] init];
//                
//                detailVC.hidesBottomBarWhenPushed = YES;
//                detailVC.artcleuuid = vo.articleUuid;
//                detailVC.franchisee = vo.franchisee;
//                detailVC.sign = vo.sign;
//                [self.navigationController pushViewController:detailVC animated:YES];
//            }
//            
//            if (vo.group&&[vo.group isEqualToString:@"voice"]) {
//                LMHomeVoiceDetailController *detailVC = [[LMHomeVoiceDetailController alloc] init];
//                
//                detailVC.hidesBottomBarWhenPushed = YES;
//                detailVC.artcleuuid = vo.articleUuid;
//                detailVC.franchisee = vo.franchisee;
//                detailVC.sign = vo.sign;
//                [self.navigationController pushViewController:detailVC animated:YES];
//            }
//            
//
//        }
//    }
//    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark  --cell click delegat

- (void)cellWillClick:(LMhomePageCell *)cell
{
    if (self.listData.count > cell.tag) {
        
        LMActicleVO *vo     = [self.listData objectAtIndex:cell.tag];
        
        if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
            
            LMWriterViewController *writerVC = [[LMWriterViewController alloc] initWithUUid:vo.userUuid];
            writerVC.hidesBottomBarWhenPushed = YES;
            writerVC.franchisee = vo.franchisee;
            writerVC.sign = vo.sign;
            [self.navigationController pushViewController:writerVC animated:YES];
        }
    }
}

- (void)TitlewillClick:(LMhomePageCell *)cell
{
    if (self.listData.count>cell.tag) {
        LMActicleVO *vo     = [self.listData objectAtIndex:cell.tag];
        if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
            
            LMArtcleTypeViewController *writerVC = [[LMArtcleTypeViewController alloc] initWithType:vo.type];
            writerVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:writerVC animated:YES];
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (fabs(self.tableView.contentSize.height - (self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.frame) - 49)) < 44.0
        && self.statefulState == FitStatefulTableViewControllerStateIdle
        && [self canLoadMore]) {
        [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
    }
}

@end
