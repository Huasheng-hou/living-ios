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
#import "LMActivityDetailController.h"
#import "LMHomeDetailController.h"
#import "LMClassroomDetailViewController.h"


#import "LMEventDetailViewController.h"


@interface LMNoticViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

{
    UITableView *_tableView;
    NSMutableArray *listArray;
    BOOL isSelected;
    NSString *Estring;
    NSMutableArray *cellArray;
    NSInteger Index;
    UIView *footView;
    NSString *name;
}

@end

@implementation LMNoticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知中心";
    [self getNoticListData];
    Estring = @"编辑";
    [self creatUI];
    listArray = [NSMutableArray new];
    cellArray = [NSMutableArray new];
    
}

-(void)creatUI
{
    if ([Estring isEqual:@"编辑"]){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+40) style:UITableViewStyleGrouped];
    }
    if ([Estring isEqual:@"完成"]){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.allowsMultipleSelection = YES;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(EditAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)EditAction
{
    isSelected = NO;//全选状态的切换
    Estring= !_tableView.editing?@"完成":@"编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:Estring style:UIBarButtonItemStyleDone target:self action:@selector(EditAction)];
    if ([Estring isEqual:@"完成"]) {
        footView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-45, kScreenWidth, 45)];
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(0, 0, kScreenWidth, 45);
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(getNoticDeleteRequest:) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.backgroundColor = LIVING_COLOR;
        [footView addSubview:deleteButton];
        [self.view addSubview:footView];
        
    }else{
        [footView removeFromSuperview];
    }
    [self refreshData];
    cellArray = [NSMutableArray new];
    _tableView.editing = !_tableView.editing;
    
    
}

