//
//  LMMyvoicSegmentViewController.m
//  living
//
//  Created by Ding on 2016/12/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyvoicSegmentViewController.h"
#import "SegmentViewController.h"
#import "FitConsts.h"
#import "LMPulicVoicViewController.h"
#import "LMMyVoice1ViewController.h"
#import "LMMyVoice2ViewController.h"

static CGFloat const ButtonHeight = 50;

@interface LMMyvoicSegmentViewController ()

@end

@implementation LMMyvoicSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我是讲师";
    
    SegmentViewController *vc = [[SegmentViewController alloc]init];
    NSArray *titleArray = @[@"未完成",@"已完成"];
    
    vc.titleArray = titleArray;
    NSMutableArray *controlArray = [[NSMutableArray alloc]init];
    
    LMMyVoice1ViewController *vc1 = [[LMMyVoice1ViewController alloc]init];
    [controlArray addObject:vc1];
    
    LMMyVoice2ViewController *vc2 = [[LMMyVoice2ViewController alloc]init];
    [controlArray addObject:vc2];
    
    vc.titleSelectedColor = LIVING_COLOR;
    vc.subViewControllers = controlArray;
    vc.buttonWidth = kScreenWidth/2;
    vc.buttonHeight = ButtonHeight;
    [vc initSegment];
    [vc addParentController:self];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publicVoice"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(publicAction)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

- (void)publicAction
{
    LMPulicVoicViewController *publicVC = [[LMPulicVoicViewController alloc] init];
    [publicVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:publicVC animated:YES];
}



@end
