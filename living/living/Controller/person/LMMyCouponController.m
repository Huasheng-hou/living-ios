//
//  LMMyCouponController.m
//  living
//
//  Created by JamHonyZ on 2016/11/2.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyCouponController.h"
#import "LMCouponCell.h"

#import "LMCouponRequest.h"

//数据
#import "LMCouponVO.h"

@interface LMMyCouponController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView *table;
    NSMutableArray *cellDataArray;
}
@end

@implementation LMMyCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    cellDataArray=[NSMutableArray arrayWithCapacity:0];
    [self requestCouponData];
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
    return cellDataArray.count;
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
    if (cellDataArray.count > indexPath.row) {
        
        LMCouponVO     *vo = cellDataArray[indexPath.row];
        
        if (vo && [vo isKindOfClass:[LMCouponVO class]]) {
            
            [(LMCouponCell *)cell setValue:vo];
        }
    }
    
    
    
    
    return cell;
}

#pragma mark  请求优惠券数据

-(void)requestCouponData
{
    LMCouponRequest *request = [[LMCouponRequest alloc] initWithUserUuid:[FitUserManager sharedUserManager].uuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(couponDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取数据失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
    
}

-(void)couponDataResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if (!bodyDict) {
        [self textStateHUD:@"获取数据失败"];
        return;
    }
    
    NSLog(@"=========优惠券==bodyDict=============%@",bodyDict);
    
    NSString *result    = [bodyDict objectForKey:@"result"];
    
    if (result && [result intValue] == 0)
    {
        NSArray *array = [LMCouponVO LMCouponVOListWithArray:[bodyDict objectForKey:@"list"]];
        if (!array || ![array isKindOfClass:[NSArray class]] || array.count < 1) {
            
            [self visiableBgImage];
        }else{
            for (LMCouponVO *vo in array) {
                [cellDataArray addObject:vo];
            }
        }
     
        [table reloadData];
    } else {
        [self textStateHUD:bodyDict[@"description"]];
    }
    
}

@end
