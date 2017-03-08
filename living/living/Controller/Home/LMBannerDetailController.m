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
#import "LMSubmitSuccessController.h"

#import "LMArtcleTypeListRequest.h"

#import "LMActicleVO.h"

static CGFloat const ButtonHeight = 38;

@interface LMBannerDetailController ()<LMSegmentDelegate>

@end

@implementation LMBannerDetailController
{
    BOOL isShow;
    CGFloat keyBoardHeight;
    
    UIView * bgView;
    UIView * topView;
    UIView * botView;
    UILabel * tips;
    UITextField * nameTF;
    UITextField * phoneTF;
    UIButton * bookBtn;
    
    NSArray * typeName;
}

- (instancetype)initWithIndex:(NSInteger)index{
    
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.index = index;
        self.ifRemoveLoadNoState        = NO;
        typeName = @[@"幸福情商", @"美丽造型", @"营养养生", @"美食吃货"];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//
//    if (self.listData.count == 0) {
//        
//        [self loadNoState];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[FitUserManager sharedUserManager] isLogin]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(publicAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                        action:nil];
    [self createUIWithIndex:self.index];
    

}


- (void)createUIWithIndex:(NSInteger)index
{
    NSLog(@"%@", self.listData);
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *titleArrays = @[@[@"美·发现", @"美·活动", @"美·达人"], @[@"康·发现", @"康·活动", @"康·达人"], @[@"食·发现", @"食·活动", @"食·达人"], @[@"福·发现", @"福·活动", @"福·达人"]];
    LMSegmentController *vc = [[LMSegmentController alloc]init];
    NSLog(@"%d",index);
    NSArray *titleArray = titleArrays[index-10];
    
    vc.titleArray = titleArray;
    NSMutableArray *controlArray = [[NSMutableArray alloc]init];
    
    LMBannerDetailCommonController *vc1 = [[LMBannerDetailCommonController alloc]initWithType:typeName[index-10]];
    [controlArray addObject:vc1];
    
    LMBannerDetailCommonController *vc2 = [[LMBannerDetailCommonController alloc]initWithType:typeName[index-10]];
    [controlArray addObject:vc2];
    
    LMBannerDetailExpertController *vc3 = [[LMBannerDetailExpertController alloc]init];
    [controlArray addObject:vc3];
    
    vc.delegate = self;
    vc.titleColor = TEXT_COLOR_LEVEL_2;
    vc.titleSelectedColor = LIVING_COLOR;
    vc.subViewControllers = controlArray;
    vc.buttonWidth = kScreenWidth/3.0;
    vc.buttonHeight = ButtonHeight;
    [vc initSegment];
    [vc addParentController:self];
    
}
#pragma mark LMSegmentDelegate
- (void)changeNavigationItem:(NSInteger)index{
    if ([[FitUserManager sharedUserManager] isLogin]) {
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(publicAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }
}
#pragma mark 发布文章
- (void)publicAction
{
    LMPublicArticleController *publicVC = [[LMPublicArticleController alloc] init];
    [self.navigationController pushViewController:publicVC animated:YES];
}


@end
