//
//  LMRecommendCell.m
//  living
//
//  Created by Huasheng on 2017/2/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMRecommendCell.h"
#import "FitConsts.h"
#import "LMRecommendVO.h"
#import "UIImageView+WebCache.h"
@implementation LMRecommendCell
{
    UIImageView *imageView;
    UILabel *title;
    UILabel *summary;
    UIImageView *icon;
    UILabel *name;
    UILabel *tag;
    UIImageView * sign;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubViews];
        
    }
    return self;
}

- (void)addSubViews{
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    [self.contentView addSubview:backView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 90)];
    imageView.image = [UIImage imageNamed:@"BackImage"];
    imageView.backgroundColor = BG_GRAY_COLOR;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [backView addSubview:imageView];
    
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, kScreenWidth-130, 25)];
    
    title.textColor = TEXT_COLOR_LEVEL_3;
    title.font = TEXT_FONT_BOLD_14;
    [backView addSubview:title];
    
    
    summary = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, kScreenWidth-130, 40)];
    summary.textColor = TEXT_COLOR_LEVEL_3;
    summary.font = TEXT_FONT_LEVEL_3;
    summary.numberOfLines = 2;
    [summary sizeToFit];
    [backView addSubview:summary];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(120, 70, 20, 20)];
    icon.backgroundColor = BG_GRAY_COLOR;
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 10;
    [backView addSubview:icon];
    
    sign = [[UIImageView alloc] initWithFrame:CGRectMake(icon.center.x, icon.center.y, CGRectGetWidth(icon.frame)/2, CGRectGetHeight(icon.frame)/2)];
    sign.layer.masksToBounds = YES;
    sign.layer.cornerRadius = 5;
    [backView addSubview:sign];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(150, 72.5, 60, 15)];
    name.textColor = TEXT_COLOR_LEVEL_4;
    name.font = TEXT_FONT_LEVEL_3;
    [backView addSubview:name];
    
    tag = [[UILabel alloc] initWithFrame:CGRectMake(210, 72.5, 55, 15)];
    tag.textAlignment = NSTextAlignmentCenter;
    tag.textColor = [UIColor whiteColor];
    tag.layer.masksToBounds = YES;
    tag.layer.cornerRadius = 2;
    tag.font = TEXT_FONT_LEVEL_4 ;
    [backView addSubview:tag];
}


- (void)setValue:(LMRecommendVO *)vo{
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:vo.avatar] placeholderImage:nil];
    
    
    title.text = vo.articleTitle;
    summary.text = vo.articleContent;
    [icon sd_setImageWithURL:[NSURL URLWithString:vo.headImgUrl] placeholderImage:nil];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.clipsToBounds = YES;
    name.text = vo.articleName;
    
    //NSArray * typeList = @[@"幸福情商", @"美丽造型", @"营养养生", @"美食吃货", @"其他"]; //2.3
    NSArray * typeList = @[@"happiness", @"beautiful", @"healthy", @"delicious", @"其他"];  //3.0
    NSArray * colorList = @[[UIColor colorWithRed:247/255.0 green:179/255.0 blue:155/255.0 alpha:1],
                            [UIColor colorWithRed:242/255.0 green:85/255.0 blue:120/255.0 alpha:1],
                            [UIColor colorWithRed:243/255.0 green:111/255.0 blue:102/255.0 alpha:1],
                            [UIColor colorWithRed:248/255.0 green:198/255.0 blue:41/255.0 alpha:1],
                            [UIColor colorWithRed:247/255.0 green:179/255.0 blue:155/255.0 alpha:1]];
    NSInteger index = [typeList indexOfObject:vo.category];
    if (index >= 4) {
        index = 3;
    }
    NSArray * newType = @[@"Yao·幸福", @"Yao·美丽", @"Yao·健康", @"Yao·美食",  @"Yao·幸福"];
    
    tag.text = newType[index];
    tag.backgroundColor = colorList[index];
    
    if ([vo.sign isEqualToString:@"menber"]) {
        sign.image = [UIImage imageNamed:@"BigVRed"];
    }else if([vo.sign isEqualToString:@"user"]){
        sign.image = [UIImage imageNamed:@""];
    }
    
    
    
}


@end
