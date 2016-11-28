//
//  LM2DresultViewController.m
//  living
//
//  Created by Ding on 2016/11/28.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LM2DresultViewController.h"

@interface LM2DresultViewController ()

@end

@implementation LM2DresultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描结果";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatView];
}

-(void)creatView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 30)];
    titleLabel.text = @"！！！此二维码非腰果生活二维码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *desp = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth, 30)];
    desp.text = @"预知后事如何，请参照下方扫描结果";
    desp.textColor = TEXT_COLOR_LEVEL_2;
    desp.font = TEXT_FONT_LEVEL_2;
    desp.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:desp];
    
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(15, 230, kScreenWidth-30, 100)];
    yellowView.layer.cornerRadius = 10;
    yellowView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:186.0/255.0 blue:2.0/255.0 alpha:1.0];
    
    [self.view addSubview:yellowView];
    
    
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, kScreenWidth-110, 60)];
    resultLabel.textColor = LIVING_REDCOLOR;
    resultLabel.font = TEXT_FONT_LEVEL_2;
    resultLabel.text = _result;
    resultLabel.numberOfLines = 2;
    resultLabel.textAlignment = NSTextAlignmentCenter;
    [yellowView addSubview:resultLabel];
    
    
    

}






@end
