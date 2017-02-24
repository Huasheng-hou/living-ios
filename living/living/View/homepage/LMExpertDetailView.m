//
//  LMExpertDetailView.m
//  living
//
//  Created by Huasheng on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertDetailView.h"
#import "FitConsts.h"
@implementation LMExpertDetailView
{
    UIImageView * _icon;
    UIImageView * _flag;
    UILabel * _name;
    UILabel * _introduce;

}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self addSubViews];
        
    }
    return self;
    
}

- (void)addSubViews{
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
    _icon.image = [UIImage imageNamed:@"cellHeadImageIcon"];
    _icon.backgroundColor = BG_GRAY_COLOR;
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = 25;
    [backView addSubview:_icon];
    
    _flag = [[UIImageView alloc] initWithFrame:CGRectMake(40, 45, 20, 20)];
    _flag.image = [UIImage imageNamed:@"BigVRed"];
    //_flag.backgroundColor = ORANGE_COLOR;
    _flag.layer.masksToBounds = YES;
    _flag.layer.cornerRadius = 10;
    [backView addSubview:_flag];
    
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 60, 20)];
    _name.text = @"李莺莺";
    _name.textColor = TEXT_COLOR_LEVEL_3;
    _name.font = TEXT_FONT_BOLD_14;
    [backView addSubview:_name];
    
    
    _introduce = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 170, 30)];
    _introduce.text = @"讲师介绍讲师介绍讲师介绍讲师介绍讲师介绍讲师介绍讲师介绍";
    _introduce.textColor = TEXT_COLOR_LEVEL_5;
    _introduce.font = TEXT_FONT_BOLD_12;
    _introduce.numberOfLines = 2;
    [backView addSubview:_introduce];
    
}






@end
