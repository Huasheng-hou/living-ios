//
//  LMBannerDetailMakerController.m
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMBannerDetailMakerController.h"
#import "LMMakerHeadView.h"

#import "LMSubmitSuccessController.h"
#import "LMQingMakerController.h"

#import "LMBookLivingRequest.h"
#import <CoreLocation/CoreLocation.h>

#import "LMMakerBannerVO.h"
#import "LMMakerBannerRequest.h"
#import "WJLoopView.h"
#import "LMWebViewController.h"
@interface LMBannerDetailMakerController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LMMakerDelegate,CLLocationManagerDelegate,WJLoopViewDelegate>

@end

@implementation LMBannerDetailMakerController
{
    UICollectionView * _collectionView;
    
    BOOL isShow;
    CGFloat keyBoardHeight;
    
    UIView * bgView;
    UIView * topView;
    UIView * botView;
    UILabel * tips;
    UITextField * nameTF;
    UITextField * phoneTF;
    UIButton * bookBtn;
    
    CLLocationManager * locationManager;
    NSString * _currentCity;
    
    NSArray * _bannerArray;
    UIView * headView;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self location];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}

- (void)createUI{

    self.view.backgroundColor = BG_GRAY_COLOR;
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@""
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:nil
                                                                           action:nil];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"headCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"mainCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHead"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFoot"];
}
#pragma mark - 请求轮播图数据
- (void)getBannerDataRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    LMMakerBannerRequest *request = [[LMMakerBannerRequest alloc] init];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [self parseBannerResp:resp];
                                               });
                                               
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}
- (void)parseBannerResp:(NSString *)resp{
    
    NSDictionary *bodyDict   = [VOUtil parseBody:resp];
    
    NSString     *result     = [bodyDict objectForKey:@"result"];
    
    if (result && ![result isEqual:[NSNull null]] && [result isEqualToString:@"0"]) {
        
        _bannerArray = [LMMakerBannerVO LMMakerBannerVOWithArray:[bodyDict objectForKey:@"banners"]];
        
        if (!_bannerArray || ![_bannerArray isKindOfClass:[NSArray class]] || _bannerArray.count < 1) {
            
            headView.backgroundColor = BG_GRAY_COLOR;
        } else {
            
            for (UIView *subView in headView.subviews) {
                
                [subView removeFromSuperview];
            }
            
            NSMutableArray   *imgUrls    = [NSMutableArray new];
            
            
            for (int i=0; i<_bannerArray.count; i++) {
                LMMakerBannerVO * vo = _bannerArray[i];
                if (vo && [vo isKindOfClass:[LMMakerBannerVO class]] && vo.webUrl) {
                    
                    [imgUrls addObject:vo.webUrl];
                }
            }
            
            WJLoopView * loopView = [[WJLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)
                                                            delegate:self
                                                           imageURLs:imgUrls
                                                    placeholderImage:nil
                                                        timeInterval:8
                                      currentPageIndicatorITintColor:nil
                                              pageIndicatorTintColor:nil];
            
            loopView.location = WJPageControlAlignmentRight;
            
            [headView addSubview:loopView];
        }
    }
    
}

