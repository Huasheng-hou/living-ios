//
//  LMMyFriendViewController.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyFriendViewController.h"
#import "LMFriendListRequest.h"
#import "LMFriendCell.h"
#import "LMScanViewController.h"
#import "MJRefresh.h"
#import "LMFriendVO.h"
#define PAGER_SIZE      20
@interface LMMyFriendViewController ()
{
    UIView *homeImage;
    
    NSInteger        totalPage;

    
    NSMutableArray *stateArray;
    
    NSIndexPath *deleteIndexPath;
}

@end

@implementation LMMyFriendViewController
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    self.title = @"我的好友";
    [self loadNewer];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.listData.count == 0) {
        
        [self loadNoState];
    }
}

- (void)createUI
{
    [super createUI];

    self.tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
//    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;

}

#pragma mark 重新请求单元格数据（通知  投票）

- (FitBaseRequest *)request
{
    LMFriendListRequest    *request    = [[LMFriendListRequest alloc] initWithPageIndex:self.current andPageSize:PAGER_SIZE];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    NSString    *result         = [bodyDic objectForKey:@"result"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        
        return [LMFriendVO LMFriendVOListWithArray:[bodyDic objectForKey:@"list"]];
        
    } else if (description && ![description isEqual:[NSNull null]] && [description isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:description waitUntilDone:NO];
    }
    
    return nil;
}

- (void)sweepAction
{
    LMScanViewController *setVC = [[LMScanViewController alloc] init];
    [setVC setHidesBottomBarWhenPushed:YES];
  
    [self.navigationController pushViewController:setVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
  
    LMFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[LMFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LMFriendVO *list = [self.listData objectAtIndex:indexPath.row];
    
    cell.tintColor = LIVING_COLOR;
    [cell  setData:list];
    
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deletCellAction:)];
    tap.minimumPressDuration = 1.0;
    cell.contentView.tag = indexPath.row;
    [cell.contentView addGestureRecognizer:tap];
    
    
    return cell;
}












- (void)deletCellAction:(UILongPressGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否屏蔽该好友"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction*action) {
                                                        [self textStateHUD:@"已经屏蔽该好友"];
                                                       
                                                    }]];
            
            [self presentViewController:alert animated:YES completion:nil];
    }else{
        
    }

}



@end
