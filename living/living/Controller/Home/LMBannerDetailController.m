//
//  LMBannerDetailController.m
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMBannerDetailController.h"
#import "LMBannerDetailCommonController.h"
#import "LMBannerDetailExpertController.h"
#import "LMBannerDetailMakerController.h"
#import "LMSegmentController.h"

#import "LMPublicArticleController.h"

static CGFloat const ButtonHeight = 38;

@interface LMBannerDetailController ()

@end

@implementation LMBannerDetailController


- (instancetype)init{
    
    if (self = [super init]) {
        
        [self createUIWithIndex:10000];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[FitUserManager sharedUserManager] isLogin]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(publicAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}


- (void)createUIWithIndex:(NSInteger)index
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Yao·美丽";
    
    LMSegmentController *vc = [[LMSegmentController alloc]init];
    NSArray *titleArray = @[@"全部", @"美·发现", @"美·活动", @"美·达人", @"美·创客"];
    
    vc.titleArray = titleArray;
    NSMutableArray *controlArray = [[NSMutableArray alloc]init];
    
    LMBannerDetailCommonController *vc1 = [[LMBannerDetailCommonController alloc]init];
    [controlArray addObject:vc1];
    
    LMBannerDetailCommonController *vc2 = [[LMBannerDetailCommonController alloc]init];
    [controlArray addObject:vc2];
    
    LMBannerDetailCommonController *vc3 = [[LMBannerDetailCommonController alloc]init];
    [controlArray addObject:vc3];
    
    LMBannerDetailExpertController *vc4 = [[LMBannerDetailExpertController alloc]init];
    [controlArray addObject:vc4];
    
    LMBannerDetailMakerController *vc5 = [[LMBannerDetailMakerController alloc] init];
    [controlArray addObject:vc5];
    
    vc.titleColor = TEXT_COLOR_LEVEL_2;
    vc.titleSelectedColor = LIVING_COLOR;
    vc.subViewControllers = controlArray;
    vc.buttonWidth = kScreenWidth/4.5;
    vc.buttonHeight = ButtonHeight;
    [vc initSegment];
    [vc addParentController:self];
    
    
}

#pragma mark 发布文章
- (void)publicAction
{
    LMPublicArticleController *publicVC = [[LMPublicArticleController alloc] init];
    [self.navigationController pushViewController:publicVC animated:YES];
}

@end
