//
//  LMMyLivingViewController.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyLivingViewController.h"
#import "LMMyLivingHomeCell.h"

@interface LMMyLivingViewController ()<LMMyLivingHomeCellDelegate>

@end

@implementation LMMyLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的生活馆";
    [self createUI];
    [self getLivingHomeListData];
    

}
#pragma mark  --生活馆数据列表请求
-(void)getLivingHomeListData
{
    
}



-(void)createUI
{
    [super createUI];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 235;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    LMMyLivingHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LMMyLivingHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    
    [cell setXScale:self.xScale yScale:self.yScaleNoTab];

    return cell;
}

-(void)cellWillpay:(LMMyLivingHomeCell *)cell
{
    NSLog(@"***********立即支付");
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
