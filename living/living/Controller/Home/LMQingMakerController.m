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
    
    
    
}

- (void)createUI{
    [super createUI];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}

- (FitBaseRequest *)request
{
    LMArtcleTypeRequest *request = [[LMArtcleTypeRequest alloc] init];
    
    return request;
}

#pragma mark - tableveiw代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
//    return self.listData.count;
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
    image.image = [UIImage imageNamed:@""];
    image.clipsToBounds = YES;
    image.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:image];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存不够了");
}



@end
