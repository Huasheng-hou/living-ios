//
//  LMMyLivingViewController.h
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseViewController.h"

@interface LMMyLivingViewController : FitBaseViewController

@property (nonatomic)           int     current;
@property (nonatomic,strong)NSString *livImgUUid;

// 带tab, nav, status的y向缩放
@property (nonatomic) CGFloat yScaleWithAll;

// 不带tab的y向缩放
@property (nonatomic) CGFloat yScaleNoTab;

// 不带tab, nav的y向缩放
@property (nonatomic) CGFloat yScaleWithStatus;

// x向缩放
@property (nonatomic) CGFloat xScale;
@property (nonatomic) CGFloat yScale;

@end
