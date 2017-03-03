//
//  LMVoiceDetailHeaderView.m
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMVoiceDetailHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageHelpTool.h"
#import "FitConsts.h"
#import "LMVoiceDetailVO.h"
#import "FitUserManager.h"

@implementation LMVoiceDetailHeaderView
{
    UIImageView *_headV;
    UILabel     *_nameLabel;
    UILabel     *_countLabel;
    UIButton    *_joinButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initViews];
    }
    
    return self;
}

- (void)initViews
{
    // * 活动发布者头像
    
    _headV = [UIImageView new];
    
    _headV.contentMode           = UIViewContentModeScaleAspectFill;
    _headV.clipsToBounds         = YES;
    _headV.layer.cornerRadius    = 5.f;
    [_headV sizeToFit];
    _headV.frame                 = CGRectMake(15, 30, 40, 40);
    
    [self addSubview:_headV];
    
    // * 活动发布者名称
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:13.f];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(60, 32, _nameLabel.bounds.size.width, _nameLabel.bounds.size.height);
    
    [self addSubview:_nameLabel];
    
    // * 人均费用
    
    _countLabel = [UILabel new];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.font = [UIFont systemFontOfSize:13.f];
    [_countLabel sizeToFit];
    _countLabel.frame = CGRectMake(60, 35+_nameLabel.bounds.size.height, _countLabel.bounds.size.width, _countLabel.bounds.size.height);
    
    [self addSubview:_countLabel];
    
    
    _joinButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    
    [_joinButton setTintColor:[UIColor whiteColor]];
    _joinButton.showsTouchWhenHighlighted = YES;
    _joinButton.frame = CGRectMake(kScreenWidth - 70, 25, 60.f, 50.f);
    [_joinButton addTarget:self action:@selector(joinButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_joinButton];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor whiteColor];
    [line sizeToFit];
    line.frame = CGRectMake(kScreenWidth-71, 35, 1, 30);
    [self addSubview:line];
}

- (void)setEvent:(LMVoiceDetailVO *)event
{
    if (!event || ![event isKindOfClass:[LMVoiceDetailVO class]]) {
        
        return;
    }
    
    _event  = event;
    
    [_headV sd_setImageWithURL:[NSURL URLWithString:_event.image] placeholderImage:[ImageHelpTool imageWithColor:BG_GRAY_COLOR]];
    
    _nameLabel.text = [NSString stringWithFormat:@"发布者：%@", _event.publishName];
    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(60, 32, _nameLabel.bounds.size.width, _nameLabel.bounds.size.height);
    
    _countLabel.text = [NSString stringWithFormat:@"人均费用 ￥%@", _event.perCost];
    [_countLabel sizeToFit];
    _countLabel.frame = CGRectMake(60, 35+_nameLabel.bounds.size.height, _countLabel.bounds.size.width, _countLabel.bounds.size.height);
    
    if ([_role isEqualToString:@"student"]) {
        if (_event.isBuy == YES) {
            [_joinButton setTitle:@"已报名" forState:UIControlStateNormal];
            _joinButton.userInteractionEnabled = NO;
        }else{
            if (_event.status&&[_event.status isEqualToString:@"open"]) {
                [_joinButton setTitle:@"已开始" forState:UIControlStateNormal];
                _joinButton.userInteractionEnabled = NO;
            }
            if (_event.status&&[_event.status isEqualToString:@"ready"]) {
                [_joinButton setTitle:@"报名" forState:UIControlStateNormal];
            }
            if (_event.status&&[_event.status isEqualToString:@"closed"]) {
                [_joinButton setTitle:@"已结束" forState:UIControlStateNormal];
                _joinButton.userInteractionEnabled = NO;
            }
        }
    }else{
        if ([[FitUserManager sharedUserManager].uuid isEqualToString:event.userUuid]) {
            if (_event.status&&[_event.status isEqualToString:@"open"]) {
                [_joinButton setTitle:@"已开始" forState:UIControlStateNormal];
                _joinButton.userInteractionEnabled = NO;
            }
            if (_event.status&&[_event.status isEqualToString:@"ready"]) {
                [_joinButton setTitle:@"未开始" forState:UIControlStateNormal];
                _joinButton.userInteractionEnabled = NO;
            }
            if (_event.status&&[_event.status isEqualToString:@"closed"]) {
                [_joinButton setTitle:@"已结束" forState:UIControlStateNormal];
                _joinButton.userInteractionEnabled = NO;
            }
        }else{
            if (_event.isBuy == YES) {
                [_joinButton setTitle:@"已报名" forState:UIControlStateNormal];
                _joinButton.userInteractionEnabled = NO;
            }else{
                if (_event.status&&[_event.status isEqualToString:@"open"]) {
                    [_joinButton setTitle:@"已开始" forState:UIControlStateNormal];
                    _joinButton.userInteractionEnabled = NO;
                }
                if (_event.status&&[_event.status isEqualToString:@"ready"]) {
                    [_joinButton setTitle:@"报名" forState:UIControlStateNormal];
                }
                if (_event.status&&[_event.status isEqualToString:@"closed"]) {
                    [_joinButton setTitle:@"已结束" forState:UIControlStateNormal];
                    _joinButton.userInteractionEnabled = NO;
                }
            }
        }
        
        

    }
    
    
    
}

- (void)joinButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldJoinVoice)]) {
        
        [_delegate shouldJoinVoice];
    }
}

@end
