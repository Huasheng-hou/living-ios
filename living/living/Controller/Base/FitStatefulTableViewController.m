//
//  FitStatefulTableViewController.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/21.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitStatefulTableViewController.h"

static const int kLoadingCellTag = 2571;

@interface FitStatefulTableViewController ()
{
    UITableViewStyle    _tableStyle;
    UIButton            *_reloadMask;
}

@property (assign, nonatomic)   BOOL            hasAddedPullToRefreshControl;

- (void)setExtraCellLineHidden:(UITableView *)tableView;
- (void)loadFirstPage;
- (void)loadNextPage;
- (void)loadFromPullToRefresh;

@end

@implementation FitStatefulTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _tableStyle = style;
        _current = 0;
        _max = -1;
        _ifAddPullToRefreshControl  = YES;
        _ifShowTableSeparator       = YES;
        _isCountingRows             = YES;
        _ifRemoveLoadNoState        = YES;
        _ifDelayLoad                = YES;
        _ifShowLoadingState         = YES;
        _ifProcessLoadFirst         = NO;
        _ifLoadReverse              = NO;
        _statefulState = FitStatefulTableViewControllerStateIdle;
        table_proxy = nil;
        
        _listData = [NSMutableArray arrayWithCapacity:20];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setExtraCellLineHidden:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    tableView.tableFooterView   = [[UIView alloc] init];
}

- (void)createUI
{
    [super createUI];
    
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
    
    if (_ifAddPullToRefreshControl) {
        _pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
        _pullToRefreshView.defaultContentInset      = UIEdgeInsetsMake(64, 0, 0, 0);
    }
}

// 隐藏状态提示文字
- (void)hideHUDView
{
    [stateHud hide:YES afterDelay:0.3];
}

// 滚动表格到底部
- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - state info view
//所有的状态信息提示视图
//////////////////////////////////////////////////////////////////////////////////
- (UIView *)idleView
{
    return nil;
}

- (UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:self.tableView.bounds];
        [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [_loadingView setBackgroundColor:[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]];
        
        UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.center = _loadingView.center;
        
        [activityIndicatorView startAnimating];
        
        [_loadingView addSubview:activityIndicatorView];
    }
    
    return _loadingView;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_emptyView setBackgroundColor:[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]];
    }
    return _emptyView;
}

- (UIView *)errorView
{
    if (!_errorView) {
        _errorView = [[UIView alloc] initWithFrame:self.view.frame];
        [_errorView setBackgroundColor:[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]];
        
        CGFloat w = self.view.bounds.size.width;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 160)];
        [view setBackgroundColor:[UIColor clearColor]];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"neterror"]];
        [image setFrame:CGRectMake((w - CGRectGetWidth(image.frame)) / 2, 15, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame))];
        [view addSubview:image];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, w, 34)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setNumberOfLines:2];
        [lbl setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1]];
        [lbl setFont:[UIFont systemFontOfSize:14.0]];
        [lbl setText:@"网络抛锚\r\n请检查网络后点击屏幕重试！"];
        [view addSubview:lbl];
        
        view.center = _errorView.center;
        [_errorView addSubview:view];
    }
    
    if (!_reloadMask) {
        UIButton *reloadMask = [[UIButton alloc] initWithFrame:_errorView.bounds];
        [reloadMask addTarget:self action:@selector(reloadAfterError) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:reloadMask];
        _reloadMask = reloadMask;
        [self.view bringSubviewToFront:_reloadMask];
    }
    
    return _errorView;
}

- (void)reloadAfterError
{
    [self loadNewer];
    if (_reloadMask) {
        [_reloadMask removeFromSuperview];
        _reloadMask = nil;
    }
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - start to load
//所有的加载数据相关方法
//////////////////////////////////////////////////////////////////////////////////
- (void)loadNewer
{
    if (_reloadMask) {
//        [_reloadMask removeFromSuperview];
        _reloadMask = nil;
    }
    
    if (self.statefulState == FitStatefulTableViewControllerStateInitialLoading) {
        return;
    }
    
    [self.listData removeAllObjects];
    _current = 1;
    _max = -1;
    
    if (_ifShowLoadingState) {
        self.statefulState = FitStatefulTableViewControllerStateInitialLoading;
        [self.tableView reloadData];
    }
    
    [self performSelector:@selector(loadFirstPage) withObject:nil afterDelay:(_ifDelayLoad ? 0.5 : 0)];
}

- (void)loadNoState
{
    if (self.statefulState == FitStatefulTableViewControllerStateInitialLoading) {
        return;
    }
    
    if (_ifRemoveLoadNoState) {
        [self.listData removeAllObjects];
    }
    _current = 1;
    _max = -1;
    
    [self performSelector:@selector(loadFirstPage) withObject:nil afterDelay:0];
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////        ////////////////////////////////////////////////////
#pragma mark - load first page
//加载第一页数据
//////////////////////////////////////////////////////////////////////////////////
- (void)loadFirstPage
{
    //    已经在加载或者已经完成第一次加载，直接跳过
    
    FitBaseRequest * req = [self request];
    
    table_proxy = [HTTPProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        NSArray * items = [self parseResponse:resp];
        
        if (items && [items count]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!_ifRemoveLoadNoState && _listData && _listData.count != 0) {
                    [_listData removeAllObjects];
                }
                [_listData addObjectsFromArray:items];
                [self.tableView reloadData];
                
                if (_ifProcessLoadFirst) {
                    [self firstPageLoadedProcess];
                }
            });
            
            self.statefulState = FitStatefulTableViewControllerStateIdle;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![_listData count] && _isCountingRows) {
                    
                    self.statefulState = FitStatefulTableViewControllerStateEmpty;
                    
                }else{
                    self.statefulState = FitStatefulTableViewControllerStateIdle;
                }
            });
        }
    } failed:^(NSError *error) {
        
        self.statefulState = FitStatefulTableViewControllerError;
    }];
    
    [table_proxy start];
}

