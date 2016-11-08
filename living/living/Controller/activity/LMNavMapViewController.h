//
//  LMNavMapViewController.h
//  living
//
//  Created by JamHonyZ on 2016/11/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviDriveManager.h>

//#import "iflyMSC/IFlySpeechError.h"
//#import "iflyMSC/IFlySpeechSynthesizer.h"
//#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"


@interface LMNavMapViewController : UIViewController

@property(nonatomic,strong)NSMutableDictionary *infoDic;


@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

//@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@end
