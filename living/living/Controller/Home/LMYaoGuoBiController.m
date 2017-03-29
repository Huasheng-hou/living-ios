//
//  LMYaoGuoBiController.m
//  living
//
//  Created by hxm on 2017/3/8.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYaoGuoBiController.h"
#import "WJLoopView.h"
#import "FitConsts.h"
#import "LMYGBConvertCell.h"
#import "LMYGBActivityCell.h"

#import "BannerVO.h"
#import "LMBannerrequest.h"
#import "LMHomeDetailController.h"
#import "LMActivityDetailController.h"
#import "LMWebViewController.h"
#import "LMClassroomDetailViewController.h"
#import "LMYaoGuoBiConvertController.h"

#import "LMArtcleTypeListRequest.h"

#import "LMYGBBannerRequest.h"
#import "LMYGBDetailController.h"

#import "LMYGBCoinListRequest.h"
#import "LMYGBDetailRequest.h"
#import "LMCoinlistVO.h"
#import "LMYGBDetailVO.h"
#import "LMYGBExchangeRequest.h"
@interface LMYaoGuoBiController ()<UITableViewDelegate,UITableViewDataSource,WJLoopViewDelegate>

@end

@implementation LMYaoGuoBiController
{
    UIView * headView;
    
    NSArray * _bannerArray;
    NSMutableArray  *stateArray;
    NSArray * _coinDetailArray;
}

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (self.listData.count == 0) {
//        
//        [self loadNoState];
//    }
//
//    if (!_bannerArray || _bannerArray.count == 0) {
//        
//        [self getBannerDataRequest];
//    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];

    //[self getBannerDataRequest];
    [self loadNewer];

}

- (void)createUI{
    [super createUI];
    
    self.navigationItem.title = @"Yao·果币";
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat h = kScreenWidth*3/5+42+10;
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, h)];
    headView.backgroundColor = BG_GRAY_COLOR;
    
    self.tableView.tableHeaderView = headView;
}


#pragma mark - 请求banner数据
- (void)getBannerDataRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LMYGBBannerRequest * request = [[LMYGBBannerRequest alloc] init];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                                   [self parseResp:resp];
                                               });
                                               
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)parseResp:(NSString *)resp{
    
    NSDictionary *bodyDict   = [VOUtil parseBody:resp];
    
    NSString     *result     = [bodyDict objectForKey:@"result"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isEqualToString:@"0"]) {
        
        _bannerArray = [bodyDict objectForKey:@"banners"];
        NSMutableArray * imageUrls = [NSMutableArray new];
        for (int i = 0; i<_bannerArray.count; i++) {
            NSDictionary * dic = _bannerArray[i];
            NSString * imageUrl = [dic objectForKey:@"linkUrl"];
            [imageUrls addObject:imageUrl];
        }
        if (!_bannerArray || ![_bannerArray isKindOfClass:[NSArray class]] || _bannerArray.count < 1) {
            
            headView.backgroundColor = BG_GRAY_COLOR;
        } else {
            
            for (UIView *subView in headView.subviews) {
                
                [subView removeFromSuperview];
            }
            NSString * imgPath = [[NSBundle mainBundle] pathForResource:@"BackImage.png" ofType:nil];
            WJLoopView *loopView = [[WJLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)
                                                            delegate:self
                                                           imageURLs:imageUrls
                                                    placeholderImage:imgPath
                                                        timeInterval:8
                                      currentPageIndicatorITintColor:nil
                                              pageIndicatorTintColor:nil];
                
            loopView.location = WJPageControlAlignmentRight;
            loopView.backgroundColor = ORANGE_COLOR;
            [headView addSubview:loopView];
            
        }
        [self addHeadSubViews];
    }
}
- (void)addHeadSubViews{
    
    CGFloat h = kScreenWidth*3/5+42+10;
    //您的腰果币
    UIView * back = [[UIView alloc] initWithFrame:CGRectMake(0, h-52, kScreenWidth, 42)];
    back.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ygbDetail:)];
    [back addGestureRecognizer:tap];
    [headView addSubview:back];
    
    UIImageView * ygIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    ygIcon.backgroundColor = [UIColor whiteColor];
    ygIcon.image = [UIImage imageNamed:@"yaoguobi-2"];
    [back addSubview:ygIcon];
    
    UILabel * ygb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ygIcon.frame)+10, 11, 100, 20)];
    ygb.text = @"您的腰果币";
    ygb.textColor = TEXT_COLOR_LEVEL_3;
    ygb.font = TEXT_FONT_LEVEL_1;
    ygb.textAlignment = NSTextAlignmentLeft;
    [back addSubview:ygb];
    
    UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-90, 11, 80, 20)];
    number.text = @"0颗";
    number.textColor = TEXT_COLOR_LEVEL_3;
    number.font = TEXT_FONT_LEVEL_1;
    number.textAlignment = NSTextAlignmentRight;
    [back addSubview:number];
    
    UILabel * gapLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(back.frame), kScreenWidth, 10)];
    gapLabel.backgroundColor = BG_GRAY_COLOR;
    [headView addSubview:gapLabel];
    
    
}
#pragma mark - 请求果币明细数据
- (void)getCoinDetailRequest{
    LMYGBDetailRequest * request = [[LMYGBDetailRequest alloc] initWithPageIndex:self.current andPageSize:20];
    HTTPProxy * proxy = [HTTPProxy loadWithRequest:request completed:^(NSString *resp, NSStringEncoding encoding) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self parseCoinDetailResponse:resp];
        });
        
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:@"请求失败"];
        });
    }];
    [proxy start];
}
- (void)parseCoinDetailResponse:(NSString *)resp{
    
    NSData * respData = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * headDict = [respDict objectForKey:@"head"];
    if (![[headDict objectForKey:@"returnCode"] isEqualToString:@"000"]) {
        [self textStateHUD:@"请求失败"];
        return;
    }
    NSDictionary * bodyDict = [VOUtil parseBody:resp];
    if ([bodyDict[@"result"] isEqualToString:@"0"]) {
        
        _coinDetailArray = [LMYGBDetailVO LMYGBDetailVOWithArray:bodyDict[@"list"]];
    }
}


