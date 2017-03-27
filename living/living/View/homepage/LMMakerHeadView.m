//
//  LMMakerHeadView.m
//  living
//
//  Created by Huasheng on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMMakerHeadView.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"
@implementation LMMakerHeadView
{
    UIImageView * _backImage;
    UILabel * _title;
    UIButton * _click;
    UILabel * _introduction;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    
    _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
    _backImage.backgroundColor = BG_GRAY_COLOR;
    _backImage.image = [UIImage imageNamed:@"BackImage"];
    _backImage.clipsToBounds = YES;
    _backImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_backImage];
    
//    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 25)];
//    _title.text = @"腰果“创“故事";
//    _title.textColor = [UIColor whiteColor];
//    _title.font = TEXT_FONT_BOLD_20;
//    _title.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:_title];
    
//    _click = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 25)];
//    _click.center = CGPointMake(kScreenWidth/2, CGRectGetMaxY(_title.frame)+10+12.5);
//    [_click setTitle:@"点击了解轻创客" forState:UIControlStateNormal];
//    [_click setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _click.backgroundColor = BTN_ORANGE_COLOR;
//    _click.titleLabel.font = TEXT_FONT_BOLD_12;
//    _click.titleLabel.textAlignment = NSTextAlignmentCenter;
//    _click.layer.masksToBounds = YES;
//    _click.layer.cornerRadius = 5;
//    [_click addTarget:self action:@selector(inquire:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_click];
    
    UIView * botView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_backImage.frame), kScreenWidth, 55)];
    botView.backgroundColor = [UIColor whiteColor];
    [self addSubview:botView];
    
    _introduction = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20,30)];
    //_introduction.text = @"腰果创客介绍腰果创客介绍腰果创客介绍腰果创客介绍腰果创客介绍腰果创客介绍腰果创客介绍";
    _introduction.textColor = TEXT_COLOR_LEVEL_4;
    _introduction.font = TEXT_FONT_LEVEL_4;
    _introduction.numberOfLines = 2;
    [botView addSubview:_introduction];
    
    
}
- (void)setValue:(NSDictionary *)dict{
    
    [_backImage sd_setImageWithURL:[NSURL URLWithString:dict[@"picture"]]];
    
    _introduction.text = dict[@"introduce"];
    
    
}



- (void)inquire:(UIButton *)btn{
    
    NSLog(@"了解轻创客");
    [self.delegate gotoNextPage];
    
}

@end
