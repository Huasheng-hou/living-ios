//
//  LMExpertEventView.m
//  living
//
//  Created by hxm on 2017/5/3.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertEventView.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"
@implementation LMExpertEventView
{
    UIView * shadow;
    
    UIImageView * _backImage;
    UILabel * _title;
    UIImageView * _microPhone;
    UILabel * _teacher;
    UIImageView * _helper;
    UILabel * _assistant;
    UIButton * _appointment;
    
    UIImageView * _good;
    UILabel * _goodLabel;
    UIImageView * _comment;
    UILabel * _commentLabel;
    UIImageView * _share;
    UILabel * _shareLabel;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubViews:frame];
    }
    return self;
}


- (void)addSubViews:(CGRect)frame{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    
    _backImage = [[UIImageView alloc] initWithFrame:backView.bounds];
    _backImage.backgroundColor = BG_GRAY_COLOR;
    _backImage.image = [UIImage imageNamed:@"BackImage"];
    [backView addSubview:_backImage];
    
    shadow = [[UIView alloc] initWithFrame:_backImage.frame];
    shadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [backView addSubview:shadow];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth(backView.frame), 15)];
    _title.text = @"动手吧！好吃到飞起来的料理";
    _title.textColor = [UIColor whiteColor];
    _title.font = TEXT_FONT_LEVEL_3;
    _title.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:_title];
    
    
    _teacher = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_title.frame)+5, frame.size.width/2-10, 15)];
    _teacher.text = @"费用 ¥68/人";
    _teacher.textColor = [UIColor whiteColor];
    _teacher.textAlignment = NSTextAlignmentCenter;
    _teacher.font = TEXT_FONT_LEVEL_5;
    [backView addSubview:_teacher];
    
    
    _assistant = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2+5, CGRectGetMinY(_teacher.frame), frame.size.width/2-10, 15)];
    _assistant.text = @"截止至02-14";
    _assistant.textColor = [UIColor whiteColor];
    _assistant.font = TEXT_FONT_LEVEL_5;
    [backView addSubview:_assistant];
    
    _appointment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 24)];
    _appointment.center = CGPointMake(frame.size.width/2, CGRectGetMaxY(_assistant.frame)+10+12);
    [_appointment setTitle:@"快来预约" forState:UIControlStateNormal];
    [_appointment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _appointment.backgroundColor = ORANGE_COLOR;
    _appointment.titleLabel.font = TEXT_FONT_LEVEL_4;
    _appointment.titleLabel.textAlignment = NSTextAlignmentCenter;
    _appointment.layer.masksToBounds = YES;
    _appointment.layer.cornerRadius = 5;
    [backView addSubview:_appointment];
}

- (void)setData:(LMMoreEventsVO *)vo{
    
    [_backImage sd_setImageWithURL:[NSURL URLWithString:vo.eventImg] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    _backImage.contentMode = UIViewContentModeScaleAspectFill;
    _backImage.clipsToBounds = YES;
    
    _title.text = vo.eventName;
    _teacher.text = [NSString stringWithFormat:@"费用 ¥%@/人", vo.perCost];

    
}


@end