#pragma mark - 请求兑换列表数据

- (FitBaseRequest *)request{
    [self initStateHud];
    [self getBannerDataRequest];
    
    LMYGBCoinListRequest *request = [[LMYGBCoinListRequest alloc] initWithPageIndex:self.current andPageSize:20];
    return  request;
}

- (NSArray *)parseResponse:(NSString *)resp{
    NSData * data = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * headDic = [dic objectForKey:@"head"];
    if (![headDic[@"returnCode"] isEqualToString:@"000"]) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:@"身份验证失败"];
        });
        
        return nil;
    }
    NSDictionary * body = [VOUtil parseBody:resp];
    if (![body[@"result"] isEqualToString:@"0"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:@"请求失败"];
        });
        return nil;
    }
    NSArray * listArr = [body objectForKey:@"list"];
    NSArray * resultArr = [LMCoinlistVO LMCoinlistVOWithArray:listArr];
    if (resultArr.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:@"数据列表为空"];
        });
    }
    return resultArr;
}

#pragma mark - 发起兑换优惠券请求
- (void)coinExchangeRequest:(NSInteger)index{
    [self initStateHud];
    LMCoinlistVO * vo = self.listData[index];
    LMYGBExchangeRequest * request = [[LMYGBExchangeRequest alloc] initWithAmount:vo.amount andNumbers:vo.numbers];
    HTTPProxy * proxy = [HTTPProxy loadWithRequest:request completed:^(NSString *resp, NSStringEncoding encoding) {
        
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self parseCoinExchangeResponse:resp];
                                                });
                                            }
                                            failed:^(NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self textStateHUD:@"网络错误"];
                                                    NSLog(@"%@", error.localizedDescription);
                                                });
                                            }];
    
    [proxy start];
}

- (void)parseCoinExchangeResponse:(NSString *)resp{
    
    NSData * data = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSString * description = [dic objectForKey:@"description"];
    NSDictionary * headDic = [dic objectForKey:@"head"];
    if (![headDic[@"returnCode"] isEqualToString:@"000"]) {
        
        [self textStateHUD:description];
        return ;
    }
    NSDictionary * body = [VOUtil parseBody:resp];
    if (![body[@"result"] isEqualToString:@"0"]) {
        
        [self textStateHUD:@"兑换失败"];
        return;
    }
    
    [self textStateHUD:@"兑换成功"];
    [self loadNewer];
}

