//
//  LMBannerDetailCommonController.m
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMBannerDetailCommonController.h"
#import "HotArticleCell.h"

#import "LMArtcleTypeListRequest.h"
#import "LMActicleVO.h"

#import "LMHomeDetailController.h"
#import "LMHomeVoiceDetailController.h"
#import "LMBannerrequest.h"
#import "BannerVO.h"
#import "LMCategoryEventsRequest.h"
#define PAGE_SIZE 20
@interface LMBannerDetailCommonController ()<UITableViewDelegate, UITableViewDataSource>
@end

@implementation LMBannerDetailCommonController{

    NSString * _category;
    NSInteger _index;
    NSArray * _reviewArr;
    
}
- (id)initWithType:(NSString *)type andIndex:(NSInteger)index
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        //        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
        _category = type;
        _index = index;
        self.current = 1;
    }
    
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.listData.count == 0) {
        
        [self loadNoState];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    if (_index == 2) {
        [self getCategoryArticlesRequest];
    }
    [self loadNewer];
    
}

- (void)createUI{
    [super createUI];
    
    self.tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.contentInset                 = UIEdgeInsetsMake(0, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(0, 0, 102, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}


#pragma mark - 数据请求

- (FitBaseRequest *)request
{
    if (_index == 1) {
        LMArtcleTypeListRequest *request = [[LMArtcleTypeListRequest alloc] initWithPageIndex:self.current andPageSize:PAGE_SIZE andCategory:_category];
        
        return request;
    }
    if (_index == 2) {
        LMCategoryEventsRequest * request = [[LMCategoryEventsRequest alloc] initWithPageIndex:self.current andPageSize:PAGE_SIZE andCategory:_category];
        return request;
    }
    return nil;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSData          *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary    *respDict = [NSJSONSerialization JSONObjectWithData:respData
                                                                options:NSJSONReadingMutableLeaves
                                                                  error:nil];
    
    NSDictionary *headDic = [respDict objectForKey:@"head"];
    NSString    *coderesult         = [headDic objectForKey:@"returnCode"];
    
    if (![coderesult isEqualToString:@"000"]) {
        return nil;
    }

    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    NSString    *result         = [bodyDic objectForKey:@"result"];

    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        
        NSArray *resultArr  = [LMActicleVO LMActicleVOListWithArray:[bodyDic objectForKey:@"list"]];
        if (resultArr && resultArr.count > 0) {
            if (_index == 2) {
                _reviewArr = resultArr;
            }else{
                return resultArr;
            }
        }
    }
    return nil;
}
- (void)getCategoryArticlesRequest{
    LMCategoryEventsRequest * request = [[LMCategoryEventsRequest alloc] initWithPageIndex:self.current andPageSize:PAGE_SIZE andCategory:_category];
    HTTPProxy * proxy = [HTTPProxy loadWithRequest:request completed:^(NSString *resp, NSStringEncoding encoding) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self parseResponse:resp];
        });
    } failed:^(NSError *error) {
        [self textStateHUD:@"网络错误"];
    }];
    [proxy start];
}
#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_index == 1) {
        return self.listData.count;
    }
    if (_index == 2) {
        if (_reviewArr.count > 0) {
            return _reviewArr.count;
        }
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 215;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HotArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[HotArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.cellType = 1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = _category;
    if (_index == 1) {
        if (self.listData.count > indexPath.row) {
            
            LMActicleVO     *vo = self.listData[indexPath.row];
            
            if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
                
                [(HotArticleCell *)cell setValue:vo];
            }
        }
    }
    if (_index == 2) {
        if (_reviewArr.count > indexPath.row) {
            
            LMActicleVO     *vo = _reviewArr[indexPath.row];
            
            if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
                
                [(HotArticleCell *)cell setValue:vo];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.listData.count > indexPath.row) {
        
        LMActicleVO *vo     = [self.listData objectAtIndex:indexPath.row];
        
        if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
            
            if (vo.group&&[vo.group isEqualToString:@"article"]) {
                LMHomeDetailController *detailVC = [[LMHomeDetailController alloc] init];
                
                detailVC.hidesBottomBarWhenPushed = YES;
                detailVC.artcleuuid = vo.articleUuid;
                detailVC.franchisee = vo.franchisee;
                detailVC.sign = vo.sign;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            
            if (vo.group&&[vo.group isEqualToString:@"voice"]) {
                LMHomeVoiceDetailController *detailVC = [[LMHomeVoiceDetailController alloc] init];
                
                detailVC.hidesBottomBarWhenPushed = YES;
                detailVC.artcleuuid = vo.articleUuid;
                detailVC.franchisee = vo.franchisee;
                detailVC.sign = vo.sign;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            
            
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
