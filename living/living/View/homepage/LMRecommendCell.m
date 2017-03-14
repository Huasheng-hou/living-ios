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
    [backView addSubview:imageView];
    
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, kScreenWidth-130, 25)];
    title.text = @"比较大的大提琴体验课";
    title.textColor = TEXT_COLOR_LEVEL_3;
    title.font = TEXT_FONT_BOLD_14;
    [backView addSubview:title];
    
    
    summary = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, kScreenWidth-130, 40)];
    summary.text = @"新年新计划，是时候开展一个属于你的音乐之旅，年后让你周围的小伙伴眼前一亮哦";
    summary.textColor = TEXT_COLOR_LEVEL_3;
    summary.font = TEXT_FONT_LEVEL_3;
    summary.numberOfLines = 2;
    [summary sizeToFit];
    [backView addSubview:summary];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(120, 70, 20, 20)];
    icon.image = [UIImage imageNamed:@"cellHeadImageIcon"];
    icon.backgroundColor = BG_GRAY_COLOR;
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 10;
    [backView addSubview:icon];
    
    sign = [[UIImageView alloc] initWithFrame:CGRectMake(icon.center.x, icon.center.y, CGRectGetWidth(icon.frame)/2, CGRectGetHeight(icon.frame)/2)];
    sign.layer.masksToBounds = YES;
    sign.layer.cornerRadius = 5;
    [backView addSubview:sign];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(150, 75, 60, 10)];
    name.text = @"欧阳夏丹";
    name.textColor = TEXT_COLOR_LEVEL_4;
    name.font = TEXT_FONT_LEVEL_3;
    [backView addSubview:name];
    
    tag = [[UILabel alloc] initWithFrame:CGRectMake(210, 75, 45, 10)];
    tag.text = @"Yao·美丽";
    tag.textAlignment = NSTextAlignmentCenter;
    tag.textColor = [UIColor whiteColor];
    tag.backgroundColor = [UIColor redColor];
    tag.layer.masksToBounds = YES;
    tag.layer.cornerRadius = 2;
    tag.font = TEXT_FONT_LEVEL_4 ;
    [backView addSubview:tag];
}


- (void)setValue:(LMRecommendVO *)vo{
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:vo.avatar] placeholderImage:nil];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    title.text = vo.articleTitle;
    summary.text = vo.articleContent;
    [icon sd_setImageWithURL:[NSURL URLWithString:vo.avatar] placeholderImage:nil];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.clipsToBounds = YES;
    name.text = vo.articleName;
    
    NSArray * typeList = @[@"幸福情商", @"美丽造型", @"营养养生", @"美食吃货", @"其他"]; //2.3
    NSInteger index = [typeList indexOfObject:vo.type];
    
    if (index >= 4) {
        index = 3;
    }
    NSArray * newType = @[@"Yao·幸福", @"Yao·美丽", @"Yao·健康", @"Yao·美食",  @"Yao·幸福"];
    
    tag.text = newType[index];
    
    if ([vo.sign isEqualToString:@"menber"]) {
        sign.image = [UIImage imageNamed:@"BigVRed"];
    }else if([vo.sign isEqualToString:@"user"]){
        sign.image = [UIImage imageNamed:@""];
    }
    
    
    
}


@end
