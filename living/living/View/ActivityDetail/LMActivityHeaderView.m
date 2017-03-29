//
//  LMActivityHeaderView.m
//  living
//
//  Created by 戚秋民 on 16/12/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMActivityHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageHelpTool.h"
#import "FitConsts.h"
#import "LMEventBodyVO.h"

@implementation LMActivityHeaderView
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

- (void)setEvent:(LMEventBodyVO *)event
{
    if (!event || ![event isKindOfClass:[LMEventBodyVO class]]) {
        
        return;
    }
    
    _event  = event;
    
    [_headV sd_setImageWithURL:[NSURL URLWithString:_event.publishAvatar] placeholderImage:[ImageHelpTool imageWithColor:BG_GRAY_COLOR]];
    
    _nameLabel.text = [NSString stringWithFormat:@"发布者：%@", _event.publishName];
    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(60, 32, _nameLabel.bounds.size.width, _nameLabel.bounds.size.height);
    
    _countLabel.text = [NSString stringWithFormat:@"人均费用 ￥%@", _event.perCost];
    [_countLabel sizeToFit];
    _countLabel.frame = CGRectMake(60, 35+_nameLabel.bounds.size.height, _countLabel.bounds.size.width, _countLabel.bounds.size.height);

    
    
    
    
    NSString *string = [NSString stringWithFormat:@"%d", _event.status];
    
    if ([string isEqual:@"1"]) {
        [_joinButton setTitle:@"报名" forState:UIControlStateNormal];
    }
    if ([string isEqual:@"2"]) {
        [_joinButton setTitle:@"人满" forState:UIControlStateNormal];
        _joinButton.userInteractionEnabled = NO;
    }
    if ([string isEqual:@"3"]) {
        [_joinButton setTitle:@"已开始" forState:UIControlStateNormal];
        
        _joinButton.userInteractionEnabled = NO;
    }
    if ([string isEqual:@"4"]) {
        [_joinButton setTitle:@"已完结" forState:UIControlStateNormal];
        _joinButton.userInteractionEnabled = NO;
    }
    if ([string isEqual:@"5"]) {
        [_joinButton setTitle:@"删除" forState:UIControlStateNormal];
        _joinButton.userInteractionEnabled = NO;
    }
}

- (void)joinButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldJoinActivity)]) {
        
        [_delegate shouldJoinActivity];
    }
}

@end
