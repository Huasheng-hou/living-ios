//
//  LMExpertDetailView.m
//  living
//
//  Created by Huasheng on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertDetailView.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"
@implementation LMExpertDetailView
{
    UIImageView * _icon;
    UIImageView * _flag;
    UILabel * _name;
    UILabel * _introduce;

}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = BG_GRAY_COLOR;
        [self addSubViews:frame];
        
    }
    return self;
    
}

- (void)addSubViews:(CGRect)frame{
    
    CGFloat w = (kScreenWidth-30)/2;
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, frame.size.height-10)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, w, backView.frame.size.height-20)];
    _icon.image = [UIImage imageNamed:@"BackImage"];
    _icon.contentMode = UIViewContentModeScaleToFill;
    _icon.clipsToBounds = YES;
    _icon.backgroundColor = BG_GRAY_COLOR;
    [backView addSubview:_icon];
    
//    _flag = [[UIImageView alloc] initWithFrame:CGRectMake(40, 45, 20, 20)];
//    _flag.image = [UIImage imageNamed:@"BigVRed"];
//    //_flag.backgroundColor = ORANGE_COLOR;
//    _flag.layer.masksToBounds = YES;
//    _flag.layer.cornerRadius = 10;
//    [backView addSubview:_flag];
    
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+10, 10, w, 25)];
    //_name.text = @"介绍标题";
    _name.textColor = TEXT_COLOR_LEVEL_2;
    _name.font = TEXT_FONT_BOLD_18;
    _name.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:_name];
    
    
    _introduce = [[UILabel alloc] initWithFrame:CGRectMake(w+20, CGRectGetMaxY(_name.frame)+10, w, backView.frame.size.height-20-_name.frame.size.height-10)];
    //_introduce.text = @"达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍达人介绍";
    _introduce.textColor = TEXT_COLOR_LEVEL_3;
    _introduce.font = TEXT_FONT_BOLD_14;
    _introduce.numberOfLines = -1;
    [backView addSubview:_introduce];
    
}

- (void)setValue:(LMExpertSpaceVO *)vo{
    
    _name.text = vo.nickName;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:vo.avatar]];
    
    
    _introduce.text = vo.introduce;
    
    
}




@end
