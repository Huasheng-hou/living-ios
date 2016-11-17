//
//  LMEventDetailViewController.h
//  living
//
//  Created by Ding on 2016/11/17.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseViewController.h"

@interface LMEventDetailViewController : FitBaseViewController

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic, strong) NSString *titleStr;
@property(nonatomic, strong) NSString *eventUuid;

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
