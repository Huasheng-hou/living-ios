//
//  LMActivityLifeHouseBtn.m
//  living
//
//  Created by WangShengquan on 2017/2/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMActivityLifeHouseBtn.h"
#import "UIImageView+WebCache.h"
#import "FitConsts.h"

#define BtnW self.frame.size.width
#define BtnH self.frame.size.height

@interface LMActivityLifeHouseBtn ()

@end

@implementation LMActivityLifeHouseBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    // 图片
    self.activityImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, BtnW, (BtnW - 5) /3 * 2)];
    self.activityImg.layer.cornerRadius = 8;
    self.activityImg.backgroundColor = [UIColor colorWithRed:253.0/255 green:223.0/255 blue:208.0/255 alpha:1.0];
    [self addSubview:self.activityImg];
    
    // 图片中的活动名称
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 144 * 0.3, BtnW, 40)];
    self.nameLbl.textColor = [UIColor whiteColor];
    self.nameLbl.textAlignment = NSTextAlignmentCenter;
    self.nameLbl.text = @"活动名称";
    [self.activityImg addSubview:self.nameLbl];
    
    // 图片下的活动标题
    self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 144 * 0.8, BtnW, 30)];
    self.titleLbl.textColor = [UIColor blackColor];
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.text = @"杭州V5生活馆";
    self.titleLbl.font = TEXT_FONT_LEVEL_2;
    [self addSubview:self.titleLbl];
}


@end
