//
//  LMHostoryEventViewController.m
//  living
//
//  Created by Ding on 2017/2/8.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMHostoryEventViewController.h"
#import "LMActivityDetailController.h"
#import "LMPublishViewController.h"
#import "LMEventOverRequest.h"
#import "LMActivityCell.h"
#import "SQMenuShowView.h"
#import "ActivityListVO.h"
#import "LMMyPublicViewController.h"
#import "SXButton.h"
#import "SearchViewController.h"
#import "FitDatePickerView.h"
#import "LMHostoryView.h"
#import "LMEventUpstoreRequest.h"

#define PAGER_SIZE      20

@interface LMHostoryEventViewController ()
<
LMactivityCellDelegate,
FitDatePickerDelegate
>
{
    UIBarButtonItem *backItem;
    UIImageView *homeImage;
    
    NSIndexPath *deleteIndexPath;
    
    NSInteger        totalPage;
    NSInteger        currentPageIndex;
    NSMutableArray   *pageIndexArray;
    BOOL                reload;
    NSString         *city;
    LMHostoryView    *hostoryView;
    NSInteger  dateIndex;
}
@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;

@end

@implementation LMHostoryEventViewController

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
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
    
    
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
    
    
    LMEventOverRequest   *request    = [[LMEventOverRequest alloc] initWithPageIndex:self.current andPageSize:PAGER_SIZE andUser_uuid:[FitUserManager sharedUserManager].uuid];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
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
    imageLb.text = @"您还没有发布活动哦\n赶快去发布活动吧~";
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
            
            [(LMActivityCell *)cell setActivityList:vo index:3] ;
            [(LMActivityCell *)cell setDelegate:self];
        }
    }
    [(LMActivityCell *)cell setTag: indexPath.row];
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
    if (fabs(self.tableView.contentSize.height - (self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.frame))) < 44.0
        && self.statefulState == FitStatefulTableViewControllerStateIdle
        && [self canLoadMore]) {
        [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
    }
}

-(void)cellWillClick:(LMActivityCell *)cell
{
    
    hostoryView = [[LMHostoryView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [[[UIApplication sharedApplication].windows lastObject] addSubview:hostoryView];
    
    
    [hostoryView.startButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [hostoryView.finishButton addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
    
    hostoryView.upstoreButton.tag = cell.tag;
    [hostoryView.upstoreButton addTarget:self action:@selector(upstoreAction:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"%ld",(long)cell.tag);
    
}

- (void)startAction:(UIButton *)sender
{
    NSLog(@"开始时间~~~~");
    dateIndex = 0;
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate;
    
    currentDate = [NSDate date];
    
    [FitDatePickerView showWithMinimumDate:currentDate
                               MaximumDate:[formatter dateFromString:@"2950-01-01"]
                               CurrentDate:currentDate
                                      Mode:UIDatePickerModeDateAndTime
                                  Delegate:self];
}

- (void)finishAction:(UIButton *)sender
{
    NSLog(@"结束时间~~~~");
    
    dateIndex = 1;
    
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate;
    if ([hostoryView.startButton.textLabel.text isEqual:@"请选择开始时间          "]) {
        currentDate = [NSDate date];
    }else{
        
        NSString *dateString=hostoryView.startButton.textLabel.text;
        
        currentDate=[formatter dateFromString:dateString];
        
    }
    
    [FitDatePickerView showWithMinimumDate:currentDate
                               MaximumDate:[formatter dateFromString:@"2950-01-01 00:00:00"]
                               CurrentDate:currentDate
                                      Mode:UIDatePickerModeDateAndTime
                                  Delegate:self];
}

- (void)upstoreAction:(UIButton *)sender
{
    NSLog(@"上架~~~~");
    NSLog(@"sender.tag           %ld",(long)sender.tag);
     ActivityListVO  *vo = [self.listData objectAtIndex:sender.tag];
    [hostoryView removeFromSuperview];
    LMEventUpstoreRequest *request = [[LMEventUpstoreRequest alloc] initWithevent_uuid:vo.EventUuid andstart_time:hostoryView.startButton.textLabel.text andend_time:hostoryView.finishButton.textLabel.text];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(upstoreRespond:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];

                                           }];
    [proxy start];
    
}

- (void)upstoreRespond:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"重新上架失败~"];
        return;
    }
    NSString *result    = [bodyDic objectForKey:@"result"];
    
    if (result && [result intValue] == 0){
        [self textStateHUD:@"已重新上架~"];
        [self loadNoState];
    }
}


#pragma mark - 日期选择

- (void)didSelectedDate:(NSDate *)date
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    if (dateIndex == 0) {
        
        hostoryView.startButton.textLabel.text   = [formatter stringFromDate:date];
    }
    if (dateIndex == 1) {
        
        hostoryView.finishButton.textLabel.text   = [formatter stringFromDate:date];
    }
}




@end
