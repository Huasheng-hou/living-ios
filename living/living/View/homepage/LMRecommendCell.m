//
//  LMRecommendCell.m
//  living
//
//  Created by Huasheng on 2017/2/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMRecommendCell.h"
#import "FitConsts.h"
@implementation LMRecommendCell
{
    UIImageView *imageView;
    UILabel *title;
    UILabel *summary;
    UIImageView *icon;
    UILabel *name;
    UILabel *tag;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubViews];
        
    }
    return self;
}

- (void)addSubViews{
    
    UIView * backView = [[UIView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:backView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 90)];
    imageView.image = [UIImage imageNamed:@"cellHeadImageIcon"];
    imageView.backgroundColor = BG_GRAY_COLOR;
    [backView addSubview:imageView];
    
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, self.bounds.size.width-130, 25)];
    title.text = @"比较大的大提琴体验课";
    //title.backgroundColor = [UIColor yellowColor];
    title.textColor = TEXT_COLOR_LEVEL_3;
    title.font = TEXT_FONT_BOLD_14;
    [backView addSubview:title];
    
    
    summary = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, self.bounds.size.width-130, 40)];
    summary.text = @"新年新计划，是时候开展一个属于你的音乐之旅，年后让你周围的小伙伴眼前一亮哦";
    //summary.backgroundColor = [UIColor redColor];
    summary.textColor = TEXT_COLOR_LEVEL_3;
    summary.font = TEXT_FONT_LEVEL_3;
    summary.numberOfLines = 2;
    [summary sizeToFit];
    [backView addSubview:summary];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(120, 80, 20, 20)];
    icon.image = [UIImage imageNamed:@"cellHeadImageIcon"];
    icon.backgroundColor = BG_GRAY_COLOR;
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 10;
    [backView addSubview:icon];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(150, 85, 60, 10)];
    name.text = @"欧阳夏丹";
    name.textColor = TEXT_COLOR_LEVEL_4;
    name.font = TEXT_FONT_LEVEL_3;
    [backView addSubview:name];
    
    tag = [[UILabel alloc] initWithFrame:CGRectMake(210, 85, 45, 10)];
    tag.text = @"Yao·美丽";
    tag.textAlignment = NSTextAlignmentCenter;
    tag.textColor = [UIColor whiteColor];
    tag.backgroundColor = [UIColor yellowColor];
    tag.layer.masksToBounds = YES;
    tag.layer.cornerRadius = 2;
    tag.font = TEXT_FONT_LEVEL_4 ;
    [backView addSubview:tag];
    
    
    
    
    
    
}

@end
