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
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 110, 75)];
    leftImage.backgroundColor = BG_GRAY_COLOR;
    //leftImage.image = [UIImage imageNamed:@"demo"];
    [backView addSubview:leftImage];
    
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftImage.frame)+10, 0, kScreenWidth-140, 20)];
    title.text = @"10元兑换券";
    title.textColor = TEXT_COLOR_LEVEL_3;
    title.font = TEXT_FONT_BOLD_14;
    [backView addSubview:title];
    
    content = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(title.frame), CGRectGetMaxY(title.frame), kScreenWidth-140, 30)];
    content.text = @"xxx腰果币，即可兑换价值10元的腰果券哦！";
    content.textColor = TEXT_COLOR_LEVEL_4;
    content.font = TEXT_FONT_BOLD_12;
    content.numberOfLines = 2;
    [backView addSubview:content];
    
    ygb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(content.frame), CGRectGetMaxY(content.frame)+5, 40, 20)];
    ygb.text = @"兑换";
    ygb.layer.borderWidth = 1;
    ygb.layer.borderColor = ORANGE_COLOR.CGColor;
    ygb.layer.masksToBounds = YES;
    ygb.layer.cornerRadius = 3;
    ygb.textColor = ORANGE_COLOR;
    ygb.font = TEXT_FONT_BOLD_12;
    ygb.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:ygb];
    
}

@end