#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listData.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray * typeNames = @[@"丨 果币兑换", @"丨 果币活动"];
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    backView.backgroundColor = [UIColor whiteColor];
    for (UIView * subView in backView.subviews) {
        [subView removeFromSuperview];
    }
    
    
    UILabel * typeName = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 15)];
    typeName.textColor = TEXT_COLOR_LEVEL_4;
    typeName.font = TEXT_FONT_LEVEL_3;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:typeNames[section]];
    [attr addAttribute:NSForegroundColorAttributeName value:ORANGE_COLOR range:NSMakeRange(0, 2)];
    typeName.attributedText = attr;
    [backView addSubview:typeName];
    
    UILabel * lookMore = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-60-10, 15, 60, 15)];
    lookMore.text = @"查看更多 >";
    lookMore.textAlignment = NSTextAlignmentRight;
    lookMore.textColor = TEXT_COLOR_LEVEL_5;
    lookMore.font = TEXT_FONT_LEVEL_3;
    lookMore.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMore:)];
    [lookMore addGestureRecognizer:tap];
    //[backView addSubview:lookMore];
    
    return  backView;
    
}
- (void)lookMore:(UITapGestureRecognizer *)tap{
    NSLog(@"查看更多");
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LMYGBActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"aCell"];
    if (!cell) {
        cell = [[LMYGBActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listData.count > indexPath.row) {
        LMCoinlistVO * vo = self.listData[indexPath.row];
        [cell setVO:vo];
    }
    return cell;
}
//点击列表进行兑换
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要进行兑换吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"兑换请求");
        [self coinExchangeRequest:indexPath.row];
    }];
    
    [alert addAction:cancleAction];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - 进入腰果币明细
- (void)ygbDetail:(UITapGestureRecognizer *)tap{
    
    LMYGBDetailController * ygbDetail = [[LMYGBDetailController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:ygbDetail animated:YES];
    
}

#pragma mark scrollview代理函数

- (void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index
{
    if (_bannerArray.count>index) {
        
        NSDictionary * dic = _bannerArray[index];
        NSString * url = [dic objectForKey:@"linkUrl"];
        LMWebViewController *webVC = [[LMWebViewController alloc] init];
        
        webVC.hidesBottomBarWhenPushed  = YES;
        webVC.urlString                 = url;
        [self.navigationController pushViewController:webVC animated:YES];
        
        /*
        //活动
        if ([dic[@"type"] isEqualToString:@"event"]) {
            
                LMActivityDetailController *eventVC = [[LMActivityDetailController alloc] init];
                
                eventVC.hidesBottomBarWhenPushed = YES;
                //eventVC.eventUuid = vo.KeyUUID;
                
                [self.navigationController pushViewController:eventVC animated:YES];
        }
        //文章
        if ([dic[@"type"] isEqualToString:@"article"]) {
            
            if (vo.KeyUUID && [vo.KeyUUID isKindOfClass:[NSString class]] && ![vo.KeyUUID isEqual:@""]) {
                
                LMHomeDetailController *eventVC = [[LMHomeDetailController alloc] init];
                
                eventVC.hidesBottomBarWhenPushed = YES;
                eventVC.artcleuuid = vo.KeyUUID;
                
                [self.navigationController pushViewController:eventVC animated:YES];
            }
        }
        //web
        if ([dic[@"type"] isEqualToString:@"web"]) {
            
            if (vo.webUrl && [vo.webUrl isKindOfClass:[NSString class]] && ![vo.webUrl isEqualToString:@""]) {
                
                LMWebViewController *webVC = [[LMWebViewController alloc] init];
                
                webVC.hidesBottomBarWhenPushed  = YES;
                webVC.titleString               = vo.webTitle ;
                webVC.urlString                 = vo.webUrl;
                
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
        //语音课堂
        if ([dic[@"type"] isEqualToString:@"voice"]) {
            
            if (vo.KeyUUID && [vo.KeyUUID isKindOfClass:[NSString class]] && ![vo.KeyUUID isEqual:@""]) {
                
                LMClassroomDetailViewController *eventVC = [[LMClassroomDetailViewController alloc] init];
                
                eventVC.hidesBottomBarWhenPushed = YES;
                eventVC.voiceUUid = vo.KeyUUID;
                
                [self.navigationController pushViewController:eventVC animated:YES];
            }
        }
         
         */
         
    }
}

@end
