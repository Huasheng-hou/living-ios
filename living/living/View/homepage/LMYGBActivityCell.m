//
//  LMYGBActivityCell.m
//  living
//
//  Created by hxm on 2017/3/8.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYGBActivityCell.h"
#import "FitConsts.h"
@implementation LMYGBActivityCell
{
    UIImageView * leftImage;
    UILabel * title;
    UILabel * content;
    UILabel * ygb;
    
    
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 97)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 90, 77)];
    leftImage.backgroundColor = BG_GRAY_COLOR;
    leftImage.image = [UIImage imageNamed:@"demo"];
    [backView addSubview:leftImage];
    
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftImage.frame)+10, 0, kScreenWidth-120, 20)];
    title.text = @"你弹琴我就送口红";
    title.textColor = TEXT_COLOR_LEVEL_3;
    title.font = TEXT_FONT_BOLD_14;
    [backView addSubview:title];
    
    content = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(title.frame), CGRectGetMaxY(title.frame)+5, kScreenWidth-120, 35)];
    content.text = @"来一首令人浮想联翩的音乐，一起进入梦想的世界，这个你我的精神角落担惊受恐雷锋精神分类极乐世界";
    content.textColor = TEXT_COLOR_LEVEL_4;
    content.font = TEXT_FONT_BOLD_12;
    content.numberOfLines = 2;
    [backView addSubview:content];
    
    ygb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(content.frame), CGRectGetMaxY(content.frame)+5, kScreenWidth-120, 10)];
    ygb.text = @"300腰果币+10元";
    ygb.textColor = ORANGE_COLOR;
    ygb.font = TEXT_FONT_BOLD_12;
    ygb.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:ygb];
    
}

@end
