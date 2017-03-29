//
//  LMHomeVoiceDetailController.h
//  living
//
//  Created by Ding on 2017/1/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseViewController.h"

@interface LMHomeVoiceDetailController : FitBaseViewController

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic, strong) NSString *voiceUuid;

@property(nonatomic, strong) NSString *franchisee;

@property(nonatomic, strong) NSString *sign;



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
