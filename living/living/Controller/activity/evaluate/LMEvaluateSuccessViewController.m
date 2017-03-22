//
//  LMEvaluateSuccessViewController.m
//  living
//
//  Created by WangShengquan on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMEvaluateSuccessViewController.h"
#import "FitConsts.h"

@interface LMEvaluateSuccessViewController ()


@end

@implementation LMEvaluateSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"评价成功";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonPressed:)];
    
    [self createUI];
}

- (void)rightBarButtonPressed:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.4, kScreenWidth * 0.07 + 64, kScreenWidth * 0.2, kScreenWidth * 0.2)];
    //imageView.backgroundColor = BG_GRAY_COLOR;
    imageView.image = [UIImage imageNamed:@"choose"];
    [self.view addSubview:imageView];
    
    UILabel *commitLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenWidth * 0.33 + 64, kScreenWidth, kScreenWidth * 0.05)];
    commitLbl.text = @"提交成功";
    commitLbl.font = TEXT_FONT_LEVEL_1;
    commitLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:commitLbl];
    
    UILabel *thinksLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenWidth * 0.4 + 64, kScreenWidth, kScreenWidth * 0.04)];
    thinksLbl.text = @"果仁谢谢您的付出！";
    thinksLbl.font = TEXT_FONT_LEVEL_3;
    thinksLbl.textColor = TEXT_COLOR_LEVEL_4;
    thinksLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:thinksLbl];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
