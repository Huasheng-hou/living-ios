//
//  LMActivityExperienceBtn.m
//  living
//
//  Created by WangShengquan on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMActivityExperienceBtn.h"
#import "FitConsts.h"

@interface LMActivityExperienceBtn ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel * titleLbl;

@end

@implementation LMActivityExperienceBtn

-(instancetype)initWithFrame:(CGRect)frame actionTitle:(NSString *)title IconImage:(UIImage *)iconImage
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        _iconImageView.image = iconImage;
        _titleLbl.text = title;
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    //_iconImageView.backgroundColor = BG_GRAY_COLOR;
    [self addSubview:_iconImageView];
    
    _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(23, 0, 32, 23)];
    _titleLbl.font = TEXT_FONT_LEVEL_2;
    _titleLbl.textColor = TEXT_COLOR_LEVEL_4;
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLbl];
    
    
}

@end