- (void)firstPageLoadedProcess
{
    return;
}

- (void)loadNextPage
{
    if (self.statefulState == FitStatefulTableViewControllerStateLoadingNextPage) return;
    
    if ([self canLoadMore]) {
        
        self.statefulState = FitStatefulTableViewControllerStateLoadingNextPage;
        
        //        切换页码到下一页
        _current++;
        
        FitBaseRequest * req = [self request];
        table_proxy = [HTTPProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
            
            NSArray * items = [self parseResponse:resp];
            
            if (items && [items count]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (!_ifLoadReverse) {
                        [_listData addObjectsFromArray:items];
                        
                        [self.tableView reloadData];
                    } else {
                        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_listData];
                        [_listData removeAllObjects];
                        [_listData addObjectsFromArray:items];
                        [_listData addObjectsFromArray:tempArr];
                        
                        [self.tableView reloadData];
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:items.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }
                    
                });
            }
            self.statefulState = FitStatefulTableViewControllerStateIdle;
        } failed:^(NSError *error) {
            
            self.statefulState = FitStatefulTableViewControllerStateIdle;
        }];
        
        [table_proxy start];
    }
}

- (void)loadFromPullToRefresh
{
    if  (self.statefulState == FitStatefulTableViewControllerStateLoadingFromPullToRefresh) return;
    
    self.statefulState = FitStatefulTableViewControllerStateLoadingFromPullToRefresh;
    
    _current = 1;
    
    FitBaseRequest * req = [self request];
    table_proxy = [HTTPProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        NSArray * items = [self parseResponse:resp];
        
        if (items && [items count]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (_listData && [_listData count]) {
                    [_listData removeAllObjects];
                }
                
                [_listData addObjectsFromArray:items];
                
                [self.tableView reloadData];
            });
            
            self.statefulState = FitStatefulTableViewControllerStateIdle;
        }else{
            self.statefulState = FitStatefulTableViewControllerStateIdle;
        }
        
        [_pullToRefreshView performSelectorOnMainThread:@selector(finishLoading) withObject:nil waitUntilDone:YES];
        
    } failed:^(NSError *error) {
        
        self.statefulState = FitStatefulTableViewControllerError;
        
        [_pullToRefreshView performSelectorOnMainThread:@selector(finishLoading) withObject:nil waitUntilDone:YES];
    }];
    
    [table_proxy start];
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - give request, need override
//提供需要的请求数据
//////////////////////////////////////////////////////////////////////////////////
- (FitBaseRequest *)request
{
    return nil;
}

