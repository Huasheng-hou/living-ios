//
//  LMBlacklistViewController.m
//  living
//
//  Created by Ding on 2016/12/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBlacklistViewController.h"
#import "LMBlackListRequest.h"
#import "LMCancelauthorRequest.h"

@interface LMBlacklistViewController ()
{
    UIView *homeImage;
}

@end

@implementation LMBlacklistViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
//                self.ifRemoveLoadNoState        = NO;
        //        self.ifShowTableSeparator       = NO;
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
    [self createUI];
    [self loadNewer];
    self.title = @"我的黑名单";
    
}

-(void)createUI
{
    
    [super createUI];
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.separatorInset               = UIEdgeInsetsMake(0, 15, 0, 0);
    [self creatImage];
}

-(void)creatImage
{
    homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-160, kScreenWidth, 100)];
    
    UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-150, 80, 300, 60)];
    imageLb.numberOfLines = 0;
    imageLb.text = @"还没有设置黑名单";
    imageLb.textColor = TEXT_COLOR_LEVEL_3;
    imageLb.font = TEXT_FONT_LEVEL_2;
    imageLb.textAlignment = NSTextAlignmentCenter;
    [homeImage addSubview:imageLb];
    homeImage.hidden = YES;
    [self.tableView addSubview:homeImage];
}

- (FitBaseRequest *)request
{
    LMBlackListRequest *request = [[LMBlackListRequest alloc] initWithUserUUid:[FitUserManager sharedUserManager].uuid];
    
    return request;
}


- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSString    *result         = [bodyDic objectForKey:@"result"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        self.max    = [[bodyDic objectForKey:@"total"] intValue];
        NSArray *resultArr  = [bodyDic objectForKey:@"list"];
        
        if (resultArr.count==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                homeImage.hidden = NO;
            });
        }
        
        if (resultArr && resultArr.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                homeImage.hidden = YES;
            });
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
    
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellIdd = @"cellIdd";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdd];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self.listData.count > indexPath.row) {
        
        NSDictionary *dic = self.listData[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@   ID:%@",dic[@"author_name"],dic[@"userId"]];
        cell.textLabel.font = TEXT_FONT_LEVEL_2;
        cell.textLabel.textColor = TEXT_COLOR_LEVEL_2;
        
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listData.count > indexPath.row) {
        NSDictionary *dic = self.listData[indexPath.row];
        NSString *string = dic[@"author_uuid"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否取消对该作者屏蔽"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction*action) {
                                                    [self cancleAction:string];
                                                    
                                                }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (void)cancleAction:(NSString *)uuid
{
    LMCancelauthorRequest *request = [[LMCancelauthorRequest alloc] initWithAuthor_uuid:uuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getcancelDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

-(void)getcancelDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"屏蔽失败"];
    }else{
        
        NSString *result    = [bodyDic objectForKey:@"result"];
        
        if (result && [result intValue] == 0)
        {
            [self textStateHUD:@"删除成功"];
            [self loadNoState];

        }else {
            [self textStateHUD:bodyDic[@"description"]];
        }
    }
}

//重新加载数据

- (void)refreshData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}



@end
