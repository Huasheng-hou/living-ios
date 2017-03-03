//
//  LMMyJoin1ViewController.m
//  living
//
//  Created by Ding on 2016/12/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyJoin1ViewController.h"
#import "LMClassroomDetailViewController.h"
#import "LMClassroomCell.h"
#import "ClassroomVO.h"
#import "LMMyjoinVoiceRequest.h"
#import "LMChatViewController.h"

@interface LMMyJoin1ViewController ()

@end

@implementation LMMyJoin1ViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
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
    [self creatUI];
    [self loadNewer];
}

- (void)creatUI
{
    [super createUI];
    
    self.tableView.frame = CGRectMake(0, -60, kScreenWidth, kScreenHeight-54);
    
    self.tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    [self createFooterView];
}

- (void)createFooterView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    self.tableView.tableFooterView = footView;
}

- (FitBaseRequest *)request
{
    LMMyjoinVoiceRequest    *request    = [[LMMyjoinVoiceRequest alloc] initWithPageIndex:self.current andPageSize:20];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSString    *result         = [bodyDic objectForKey:@"result"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        
        NSArray *resultArr = [ClassroomVO ClassroomVOListWithArray:[bodyDic objectForKey:@"list"]];
        
        if (resultArr&&resultArr.count>0) {
            return resultArr;
        }
        
    } else if (description && ![description isEqual:[NSNull null]] && [description isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:description waitUntilDone:NO];
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h   = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (h) {
        
        return h;
    }
    
    return 135;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell   = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        
        return cell;
    }
    
    cell    = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell    = [[LMClassroomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (self.listData.count > indexPath.row) {
        ClassroomVO *vo = self.listData[indexPath.row];
        if (vo && [vo isKindOfClass:[ClassroomVO class]]) {
            
            [(LMClassroomCell *)cell setValue:vo];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listData.count>indexPath.row) {
        ClassroomVO *vo = self.listData[indexPath.row];
        if ([vo.status isEqual:@"open"]) {
        
//            if (vo.role&&([vo.role isEqualToString:@"host"]||[vo.role isEqualToString:@"teacher"])) {
                LMChatViewController *roomVC = [[LMChatViewController alloc] init];
                [roomVC setHidesBottomBarWhenPushed:YES];
                roomVC.voiceUuid = vo.voiceUuid;
                roomVC.sign = vo.sign;
                roomVC.roles = vo.role;
                [self.navigationController pushViewController:roomVC animated:YES];
//            }
//            if (vo.role&&[vo.role isEqualToString:@"student"]&&vo.isBuy==YES) {
//                LMChatViewController *roomVC = [[LMChatViewController alloc] init];
//                [roomVC setHidesBottomBarWhenPushed:YES];
//                roomVC.voiceUuid = vo.voiceUuid;
//                roomVC.sign = vo.sign;
//                roomVC.roles = vo.role;
//                [self.navigationController pushViewController:roomVC animated:YES];
//            }
//            
//            if (vo.role&&[vo.role isEqualToString:@"student"]&&vo.isBuy==NO) {
//                LMClassroomDetailViewController *voiceVC = [[LMClassroomDetailViewController alloc] init];
//                voiceVC.voiceUUid = vo.voiceUuid;
//                voiceVC.role = vo.role;
//                [voiceVC setHidesBottomBarWhenPushed:YES];
//                [self.navigationController pushViewController:voiceVC animated:YES];
//            }
//            
        }else{
            LMClassroomDetailViewController *voiceVC = [[LMClassroomDetailViewController alloc] init];
            voiceVC.voiceUUid = vo.voiceUuid;
            voiceVC.role = vo.role;
            [voiceVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:voiceVC animated:YES];
            
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenAction" object:nil];
    
}

@end
