//
//  LMBannerDetailExpertController.m
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMBannerDetailExpertController.h"
#import "LMExpertListCell.h"
#import "LMExpertHotArticleCell.h"
#import "LMExpertDetailController.h"

#import "LMNewHotArticleCell.h"
#import "LMExpertListController.h"
#import "LMArtcleTypeListRequest.h"

#import "LMExpertListRequest.h"
#import "LMExpertRecommendRequest.h"
#import "LMExpertArticlesRequest.h"
#import "LMExpertEventsRequest.h"
#import "LMExpertVoicesRequest.h"
#import "LMRecommendExpertVO.h"
#import "LMExpertListVO.h"
#import "LMMoreArticlesVO.h"
#import "LMMoreEventsVO.h"
#import "LMMoreVoicesVO.h"
#import "LMAllRecommendRequest.h"

#define PAGE_SIZE 20
@interface LMBannerDetailExpertController ()<UITableViewDelegate,UITableViewDataSource,LMExpertListDelegate>

@end

@implementation LMBannerDetailExpertController
{
    NSString * _category;
    
    NSArray * _expertList;
    NSArray * _recommendExpert;
    NSArray * _articles;
    NSArray * _events;
    NSArray * _voices;
    
}
- (instancetype)initWithType:(NSString *)type{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
        _category = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    //[self getArticlesRequest];
    [self loadNewer];
}

- (void)createUI{
    
    [super createUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 102, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 102, 0);
    self.pullToRefreshView.defaultContentInset = UIEdgeInsetsMake(0, 0, 102, 0);
    
}
#pragma mark - 官方推荐达人数据请求
- (FitBaseRequest *)request{
    
    [self getArticlesRequest];
    
    LMExpertRecommendRequest * request = [[LMExpertRecommendRequest alloc] initWithCategory:_category];
    return request;
}
- (NSArray *)parseResponse:(NSString *)resp{
    
    NSData * respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary * respDic = [NSJSONSerialization JSONObjectWithData:respData
                                                             options:NSJSONReadingMutableLeaves
                                                               error:nil];
    NSDictionary * headDic = [respDic objectForKey:@"head"];
    if (![[headDic objectForKey:@"returnCode"] isEqualToString:@"000"]) {
        return nil;
    }
    NSDictionary * bodyDic = [VOUtil parseBody:resp];
    NSString * desp = [bodyDic objectForKey:@"description"];
    if ([[bodyDic objectForKey:@"result"] isEqualToString:@"0"]) {
        
        NSArray * list = [bodyDic objectForKey:@"list"];
        if (list.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self textStateHUD:@"达人数据请求失败"];
            });
            
        }
        _recommendExpert = [LMRecommendExpertVO LMRecommendExpertVOListWithArray:[bodyDic objectForKey:@"list"]];
        return _recommendExpert;
    }else if (desp && ![desp isEqual:[NSNull null]] && [desp isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:)
                               withObject:desp
                            waitUntilDone:NO];
    }
    return nil;

}
#pragma mark - 官方推荐文章、活动、课程
- (void)getArticlesRequest{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LMAllRecommendRequest * request = [[LMAllRecommendRequest alloc] initWithCategory:_category];
    HTTPProxy * proxy = [HTTPProxy loadWithRequest:request
                                         completed:^(NSString *resp, NSStringEncoding encoding) {
                                             
                                             [self performSelectorOnMainThread:@selector(parseData:)
                                                                    withObject:resp
                                                                 waitUntilDone:YES];
                                             
                                         }
                                            failed:^(NSError *error) {
                                                [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                       withObject:@"网络错误"
                                                                    waitUntilDone:YES];
                                            }];

     [proxy start];
}
- (void)parseData:(NSString *)resp{
    
    NSData * respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary * respDic = [NSJSONSerialization JSONObjectWithData:respData
                                                             options:NSJSONReadingMutableLeaves
                                                               error:nil];
    NSDictionary * headDic = [respDic objectForKey:@"head"];
    if (![[headDic objectForKey:@"returnCode"] isEqualToString:@"000"]) {
        return ;
    }
    NSDictionary * bodyDic = [VOUtil parseBody:resp];
    NSString * desp = [bodyDic objectForKey:@"description"];
    if ([[bodyDic objectForKey:@"result"] isEqualToString:@"0"]) {
        _events = [LMMoreEventsVO LMMoreEventsVOListWithArray:[bodyDic objectForKey:@"events_body"]];
        _articles = [LMMoreArticlesVO LMMoreArticlesVOWithArray:[bodyDic objectForKey:@"articles_body"]];
        _voices = [LMMoreVoicesVO LMMoreVoicesVOWithArray:[bodyDic objectForKey:@"voices_body"]];
        
        if (_events.count == 0 || _articles.count == 0 || _voices.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self textStateHUD:@"请求失败"];
            });
            
        }
        
        [self.tableView reloadData];
        
    }else if (desp && ![desp isEqual:[NSNull null]] && [desp isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:desp waitUntilDone:NO];
    }

    
}
#pragma mark tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (self.listData.count == 0) {
            return 0;
        }
        return 100;
    }
