//
//  LMMapViewController.h
//  living
//
//  Created by JamHonyZ on 2016/11/2.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

#import "AMapTipAnnotation.h"
#import "POIAnnotation.h"
#import <AMapSearchKit/AMapSearchKit.h>
//代理
@protocol selectAddressDelegate <NSObject>

- (void)selectAddress:(NSString *)addressName andLatitude:(CGFloat)latitude
         andLongitude:(CGFloat)longitude
          anddistance:(CGFloat)distance;

@end

@interface LMMapViewController : UIViewController

@property(nonatomic,strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property(nonatomic,assign)id <selectAddressDelegate> delegate;

@end
