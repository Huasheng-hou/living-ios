//
//  LMSegmentViewController.m
//  living
//
//  Created by Ding on 2016/12/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMSegmentViewController.h"
#import "LMLessonViewController.h"
#import "LMLessonAllViewController.h"
#import "SegmentViewController.h"
#import "FitConsts.h"
#import "LMPulicVoicViewController.h"

static CGFloat const ButtonHeight = 50;

@interface LMSegmentViewController ()

@end

@implementation LMSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"语音课堂";
    
    SegmentViewController *vc = [[SegmentViewController alloc]init];
    NSArray *titleArray = @[@"未完成",@"已完成"];
    
    vc.titleArray = titleArray;
    NSMutableArray *controlArray = [[NSMutableArray alloc]init];
    
    LMLessonViewController *vc1 = [[LMLessonViewController alloc]init];
    [controlArray addObject:vc1];
    
    LMLessonAllViewController *vc2 = [[LMLessonAllViewController alloc]init];
    [controlArray addObject:vc2];
    
    vc.titleSelectedColor = LIVING_COLOR;
    vc.subViewControllers = controlArray;
    vc.buttonWidth = kScreenWidth/2;
    vc.buttonHeight = ButtonHeight;
    [vc initSegment];
    [vc addParentController:self];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publicIcon"]
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
