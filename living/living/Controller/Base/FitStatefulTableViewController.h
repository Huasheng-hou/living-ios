
//
//  FitStatefulTableViewController.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/21.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitTableViewController.h"
#import "FitBaseRequest.h"
#import "SSPullToRefresh.h"

typedef enum {
    FitStatefulTableViewControllerStateIdle = 0,
    FitStatefulTableViewControllerStateInitialLoading = 1,
    FitStatefulTableViewControllerStateLoadingFromPullToRefresh = 2,
    FitStatefulTableViewControllerStateLoadingNextPage = 3,
    FitStatefulTableViewControllerStateEmpty = 4,
    FitStatefulTableViewControllerError = 5,
} FitStatefulTableViewControllerState;

@interface FitStatefulTableViewController : FitTableViewController <SSPullToRefreshViewDelegate>
{
    HTTPProxy * table_proxy;
}

@property (nonatomic, strong)   SSPullToRefreshView     *       pullToRefreshView;
@property (nonatomic, strong)   NSMutableArray          *       listData;

@property (nonatomic)           FitStatefulTableViewControllerState   statefulState;

@property (strong, nonatomic)   UIView      *       idleView;
@property (strong, nonatomic)   UIView      *       emptyView;
@property (strong, nonatomic)   UIView      *       loadingView;
@property (strong, nonatomic)   UIView      *       errorView;

@property (assign, nonatomic)   BOOL    ifAddPullToRefreshControl;
@property (assign, nonatomic)   BOOL    ifShowTableSeparator;
@property (assign, nonatomic)   BOOL    isCountingRows;
@property (assign, nonatomic)   BOOL    ifRemoveLoadNoState;
@property (assign, nonatomic)   BOOL    ifDelayLoad;
@property (assign, nonatomic)   BOOL    ifShowLoadingState;
@property (assign, nonatomic)   BOOL    ifProcessLoadFirst;
@property (assign, nonatomic)   BOOL    ifLoadReverse;
@property (nonatomic)           int     current;
@property (nonatomic)           int     max;

- (id) initWithStyle:(UITableViewStyle)style;

// * 清空当前数据，然后重新加载，一般在viewDidLoad中调用，在调用此方法前需要先调用createUI
//
- (void)loadNewer;

// * 不清空数据，直接重新加载，加载成功后替换当前数据
//
- (void)loadNoState;

// * 私有方法，下拉刷新，刷新时不清空之前的数据
- (void)loadFromPullToRefresh;

// * 私有方法，加载第一页，被loadNewer, loadNoState 和 loadFromPullToRefresh 调用
- (void)loadFirstPage;

// * 私有方法，加载下一页，执行翻页操作，在scrollView 的代理方法中，当判断以滚动到底部且能够加载下一页时被调用
- (void)loadNextPage;

// * 被子类覆写，返回当前需要调用的接口类
- (FitBaseRequest *)request;

// * 根据后端返回的总信息条目数和当前页数，判断是否可以加载下一页
//
- (BOOL)canLoadMore;

// * 被子类覆写，解析返回数据，为TableView提供数据源
//
- (NSArray *)parseResponse:(NSString *)resp;

// * 滚动表格到底部
//
- (void)scrollTableToFoot:(BOOL)animated;

- (void)firstPageLoadedProcess;

@end