- (BOOL)canLoadMore
{
    return _current < _max;
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - parse response data, need override
//解析返回的数据
//////////////////////////////////////////////////////////////////////////////////
- (NSArray *)parseResponse:(NSString *)resp
{
    _max = 1;
    return nil;
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - change state
//切换状态
//////////////////////////////////////////////////////////////////////////////////
- (void)setStatefulState:(FitStatefulTableViewControllerState)statefulState
{
    _statefulState = statefulState;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (_statefulState) {
            case FitStatefulTableViewControllerStateIdle:
                [self.tableView setBackgroundView:self.idleView];
                if (_ifShowTableSeparator) {
                    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                } else {
                    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                }
//                [self.tableView setScrollEnabled:YES];
                [self.tableView.tableFooterView setHidden:YES];
                [self.tableView reloadData];
                if (stateHud) {
                    [self hideHUDView];
                }
                break;
            case FitStatefulTableViewControllerStateInitialLoading:
                [self.tableView setBackgroundView:self.loadingView];
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//                [self.tableView setScrollEnabled:NO];
                [self.tableView.tableFooterView setHidden:YES];
                [self.tableView reloadData];
                break;
            case FitStatefulTableViewControllerStateEmpty:
                [self.tableView setBackgroundView:self.emptyView];
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//                [self.tableView setScrollEnabled:NO];
                [self.tableView.tableFooterView setHidden:YES];
                [self.tableView reloadData];
                if (stateHud) {
                    [self hideHUDView];
                }
                break;
            case FitStatefulTableViewControllerError:
                [self.tableView setBackgroundView:self.errorView];
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//                [self.tableView setScrollEnabled:NO];
                [self.tableView.tableFooterView setHidden:YES];
                [self.tableView reloadData];
                if (stateHud) {
                    [self hideHUDView];
                }
                break;
            case FitStatefulTableViewControllerStateLoadingNextPage:
                break;
            case FitStatefulTableViewControllerStateLoadingFromPullToRefresh:
                break;
            default:
                break;
        }
    });
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - pull to refresh
//下拉刷新
//////////////////////////////////////////////////////////////////////////////////
- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self loadFromPullToRefresh];
}
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
#pragma mark - tableview datasource && tableview delegate
//常规表格的数据和委托
//////////////////////////////////////////////////////////////////////////////////


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.listData.count; //
    
    if (count == 0) {
        return count;
    }
    
    if ([self canLoadMore] || _ifLoadReverse) {
        count++;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (!_ifLoadReverse) {
        if (row && row == self.listData.count) { //
            return 44.0f;
        }
    } else {
        if ([self canLoadMore]) {
            if (row == 0) {
                return 44.0f;
            }
        } else {
            return 0;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * LOAD_MORE_CELL = @"LOAD_MORE_CELL_IDENTIFITY";
    
    UITableViewCell * cell = nil;
    NSInteger row = indexPath.row;
    
    if (!_ifLoadReverse) {
        if (row && row == self.listData.count) { //
            cell = [tableView dequeueReusableCellWithIdentifier:LOAD_MORE_CELL];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LOAD_MORE_CELL];
                [cell.contentView setBackgroundColor:[UIColor clearColor]];
                [cell setBackgroundColor:[UIColor clearColor]];
                
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.center = CGPointMake(70, CGRectGetHeight(cell.frame) / 2.0);
                activityIndicator.tag = kLoadingCellTag;
                
                [cell addSubview:activityIndicator];
                
                UILabel *loadingLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(cell.frame))];
                [loadingLbl setBackgroundColor:[UIColor clearColor]];
                [loadingLbl setTextAlignment:NSTextAlignmentCenter];
                [loadingLbl setTextColor:[UIColor grayColor]];
                [loadingLbl setFont:[UIFont systemFontOfSize:14.0]];
                [loadingLbl setText:@"       (>﹏<) 卖力加载下一页中…"];
                [cell addSubview:loadingLbl];
                
                [activityIndicator startAnimating];
                cell.userInteractionEnabled = NO;
                cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
            }else{
                UIActivityIndicatorView * activityIndicator = (UIActivityIndicatorView * )[cell viewWithTag:kLoadingCellTag];
                [activityIndicator startAnimating];
            }
        }
    } else {
        if (row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:LOAD_MORE_CELL];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LOAD_MORE_CELL];
                [cell.contentView setBackgroundColor:[UIColor clearColor]];
                [cell setBackgroundColor:[UIColor clearColor]];
                
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.center = CGPointMake(70, CGRectGetHeight(cell.frame) / 2.0);
                activityIndicator.tag = kLoadingCellTag;
                
                [cell addSubview:activityIndicator];
                
                UILabel *loadingLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(cell.frame))];
                [loadingLbl setBackgroundColor:[UIColor clearColor]];
                [loadingLbl setTextAlignment:NSTextAlignmentCenter];
                [loadingLbl setTextColor:[UIColor grayColor]];
                [loadingLbl setFont:[UIFont systemFontOfSize:14.0]];
                [loadingLbl setText:@"       (>﹏<) 卖力加载上一页…"];
                [cell addSubview:loadingLbl];
                
                [activityIndicator startAnimating];
                cell.userInteractionEnabled = NO;
                cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
            }else{
                UIActivityIndicatorView * activityIndicator = (UIActivityIndicatorView * )[cell viewWithTag:kLoadingCellTag];
                [activityIndicator startAnimating];
            }
        }
    }
    
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!_ifLoadReverse) {
        if (fabs(self.tableView.contentSize.height - (self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.frame))) < 44.0
            && self.statefulState == FitStatefulTableViewControllerStateIdle
            && [self canLoadMore]) {
            [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
        }
    } else {
        if (-64 == self.tableView.contentOffset.y && self.statefulState == FitStatefulTableViewControllerStateIdle && [self canLoadMore]) {
            [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
        }
    }
}

@end
