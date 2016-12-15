//
//  LMVoiceMemeberListViewController.m
//  living
//
//  Created by Ding on 2016/12/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMVoiceMemeberListViewController.h"
#import "LMVoiceMemberRequest.h"
#import "LMVoiceMemberVO.h"
#import "UIImageView+WebCache.h"

@interface LMVoiceMemeberListViewController ()

@end

@implementation LMVoiceMemeberListViewController

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
    self.title = @"语音课堂";
    [self creatUI];
    [self loadNewer];
}

- (void)creatUI
{
    [super createUI];
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.separatorInset               = UIEdgeInsetsMake(0, 15, 0, 0);
}

- (FitBaseRequest *)request
{
    LMVoiceMemberRequest    *request    = [[LMVoiceMemberRequest alloc] initWithPageIndex:self.current andPageSize:20 andVoiceUuid:_VoiceUUid];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSString    *result         = [bodyDic objectForKey:@"result"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        
        NSArray *resultArr = [LMVoiceMemberVO LMVoiceMemberVOWithArray:[bodyDic objectForKey:@"list"]];
        
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
    
    return 60;
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
        
        cell    = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (self.listData.count > indexPath.row) {
        LMVoiceMemberVO *vo = self.listData[indexPath.row];
        if (vo && [vo isKindOfClass:[LMVoiceMemberVO class]]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:vo.avatar] placeholderImage:[UIImage imageNamed:@"headIcon"]];
            cell.textLabel.font = TEXT_FONT_LEVEL_2;
            cell.textLabel.textColor = TEXT_COLOR_LEVEL_2;
            cell.detailTextLabel.font = TEXT_FONT_LEVEL_2;
            cell.detailTextLabel.textColor = TEXT_COLOR_LEVEL_2;
            cell.textLabel.text =[NSString stringWithFormat:@"%@ (ID:%@)",vo.nickname,vo.userId];
            cell.detailTextLabel.text = vo.address;
            
            
        }
        
        
    }
    return cell;
}



@end
