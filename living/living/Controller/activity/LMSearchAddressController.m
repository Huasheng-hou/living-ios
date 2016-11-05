//
//  FirLawyerContactController.m
//  firefly
//
//  Created by JamHonyZ on 16/1/23.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMSearchAddressController.h"
#import "POIAnnotation.h"

@interface LMSearchAddressController ()
<
UISearchBarDelegate,
AMapSearchDelegate,
UISearchDisplayDelegate,
MAMapViewDelegate
>

@end

@implementation LMSearchAddressController

{
    NSMutableArray *_listData;
    UISearchBar *_searchBar;
    
    NSMutableArray *cellArray;
    NSString *userPhone;
    NSString *userHomePhone;
    
    BOOL ifGetLocation;
     AMapPOIAroundSearchRequest *request;
    
    CLGeocoder *_geocoder;
    
    double locationY;
    double locationX;
    
    UIActivityIndicatorView *activity;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_listData) {
        _listData = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [self createUI];
 
    [self initSearch];
    
    [self loadImage];
}

//原生菊花
-(void)loadImage
{
    activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];//指定进度轮的大小
    [activity setCenter:self.view.center];//指定进度轮中心点
    
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
    [self.view addSubview:activity];
    [activity startAnimating];
}

- (void)initSearch
{
    self.search.delegate = self;
    request = [[AMapPOIAroundSearchRequest alloc] init];
    _geocoder=[[CLGeocoder alloc]init];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
   CLLocation *currLocation=userLocation.location;
    
   
    
    if (!ifGetLocation) {
        ifGetLocation=YES;
        
         NSLog(@"didUpdateUserLocation");
        
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(currLocation.coordinate.latitude, currLocation.coordinate.longitude)];
        
        //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
        request.location = [AMapGeoPoint locationWithLatitude:currLocation.coordinate.latitude longitude: currLocation.coordinate.longitude];
        request.sortrule = 0;
        request.requireExtension = YES;
        //发起周边搜索
        [_search AMapPOIAroundSearch: request];
    }
}

#pragma mark - AMapSearchDelegate


- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSLog(@"===========================搜索响应结果=========================");
    
     [activity stopAnimating];
    
    _listData=[NSMutableArray arrayWithCapacity:0];
    
    if (response.pois.count == 0)
    {
        return;
    }
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
    }];
    
    for (int i=0; i<poiAnnotations.count; i++) {
        
        if ( [poiAnnotations[i] title]) {
             [_listData addObject:poiAnnotations[i]];
        }
    }
    
    [self.tableView reloadData];
}


- (void)createUI
{
    [super createUI];
    
     self.title=@"位置";
    
    self.tableView.contentInset     = UIEdgeInsetsMake(114, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(114, 0, 0, 0);
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 50)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"输入地名";
//    [_searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [_searchBar setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:_searchBar];
    
    _searchBar.backgroundImage = [self imageWithColor:BG_GRAY_COLOR size:_searchBar.bounds.size];
    
    _mapView.delegate = self;
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
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString    *IDENTIFIER_CELL = @"IDENTIFIER_CELL";
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_CELL];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER_CELL];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_listData.count>0) {
        
        cell.textLabel.text=[_listData[indexPath.row] title];
        cell.detailTextLabel.text=[_listData[indexPath.row] subtitle];
        [cell.detailTextLabel setTextColor:TEXT_COLOR_LEVEL_3];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    POIAnnotation *poi=_listData[indexPath.row];
    [self.delegate selectAddress:[_listData[indexPath.row] title] andLatitude:poi.coordinate.latitude andLongitude:poi.coordinate.longitude anddistance:0];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""] && [_searchBar.text isEqualToString:@""]) {
        return;
    }else{
        [_geocoder geocodeAddressString:_searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
            //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
            CLPlacemark *placemark=[placemarks firstObject];
            CLLocation *location=placemark.location;//位置
            locationX=location.coordinate.latitude;
            locationY=location.coordinate.longitude;
            
            //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
            request.location = [AMapGeoPoint locationWithLatitude:locationX longitude: locationY];
            request.sortrule = 0;
            request.requireExtension = YES;
            //发起周边搜索
            [_search AMapPOIAroundSearch: request];
            
            [activity startAnimating];
        }];
    }
}




-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self.view endEditing:YES];
    NSLog(@"=============搜索按钮========点击===============");
    
    if ([_searchBar.text isEqualToString:@""]) {
        return;
    }else{
         NSLog(@"=============搜索按钮========点击=开始搜索==============");
        [_geocoder geocodeAddressString:_searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
            //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
            CLPlacemark *placemark=[placemarks firstObject];
            CLLocation *location=placemark.location;//位置
            locationX=location.coordinate.latitude;
            locationY=location.coordinate.longitude;
            
            NSLog(@"=========searchBarSearchButtonClicked=========获取到经纬度=============");
            
            //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
            request.location = [AMapGeoPoint locationWithLatitude:locationX longitude: locationY];
            request.sortrule = 0;
            request.requireExtension = YES;
            //发起周边搜索
            [_search AMapPOIAroundSearch: request];
            
            [activity startAnimating];
        }];
    }
    
}







@end
