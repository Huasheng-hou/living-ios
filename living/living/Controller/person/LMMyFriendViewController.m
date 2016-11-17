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

@interface LMMyFriendViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    NSMutableArray *listArray;
    UIView *homeImage;
    
    NSInteger        totalPage;

    
    NSMutableArray *stateArray;
    
    NSIndexPath *deleteIndexPath;
}

@property (nonatomic,retain)UITableView *tableView;

@end

@implementation LMMyFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    [self getFriendListRequest];
    
}

- (void)createUI
{
    self.title = @"我的好友";
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    listArray = [NSMutableArray new];
    
}

#pragma mark 重新请求单元格数据（通知  投票）

- (void)getFriendListRequest
{
    LMFriendListRequest *request = [[LMFriendListRequest alloc] initWithUserUuid:[FitUserManager sharedUserManager].uuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getFriendListDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取好友列表失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getFriendListDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if (!bodyDic) {
        [self textStateHUD:@"获取好友列表失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            

            LMFriendVO *vo = [LMFriendVO LMFriendVOWithDictionary:bodyDic[@"friend"]];
        
            [listArray addObject:vo];
            
            [_tableView reloadData];
            
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
            homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-150, kScreenHeight/2-160, 300, 100)];
            
            UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 90, 75)];
            homeImg.image = [UIImage imageNamed:@"NO-friend"];
            [homeImage addSubview:homeImg];
            UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 300, 60)];
            imageLb.numberOfLines = 0;
            imageLb.text = @"手牵手，一起走，如此优秀可爱的你\n怎么可以这么孤单呢";
            imageLb.textColor = TEXT_COLOR_LEVEL_3;
            imageLb.font = TEXT_FONT_LEVEL_3;
            imageLb.textAlignment = NSTextAlignmentCenter;
            [homeImage addSubview:imageLb];
            
            [_tableView addSubview:homeImage];
            
            [_tableView reloadData];
        }
    }
    
}

- (void)sweepAction
{
    LMScanViewController *setVC = [[LMScanViewController alloc] init];
    [setVC setHidesBottomBarWhenPushed:YES];
  
    [self.navigationController pushViewController:setVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
  
    LMFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[LMFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LMFriendVO *list = [listArray objectAtIndex:indexPath.row];
    
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
