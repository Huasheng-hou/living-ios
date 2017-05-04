//
//  LMExpertHeadView.m
//  living
//
//  Created by hxm on 2017/5/3.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertHeadView.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"

@implementation LMExpertHeadView
{
    UIImageView * _headImg;
    UIImageView * _avatar;
    UILabel * _name;
    UILabel * _desp;
    
    
    
    
    UIButton * articleBtn;
    UIButton * activityBtn;
    UIButton * classBtn;
    
    UIView * botView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    
    _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)];
    _headImg.image = [UIImage imageNamed:@"BackImage"];
    _headImg.clipsToBounds = YES;
    _headImg.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_headImg];
    
    
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = _headImg.bounds;
//    [_headImg addSubview:effectView];
    
//    UIView * shadow = [[UIView alloc] initWithFrame:_headImg.bounds];
//    shadow.backgroundColor = [UIColor whiteColor];
//    shadow.alpha = 0.5;
//    [_headImg addSubview:shadow];
    
    
    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-30, CGRectGetMaxY(_headImg.frame)-30, 60, 60)];
    _avatar.backgroundColor = BG_GRAY_COLOR;
    _avatar.image = [UIImage imageNamed:@"BackImage"];
    _avatar.clipsToBounds = YES;
    if (kScreenWidth == 320) {
        _avatar.layer.cornerRadius = 29;
    }
    if (kScreenWidth > 320) {
        _avatar.layer.cornerRadius = 33;
    }
    
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_avatar];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_avatar.frame)+10, kScreenWidth, 30)];
    _name.textColor = TEXT_COLOR_LEVEL_1;
    _name.font = TEXT_FONT_LEVEL_1;
    _name.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_name];
    
    
    _desp = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_name.frame)+10, kScreenWidth, 50)];
    _desp.backgroundColor = [UIColor whiteColor];
    _desp.textColor = TEXT_COLOR_LEVEL_2;
    _desp.font = TEXT_FONT_LEVEL_3;
    _desp.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_desp];
    
    
    /**********  底部分类   ********/
    
    botView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_desp.frame)+10, kScreenWidth, 50)];
    botView.backgroundColor = [UIColor whiteColor];
    [self addSubview:botView];
    
    UILabel * topLine = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 1)];
    topLine.backgroundColor = BG_GRAY_COLOR;
    [botView addSubview:topLine];
    
    //文章
    articleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth/3, 20)];
    [articleBtn setTitle:@"0" forState:UIControlStateNormal];
    [articleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    articleBtn.titleLabel.font = TEXT_FONT_LEVEL_S1;
    articleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    articleBtn.tag = 100;
    [articleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:articleBtn];
    
    UILabel * articleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(articleBtn.frame), kScreenWidth/3, 10)];
    articleLabel.text = @"文章";
    articleLabel.textColor = TEXT_COLOR_LEVEL_2;
    articleLabel.font = TEXT_FONT_LEVEL_3;
    articleLabel.textAlignment = NSTextAlignmentCenter;
    [botView addSubview:articleLabel];
    
    //活动
    activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/3, 10, kScreenWidth/3, 20)];
    [activityBtn setTitle:@"0" forState:UIControlStateNormal];
    [activityBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    activityBtn.titleLabel.font = TEXT_FONT_LEVEL_S1;
    activityBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    activityBtn.tag = 101;
    [activityBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:activityBtn];
    
    UILabel * activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3, CGRectGetMaxY(activityBtn.frame), kScreenWidth/3, 10)];
    activityLabel.text = @"活动";
    activityLabel.textColor = TEXT_COLOR_LEVEL_2;
    activityLabel.font = TEXT_FONT_LEVEL_3;
    activityLabel.textAlignment = NSTextAlignmentCenter;
    [botView addSubview:activityLabel];

    
    
    //课堂
    classBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*2/3, 10, kScreenWidth/3, 20)];
    [classBtn setTitle:@"0" forState:UIControlStateNormal];
    [classBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    classBtn.titleLabel.font = TEXT_FONT_LEVEL_S1;
    classBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    classBtn.tag = 102;
    [classBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:classBtn];
    
    UILabel * classLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*2/3, CGRectGetMaxY(classBtn.frame), kScreenWidth/3, 10)];
    classLabel.text = @"课堂";
    classLabel.textColor = TEXT_COLOR_LEVEL_2;
    classLabel.font = TEXT_FONT_LEVEL_3;
    classLabel.textAlignment = NSTextAlignmentCenter;
    [botView addSubview:classLabel];

    UILabel * botLine = [[UILabel alloc] initWithFrame:CGRectMake(10, 49, kScreenWidth-20, 1)];
    botLine.backgroundColor = BG_GRAY_COLOR;
    [botView addSubview:botLine];
}

- (void)setData:(LMExpertSpaceVO *)vo{
    
    [_headImg sd_setImageWithURL:[NSURL URLWithString:vo.images] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    
    [_avatar sd_setImageWithURL:[NSURL URLWithString:vo.avatar] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    
    _name.text = vo.nickName;
    
    [articleBtn setTitle:[NSString stringWithFormat:@"%@", vo.articleNums] forState:UIControlStateNormal];
    [activityBtn setTitle:[NSString stringWithFormat:@"%@", vo.eventNums] forState:UIControlStateNormal];
    [classBtn setTitle:[NSString stringWithFormat:@"%@", vo.voiceNums] forState:UIControlStateNormal];

    
    
    _desp.text = vo.introduce;
    _desp.numberOfLines = -1;
    [_desp sizeToFit];
    _desp.frame = CGRectMake(0, CGRectGetMaxY(_name.frame)+10, kScreenWidth, _desp.bounds.size.height);
    
    botView.frame = CGRectMake(0, CGRectGetMaxY(_desp.frame)+10, kScreenWidth, 50);
    
    _cellH = CGRectGetMaxY(botView.frame)+10;
    
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self sizeToFit];
    
    self.frame = CGRectMake(0, 0, kScreenWidth, _cellH);
    
    
}


- (void)btnClicked:(UIButton *)sender {
    
    
    [self.delegate gotoListPage:sender.tag];
    
}

@end
