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
#import "MoreFunctionView.h"
#import "LMMyjoinSegmentViewController.h"
#import "LMMyvoicSegmentViewController.h"

static CGFloat const ButtonHeight = 50;

@interface LMSegmentViewController ()<moreSelectItemDelegate>
{
    MoreFunctionView *moreView;
    NSInteger clickItem;
}

@end

@implementation LMSegmentViewController
- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenView) name:@"hiddenAction" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ifcanpublic) name:@"ifCanpublic" object:nil];

    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [moreView setHidden:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"语音课堂";
    
    SegmentViewController *vc = [[SegmentViewController alloc]init];
    NSArray *titleArray = @[@"进行中",@"全部"];
    
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
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moreIcon"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(showAction)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self moreAction:@"cannot"];
    
}

- (void)ifcanpublic
{
    [self moreAction:@"can"];
}



- (void)showAction
{
    [moreView setHidden:NO];
}

- (void)hiddenView
{
    [moreView setHidden:YES];
}


- (void)moreAction:(NSString *)string
{
    NSArray *titleArray;
    NSArray *iconArray;
    if ([string isEqualToString:@"cannot"]) {
        titleArray=@[@"我参与"];
        clickItem = 1;
        iconArray=@[@"myJoin"];
    }
    if ([string isEqualToString:@"can"]) {
        titleArray=@[@"发布",@"我的",@"我参与"];
        clickItem = 2;
        iconArray=@[@"publicVoice",@"myVoice",@"myJoin"];
    }

    
    moreView=[[MoreFunctionView alloc]initWithContentArray:titleArray andImageArray:iconArray];
    moreView.delegate=self;
    [moreView setHidden:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:moreView];
}

-(void)moreViewSelectItem:(NSInteger)item
{
    if (clickItem  == 1) {
        if (item == 0) {
            [self myjoin];
        }
    }
    if (clickItem  == 2) {
        if (item == 0) {
            [self publicAction];
        }
        if (item == 1) {
            [self myVoice];
        }
        if (item == 2) {
            [self myjoin];
        }
    }
    
}


- (void)publicAction
{
    LMPulicVoicViewController *publicVC = [[LMPulicVoicViewController alloc] init];
    [publicVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:publicVC animated:YES];
}

- (void)myVoice
{
    LMMyvoicSegmentViewController *myVoiceVC = [[LMMyvoicSegmentViewController alloc] init];
    myVoiceVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myVoiceVC animated:YES];
}

- (void)myjoin
{
    LMMyjoinSegmentViewController *myjoinVC = [[LMMyjoinSegmentViewController alloc] init];
    myjoinVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myjoinVC animated:YES];
}



@end
