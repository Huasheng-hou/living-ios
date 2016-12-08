//
//  LMArtcleTypeViewController.m
//  living
//
//  Created by Ding on 2016/12/7.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMArtcleTypeViewController.h"
#import "LMArtcleTypeListRequest.h"
#import "LMActicleVO.h"
#import "LMhomePageCell.h"
#import "LMHomeDetailController.h"

@interface LMArtcleTypeViewController ()
<LMhomePageCellDelegate>

@end

@implementation LMArtcleTypeViewController

- (id)initWithType:(NSString *)type
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        //        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
        _type = type;
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
    self.title = _type;
    [self createUI];
    [self loadNewer];
    
}
-(void)createUI
{
    
    [super createUI];
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"屏蔽"
//                                                                  style:UIBarButtonItemStylePlain
//                                                                 target:self
//                                                                 action:@selector(reportAction)];
//    
//    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)reportAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否屏蔽该该作者"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                [self textStateHUD:@"您已经屏蔽了该作者"];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (FitBaseRequest *)request
{
    LMArtcleTypeListRequest *request = [[LMArtcleTypeListRequest alloc] initWithPageIndex:self.current andPageSize:20 andType:_type];
    
    return request;
}


- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSString    *result         = [bodyDic objectForKey:@"result"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        NSArray *resultArr  = [LMActicleVO LMActicleVOListWithArray:[bodyDic objectForKey:@"list"]];
        if (resultArr && resultArr.count > 0) {
            
            return resultArr;
        }
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
        static NSString *cellIdd = @"cellIdd";
        UITableViewCell *cell   = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        
        if (cell) {
            
            return cell;
        }
        
        cell    = [tableView dequeueReusableCellWithIdentifier:cellIdd];
        
        if (!cell) {
            
            cell    = [[LMhomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdd];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.listData.count > indexPath.row) {
            
            LMActicleVO     *vo = self.listData[indexPath.row];
            
            if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
                
                [(LMhomePageCell *)cell setValue:vo];
            }
        }
        
        cell.tag = indexPath.row;
        [(LMhomePageCell *)cell setDelegate:self];
        
        return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listData.count > indexPath.row) {
        
        LMActicleVO *vo     = [self.listData objectAtIndex:indexPath.row];
        
        if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
            
            LMHomeDetailController *detailVC = [[LMHomeDetailController alloc] init];
            
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.artcleuuid = vo.articleUuid;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end
