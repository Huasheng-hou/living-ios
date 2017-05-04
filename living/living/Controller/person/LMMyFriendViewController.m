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
#import "LMMyMessageViewController.h"
#import "LMMessageBoardViewController.h"
#import "LMEditRemarksController.h"


#define PAGER_SIZE      20
@interface LMMyFriendViewController ()
{
    UIView *homeImage;
    
    NSInteger        totalPage;

    NSInteger totalNumber;
    
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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"留言" style:UIBarButtonItemStylePlain target:self action:@selector(MessageBoardAction)];
    self.navigationItem.rightBarButtonItem = rightItem;

}

-(void)MessageBoardAction
{
    LMMyMessageViewController *messageVC = [[LMMyMessageViewController alloc] init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
    
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
        
        totalNumber = [bodyDic[@"friendsNums"] integerValue];
        
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
    return self.listData.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [NSString stringWithFormat:@"%ld位好友", (long)totalNumber];
        cell.textLabel.textColor = TEXT_COLOR_LEVEL_3;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    
    static NSString *cellId = @"cellId";
  
    LMFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[LMFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.editBtn.tag = indexPath.row-1;
    [cell.editBtn addTarget:self action:@selector(editRemarks:) forControlEvents:UIControlEventTouchUpInside];
    
    
    LMFriendVO *list = [self.listData objectAtIndex:indexPath.row-1];
    cell.tintColor = LIVING_COLOR;
    [cell  setData:list];
    
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deletCellAction:)];
    tap.minimumPressDuration = 1.0;
    cell.contentView.tag = indexPath.row-1;
    [cell.contentView addGestureRecognizer:tap];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    
    if (self.listData.count > indexPath.row-1) {
        NSLog(@"留言板");
        LMFriendVO *list = [self.listData objectAtIndex:indexPath.row-1];
        LMMessageBoardViewController *messageBoardVC = [[LMMessageBoardViewController alloc] init];
        messageBoardVC.friendUUid = list.userUuid;
        messageBoardVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageBoardVC animated:YES];
    }
}

#pragma mark - 修改备注
- (void)editRemarks:(UIButton *)btn{
    
    LMEditRemarksController * editVC = [[LMEditRemarksController alloc] init];
    LMFriendVO * vo = self.listData[btn.tag];
    editVC.friendVO = vo;
    editVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editVC animated:YES];
    
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
