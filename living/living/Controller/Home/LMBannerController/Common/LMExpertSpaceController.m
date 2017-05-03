//
//  LMExpertSpaceController.m
//  living
//
//  Created by hxm on 2017/5/3.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertSpaceController.h"
#import "LMPublicArticleController.h"
#import "LMExpertDetailView.h"
#import "LMExpertHotArticleCell.h"
#import "LMExpertListCell.h"
#import "LMNewHotArticleCell.h"

#import "LMArtcleTypeListRequest.h"

#import "LMMoreArticlesController.h"
#import "LMMoreEventsController.h"
#import "LMMoreClassController.h"

#import "LMExpertSpaceRequest.h"
#import "LMExpertSpaceVO.h"

#import "LMHomeDetailController.h"
#import "LMActivityDetailController.h"
#import "LMHomeVoiceDetailController.h"
#import "LMClassroomDetailViewController.h"
#import "LMEventDetailViewController.h"

#import "LMExpertHeadView.h"
#import "LMExpertFootView.h"

@interface LMExpertSpaceController ()<LMExpertFootViewDelegate,LMExpertHeadViewDelegate>

@end

@implementation LMExpertSpaceController
{
    NSArray * _articles;
    NSArray * _events;
    NSArray * _voices;
    
    
    LMExpertSpaceVO * expertVO;
    LMExpertHeadView * headerView;
    LMExpertFootView * footerView;
    
}
- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self loadNewer];
}

- (void)createUI{
    [super createUI];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BG_GRAY_COLOR;
    
    headerView = [[LMExpertHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    
}

#pragma mark - 请求达人空间数据
- (FitBaseRequest *)request{
    
    [self initStateHud];
    
    LMExpertSpaceRequest * request = [[LMExpertSpaceRequest alloc] initWithUserUuid:self.userUuid];
    return request;
}
- (NSArray *)parseResponse:(NSString *)resp{
    NSData * respData = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * respDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * headDic = [respDic objectForKey:@"head"];
    if (![headDic[@"returnCode"] isEqualToString:@"000"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:@"请求失败"];
        });
        return nil;
    }
    
    NSDictionary * bodyDic = [VOUtil parseBody:resp];
    if (![bodyDic[@"result"] isEqualToString:@"0"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:@"请求失败"];
        });
        return nil;
    }
    //处理返回数据
    //达人信息 model存到headerView
    expertVO = [[LMExpertSpaceVO alloc] initWithDictionary:bodyDic[@"userInfo"]];
    
    //文章 model存到_articles
    _articles = [LMMoreArticlesVO LMMoreArticlesVOWithArray:[bodyDic objectForKey:@"articles_body"]];
    
    
    //活动 model存到_events
    _events = [LMMoreEventsVO LMMoreEventsVOListWithArray:[bodyDic objectForKey:@"events_body"]];
    
    
    //课堂 model存到_voices
    _voices = [LMMoreVoicesVO LMMoreVoicesVOWithArray:[bodyDic objectForKey:@"voices_body"]];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideStateHud];
        [headerView setData:expertVO];
        UIView * view = self.tableView.tableHeaderView;
        view.height = headerView.cellH;
        [self.tableView beginUpdates];
        [self.tableView setTableHeaderView:view];
        
        [self.tableView endUpdates];
        [self refreshData];
    });
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 165;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView * subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    footerView = [[LMExpertFootView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 165)];
    footerView.delegate = self;
    [footerView setDataWithArticle:_articles andEvents:_events andVoices:_voices];
    [cell.contentView addSubview:footerView];
    
    return cell;
}

- (void)gotoListPage:(NSInteger)index{
    switch (index) {
        case 100:
        {
            //文章
            NSLog(@"文章");
            LMMoreArticlesController * maVC = [[LMMoreArticlesController alloc] init];
            maVC.userUuid = self.userUuid;
            [self.navigationController pushViewController:maVC animated:YES];
        }
            break;
        case 101:
        {
            //活动
            NSLog(@"活动");
            LMMoreEventsController * eventVC = [[LMMoreEventsController alloc] init];
            eventVC.userUuid = self.userUuid;
            [self.navigationController pushViewController:eventVC animated:YES];
        }
            break;
        case 102:
        {
            //课程
            NSLog(@"课程");
            LMMoreClassController * classVC = [[LMMoreClassController alloc] init];
            classVC.userUuid = self.userUuid;
            [self.navigationController pushViewController:classVC animated:YES];
        }
            break;
        default:
            break;
    }

}

- (void)gotoDetailPage:(NSInteger)index{
    
    if (index == 10 || index == 11) {
        if (_articles.count > index-10) {
            LMMoreArticlesVO * vo = _articles[index-10];
            LMHomeDetailController * detailVC = [[LMHomeDetailController alloc] init];
            detailVC.artcleuuid = vo.articleUuid;
            detailVC.title = vo.articleTitle;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }
    if (index == 20 || index == 21) {
        if (_events.count > index-20) {
            LMMoreEventsVO * vo = _events[index-20];
            if (vo.type && [vo.type isEqualToString:@"event"]) {
                LMActivityDetailController * detailVC = [[LMActivityDetailController alloc] init];
                detailVC.eventUuid = vo.eventUuid;
                detailVC.titleStr = vo.eventName;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            if (vo.type && [vo.type isEqualToString:@"item"]) {
                LMEventDetailViewController * detailVC = [[LMEventDetailViewController alloc] init];
                detailVC.eventUuid = vo.eventUuid;
                detailVC.titleStr = vo.eventName;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            
        }
    }
    if (index == 30 || index == 31) {
        if (_voices.count > index-30) {
            LMMoreVoicesVO * vo = _voices[index-30];
            LMClassroomDetailViewController * detailVC = [[LMClassroomDetailViewController alloc] init];
            detailVC.voiceUUid = vo.voiceUuid;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }

    
}

@end
