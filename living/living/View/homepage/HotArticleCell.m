//
//  HotArticleCell.m
//  living
//
//  Created by Huasheng on 2017/2/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "HotArticleCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"
@implementation HotArticleCell
{
    UIView * backView;
    
    UIImageView * backImage;
    UILabel * title;
    UILabel * desp;
    UIImageView * icon;
    UILabel * name;
    UILabel * tag;
    UIImageView * sign;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
    }
    return self;
}

- (void)setValue:(LMActicleVO *)list{
    NSArray * typeList = @[@"幸福情商", @"美丽造型", @"营养养生", @"美食吃货", @"其他"]; //2.3
    //NSArray * typeList = @[@"happiness", @"beautiful", @"healthy", @"delicious", @"其他"];  //3.0
    NSInteger index = [typeList indexOfObject:list.type];

    if (index >= 4) {
        index = 3;
    }
    NSArray * preTitle = @[@"腰·幸福 丨 ", @"腰·美丽 丨 ", @"腰·健康 丨 ", @"腰·美食 丨 ", @"腰·幸福 丨 "];
    NSArray * newType = @[@"Yao·幸福", @"Yao·美丽", @"Yao·健康", @"Yao·美食",  @"Yao·幸福"];
    [backImage sd_setImageWithURL:[NSURL URLWithString:list.avatar] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    backImage.contentMode = UIViewContentModeScaleAspectFill;
    backImage.clipsToBounds = YES;
    title.text = [NSString stringWithFormat:@"%@%@",preTitle[index], list.articleTitle];
    
    [icon sd_setImageWithURL:[NSURL URLWithString:list.avatar]];
    name.text = list.articleName;
    tag.text = newType[index];
    
    if ([list.sign isEqualToString:@"menber"]) {
        sign.image = [UIImage imageNamed:@"BigVRed"];
    }else if([list.sign isEqualToString:@"user"]){
        sign.image = [UIImage imageNamed:@""];
    }
    
    
}


- (void)setCellType:(NSInteger)cellType{
    if (cellType == 1) {
        //发现
        backImage.frame = CGRectMake(0, 0, kScreenWidth, 205);
        title.numberOfLines = 2;
    }
    if (cellType == 2) {
        //活动总结
        title.frame = CGRectMake(20, 90, kScreenWidth-40, 20);
        title.text = @"每个女生都有变美的潜质！";
        title.numberOfLines = 1;
        
        
        desp = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(title.frame), kScreenWidth-40, 40)];
        desp.text = @"新年新计划，是时候开展一个属于你的音乐之旅，年后让小伙伴们眼前一亮哦";
        desp.textColor = [UIColor whiteColor];
        desp.font = TEXT_FONT_LEVEL_3;
        desp.numberOfLines = 2;
        [backView addSubview:desp];
        
        
        [tag removeFromSuperview];
    }
}
- (void)addSubViews{
    for (UIView * subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 215)];
    [self.contentView addSubview:backView];
    
    backImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 205)];
    backImage.image = [UIImage imageNamed:@"BackImage"];
    backImage.backgroundColor = BG_GRAY_COLOR;
    [backView addSubview:backImage];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, kScreenWidth-40, 45)];
    title.text = @"腰·美丽 丨 用一束光的时间与你相遇青春不负的冬日";
    title.textColor = [UIColor whiteColor];
    title.font = TEXT_FONT_BOLD_18;
    //title.numberOfLines = 2;
    [backView addSubview:title];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(title.frame)+10, 25, 25)];
    icon.image = [UIImage imageNamed:@"cellHeadImageIcon"];
    icon.backgroundColor = COLOR_RED_LIGHT;
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 13;
    [backView addSubview:icon];
    
    sign = [[UIImageView alloc] initWithFrame:CGRectMake(icon.center.x+3, icon.center.y, CGRectGetWidth(icon.frame)/2, CGRectGetHeight(icon.frame)/2)];
    //sign.backgroundColor = BG_GRAY_COLOR;
    //sign.image = [UIImage imageNamed:@"BigVRed"];
    sign.layer.masksToBounds = YES;
    sign.layer.cornerRadius = 7;
    [backView addSubview:sign];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(60, 165, 60, 10)];
    name.text = @"欧阳夏丹";
    name.textColor = TEXT_COLOR_LEVEL_4;
    name.font = TEXT_FONT_LEVEL_3;
    [backView addSubview:name];
    
    tag = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(name.frame)+10, 165, 45, 10)];
    tag.text = @"Yao·美丽";
    tag.textAlignment = NSTextAlignmentCenter;
    tag.textColor = [UIColor whiteColor];
    tag.backgroundColor = COLOR_RED_LIGHT;
    tag.layer.masksToBounds = YES;
    tag.layer.cornerRadius = 2;
    tag.font = TEXT_FONT_LEVEL_4 ;
    [backView addSubview:tag];

    
}



@end
