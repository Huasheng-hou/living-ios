//
//  LMYGBOrderHeadCell.m
//  living
//
//  Created by hxm on 2017/3/9.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYGBOrderHeadCell.h"
#import "FitConsts.h"
@implementation LMYGBOrderHeadCell
{
    
    UIImageView * avatar;
    UILabel * title;
    UILabel * desp;
    UILabel * time;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = BG_GRAY_COLOR;
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 95)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 85, 75)];
    avatar.backgroundColor = BG_GRAY_COLOR;
    avatar.image = [UIImage imageNamed:@"一场说走就走的旅行"];
    avatar.contentMode = UIViewContentModeScaleAspectFill;
    [backView addSubview:avatar];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatar.frame)+10, 10, kScreenWidth-CGRectGetMaxX(avatar.frame)-20, 20)];
    title.text = @"一场说走就走的旅行";
    title.textColor = TEXT_COLOR_LEVEL_2;
    title.font = TEXT_FONT_BOLD_14;
    [backView addSubview:title];
    
    desp = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(title.frame), CGRectGetMaxY(title.frame)+5, CGRectGetWidth(title.frame), 30)];
    desp.text = @"新年心计划，是时候开展一个属于你的音乐之旅，年后让你周围的小伙伴眼前一亮哦";
    desp.textColor = TEXT_COLOR_LEVEL_3;
    desp.font = TEXT_FONT_BOLD_12;
    desp.numberOfLines = 2;
    [backView addSubview:desp];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(desp.frame), CGRectGetMaxY(desp.frame)+5, CGRectGetWidth(desp.frame), 15)];
    time.text = @"活动时间：2017-07-18";
    time.textColor = TEXT_COLOR_LEVEL_4;
    time.font = TEXT_FONT_LEVEL_4;
    [backView addSubview:time];
    
    
}












@end
