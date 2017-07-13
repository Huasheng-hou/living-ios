//
//  LMDraftViewController.m
//  living
//
//  Created by hxm on 2017/7/13.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMDraftViewController.h"

@interface LMDraftViewController ()

@end

@implementation LMDraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    
}
- (void)createUI {
    [super createUI];
    self.view.backgroundColor = BG_GRAY_COLOR;
    self.navigationItem.title = @"草稿箱";
    
    
    //数据库查询
    
    //有数据，刷新列表
    
    //没数据，提示信息‘暂无草稿’
    
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"草稿箱--内存预警");
}

@end
