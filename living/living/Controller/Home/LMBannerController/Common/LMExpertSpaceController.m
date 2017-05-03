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

@interface LMExpertSpaceController ()

@end

@implementation LMExpertSpaceController
{
    NSArray * _articles;
    NSArray * _events;
    NSArray * _voices;
    
    
    LMExpertSpaceVO * expertVO;
    LMExpertHeadView * headerView;
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

@end
