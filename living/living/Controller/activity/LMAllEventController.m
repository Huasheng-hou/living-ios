//
//  LMAllEventController.m
//  living
//
//  Created by hxm on 2017/3/13.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMAllEventController.h"
#import "FitConsts.h"
#import "LMActivityListRequest.h"
#import "LMActivityExperienceCell.h"
#import "LMActivityDetailController.h"
#import "ActivityListVO.h"
#import "SXButton.h"
#import "SearchViewController.h"
#import "LMEventListRequest.h"
#import "LMEventListVO.h"
#import "SQMenuShowView.h"




#define PAGE_SIZE 20
@interface LMAllEventController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;
@end

@implementation LMAllEventController
{
    UIImageView  *homeImage;
    SXButton     *letfButton;
    NSString     *city;
    
    
}
- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadNewer)
                                                     name:@"reloadEvent"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self loadNewer];
}


- (void)createUI{
    [super createUI];
    
    self.view.backgroundColor =[UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityArr"];
    NSString *cityStr;
    for (NSString *string in searchArr) {
        cityStr = string;
    }
    // 设置导航栏左侧按钮
    letfButton = [SXButton buttonWithType:UIButtonTypeCustom];
    letfButton.frame = CGRectMake(-10, 0, 55, 20);
    [letfButton setTitleColor:COLOR_BLACK_LIGHT forState:UIControlStateNormal];
    
    [letfButton addTarget:self action:@selector(screenAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (cityStr&&![cityStr isEqual:@""]) {
        if (cityStr.length > 3) {
            
            letfButton.width = 80+24*(cityStr.length-3);
        }else{
            
            if (cityStr.length == 3) {
                
                letfButton.width = 80;
            }else{
                
                letfButton.width = 55;
                
            }
        }
        
        [letfButton setTitle:cityStr forState:UIControlStateNormal];
    }else{
        [letfButton setTitle:@"全部" forState:UIControlStateNormal];
    }
    
    [letfButton setImage:[UIImage imageNamed:@"下1"] forState:UIControlStateNormal];
    UIBarButtonItem *LeftBarButton = [[UIBarButtonItem alloc] initWithCustomView:letfButton];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItems = @[backItem,LeftBarButton];

}
- (void)goBack:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)screenAction:(UIButton *)sender
{
    SearchViewController *searchV = [[SearchViewController alloc]init];
    UINavigationController *naV = [[UINavigationController alloc]initWithRootViewController:searchV];
    [searchV setSucceed:^(NSString *str) {
        
        if (str.length > 3) {
            
            letfButton.width = 80+24*(str.length-3);
            letfButton.titleLabel.width = letfButton.titleLabel.bounds.size.width;
            letfButton.imageView.originX = letfButton.width*0.5+15;
        }else{
            
            if (str.length == 3) {
                
                letfButton.width = 80;
                letfButton.titleLabel.width = letfButton.titleLabel.bounds.size.width;
                letfButton.imageView.originX = letfButton.width*0.5+15;
                
            }else{
                
                letfButton.width = 55;
                letfButton.titleLabel.width = letfButton.titleLabel.bounds.size.width;
                letfButton.imageView.originX = letfButton.width*0.5+15;
            }
        }
        
        [letfButton setTitle:str forState:UIControlStateNormal];
        
        NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:str, nil];
        
        //存入数组并同步
        
        [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"cityArr"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
    [self presentViewController:naV animated:YES completion:^{
        
    }];
    
}
-(void)creatImage
{
    homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-160, kScreenWidth, 100)];
    
    UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-41, 5, 82, 91)];
    homeImg.image = [UIImage imageNamed:@"eventload"];
    [homeImage addSubview:homeImg];
    UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-150, 95, 300, 60)];
    imageLb.numberOfLines = 0;
    imageLb.text = @"您选择的城市还没有活动哦\n选择其它城市看看吧";
    imageLb.textColor = TEXT_COLOR_LEVEL_3;
    imageLb.font = TEXT_FONT_LEVEL_2;
    imageLb.textAlignment = NSTextAlignmentCenter;
    [homeImage addSubview:imageLb];
    homeImage.hidden = YES;
    [self.tableView addSubview:homeImage];
}


#pragma mark - 数据请求
- (FitBaseRequest *)request{
    
    LMEventListRequest   *request    = [[LMEventListRequest alloc] initWithPageIndex:self.current andPageSize:PAGE_SIZE andCity:city];
    
    return request;
}
- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary *respDict = [NSJSONSerialization
                              JSONObjectWithData:respData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    
    NSDictionary *headDic = [respDict objectForKey:@"head"];
    
    NSString    *coderesult         = [headDic objectForKey:@"returnCode"];
    
    if (coderesult && ![coderesult isEqual:[NSNull null]] && [coderesult isKindOfClass:[NSString class]] && [coderesult isEqualToString:@"000"]){
        if ([headDic[@"privileges"] isEqual:@"special"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publicIcon"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(publicAction)];
                
                self.navigationItem.rightBarButtonItem = rightItem;
            });
        }
    }
    
    NSString        *result     = [bodyDict objectForKey:@"result"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
        
        
        self.max    = [[bodyDict objectForKey:@"total"] intValue];
        
        NSArray *resultArr  = [LMEventListVO EventListVOListWithArray:[bodyDict objectForKey:@"list"]];
        
        
        if (resultArr.count==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                homeImage.hidden = NO;
            });
        }
        
        if (resultArr && resultArr.count > 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                homeImage.hidden = YES;
            });
            
            return resultArr;
        }
        
    }
    
    return nil;
}
#pragma mark 发布活动

- (void)publicAction
{
    _isShow = !_isShow;
    
    if (_isShow) {
        [self.showView showView];
        
    }else{
        [self.showView dismissView];
    }
    
}
- (SQMenuShowView *)showView{
    
    if (_showView) {
        return _showView;
    }
    NSArray *array = @[@"发布活动",@"我的活动"];
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){CGRectGetWidth(self.view.frame)-100-10,64,100,0}
                                               items:array
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-25,10}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    return _showView;
}

#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 195;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LMActivityExperienceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LMActivityExperienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listData.count > indexPath.row) {
        
        LMEventListVO  *vo = [self.listData objectAtIndex:indexPath.row];
        
        if (vo && [vo isKindOfClass:[LMEventListVO class]]) {
            
            [cell setVO:vo ] ;
        }
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listData.count > indexPath.row) {
        
        LMEventListVO  *vo = [self.listData objectAtIndex:indexPath.row];
        
        if (vo && [vo isKindOfClass:[LMEventListVO class]]) {
            
            LMActivityDetailController *detailVC = [[LMActivityDetailController alloc] init];
            
            detailVC.hidesBottomBarWhenPushed = YES;
            
            detailVC.eventUuid  = vo.eventUuid;
            detailVC.titleStr   = vo.eventName;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存警告⚠️");
}

@end
