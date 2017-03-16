//
//  LMAllExpertListCell.m
//  living
//
//  Created by hxm on 2017/3/10.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMAllExpertListCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"
@implementation LMAllExpertListCell
{
    UIImageView * avatar;
    UILabel * name;
    UILabel * life;
    UILabel * desp;
    UILabel * line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
    }
    return self;
}
- (void)addSubViews{
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 80)];
    avatar.backgroundColor = BG_GRAY_COLOR;
    avatar.image = [UIImage imageNamed:@"BackImage"];
    avatar.contentMode = UIViewContentModeScaleAspectFill;
    [backView addSubview:avatar];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatar.frame)+10, 10, 100, 25)];
    name.text = @"达人姓名";
    name.textColor = TEXT_COLOR_LEVEL_3;
    name.font = TEXT_FONT_BOLD_18;
    [backView addSubview:name];
    
    life = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(name.frame), CGRectGetMaxY(name.frame)+5, kScreenWidth-110, 25)];
    life.text = @"所属生活馆";
    life.textColor = TEXT_COLOR_LEVEL_3;
    life.font = TEXT_FONT_BOLD_18;
    [backView addSubview:life];
    
    
    desp = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(life.frame), CGRectGetMaxY(life.frame)+10, kScreenWidth-110, 10)];
    desp.text = @"这里不知道放什么这里不知道放什么这里不知道放什么这里不知道放什么";
    desp.textColor = TEXT_COLOR_LEVEL_3;
    desp.font = TEXT_FONT_BOLD_14;
    [backView addSubview:desp];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, backView.frame.size.height-1, kScreenWidth, 1)];
    line.backgroundColor = BG_GRAY_COLOR;
    [backView addSubview:line];
}

- (void)setCellWithVO:(LMExpertListVO *)vo{
    [avatar sd_setImageWithURL:[NSURL URLWithString:vo.avatar]];
    
    name.text = vo.nickName;
    
    //life.text = vo
    
    desp.text = vo.address;
}



@end
