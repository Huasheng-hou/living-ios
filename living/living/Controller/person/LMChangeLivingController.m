//
//  LMChangeLivingController.m
//  living
//
//  Created by Ding on 2016/10/27.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMChangeLivingController.h"
#import "LMLiveRoomNameCell.h"
#import "LMLivingListRequest.h"
#import "LMAllDataModels.h"
#import "UIImageView+WebCache.h"

@interface LMChangeLivingController ()
{
    UIImageView *chooseView;
    
    NSMutableArray *cellDataArray;
    
    NSInteger selectedRow;
}

@end

@implementation LMChangeLivingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellDataArray=[NSMutableArray arrayWithCapacity:0];
    
    [self getLivingListData];
    
    [self createUI];
}

- (void)createUI
{
    [super createUI];
    self.title = @"选择生活馆";
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    selectedRow = -1;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle: @"确定" style:UIBarButtonItemStylePlain target:self action:@selector(besureAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)getLivingListData
{
    LMLivingListRequest *request = [[LMLivingListRequest alloc] init];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getLivingListResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           
                           
                           }];
    [proxy start];
}

- (void)getLivingListResponse:(NSString *)resp
{
    NSDictionary *bodyDic   = [VOUtil parseBody:resp];
    
    NSString    *result     = [bodyDic objectForKey:@"result"];
    
    if (result && [result intValue] == 0)
    {
        LMALLBody *bodyData=[[LMALLBody alloc]initWithDictionary:bodyDic];
        
        for (int i=0; i<bodyData.list.count; i++) {
            LMALLList *list=bodyData.list[i];
            [cellDataArray addObject:list];
        }
        [self.tableView reloadData];
        
    } else {
  
        [self textStateHUD:bodyDic[@"description"]];
    }
}

- (void)besureAction
{
    if (selectedRow<0) {
        [self textStateHUD:@"请选择生活馆"];
        return;
    }
    
    LMALLList *list=cellDataArray[selectedRow];
    [self.delegate backLiveName:list.livingName andLiveUuid:list.livingUuid];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    LMLiveRoomNameCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[LMLiveRoomNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    if (indexPath.row==selectedRow) {
        cell.chooseView.image= [UIImage imageNamed:@"choose"];
    }else{
        cell.chooseView.image= [UIImage imageNamed:@"choose-no"];
    }
    
    LMALLList *list=cellDataArray[indexPath.row];
    cell.nameLabel.text=list.livingName;
    
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:list.livingImage]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow=indexPath.row;
    [self.tableView reloadData];
}

@end
