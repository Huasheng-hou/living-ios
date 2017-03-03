//
//  LMMyMessageViewController.m
//  living
//
//  Created by Ding on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMMyMessageViewController.h"
#import "LMMyMessageRequest.h"
#import "LMFriendVO.h"
#import "LMMessageBoardViewController.h"


#define PAGER_SIZE      20

@interface LMMyMessageViewController ()

@end

@implementation LMMyMessageViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"留言板";
    
    [self creatUI];
    [self loadNewer];
    
}

- (void)creatUI
{
    
    [super createUI];
    self.tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    
    
}

- (FitBaseRequest *)request
{
    LMMyMessageRequest    *request    = [[LMMyMessageRequest alloc] initWithPageIndex:self.current andPageSize:PAGER_SIZE];
    
    return request;

}

- (NSArray *)parseResponse:(NSString *)resp
{
        NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
        [self logoutAction:resp];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        LMFriendVO *list =[self.listData objectAtIndex:indexPath.row];

    
    
    if (list.content) {
        NSString *string =[NSString stringWithFormat:@"%@：%@",list.nickname,list.content];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0,[list.nickname length]+1)];

        cell.textLabel.attributedText = str;
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@回复%@：%@",list.myNickname,list.nickname,list.content];
    }
    
        cell.tag = indexPath.row;

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listData.count>indexPath.row) {
        LMFriendVO *list = [self.listData objectAtIndex:indexPath.row];
        LMMessageBoardViewController *messageBoardVC = [[LMMessageBoardViewController alloc] init];
        messageBoardVC.friendUUid = list.userUuid;
        messageBoardVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageBoardVC animated:YES];
    }
}


@end
