//
//  LMQingMakerController.m
//  living
//
//  Created by hxm on 2017/3/10.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMQingMakerController.h"
#import "FitConsts.h"

#import "LMArtcleTypeRequest.h"
#import "LMMoreStoryRequest.h"

#import "UIImageView+WebCache.h"
#import "LMWebViewController.h"
@interface LMQingMakerController ()

@end

@implementation LMQingMakerController

- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
    }
    return self;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
    [self loadNewer];
}
- (void)createUI{
    [super createUI];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}
#pragma mark - 请求创客故事数据
- (FitBaseRequest *)request
{
    LMMoreStoryRequest *request = [[LMMoreStoryRequest alloc] init];
    
    return request;
}
- (NSArray *)parseResponse:(NSString *)resp{
    
    NSData * data = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * headDic = [dic objectForKey:@"head"];
    if (![headDic[@"returnCode"] isEqualToString:@"000"]) {
        
        [self textStateHUD:@"验证失败"];
        return nil;
    }
    NSDictionary * body = [VOUtil parseBody:resp];
    if (![body[@"result"] isEqualToString:@"0"]) {
        
        [self textStateHUD:@"请求失败"];
        return nil;
    }

    NSArray * array = [body objectForKey:@"list"];
    
    [self.tableView reloadData];
    
    
    return array;
}
#pragma mark - tableveiw代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return kScreenWidth*3/5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenWidth*3/5-10)];
    image.backgroundColor = BG_GRAY_COLOR;
    //image.image = [UIImage imageNamed:@"BackImage"];
    [image sd_setImageWithURL:[NSURL URLWithString:self.listData[indexPath.row][@"picture"]]];
    image.clipsToBounds = YES;
    image.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:image];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LMWebViewController * webVC = [[LMWebViewController alloc] init];
    webVC.urlString = self.listData[indexPath.row][@"url"];
    webVC.title = @"创客故事";
    [self.navigationController pushViewController:webVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存不够了");
}



@end
