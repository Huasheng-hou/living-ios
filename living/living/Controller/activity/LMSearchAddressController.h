//
//  FirLawyerContactController.h
//  firefly
//
//  Created by JamHonyZ on 16/1/23.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FitTableViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

//代理
@protocol selectAddressDelegate <NSObject>

- (void)selectAddress:(NSString *)addressName andLatitude:(CGFloat)latitude
         andLongitude:(CGFloat)longitude
          anddistance:(CGFloat)distance;

@end


@interface LMSearchAddressController : FitTableViewController

@property(nonatomic,strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property(nonatomic,assign)id <selectAddressDelegate> delegate;

@end
