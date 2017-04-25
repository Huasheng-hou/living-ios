//
//  LMExpertDetailController.m
//  living
//
//  Created by Huasheng on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertDetailController.h"
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
@interface LMExpertDetailController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LMExpertDetailController
{
    NSArray * _articles;
    NSArray * _events;
    NSArray * _voices;
    
    
    LMExpertSpaceVO * expertVO;
    LMExpertDetailView * headerView;
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
    
    headerView = [[LMExpertDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)];
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
        [headerView setValue:expertVO];
        [self refreshData];
    });
    return nil;

}

#pragma mark UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return _articles.count > 2 ? 2 : _articles.count;
    }
    if (section == 1) {
        return _events.count > 2 ? 2 : _events.count;
    }
    if (section == 2) {
        return _voices.count > 2 ? 2 : _voices.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 175;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray * titles = @[@"丨 文章", @"丨 活动", @"丨 课堂"];
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)];
    title.textColor = TEXT_COLOR_LEVEL_4;
    title.font = TEXT_FONT_LEVEL_3;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:titles[section]];
    [attr addAttribute:NSForegroundColorAttributeName value:ORANGE_COLOR range:NSMakeRange(0, 2)];
    title.attributedText = attr;
    [backView addSubview:title];
    
    UILabel * lookMore = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-90-10, 10, 90, 20)];
    lookMore.text = @"更多 >";
    lookMore.tag = section;
    lookMore.textAlignment = NSTextAlignmentRight;
    lookMore.textColor = TEXT_COLOR_LEVEL_4;
    lookMore.font = TEXT_FONT_LEVEL_3;
    lookMore.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMore:)];
    [lookMore addGestureRecognizer:tap];
    [backView addSubview:lookMore];
    
    
    if (section == 0 && _articles.count == 0) {
        lookMore.text = @"暂无更多文章";
        lookMore.userInteractionEnabled = NO;
    }
    if (section == 1 && _events.count == 0) {
        lookMore.text = @"暂无更多活动";
        lookMore.userInteractionEnabled = NO;
    }
    if (section == 2 && _voices.count == 0) {
        lookMore.text = @"暂无更多课程";
        lookMore.userInteractionEnabled = NO;
    }
    
    return backView;
    
}
- (void)lookMore:(UITapGestureRecognizer *)tap{
    NSLog(@"查看更多");
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    switch (tap.view.tag) {
        case 0:
        {
            //文章
            NSLog(@"文章");
            LMMoreArticlesController * maVC = [[LMMoreArticlesController alloc] init];
            maVC.userUuid = self.userUuid;
            [self.navigationController pushViewController:maVC animated:YES];
        }
            break;
        case 1:
        {
            //活动
            NSLog(@"活动");
            LMMoreEventsController * eventVC = [[LMMoreEventsController alloc] init];
            eventVC.userUuid = self.userUuid;
            [self.navigationController pushViewController:eventVC animated:YES];
        }
            break;
        case 2:
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
//    [headerView setValue:expertVO];
    
    if (indexPath.section == 0) {
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
    if (indexPath.section == 1) {
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
    if (indexPath.section == 2) {
        LMExpertHotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotClassCell"];
        if (!cell) {
            cell = [[LMExpertHotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotClassCell"];
        }
        cell.type = 2;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_voices.count > indexPath.row) {
            LMMoreVoicesVO * vo = _voices[indexPath.row];
            [cell setVO:vo];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (_articles.count > indexPath.row) {
            LMMoreArticlesVO * vo = _articles[indexPath.row];
            LMHomeDetailController * detailVC = [[LMHomeDetailController alloc] init];
            detailVC.artcleuuid = vo.articleUuid;
            detailVC.title = vo.articleTitle;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }
    if (indexPath.section == 1) {
        if (_events.count > indexPath.row) {
            LMMoreEventsVO * vo = _events[indexPath.row];
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
    if (indexPath.section == 2) {
        if (_voices.count > indexPath.row) {
            LMMoreVoicesVO * vo = _voices[indexPath.row];
            LMClassroomDetailViewController * detailVC = [[LMClassroomDetailViewController alloc] init];
            detailVC.voiceUUid = vo.voiceUuid;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    
}

@end
