//
//  LMBalanceViewController.h
//  living
//
//  Created by Ding on 16/10/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitStatefulTableViewController.h"

@interface LMBalanceViewController : FitStatefulTableViewController

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
