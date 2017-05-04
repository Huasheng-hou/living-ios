//
//  LMExpertHotArticleCell.m
//  living
//
//  Created by Huasheng on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertHotArticleCell.h"
#import "FitConsts.h"
#import "LMMoreEventsVO.h"
#import "LMMoreVoicesVO.h"
#import "UIImageView+WebCache.h"


@implementation LMExpertHotArticleCell
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubViews];
    }
    return self;
}


- (void)setType:(NSInteger)type{
    _type = type;
    
    if (type == 1) {
        NSLog(@"活动");
        _teacher.text = @"费用 ¥68/人";
        _assistant.text = @"截止至02-14";
        [_appointment setTitle:@"火热预定中" forState:UIControlStateNormal];
        
        [_helper setHidden:YES];
        [_microPhone setHidden:YES];
        
    }
    else if (type == 2)
    {
        NSLog(@"课程");
    }
}

- (void)setVO:(id)vo{
    NSLog(@"%@", [vo class]);
    if ([vo isKindOfClass:[LMMoreEventsVO class]]) {
        LMMoreEventsVO * voo = vo;
        [_backImage sd_setImageWithURL:[NSURL URLWithString:voo.eventImg] placeholderImage:[UIImage imageNamed:@"BackImage"]];
        _backImage.contentMode = UIViewContentModeScaleAspectFill;
        _backImage.clipsToBounds = YES;
        
        _title.text = voo.eventName;
        _teacher.text = [NSString stringWithFormat:@"费用 ¥%@/人", voo.perCost];
        
    }
    if ([vo isKindOfClass:[LMMoreVoicesVO class]]) {
        LMMoreVoicesVO * voo = vo;
        [_backImage sd_setImageWithURL:[NSURL URLWithString:voo.image] placeholderImage:[UIImage imageNamed:@"BackImage"]];
        _backImage.contentMode = UIViewContentModeScaleAspectFill;
        _backImage.clipsToBounds = YES;
        
        _title.text = voo.voiceTitle;
        _teacher.text = [NSString stringWithFormat:@"讲师:%@", voo.nickName];
        _assistant.text = [NSString stringWithFormat:@"助理讲师:%@", voo.hoster];
        
        
        
        if ([voo.status isEqualToString:@"ready"]) {
            [_appointment setTitle:@"准备开课" forState:UIControlStateNormal];
        }
        if ([voo.status isEqualToString:@"open"]) {
            [_appointment setTitle:@"已开课" forState:UIControlStateNormal];
            _appointment.userInteractionEnabled = NO;
        }
        if ([voo.status isEqualToString:@"closed"]) {
            [_appointment setTitle:@"已结束" forState:UIControlStateNormal];
            _appointment.userInteractionEnabled = NO;
            _appointment.backgroundColor = BG_GRAY_COLOR;
        }
    }
}


- (void)addSubViews{
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 210-35)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.userInteractionEnabled = YES;
    [self.contentView addSubview:backView];
    
    //top
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backView.frame.size.width, 170)];
    [backView addSubview:topView];
    
    _backImage = [[UIImageView alloc] initWithFrame:topView.frame];
    _backImage.backgroundColor = BG_GRAY_COLOR;
    _backImage.image = [UIImage imageNamed:@"BackImage"];
    [topView addSubview:_backImage];
    
    shadow = [[UIView alloc] initWithFrame:_backImage.frame];
    shadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [topView addSubview:shadow];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(topView.frame), 20)];
    _title.text = @"动手吧！好吃到飞起来的料理";
    _title.textColor = [UIColor whiteColor];
    _title.font = TEXT_FONT_BOLDOBLIQUE_16;
    _title.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_title];
    
    _microPhone = [[UIImageView alloc] initWithFrame:CGRectMake(topView.bounds.size.width/2-90, CGRectGetMaxY(_title.frame)+10, 8, 15)];
    _microPhone.image = [UIImage imageNamed:@"jiangshi"];
    [topView addSubview:_microPhone];
    
    _teacher = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_microPhone.frame)+2, CGRectGetMinY(_microPhone.frame), 80, 15)];
    _teacher.text = @"讲师：李莺莺";
    _teacher.textColor = [UIColor whiteColor];
    _teacher.font = TEXT_FONT_BOLDOBLIQUE_12;
    [topView addSubview:_teacher];
    
    
    _helper = [[UIImageView alloc] initWithFrame:CGRectMake(topView.bounds.size.width/2, CGRectGetMinY(_microPhone.frame), 8, 15)];
    _helper.image = [UIImage imageNamed:@"zhuli"];
    [topView addSubview:_helper];
    
    _assistant = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_helper.frame)+2, CGRectGetMinY(_helper.frame), kScreenWidth-20-CGRectGetMaxX(_helper.frame)-2, 15)];
    _assistant.text = @"助理讲师：圆圆";
    _assistant.textColor = [UIColor whiteColor];
    _assistant.font = TEXT_FONT_BOLDOBLIQUE_12;
    [topView addSubview:_assistant];
    
    _appointment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 24)];
    _appointment.center = CGPointMake(topView.frame.size.width/2, CGRectGetMaxY(_assistant.frame)+10+12);
    [_appointment setTitle:@"快来预约" forState:UIControlStateNormal];
    [_appointment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _appointment.backgroundColor = ORANGE_COLOR;
    _appointment.titleLabel.font = TEXT_FONT_BOLDOBLIQUE_14;
    _appointment.titleLabel.textAlignment = NSTextAlignmentCenter;
    _appointment.layer.masksToBounds = YES;
    _appointment.layer.cornerRadius = 5;
    //[_appointment addTarget:self action:@selector(makeAppointment:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_appointment];
    
}


- (void)makeAppointment:(UIButton *)btn{
    
    
    NSLog(@"预约");
}

- (void)tapAction:(UIGestureRecognizer *)tap{
    
    NSLog(@"%d", tap.view.tag);
    
}


@end
