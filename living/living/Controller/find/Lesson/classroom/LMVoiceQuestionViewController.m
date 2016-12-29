//
//  LMVoiceQuestionViewController.m
//  living
//
//  Created by Ding on 2016/12/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMVoiceQuestionViewController.h"
#import "LMVoiceQuesrtionRequest.h"
#import "LMQuestionVO.h"
#import "LMQuestionTableViewCell.h"

@interface LMVoiceQuestionViewController ()
<
LMQuestionCellDelegate
>
@end

@implementation LMVoiceQuestionViewController

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
    self.title = @"问题列表";
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
    LMVoiceQuesrtionRequest    *request    = [[LMVoiceQuesrtionRequest alloc] initWithPageIndex:self.current andPageSize:20 voiceUuid:_voiceUUid];
    
    return request;
}

- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSString    *result         = [bodyDic objectForKey:@"result"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        
        NSArray *resultArr =[LMQuestionVO LMQuestionVOListWithArray:[bodyDic objectForKey:@"list"]];
        
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
    
    LMQuestionVO *vo = self.listData[indexPath.row];
    return [LMQuestionTableViewCell cellHigth:vo.content];
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
        
        cell    = [[LMQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.listData.count > indexPath.row) {
        LMQuestionVO *vo = self.listData[indexPath.row];
        if (vo && [vo isKindOfClass:[LMQuestionVO class]]) {
            
            [(LMQuestionTableViewCell *)cell setValue:vo];
            [(LMQuestionTableViewCell *)cell setDelegate:self];
            [(LMQuestionTableViewCell *)cell setTag:indexPath.row];
            [(LMQuestionTableViewCell *)cell setRoleIndex:_roleIndex];
        }
        
    }
    return cell;
}

- (void)cellClickImage:(LMQuestionTableViewCell *)cell
{
    
    LMQuestionVO *vo = self.listData[cell.tag];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否转发问题"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                if (vo.status&&[vo.status isEqualToString:@"closed"]) {
                                                    [self textStateHUD:@"问题已关闭~"];
                                                }
                                                if (vo.status&&[vo.status isEqualToString:@"open"]) {
                                                    
                                                    [self.delegate backDic:vo.userUuid content:vo.content];
                                                }
                                                
                                                [self.navigationController popViewControllerAnimated:NO];
                                                
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    


}


@end
