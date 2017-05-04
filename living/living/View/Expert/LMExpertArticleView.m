//
//  LMExpertArticleCell.m
//  living
//
//  Created by hxm on 2017/5/3.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertArticleView.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"

@implementation LMExpertArticleView
{
    UIImageView * _backImage;
    UIImageView * _avatar;
    UILabel * _title;
    UILabel * _time;
    UILabel * _name;
    
    UIView * _shadow;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubViews:frame];
    }
    return self;
}

- (void)addSubViews:(CGRect)frame{
    
    _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _backImage.clipsToBounds = YES;
    _backImage.layer.cornerRadius = 3;
    _backImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_backImage];
    
    _shadow = [[UIView alloc] initWithFrame:_backImage.bounds];
    _shadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:_shadow];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, 20)];
    _title.textColor = [UIColor whiteColor];
    _title.font = TEXT_FONT_LEVEL_3;
    [self addSubview:_title];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_title.frame), CGRectGetWidth(_title.frame), 10)];
    _time.textColor = [UIColor whiteColor];
    _time.font = TEXT_FONT_LEVEL_5;
    [self addSubview:_time];
    
    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(5, frame.size.height-25, 20, 20)];
    _avatar.clipsToBounds = YES;
    _avatar.layer.cornerRadius = 10;
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_avatar];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatar.frame)+5, CGRectGetMinY(_avatar.frame)+5, 100, 10)];
    _name.textColor = [UIColor whiteColor];
    _name.font = TEXT_FONT_LEVEL_5;
    [self addSubview:_name];
    
}

- (void)setData:(LMMoreArticlesVO *)vo{
    
    [_backImage sd_setImageWithURL:[NSURL URLWithString:vo.avatar] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    
    _title.text = vo.articleTitle;
    
    _time.text = vo.publishTime;
    
    [_avatar sd_setImageWithURL:[NSURL URLWithString:vo.headImgUrl] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    
    _name.text = [NSString stringWithFormat:@"by %@", vo.articleName];
    
}
@end
