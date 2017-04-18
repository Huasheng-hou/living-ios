//
//  LMNewHotArticleCell.m
//  living
//
//  Created by hxm on 2017/3/10.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMNewHotArticleCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"
@implementation LMNewHotArticleCell
{
    UIView * shadow;
    
    UIImageView * backImage;
    UILabel * title;
    UIImageView * avatar;
    UIImageView * flag;
    UILabel * name;
    UILabel * category;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    
    
    
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 210-35)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.userInteractionEnabled = YES;
    [self.contentView addSubview:backView];
    
    backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height-5)];
    backImage.backgroundColor = BG_GRAY_COLOR;
    backImage.image = [UIImage imageNamed:@"BackImage"];
    backImage.clipsToBounds = YES;
    backImage.contentMode = UIViewContentModeScaleAspectFill;
    [backView addSubview:backImage];
    
    
    shadow = [[UIView alloc] initWithFrame:backImage.frame];
    shadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [backView addSubview:shadow];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(backImage.frame)/2, kScreenWidth-40, 30)];
    //title.text = @"这是文章标题";
    title.numberOfLines = 2;
    title.textColor = [UIColor whiteColor];
    title.font = TEXT_FONT_BOLD_18;
    title.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:title];
    
    
    avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(title.frame)+10, 30, 30)];
    //avatar.image = [UIImage imageNamed:@"cellHeadImageIcon"];
    avatar.backgroundColor = BG_GRAY_COLOR;
    avatar.layer.masksToBounds = YES;
    avatar.layer.cornerRadius = 15;
    [backView addSubview:avatar];
    
    flag = [[UIImageView alloc] initWithFrame:CGRectMake(25+2, avatar.center.y, 15, 15)];
    flag.image = [UIImage imageNamed:@"BigVRed"];
    //_flag.backgroundColor = ORANGE_COLOR;
    flag.layer.masksToBounds = YES;
    flag.layer.cornerRadius = 8;
    [backView addSubview:flag];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(flag.frame)+10, CGRectGetMaxY(avatar.frame)-15, 100, 15)];
    //name.text = @"夏女霞";
    name.textAlignment = NSTextAlignmentLeft;
    name.textColor = [UIColor cyanColor];
    name.font = TEXT_FONT_BOLD_14;
    [backView addSubview:name];
    
    category = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(name.frame)+10, CGRectGetMinY(name.frame), 0, 15)];
    //category.backgroundColor = COLOR_RED_LIGHT;
    //category.text = @"Yao|美丽";
    category.font = TEXT_FONT_LEVEL_3;
    //[category sizeToFit];
    [backView addSubview:category];
}
- (void)setArticleVO:(LMMoreArticlesVO *)vo{
    
    [backImage sd_setImageWithURL:[NSURL URLWithString:vo.avatar] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    
    
    title.text = vo.articleTitle;
    [avatar sd_setImageWithURL:[NSURL URLWithString:vo.headImgUrl]];
    
    if (![vo.sign isEqualToString:@"menber"]) {
        [flag removeFromSuperview];
    }
    
    name.text = vo.articleName;
    
    if ([vo.category isEqualToString:@"beautiful"]) {
        category.text = @"Yao|美丽";
    }
    if ([vo.category isEqualToString:@"healthy"]) {
        category.text = @"Yao|健康";
    }
    if ([vo.category isEqualToString:@"delicious"]) {
        category.text = @"Yao|美食";
    }
    if ([vo.category isEqualToString:@"happiness"]) {
        category.text = @"Yao|幸福";
    }
}

@end
