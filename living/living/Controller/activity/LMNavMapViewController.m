//
//  LMNavMapViewController.m
//  living
//
//  Created by JamHonyZ on 2016/11/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMNavMapViewController.h"
#import "LMBottomView.h"
#import "FitConsts.h"

//地图
#import <MAMapKit/MAMapView.h>
#import "AMapTipAnnotation.h"

#import <MapKit/MapKit.h>
#import "SpeechSynthesizer.h"

@interface LMNavMapViewController ()
<
UIActionSheetDelegate,
MAMapViewDelegate,
AMapNaviDriveManagerDelegate,
AMapNaviDriveViewDelegate
>
{
    MAPointAnnotation *point;
    CLLocation *currLocation;
    
    CLLocationCoordinate2D location;
}

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;
@end

@implementation LMNavMapViewController

#pragma mark gps导航

-(void)startNavDrive
{
    [self navManager];
    
    //设置导航的起点和终点
    self.startPoint   = [AMapNaviPoint locationWithLatitude:currLocation.coordinate.latitude longitude:currLocation.coordinate.longitude];
    
    self.endPoint = [AMapNaviPoint locationWithLatitude:location.latitude longitude:location.longitude];
   
    //路径规划
    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                endPoints:@[self.endPoint]
                                                wayPoints:nil
                                          drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}

//路径规划成功后，开始导航
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"================driveManagerOnCalculateRouteSuccess============");
    
    [self.driveManager startGPSNavi];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}



/**
 *  导航界面关闭按钮点击时的回调函数
 */
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView
{
    [self backBeforePage];
}


#pragma mark 调用iphone自带地图导航

-(void)iphoneSelfNav
{
    //起点

    self.startPoint   = [AMapNaviPoint locationWithLatitude:currLocation.coordinate.latitude longitude:currLocation.coordinate.longitude];
    self.endPoint = [AMapNaviPoint locationWithLatitude:location.latitude longitude:location.longitude];
    
    
    CLLocationCoordinate2D from;
    
    from.latitude=currLocation.coordinate.latitude;
    from.longitude=currLocation.coordinate.longitude;
    
    MKMapItem *fromLocation= [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:from addressDictionary:nil]];
    
    fromLocation.name=@"当前位置";
    
    //目的地的位置
    CLLocationCoordinate2D to;
    
    to.latitude=location.latitude;
    to.longitude=location.longitude;
    
    MKMapItem *toLocat = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
    
    toLocat.name = _infoDic[@"addressName"];
    
    NSArray *items = [NSArray arrayWithObjects:fromLocation, toLocat, nil];
    
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    
    //打开苹果自身地图应用，并呈现特定的item
    
    [MKMapItem openMapsWithItems:items launchOptions:options];
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createUI];
}


-(void)navManager
{
    //初始化AMapNaviDriveManager
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }
    
    //初始化AMapNaviDriveView
    if (self.driveView == nil)
    {
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        [self.driveView setDelegate:self];
    }
    
    //将AMapNaviManager与AMapNaviDriveView关联起来
    [self.driveManager addDataRepresentative:self.driveView];
    //将AManNaviDriveView显示出来
    [self.view addSubview:self.driveView];
 
}


-(void)createUI
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsCompass=NO;
    self.mapView.showsScale=NO;
    _mapView.mapType = MAMapTypeStandard;
    [self.view addSubview:self.mapView];
    
    
    //设置中心坐标点
    location.latitude = [_infoDic[@"latitude"] floatValue];
    location.longitude = [_infoDic[@"longitude"] floatValue];
    
    //设置地图跨度
    MACoordinateSpan span;
    span.latitudeDelta = 0.008;
    span.longitudeDelta = 0.008;
    
    //显示地图
    MACoordinateRegion region = {location, span};
    [self.mapView setRegion:region animated:NO];
    
    //点
    point=[[MAPointAnnotation alloc]init];
    point.coordinate=CLLocationCoordinate2DMake(location.latitude, location.longitude);
    point.title = _infoDic[@"addressName"];
    [_mapView addAnnotation:point];
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
    
    //返回按钮
     UIButton *backBt=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 36)];
    [backBt setBackgroundImage:[UIImage imageNamed:@"activityNavBack"] forState:UIControlStateNormal];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:backBt];
    self.navigationItem.leftBarButtonItem = backItem;
    
    backItem.width = -16;
    [backBt addTarget:self action:@selector(backBeforePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBt];

    //定位
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(15, kScreenHeight-100-20-36, 36, 36)];
    [button setBackgroundImage:[UIImage imageNamed:@"activityNavLocation"] forState:UIControlStateNormal];
     [button addTarget:self action:@selector(currentLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    LMBottomView *bottomView=[[LMBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight-100, kScreenWidth, 100)];
    [self.view addSubview:bottomView];
    [bottomView.navButton addTarget:self action:@selector(selectNavType) forControlEvents:UIControlEventTouchUpInside];
    
    bottomView.nameLabel.text=self.infoDic[@"addressName"];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    currLocation=userLocation.location;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *busStopIdentifier = @"identifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:busStopIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:busStopIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    
    return nil;
}


#pragma mark 定位当前位置

-(void)currentLocation
{
     [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(currLocation.coordinate.latitude, currLocation.coordinate.longitude)];
}


-(void)selectNavType
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"用iPhone自带地图导航",@"用高德地图导航",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    actionSheet = nil;
}


#pragma mark UIActionSheet 代理函数

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"===================buttonIndex====%ld",buttonIndex);
    
    if (buttonIndex==0) {
        [self iphoneSelfNav];
    }
    
    if (buttonIndex==1) {
        [self startNavDrive];
    }
}

#pragma mark 返回上一页

-(void)backBeforePage
{
    //停止导航
     [self.driveManager stopNavi];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
