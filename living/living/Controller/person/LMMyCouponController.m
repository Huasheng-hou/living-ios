//
//  LMMyCouponController.m
//  living
//
//  Created by JamHonyZ on 2016/11/2.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyCouponController.h"
#import "LMCouponCell.h"

@interface LMMyCouponController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView *table;
}
@end

@implementation LMMyCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

#pragma mark 没有数据时显示的界面

- (void)visiableBgImage
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [bgView setBackgroundColor:BG_GRAY_COLOR];
    [self.view addSubview:bgView];
    
    UIImageView *bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-45, kScreenHeight/4+40, 90, 61)];
    [bgImage setImage:[UIImage imageNamed:@"personNoCoupon"]];
    [bgView addSubview:bgImage];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeight/4+100, kScreenWidth, 90)];
    [label setText:@"天苍苍地茫茫，无优惠好凄凉，快去邀请好友\n参与优惠活动，享受健康生活"];
    [label setNumberOfLines:2];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:TEXT_COLOR_LEVEL_4];
    [label setFont:TEXT_FONT_LEVEL_1];
    [bgView addSubview:label];
}


-(void)createUI
{
    self.title=@"我的优惠券";
    table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [table setDelegate:self];
    [table setDataSource:self];
    [self.view addSubview:table];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellId";
    LMCouponCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[LMCouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
    
    return cell;
}


@end
