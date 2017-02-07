//
//  LMMyjoinSegmentViewController.m
//  living
//
//  Created by Ding on 2016/12/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyjoinSegmentViewController.h"
#import "SegmentViewController.h"
#import "FitConsts.h"
#import "LMPulicVoicViewController.h"
#import "LMMyJoin1ViewController.h"
#import "LMMyJoin2ViewController.h"

static CGFloat const ButtonHeight = 50;

@interface LMMyjoinSegmentViewController ()

@end

@implementation LMMyjoinSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我参与课堂";
    
    SegmentViewController *vc = [[SegmentViewController alloc]init];
    NSArray *titleArray = @[@"未完成",@"已完成"];
    
    vc.titleArray = titleArray;
    NSMutableArray *controlArray = [[NSMutableArray alloc]init];
    
    LMMyJoin1ViewController *vc1 = [[LMMyJoin1ViewController alloc]init];
    [controlArray addObject:vc1];
    
    LMMyJoin2ViewController *vc2 = [[LMMyJoin2ViewController alloc]init];
    [controlArray addObject:vc2];
    
    vc.titleSelectedColor = LIVING_COLOR;
    vc.subViewControllers = controlArray;
    vc.buttonWidth = kScreenWidth/2;
    vc.buttonHeight = ButtonHeight;
    [vc initSegment];
    [vc addParentController:self];
}

@end
