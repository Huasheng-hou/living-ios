//
//  FirLawyerContactController.m
//  firefly
//
//  Created by JamHonyZ on 16/1/23.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMSearchAddressController.h"
#import "POIAnnotation.h"
#import "GeocodeAnnotation.h"
#import "NSString+StringHelper.h"
#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

@interface LMSearchAddressController ()
<
UISearchBarDelegate,
AMapSearchDelegate,
UISearchDisplayDelegate,
AMapLocationManagerDelegate
>
{
    NSMutableDictionary *cellDic;
    UISearchBar *_searchBar;
    CLGeocoder *_geocoder;
    double locationY;
    double locationX;
    UIActivityIndicatorView *activity;
}
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@end

@implementation LMSearchAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellDic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [self createUI];
 
    [self initSearch];
    
    [self loadImage];
    
    [self initCompleteBlock];
    
    [self configLocationManager];
}

#pragma mark ============定位===============
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    //进行单次定位请求
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}

#pragma mark - Initialization

- (void)initCompleteBlock
{
    __weak LMSearchAddressController *weakSelf = self;
    
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            //如果为定位失败的error，则不进行后续操作
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        //得到定位信息
        if (location)
        {
            if (regeocode)
            {
                NSLog(@"===========%@ \n %@-%@-%.2fm",regeocode.formattedAddress,regeocode.citycode, regeocode.adcode, location.horizontalAccuracy);
            }
            else
            {
                 NSLog(@"============lat:%f;lon:%f \n accuracy:%.2fm", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
                
                [weakSelf searchAroundWithLocation:location.coordinate.latitude andLongtitude:location.coordinate.longitude];
            }
        }
    };
}

//原生菊花
-(void)loadImage
{
    activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];//指定进度轮的大小
    [activity setCenter:self.view.center];//指定进度轮中心点
    
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
    [self.view addSubview:activity];
//    [activity startAnimating];
}

- (void)initSearch
{
    self.search.delegate = self;
    
    _geocoder=[[CLGeocoder alloc]init];
}

#pragma mark - AMapSearchDelegate

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
     [activity stopAnimating];
    
    if (response.pois.count == 0)
    {
        return;
    }
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    NSMutableArray *textArray=[NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray *detailTextArray=[NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray *locationArray=[NSMutableArray arrayWithCapacity:0];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
    }];
    
    for (int i=0; i<poiAnnotations.count; i++) {
        
        if ( ![poiAnnotations[i] title]) {
            return;
        }
        [textArray addObject:[poiAnnotations[i] title]];
         [detailTextArray addObject:[poiAnnotations[i] subtitle]];
        
        POIAnnotation *poi=poiAnnotations[i];
         [locationArray addObject:poi];
    }
    
    [self setupCellDataWithTitleArray:textArray andDetailTextArray:detailTextArray andLocationArray:locationArray];
}

#pragma mark 设置单元格数据
-(void)setupCellDataWithTitleArray:(NSArray *)titleArray andDetailTextArray:(NSArray *)DetailArray andLocationArray:(NSArray *)locationArray
{
     [cellDic removeAllObjects];
    
    [cellDic setObject:titleArray forKey:@"title"];
    [cellDic setObject:DetailArray forKey:@"detail"];
    [cellDic setObject:locationArray forKey:@"location"];
    
     [self.tableView reloadData];
}


/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
     [activity stopAnimating];
    
    NSMutableArray *textArray=[NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray *detailTextArray=[NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray *locationArray=[NSMutableArray arrayWithCapacity:0];

    
    for (int i=0; i<response.tips.count; i++) {
        
            AMapTip *tip=response.tips[i];
            if (!tip.name) {
                return;
            }
            [textArray addObject:tip.name];
            
            [detailTextArray addObject:tip.address];
            
            AMapGeoPoint *point=tip.location;
            NSLog(@"tip.name:%@\n tip.address: %@\n   tip.location:%@",tip.name,tip.address,tip.location);
        if (point) {
            [locationArray addObject:point];
        }else{
             [locationArray addObject:@"0"];
        }
    }
    
   [self setupCellDataWithTitleArray:textArray andDetailTextArray:detailTextArray andLocationArray:locationArray];
}



- (void)createUI
{
    [super createUI];
    
     self.title = @"选择位置";
    
    self.tableView.contentInset     = UIEdgeInsetsMake(114, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(114, 0, 0, 0);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 50)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"输入地名";

    [self.view addSubview:_searchBar];
    
    _searchBar.backgroundImage = [self imageWithColor:BG_GRAY_COLOR size:_searchBar.bounds.size];
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *titleArray=cellDic[@"title"];
    
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString    *IDENTIFIER_CELL = @"IDENTIFIER_CELL";
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_CELL];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER_CELL];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *titleArray=cellDic[@"title"];
    if (titleArray[indexPath.row]) {
         cell.textLabel.text=titleArray[indexPath.row];
    }
    
     NSArray *detailTitleArray=cellDic[@"detail"];
    if (detailTitleArray[indexPath.row]) {
        cell.detailTextLabel.text=detailTitleArray[indexPath.row];
    }
    
    [cell.detailTextLabel setTextColor:TEXT_COLOR_LEVEL_3];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    NSArray *titleArray=cellDic[@"title"];
    
    NSArray *locationArray=cellDic[@"location"];
    
    if ([locationArray[indexPath.row] isKindOfClass:[POIAnnotation class]]) {
        POIAnnotation *poi=locationArray[indexPath.row];
        
        if (poi) {
             [self.delegate selectAddress:titleArray[indexPath.row] andLatitude:poi.coordinate.latitude andLongitude:poi.coordinate.longitude anddistance:0];
        }
    }else if ([locationArray[indexPath.row] isKindOfClass:[AMapGeoPoint class]]) {
        AMapGeoPoint *point=locationArray[indexPath.row];
        if (point) {
             [self.delegate selectAddress:titleArray[indexPath.row] andLatitude:point.latitude andLongitude:point.longitude anddistance:0];
        }
    }else{
            [self textStateHUD:@"请选择详细地址"];
            return;
    }
  
    dispatch_async(dispatch_get_main_queue(), ^{
        
         [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""] && [_searchBar.text isEqualToString:@""]) {
        return;
    }else{
        if (searchText.isChinese) {
            [self searchWithKeyWord:searchText];
        }
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
    if ([_searchBar.text isEqualToString:@""]) {
        return;
    } else {
        if (_searchBar.text.isChinese) {
            [self searchWithKeyWord:_searchBar.text];
        }
    }
}

#pragma mark 周边搜索

-(void)searchAroundWithLocation:(CGFloat)latitude andLongtitude:(CGFloat)longitude
{
     [activity startAnimating];
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude: longitude];
    request.sortrule = 0;
    request.keywords            = @"住宅|购物服务|生活服务|住宿服务|风景名胜|政府机构|地名地址信息|公共设施";
    request.requireExtension = YES;
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
}

#pragma mark 关键字搜索

-(void)searchWithKeyWord:(NSString *)address
{
    [activity startAnimating];
   AMapInputTipsSearchRequest *request = [[AMapInputTipsSearchRequest alloc] init];
    request.keywords            = address;
//    request.city     = @"杭州";
    //发起周边搜索
    [_search AMapInputTipsSearch:request];
}



@end
