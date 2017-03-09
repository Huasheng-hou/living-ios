//
//  LMSubmitOrderController.m
//  living
//
//  Created by hxm on 2017/3/9.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMSubmitOrderController.h"
#import "LMYGBOrderHeadCell.h"
#import "LMYGBOrderChooseCell.h"
@interface LMSubmitOrderController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LMSubmitOrderController

- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
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
}

- (void)createUI{
    [super createUI];
    
    self.navigationItem.title = @"提交订单";
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    
    
}

- (FitBaseRequest *)request{
    
    FitBaseRequest * req = [[FitBaseRequest alloc] initWithNone];
    return req;
}
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 105;
    }
    if (indexPath.section == 1) {
        return 123;
    }
    if (indexPath.section == 2) {
        return 70;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        LMYGBOrderHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"headCell"];
        if (!cell) {
            cell = [[LMYGBOrderHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1) {
        LMYGBOrderChooseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell"];
        if (!cell) {
            cell = [[LMYGBOrderChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chooseCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"submitCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"submitCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView * subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        
        UILabel * submitOrder = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, kScreenWidth-60, 40)];
        submitOrder.text = @"提交订单";
        submitOrder.textColor = [UIColor whiteColor];
        submitOrder.backgroundColor = ORANGE_COLOR;
        submitOrder.font = TEXT_FONT_BOLD_16;
        submitOrder.textAlignment = NSTextAlignmentCenter;
        submitOrder.layer.masksToBounds = YES;
        submitOrder.layer.cornerRadius = 3;
        [cell.contentView addSubview:submitOrder];
        
        return cell;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        NSLog(@"提交订单");
    }
    
    
}













@end
