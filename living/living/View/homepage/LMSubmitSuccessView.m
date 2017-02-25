//
//  LMSubmitSuccessView.m
//  living
//
//  Created by Huasheng on 2017/2/25.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMSubmitSuccessView.h"
#import "FitConsts.h"
@implementation LMSubmitSuccessView
{
    UIImageView * _flag;
    UILabel * _tip;
    UILabel * _content;
    UILabel * _botLine;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    
    _flag = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-30, 25, 60, 60)];
    _flag.image = [UIImage imageNamed:@"choose"];
    _flag.backgroundColor = BG_GRAY_COLOR;
    _flag.layer.masksToBounds = YES;
    _flag.layer.cornerRadius = 30;
    [self addSubview:_flag];
    
    _tip = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_flag.frame)+20, kScreenWidth, 15)];
    _tip.text = @"提交成功";
    _tip.textColor = TEXT_COLOR_LEVEL_2;
    _tip.font = TEXT_FONT_BOLD_14;
    _tip.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tip];
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tip.frame)+10, kScreenWidth, 10)];
    _content.textAlignment = NSTextAlignmentCenter;
    _content.text = @"您的联系方式已提交，果仁会尽快与您联系哦！";
    _content.textColor = TEXT_COLOR_LEVEL_5;
    _content.font = TEXT_FONT_BOLD_12;
    [self addSubview:_content];
    
    _botLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_content.frame)+18, kScreenWidth, 2)];
    _botLine.backgroundColor = BG_GRAY_COLOR;
    [self addSubview:_botLine];
    
    
}
@end