#pragma mark - WJLoopViewDelegate
- (void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index{
    if (_bannerArray.count > index) {
        
        LMWebViewController * webVC = [[LMWebViewController alloc] init];
        LMMakerBannerVO * vo = _bannerArray[index];
        webVC.title = vo.title;
        webVC.urlString = vo.webUrl;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    
}


#pragma mark - collectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 2) {
        return 2;
    }
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, 225);
    }
    if (indexPath.section == 1) {
        return CGSizeMake(kScreenWidth, kScreenWidth*3/5);
    }
    return CGSizeMake((kScreenWidth-30)/2, 115);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (section != 2) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
        LMMakerHeadView * headerView = [[LMMakerHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 225)];
        headerView.delegate = self;
        [cell.contentView addSubview:headerView];
        cell.backgroundColor = BG_GRAY_COLOR;
        return cell;
    }
    if (indexPath.section == 1) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenWidth*3/5-20)];
        imageView.backgroundColor = BG_GRAY_COLOR;
        imageView.image = [UIImage imageNamed:@"BackImage"];
        [cell.contentView addSubview:imageView];
        return cell;
    }
    if (indexPath.section == 2) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-30)/2, 100)];
        imageView.backgroundColor = BG_GRAY_COLOR;
        imageView.image = [UIImage imageNamed:@"BackImage"];
        [cell.contentView addSubview:imageView];
        
        return cell;

    }
    return nil;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(kScreenWidth, 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return CGSizeZero;
    }
    return CGSizeMake(kScreenWidth, 10);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * typeNames = @[@"丨 腰果路演", @"丨 腰果轻创客"];
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView * backView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFoot" forIndexPath:indexPath];;
        for (UIView * subView in backView.subviews) {
            [subView removeFromSuperview];
        }
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        label.backgroundColor = BG_GRAY_COLOR;
        [backView addSubview:label];
        
        return backView;
    }
    if (indexPath.section != 0) {
        UICollectionReusableView * backView = nil;
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            backView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHead" forIndexPath:indexPath];
            backView.backgroundColor = [UIColor whiteColor];
            for (UIView * subView in backView.subviews) {
                [subView removeFromSuperview];
            }
            
            UILabel * typeName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
            typeName.textColor = TEXT_COLOR_LEVEL_4;
            typeName.font = TEXT_FONT_LEVEL_3;
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:typeNames[indexPath.section-1]];
            [attr addAttribute:NSForegroundColorAttributeName value:ORANGE_COLOR range:NSMakeRange(0, 2)];
            typeName.attributedText = attr;
            [backView addSubview:typeName];
            
            UILabel * lookMore = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-60-10, 10, 60, 20)];
            lookMore.text = @"查看更多 >";
            lookMore.textAlignment = NSTextAlignmentRight;
            lookMore.textColor = TEXT_COLOR_LEVEL_5;
            lookMore.font = TEXT_FONT_LEVEL_3;
            lookMore.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMore:)];
            [lookMore addGestureRecognizer:tap];
            [backView addSubview:lookMore];
            
            return  backView;
        }
    
    }
    return nil;
}

- (void)lookMore:(UITapGestureRecognizer *)tap{
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    LMQingMakerController * qmVC = [[LMQingMakerController alloc] init];
    qmVC.title =  @"轻创客";
    [self.navigationController pushViewController:qmVC animated:YES];

}
#pragma mark - 点击了解轻创客
- (void)gotoNextPage{
    
    [self contactUs];
}
#pragma mark 联系我们
- (void)contactUs{
    
    bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view.window addSubview:bgView];
    
    //半透明部分
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-210)];
    topView.backgroundColor = MASK_COLOR;
    [bgView addSubview:topView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove:)];
    [topView addGestureRecognizer:tap];
    
    //信息部分
    botView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-210, kScreenWidth, 210)];
    botView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:botView];
    
    //提示语
    tips = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 25)];
    tips.text = @"留下姓名电话，预约就近生活馆了解“创客”详情";
    tips.textColor = TEXT_COLOR_LEVEL_4;
    tips.font = TEXT_FONT_LEVEL_2;
    [botView addSubview:tips];
    
    //姓名
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 45, kScreenWidth-20, 35)];
    nameTF.keyboardType = UIKeyboardTypeDefault;
    nameTF.placeholder = @" 姓名";
    nameTF.textColor = TEXT_COLOR_LEVEL_2;
    nameTF.font = TEXT_FONT_LEVEL_1;
    [nameTF setValue:TEXT_COLOR_LEVEL_4 forKeyPath:@"_placeholderLabel.textColor"];
    nameTF.borderStyle = UITextBorderStyleLine;
    nameTF.layer.borderColor = TEXT_COLOR_LEVEL_4.CGColor;
    nameTF.layer.borderWidth = 1;
    nameTF.layer.masksToBounds = YES;
    nameTF.layer.cornerRadius = 3;
    [botView addSubview:nameTF];
    
    //电话
    phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 90, kScreenWidth-20, 35)];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.placeholder = @" 电话";
    phoneTF.textColor = TEXT_COLOR_LEVEL_2;
    phoneTF.font = TEXT_FONT_LEVEL_1;
    [phoneTF setValue:TEXT_COLOR_LEVEL_4 forKeyPath:@"_placeholderLabel.textColor"];
    phoneTF.borderStyle = UITextBorderStyleLine;
    phoneTF.layer.borderColor = TEXT_COLOR_LEVEL_4.CGColor;
    phoneTF.layer.borderWidth = 1;
    phoneTF.layer.masksToBounds = YES;
    phoneTF.layer.cornerRadius = 3;
    [botView addSubview:phoneTF];
    
    //预约按钮
    bookBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 135, kScreenWidth-40, 45)];
    [bookBtn setTitle:@"预约生活馆" forState:UIControlStateNormal];
    [bookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bookBtn.titleLabel.font = TEXT_FONT_BOLD_14;
    bookBtn.backgroundColor = ORANGE_COLOR;
    bookBtn.layer.masksToBounds = YES;
    bookBtn.layer.cornerRadius = 3;
    [bookBtn addTarget:self action:@selector(booking:) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:bookBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark - 定位
- (void)location{
    
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             _currentCity = city;
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 [self hideStateHud];
//             });
         }else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error.localizedDescription);
         }
     }];
}

