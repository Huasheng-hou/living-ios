//
//  LMChangeLivingController.m
//  living
//
//  Created by Ding on 2016/10/27.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMChangeLivingController.h"
#import "LMLiveRoomNameCell.h"

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
    
    cellDataArray=[NSMutableArray
                   arrayWithObjects:@"杭州网络科技有限公司生活馆1",
                   @"杭州网络科技有限公司生活馆2",
                   @"杭州网络科技有限公司生活馆3",
                   @"杭州网络科技有限公司生活馆4",
                   @"杭州网络科技有限公司生活馆5",
                   @"杭州网络科技有限公司生活馆6",
                   @"杭州网络科技有限公司生活馆7",
                   @"杭州网络科技有限公司生活馆8", nil];
    
    [self createUI];
}
-(void)createUI
{
    [super createUI];
    self.title = @"选择生活馆";
    
    selectedRow=-1;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle: @"确定" style:UIBarButtonItemStylePlain target:self action:@selector(besureAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

-(void)besureAction
{
    NSLog(@"确定");
    if (selectedRow<0) {
        [self textStateHUD:@"请选择生活馆"];
        return;
    }
    
    [self.delegate backLiveName:cellDataArray[selectedRow]];
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    cell.nameLabel.text=cellDataArray[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow=indexPath.row;
    [self.tableView reloadData];
}




@end
