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

#import "LMMakerRequest.h"
#import "LMWebViewController.h"
#import "UIImageView+WebCache.h"


@interface LMBannerDetailMakerController ()<LMMakerDelegate,CLLocationManagerDelegate>

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
    
    NSMutableArray * _firstArray;  //轮播图 数据
    NSMutableArray * _secondArray; //路演
    NSMutableArray * _thirdArray; //轻创客数据
    
    
    UIView * headView;
    
}
- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self location];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadNewer];
    //[self getMakerRequest];
    
}

- (void)createUI{
    [super createUI];
    
    self.view.backgroundColor = BG_GRAY_COLOR;
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@""
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:nil
                                                                           action:nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - 请求创客数据
- (FitBaseRequest *)request{
    [self initStateHud];
    LMMakerRequest *request = [[LMMakerRequest alloc] init];
    return request;
}
- (NSArray *)parseResponse:(NSString *)resp{
    NSData * data = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * headDic = [dic objectForKey:@"head"];
    if (![headDic[@"returnCode"] isEqualToString:@"000"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:@"验证失败"];
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
    if (!_firstArray) {
        _firstArray = [NSMutableArray new];
    }
    NSDictionary * firstFloor = [body objectForKey:@"first_floor"];
    [_firstArray addObject:firstFloor];
    
    if (!_secondArray) {
        _secondArray = [NSMutableArray new];
    }
    NSDictionary * secondFloor = [body objectForKey:@"second_floor"];
    [_secondArray addObject:secondFloor];
    
    if (!_thirdArray) {
        _thirdArray = [NSMutableArray new];
    }
    _thirdArray = [body objectForKey:@"third_floor"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self hideStateHud];
    });
    
    return nil;
}

#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  225;
    }
    if (indexPath.section == 1) {
        return  kScreenWidth*3/5;
    }
    return 115;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 0;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * typeNames = @[@"丨 腰果路演", @"丨 腰果轻创客"];
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    for (UIView * subView in backView.subviews) {
        [subView removeFromSuperview];
    }
    if (section != 0) {
        UILabel * typeName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        typeName.textColor = TEXT_COLOR_LEVEL_4;
        typeName.font = TEXT_FONT_LEVEL_3;
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:typeNames[section-1]];
        [attr addAttribute:NSForegroundColorAttributeName value:ORANGE_COLOR range:NSMakeRange(0, 2)];
        typeName.attributedText = attr;
        [backView addSubview:typeName];
        
        if (section == 1) {
            return backView;
        }
        
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
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"headCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headCell"];
        }
        for (UIView * subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        LMMakerHeadView * headerView = [[LMMakerHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 225)];
        [headerView setValue:_firstArray[0]];
        [cell.contentView addSubview:headerView];
        cell.backgroundColor = BG_GRAY_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:headerView];
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView * subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenWidth*3/5-20)];
        imageView.backgroundColor = BG_GRAY_COLOR;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:_secondArray[0][@"picture"]]];
        [cell.contentView addSubview:imageView];
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView * subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        for (int i=0; i<2; i++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+((kScreenWidth-30)/2+10)*i, 0, (kScreenWidth-30)/2, 100)];
            imageView.tag = i+10;
            imageView.backgroundColor = BG_GRAY_COLOR;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:_thirdArray[i][@"picture"]]];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [imageView addGestureRecognizer:tap];
            
            [cell.contentView addSubview:imageView];
        }
        return cell;
    }
    return nil;
}
#pragma mark - 点击事件
- (void)tap:(UITapGestureRecognizer *)tap{
    LMWebViewController * webVC = [[LMWebViewController alloc] init];
    webVC.title = @"创客故事";
    if (tap.view.tag == 10) {
        
        webVC.urlString = _thirdArray[0][@"url"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if (tap.view.tag == 11) {
        webVC.urlString = _thirdArray[1][@"url"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self gotoNextPage];
        return;
    }
    
    LMWebViewController * webVC = [[LMWebViewController alloc] init];
    webVC.title = @"创客故事";
    if (indexPath.section == 1) {
        webVC.urlString = _secondArray[0][@"url"];
    }
    if (indexPath.section == 2) {
        webVC.urlString = _thirdArray[indexPath.row][@"url"];
    }
    [self.navigationController pushViewController:webVC animated:YES];

}

/***************************************   预约生活馆   *****************************************/

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