-(void)getNoticListData
{
    
    if (Index==1) {
        [self initStateHud];
    }
    
    LMNoticListRequest *request = [[LMNoticListRequest alloc] initWithUserUUid:[FitUserManager sharedUserManager].uuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getNoticListDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getNoticListDataResponse:(NSString *)resp
{
    NSDictionary    *bodyDic = [VOUtil parseBody:resp];
    
    
    NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary *respDict = [NSJSONSerialization
                              JSONObjectWithData:respData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    
    NSDictionary *headDic = [respDict objectForKey:@"head"];
    
    NSString    *coderesult         = [headDic objectForKey:@"returnCode"];
    
    if (coderesult && ![coderesult isEqual:[NSNull null]] && [coderesult isKindOfClass:[NSString class]] && [coderesult isEqualToString:@"000"]) {
        
        if (headDic[@"nick_name"]&&![headDic[@"nick_name"] isEqual:@""]) {
            name = headDic[@"nick_name"];
        }

        
    }
    listArray = [NSMutableArray new];
    
    if (!bodyDic) {
        [self textStateHUD:@"获取数据失败"];
        return;
    }
    
    NSString *result    = [bodyDic objectForKey:@"result"];
    if (result && [result intValue] == 0)
    {
        [self hideStateHud];
        NSArray *array =[LMNoticVO LMNoticVOListWithArray:bodyDic[@"list"]];
        for (LMNoticVO *vo in array) {
            [listArray addObject:vo];
        }
        [self refreshData];
        
    } else {
        [self textStateHUD:bodyDic[@"description"]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMNoticVO *list = [listArray objectAtIndex:indexPath.row];
    CGFloat h = 0;
    if (list.sign&&[list.sign isEqualToString:@"article"]) {
        h = [LMNoticCell cellHigth:_nameString friendName:list.userNick type:list.type sign:list.sign title:list.articleTitle content:list.content];
    }
    if (list.sign&&[list.sign isEqualToString:@"event"]) {
       h = [LMNoticCell cellHigth:_nameString friendName:list.userNick type:list.type sign:list.sign title:list.eventName content:list.content];
    }
    if (list.sign&&[list.sign isEqualToString:@"voice"]) {
        h = [LMNoticCell cellHigth:_nameString friendName:list.userNick type:list.type sign:list.sign title:list.voiceTitle content:list.content];
    }
    if (list.sign&&[list.sign isEqualToString:@"item"]) {
        h = [LMNoticCell cellHigth:_nameString friendName:list.userNick type:list.type sign:list.sign title:list.eventName content:list.content];
    }
    if (list.sign&&[list.sign isEqualToString:@"eventReview"]) {
        h = [LMNoticCell cellHigth:_nameString friendName:list.userNick type:list.type sign:list.sign title:list.reviewTitle content:list.content];
    }
    
    return h + 10;

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
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    
    LMNoticCell     *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {

        cell = [[LMNoticCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    LMNoticVO *list = [listArray objectAtIndex:indexPath.row];
    cell.tintColor = LIVING_COLOR;
    [cell setData:list name:_nameString];
//    if ([Estring isEqual:@"完成"]) {
//        cell.INDEX = 1;
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    }else{
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    
    //[cell setXScale:self.xScale yScale:self.yScaleWithAll];
    
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
                                                    
                                                    [self getNoticDeleteRequest:indexPath.row];
                                                    
                                                }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        [self refreshData];
    };
    
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    
    action1.backgroundColor = LIVING_COLOR;
    
    
    return @[action1];
}

- (void)getNoticDeleteRequest:(NSInteger)sender
{
    if ([Estring isEqual:@"编辑"]){
        cellArray = [NSMutableArray new];
        LMNoticVO *list = [listArray objectAtIndex:sender];
        [cellArray addObject:list.noticeUuid];
    }else{
        if (cellArray.count==0) {
            [self textStateHUD:@"请选择要删除的通知"];
        }else{
            
        }
    }
    
    LMNoticDeleteRequest *request = [[LMNoticDeleteRequest alloc] initWithNoticeuuid:cellArray];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getNoticDeleteResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
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
        Index = 1;
        [self getNoticListData];
        cellArray = [NSMutableArray new];
        
    }else {
        [self textStateHUD:bodyDic[@"description"]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([Estring isEqual:@"完成"]) {
        LMNoticVO  *vo = [listArray objectAtIndex:indexPath.row];
        [cellArray addObject:vo.noticeUuid];
        
    }else{
        if (listArray.count > indexPath.row) {
            
            LMNoticVO  *vo = [listArray objectAtIndex:indexPath.row];
            
            if (vo && [vo isKindOfClass:[LMNoticVO class]]) {
                
                if (vo.sign&&[vo.sign isEqual:@"event"] ) {
                    LMActivityDetailController *detailVC = [[LMActivityDetailController alloc] init];
                    
                    detailVC.hidesBottomBarWhenPushed = YES;
                    
                    detailVC.eventUuid  = vo.eventUuid;
                    
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
                if (vo.sign&&[vo.sign isEqualToString:@"article"]) {
                    LMHomeDetailController *detailVC = [[LMHomeDetailController alloc] init];
                    
                    detailVC.hidesBottomBarWhenPushed = YES;
                    
                    detailVC.artcleuuid  = vo.articleUuid;
                    
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
                
                if (vo.sign&&[vo.sign isEqualToString:@"voice"]) {
                    LMClassroomDetailViewController *detailVC = [[LMClassroomDetailViewController alloc] init];
                    
                    detailVC.hidesBottomBarWhenPushed = YES;
                    
                    detailVC.voiceUUid  = vo.voiceUuid;
                    
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
                
                if (vo.sign&&[vo.sign isEqualToString:@"eventReview"]) {
                    LMHomeDetailController *detailVC = [[LMHomeDetailController alloc] init];
                    
                    detailVC.hidesBottomBarWhenPushed = YES;
                    
                    detailVC.artcleuuid  = vo.reviewUuid;
                    
                    detailVC.type = 2;
                    
                    [self.navigationController pushViewController:detailVC animated:YES];

                }
                
                if (vo.sign&&[vo.sign isEqualToString:@"item"]) {
                    LMEventDetailViewController *detailVC = [[LMEventDetailViewController alloc] init];
                    
                    detailVC.hidesBottomBarWhenPushed = YES;
                    
                    detailVC.eventUuid  = vo.eventUuid;
                    
                    [self.navigationController pushViewController:detailVC animated:YES];

                }
                
                
            }
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMNoticVO  *vo = [listArray objectAtIndex:indexPath.row];
    [cellArray removeObject:vo.noticeUuid];
}


//重新加载数据

- (void)refreshData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_tableView reloadData];
    });
}



@end
