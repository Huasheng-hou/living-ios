
//
//  LMMapViewController.m
//  living
//
//  Created by JamHonyZ on 2016/11/2.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMapViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface LMMapViewController ()
<
MAMapViewDelegate,
AMapSearchDelegate,
UISearchDisplayDelegate,
UITableViewDelegate,
UITableViewDataSource,
UISearchBarDelegate
>
{
    
    NSString *cityName;
    CGFloat latitudeValue;
    CGFloat longitudeValue;
    CLLocation *currLocation;
    BOOL ifGetLocation;
    
    NSMutableArray *cellDataArray;
    UITableView *table;
    AMapPOIAroundSearchRequest *request;
    AMapReGeocodeSearchRequest *regeo;
    MAPointAnnotation *pointAnnotation;
}

@end

@implementation LMMapViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self clear];
    
    [self.mapView setDelegate:nil];
    self.mapView=nil;
    [self.search setDelegate:nil];
    self.search=nil;
    request=nil;
    regeo=nil;
    pointAnnotation=nil;
}

/* 清除annotations & overlays */
- (void)clear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    currLocation=userLocation.location;
    
    if (!ifGetLocation) {
        ifGetLocation=YES;
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[AMapTipAnnotation class]]){
        static NSString *tipIdentifier = @"tipIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:tipIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:tipIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    else if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return poiAnnotationView;
    }
    else if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return poiAnnotationView;
    }
    return nil;
}

-(void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.sortrule = 0;
    request.requireExtension = YES;
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
}

#pragma mark - AMapSearchDelegate

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request1 response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request1.location.longitude);
        
        [self clear];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        pointAnnotation.title = response.regeocode.formattedAddress;
        [_mapView addAnnotation:pointAnnotation];
        
        cityName=response.regeocode.formattedAddress;
        
        latitudeValue=coordinate.latitude;
        
        longitudeValue=coordinate.longitude;
    }
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [cellDataArray removeAllObjects];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
    }];
    
    for (int i=0; i<poiAnnotations.count; i++) {
        
        [cellDataArray addObject:poiAnnotations[i]];
    }
    
    [table reloadData];
    
    [UIView animateWithDuration:0.5f animations:^{
        [table setFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (cellDataArray.count>0) {
        return cellDataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    
    if (cellDataArray.count>0) {
        
        cell.textLabel.text=[cellDataArray[indexPath.row] title];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    cityName=[cellDataArray[indexPath.row] title];
    
    latitudeValue=[cellDataArray[indexPath.row] coordinate].latitude;
    
    longitudeValue=[cellDataArray[indexPath.row] coordinate].longitude;
    
    [self clear];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue);
    pointAnnotation.title = cityName;
    [_mapView addAnnotation:pointAnnotation];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createUI];
}

-(void)createUI
{
    [self createNavUI];
   [self createMapView];
     [self initSearch];
    
    [self initVariable];
    
     table=[[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50) style:UITableViewStylePlain];
    [table setDelegate:self];
    [table setDataSource:self];
    [table setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:table];
}

-(void)createMapView
{
    self.mapView.frame = self.view.bounds;
    
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
//    self.mapView.showsUserLocation = YES;
//    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(currLocation.coordinate.latitude, currLocation.coordinate.longitude)];
    
    [self.mapView setUserTrackingMode:MAUserTrackingModeNone];
}

- (void)initVariable
{
    cellDataArray=[[NSMutableArray alloc]init];
    request = [[AMapPOIAroundSearchRequest alloc] init];
    regeo = [[AMapReGeocodeSearchRequest alloc] init];
    pointAnnotation = [[MAPointAnnotation alloc] init];
}


- (void)createNavUI
{
    self.title=@"地图";
    
    UIButton *rightBt    =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    
    [rightBt setTitle:@"确定" forState:UIControlStateNormal];
    [rightBt.titleLabel setFont:[UIFont systemFontOfSize:18]];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBt];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    UITapGestureRecognizer   *rightTap= [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(sureButtonAction)];
    
    [rightBt addGestureRecognizer:rightTap];
}

- (void)initSearch
{
    self.search.delegate = self;
}

#pragma mark 返回上一页执行的函数

- (void)returnAction
{
    [UIView animateWithDuration:0.5f animations:^{
        [table setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 确定按钮执行函数

- (void)sureButtonAction
{
    [UIView animateWithDuration:0.5f animations:^{
        [table setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    }];
    
    CLLocation *before  = [[CLLocation alloc] initWithLatitude:latitudeValue longitude:longitudeValue];
    // 计算距离
    CLLocationDistance meters   = [currLocation distanceFromLocation:before];
    
    [self.delegate selectAddress:cityName andLatitude:latitudeValue andLongitude:longitudeValue anddistance:meters];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
