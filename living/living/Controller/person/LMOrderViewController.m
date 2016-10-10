//
//  LMOrderViewController.m
//  living
//
//  Created by Ding on 16/10/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMOrderViewController.h"
#import "LMOrderCell.h"

@interface LMOrderViewController ()<UITableViewDelegate,UITableViewDataSource,
LMOrderCellDelegate>
{
    UITableView *_tableView;
}

@end

@implementation LMOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单";
    [self creatUI];
}

-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去分割线
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
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
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    LMOrderCell *cell = [[LMOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    //        [cell setXScale:self.xScale yScale:self.yScaleWithAll];
    
    return cell;
}


#pragma mark - LMOrderCell delegate -
- (void)cellWilldelete:(LMOrderCell *)cell
{
    NSLog(@"**********删除");
    
}
- (void)cellWillpay:(LMOrderCell *)cell
{
    NSLog(@"**********付款");
}
- (void)cellWillfinish:(LMOrderCell *)cell
{
    NSLog(@"**********完成");
}
- (void)cellWillRefund:(LMOrderCell *)cell
{
    NSLog(@"**********退款");
}
- (void)cellWillrebook:(LMOrderCell *)cell
{
    NSLog(@"**********再订");
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
