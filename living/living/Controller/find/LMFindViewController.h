//
//  LMFindViewController.h
//  dirty
//
//  Created by Ding on 16/9/22.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FitBaseViewController.h"

@interface LMFindViewController : FitBaseViewController

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
