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
#import "LMFriendMessageCell.h"


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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMessage:) name:@"message_notice" object:nil];
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
    CGFloat conHigh = 0;
    LMFriendVO *vo = self.listData[indexPath.row];
    NSString *string;
    
    if (vo.content) {
        string =[NSString stringWithFormat:@"%@：%@",vo.nickname,vo.content];
        
    }else{
        string =[NSString stringWithFormat:@"%@回复%@：%@",vo.myNickname,vo.nickname,vo.myContent];
        
        
    }
    NSDictionary *attributes    = @{NSFontAttributeName:TEXT_FONT_LEVEL_1};
    conHigh = [string boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000)
                                   options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:attributes
                                   context:nil].size.height;
    
    
    
    return conHigh +20;
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
    
    LMFriendMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LMFriendMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    LMFriendVO *list =[self.listData objectAtIndex:indexPath.row];
    
    cell.friendVO = list;
    
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

- (void)addMessage:(NSNotification *)notice
{
    
    NSDictionary *dic = notice.userInfo;
    NSLog(@"%@",dic);
    NSDictionary *message = dic[@"message"];
    NSMutableDictionary *new = [NSMutableDictionary new];
    NSMutableArray *array = [NSMutableArray new];
    [new setObject:message[@"push_dsp"] forKey:@"content"];
    [new setObject:message[@"push_title"] forKey:@"nickname"];
    [array addObject:new];
    NSArray *array2 = [LMFriendVO LMFriendVOListWithArray:array];
    NSMutableArray *newArray = [NSMutableArray new];
    [newArray addObjectsFromArray:self.listData];
    [self.listData removeAllObjects];
    [self.listData addObjectsFromArray:array2];
    [self.listData addObjectsFromArray:newArray];
    [self.tableView reloadData];
 
    
}


@end