- (void)booking:(UIButton *)btn{
    
    [self location];
    //验证输入内容
    if ([self checkConfirm]) {
        
        [self bookLivingRequest];
    }
}
#pragma mark - 发起预约生活馆请求
- (void)bookLivingRequest{
    if (![CheckUtils isLink]) {
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LMBookLivingRequest * request = [[LMBookLivingRequest alloc] initWithName:nameTF.text andPhone:phoneTF.text andLivingUuid:@""];
    HTTPProxy * proxy = [HTTPProxy loadWithRequest:request
                                         completed:^(NSString *resp, NSStringEncoding encoding) {
                                            [self performSelectorOnMainThread:@selector(parseResp:)
                                                                   withObject:resp
                                                                waitUntilDone:YES];
                                         }
                                            failed:^(NSError *error) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [self textStateHUD:@"网络错误"];
                                           });
                                        }];
    [proxy start];
}
- (void)parseResp:(NSString *)resp{
    NSData * respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary * respDic = [NSJSONSerialization JSONObjectWithData:respData
                                                             options:NSJSONReadingMutableLeaves
                                                               error:nil];
    NSDictionary * headDic = [respDic objectForKey:@"head"];
    if (![[headDic objectForKey:@"returnCode"] isEqualToString:@"000"]) {
        [nameTF resignFirstResponder];
        [phoneTF resignFirstResponder];
        
        [self textStateHUD:@"预约失败"];
        
        
        return ;
    }
    NSDictionary * bodyDic = [VOUtil parseBody:resp];
    if (![[bodyDic objectForKey:@"result"] isEqualToString:@"0"]) {
        [nameTF resignFirstResponder];
        [phoneTF resignFirstResponder];
        
        [self textStateHUD:@"预约失败"];
       
        return;
    }
    //移除当前视图
    [bgView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //跳转下一页面
    LMSubmitSuccessController * ssVC = [[LMSubmitSuccessController alloc] init];
    ssVC.title = @"预约成功";
    ssVC.city = _currentCity;
    [self.navigationController pushViewController:ssVC animated:YES];
    
}
#pragma 验证输入内容
- (BOOL)checkConfirm{
    if ([nameTF.text isEqualToString:@""] ) {
        [nameTF resignFirstResponder];
        [phoneTF resignFirstResponder];
        
        [self textStateHUD:@"请输入姓名"];
        

        
        return NO;
    }
    else if ([phoneTF.text isEqualToString:@""]) {
        [nameTF resignFirstResponder];
        [phoneTF resignFirstResponder];
        
        [self textStateHUD:@"请输入电话"];
        
       
        return NO;
    }
    else{
        // 手机号正则
        NSString *mobileRegex = @"[1][34578][0-9]{9}";
        NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
        
        if (![mobilePredicate evaluateWithObject:phoneTF.text]) {
            
            [nameTF resignFirstResponder];
            [phoneTF resignFirstResponder];
            
            [self textStateHUD:@"手机格式不正确"];
    
            return NO;
        }
    }
    return YES;
}

- (void)keyboardShow:(NSNotification *)noti{
    if (isShow) {
        return;
    }
    isShow = YES;

    CGRect frame = bgView.frame;
    NSDictionary * info = [noti userInfo];
    CGSize kSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyBoardHeight = kSize.height;
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y-kSize.height, frame.size.width, frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        bgView.frame = rect;
    }];
}
- (void)keyboardHide:(NSNotification *)noti{
    
    [self hideAnimation];
    
}
- (void)remove:(UITapGestureRecognizer *)tap{
    if (isShow) {
        
        [nameTF resignFirstResponder];
        [phoneTF resignFirstResponder];
        
    }else{
        [bgView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
- (void)hideAnimation{
    isShow = NO;
    
    CGRect frame = bgView.frame;
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y+keyBoardHeight, frame.size.width, frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        bgView.frame = rect;
    }];
    
    
}
@end
