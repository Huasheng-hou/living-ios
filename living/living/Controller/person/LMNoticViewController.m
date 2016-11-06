//
//  LMNoticViewController.m
//  living
//
//  Created by Ding on 16/10/9.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMNoticViewController.h"
#import "LMNoticListRequest.h"
#import "FitUserManager.h"
#import "LMNoticVO.h"
#import "LMNoticCell.h"

#import "LMNoticDeleteRequest.h"

@interface LMNoticViewController ()
<UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView *_tableView;
    NSMutableArray *listArray;
    BOOL isSelected;
    NSString *Estring;
    NSMutableArray *cellArray;
}

@end

@implementation LMNoticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知中心";
    [self getNoticListData];
    [self creatUI];
    listArray = [NSMutableArray new];
    cellArray = [NSMutableArray new];
}

-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.editing = NO;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(EditAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

-(void)EditAction
{
    NSLog(@"**************编辑");
    isSelected = NO;//全选状态的切换
    Estring= !_tableView.editing?@"完成":@"编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:Estring style:UIBarButtonItemStyleDone target:self action:@selector(EditAction)];
    
   [_tableView reloadData];
    _tableView.editing = !_tableView.editing;
   

}

-(void)getNoticListData
{
    LMNoticListRequest *request = [[LMNoticListRequest alloc] initWithUserUUid:[FitUserManager sharedUserManager].uuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getNoticListDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取通知列表失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

-(void)getNoticListDataResponse:(NSString *)resp
{
    NSDictionary    *bodyDic = [VOUtil parseBody:resp];
    listArray = [NSMutableArray new];
    
    [self logoutAction:resp];
    
    if (!bodyDic) {
        [self textStateHUD:@"获取数据失败"];
        return;
    }
    
    NSString *result    = [bodyDic objectForKey:@"result"];
    
    if (result && [result intValue] == 0)
    {
        NSArray *array = bodyDic[@"list"];
        for (int i =0; i<array.count; i++) {
            LMNoticVO *list=[[LMNoticVO alloc]initWithDictionary:array[i]];
            if (![listArray containsObject:list]) {
                [listArray addObject:list];
            }
            
        }
        [_tableView reloadData];
        
    } else {
        [self textStateHUD:bodyDic[@"description"]];
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    LMNoticCell *cell = [[LMNoticCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LMNoticVO *list = [listArray objectAtIndex:indexPath.row];
    cell.tintColor = LIVING_COLOR;
    [cell  setData:list];
    
    if ([Estring isEqual:@"完成"]) {
        cell.INDEX = 1;
    }
    
    [cell setXScale:self.xScale yScale:self.yScaleWithAll];
    
    return cell;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"是否删除"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction*action) {
//                                                                 [listArray removeObjectAtIndex:indexPath.row];
                                                                 [self getNoticDeleteRequest:indexPath.row];
                                                                 
                                                             }]];

        [self presentViewController:alert animated:YES completion:nil];
             
        
        [tableView reloadData];
    };

    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    
    action1.backgroundColor = LIVING_COLOR;

    
    return @[action1];
}


-(void)getNoticDeleteRequest:(NSInteger)sender
{
    LMNoticVO *list = [listArray objectAtIndex:sender];
    
    [cellArray addObject:list.noticeUuid];
    LMNoticDeleteRequest *request = [[LMNoticDeleteRequest alloc] initWithNoticeuuid:cellArray];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getNoticDeleteResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"删除通知失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];

}

-(void)getNoticDeleteResponse:(NSString *)resp
{
    NSDictionary    *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if (!bodyDic) {
        [self textStateHUD:@"删除通知失败"];
        return;
    }
    
    NSString *result    = [bodyDic objectForKey:@"result"];
    
    if (result && [result intValue] == 0)
    {
        [self textStateHUD:@"删除成功"];
        
        [self getNoticListData];
        
    }else {
        [self textStateHUD:bodyDic[@"description"]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