//    if (indexPath.row == 0) {
//        return _articles.count > 0 ? 210 - 35 : 0;
//    }
//    if (indexPath.row == 1) {
//        return _events.count > 0 ? 210 - 35 : 0;
//    }
//    if (indexPath.row == 2) {
//        return _voices.count > 0 ? 210 - 35 : 0;
//    }
    return 175;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nameList = @[@"| 腰果达人", @"| 热门文章", @"| 热门活动", @"| 热门课程"];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    titleLabel.textColor = TEXT_COLOR_LEVEL_3;
    titleLabel.font = TEXT_FONT_LEVEL_3;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:nameList[section]];
    [attr addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0, 2)];
    titleLabel.attributedText = attr;
    [headerView addSubview:titleLabel];
    if (section == 0) {
        UILabel * lookMore = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-60-10, 10, 60, 20)];
        lookMore.text = @"更多 >";
        lookMore.textAlignment = NSTextAlignmentRight;
        lookMore.textColor = TEXT_COLOR_LEVEL_3;
        lookMore.font = TEXT_FONT_LEVEL_3;
        lookMore.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMore:)];
        [lookMore addGestureRecognizer:tap];
        [headerView addSubview:lookMore];
    }
    return headerView;
}
- (void)lookMore:(UITapGestureRecognizer *)tap{
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    LMExpertListController * listVC = [[LMExpertListController alloc] init];
    listVC.title = @"达人";
    listVC.category = _category;
    [self.navigationController pushViewController:listVC animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        LMExpertListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[LMExpertListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.count = _recommendExpert.count;
        cell.delegate = self;
        if (_recommendExpert.count > indexPath.row) {
            cell.count = _recommendExpert.count;
        
            [cell setArray:_recommendExpert];
            
        }
        return cell;
    }
    if (indexPath.section == 1) {
        LMNewHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotArticleCell"];
        if (!cell) {
            cell = [[LMNewHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotArticleCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_articles.count > indexPath.row) {
            LMMoreArticlesVO * vo = _articles[indexPath.row];
            [cell setArticleVO:vo];
        }
        return cell;

    }
    if (indexPath.section == 2) {
        LMExpertHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotEventCell"];
        if (!cell) {
            cell = [[LMExpertHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotEventCell"];
        }
        cell.type = 1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_events.count > indexPath.row) {
            LMMoreEventsVO * vo = _events[indexPath.row];
            [cell setVO:vo];
        }
        return cell;
    }
    if (indexPath.section == 3) {
        LMExpertHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotClassCell"];
        if (!cell) {
            cell = [[LMExpertHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotClassCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_voices.count > indexPath.row) {
            LMMoreVoicesVO * vo = _voices[indexPath.row];
            [cell setVO:vo];
        }
        return cell;
    }
    return nil;
}

#pragma mark 点击达人头像进入详情代理方法
- (void)gotoNextPage:(NSInteger)index{
    
    LMExpertDetailController * vc = [[LMExpertDetailController alloc] init];
    
    LMExpertListVO * vo = _recommendExpert[index];
    vc.userUuid = vo.userUuid;
    vc.title = [NSString stringWithFormat:@"%@的空间", vo.nickName];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
