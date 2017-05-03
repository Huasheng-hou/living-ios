//
//  LMExpertVoiceView.m
//  living
//
//  Created by hxm on 2017/5/3.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertVoiceView.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"
@implementation LMExpertVoiceView
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

    
    _microPhone = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-70, CGRectGetMaxY(_title.frame)+5, 8, 13)];
    _microPhone.image = [UIImage imageNamed:@"jiangshi"];
    [backView addSubview:_microPhone];
    
    _teacher = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_microPhone.frame)+2, CGRectGetMinY(_microPhone.frame), 62, 15)];
    _teacher.text = @"讲师：李莺莺";
    _teacher.textColor = [UIColor whiteColor];
    _teacher.font = TEXT_FONT_LEVEL_5;
    [backView addSubview:_teacher];
    
    
    _helper = [[UIImageView alloc] initWithFrame:CGRectMake(backView.bounds.size.width/2, CGRectGetMinY(_microPhone.frame), 8, 13)];
    _helper.image = [UIImage imageNamed:@"zhuli"];
    [backView addSubview:_helper];
    
    _assistant = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_helper.frame)+2, CGRectGetMinY(_helper.frame), frame.size.width/2-13, 15)];
    _assistant.text = @"助理讲师：圆圆";
    _assistant.textColor = [UIColor whiteColor];
    _assistant.font = TEXT_FONT_LEVEL_5;
    [backView addSubview:_assistant];
    
    _appointment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 24)];
    _appointment.center = CGPointMake(backView.frame.size.width/2, CGRectGetMaxY(_assistant.frame)+10+12);
    [_appointment setTitle:@"快来预约" forState:UIControlStateNormal];
    [_appointment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _appointment.backgroundColor = ORANGE_COLOR;
    _appointment.titleLabel.font = TEXT_FONT_LEVEL_4;
    _appointment.titleLabel.textAlignment = NSTextAlignmentCenter;
    _appointment.layer.masksToBounds = YES;
    _appointment.layer.cornerRadius = 5;
    [backView addSubview:_appointment];
}

- (void)setData:(LMMoreVoicesVO *)vo{
    
    [_backImage sd_setImageWithURL:[NSURL URLWithString:vo.image] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    _backImage.contentMode = UIViewContentModeScaleAspectFill;
    _backImage.clipsToBounds = YES;
    
    _title.text = vo.voiceTitle;
    _teacher.text = [NSString stringWithFormat:@"讲师:%@", vo.nickName];
    _assistant.text = [NSString stringWithFormat:@"助理讲师:%@", vo.hoster];
    
    
    if ([vo.status isEqualToString:@"ready"]) {
        [_appointment setTitle:@"准备开课" forState:UIControlStateNormal];
    }
    if ([vo.status isEqualToString:@"open"]) {
        [_appointment setTitle:@"已开课" forState:UIControlStateNormal];
        _appointment.userInteractionEnabled = NO;
    }
    if ([vo.status isEqualToString:@"closed"]) {
        [_appointment setTitle:@"已结束" forState:UIControlStateNormal];
        _appointment.userInteractionEnabled = NO;
        _appointment.backgroundColor = BG_GRAY_COLOR;
    }

}

@end
