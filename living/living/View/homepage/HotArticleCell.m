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
    UIView * shadow;
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
    NSArray * colorList = @[[UIColor colorWithRed:247/255.0 green:179/255.0 blue:155/255.0 alpha:1],
                            [UIColor colorWithRed:242/255.0 green:85/255.0 blue:120/255.0 alpha:1],
                            [UIColor colorWithRed:243/255.0 green:111/255.0 blue:102/255.0 alpha:1],
                            [UIColor colorWithRed:248/255.0 green:198/255.0 blue:41/255.0 alpha:1],
                            [UIColor colorWithRed:247/255.0 green:179/255.0 blue:155/255.0 alpha:1]];
    //NSArray * typeList = @[@"happiness", @"beautiful", @"healthy", @"delicious", @"其他"];  //3.0
    NSInteger index = [typeList indexOfObject:list.type];

    if (index >= 4) {
        index = 3;
    }
    NSArray * preTitle = @[@"腰·幸福 丨 ", @"腰·美丽 丨 ", @"腰·健康 丨 ", @"腰·美食 丨 ", @"腰·幸福 丨 "];
    NSArray * newType = @[@"Yao·幸福", @"Yao·美丽", @"Yao·健康", @"Yao·美食",  @"Yao·幸福"];
    
    [backImage sd_setImageWithURL:[NSURL URLWithString:list.avatar] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    
    
    //title.text = [NSString stringWithFormat:@"%@%@",preTitle[index], list.articleTitle];
    title.text = list.articleTitle;
    
    
    [icon sd_setImageWithURL:[NSURL URLWithString:list.headImgUrl]];
    
    name.text = list.articleName;
    
    tag.text = newType[index];
    tag.backgroundColor = colorList[index];
    
    if ([list.sign isEqualToString:@"menber"]) {
        
        sign.image = [UIImage imageNamed:@"BigVRed"];
        
    }else if([list.sign isEqualToString:@"user"]){
        
        sign.image = [UIImage imageNamed:@""];
        
    }
    
    
    if (_cellType == 2) {
        [backImage sd_setImageWithURL:[NSURL URLWithString:list.image]];
        title.text = list.title;
        desp.text = list.content;
        name.text = list.nickName;
    }
    
    
    
    
}

- (void)setCellType:(NSInteger)cellType{
    _cellType = cellType;
    if (cellType == 1) {
        //发现
        backImage.frame = CGRectMake(0, 0, kScreenWidth, 205);
        shadow.frame = backImage.frame;
        title.numberOfLines = 2;
        
        [tag removeFromSuperview];
    }
    if (cellType == 2) {
        //活动总结
        
        backImage.frame = CGRectMake(0, 0, kScreenWidth, 205);
        shadow.frame = backImage.frame;
        
        title.frame = CGRectMake(20, 90, kScreenWidth-40, 20);
        //title.text = @"每个女生都有变美的潜质！";
        title.numberOfLines = 1;
        
        
        desp = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(title.frame), kScreenWidth-40, 40)];
        //desp.text = @"新年新计划，是时候开展一个属于你的音乐之旅，年后让小伙伴们眼前一亮哦";
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
    backImage.contentMode = UIViewContentModeScaleAspectFill;
    backImage.clipsToBounds = YES;
    [backView addSubview:backImage];
    
    shadow = [[UIView alloc] initWithFrame:backImage.frame];
    shadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [backView addSubview:shadow];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, kScreenWidth-40, 45)];
    //title.text = @"用一束光的时间与你相遇青春不负的冬日";
    title.textColor = [UIColor whiteColor];
    title.font = TEXT_FONT_BOLD_18;
    //title.numberOfLines = 2;
    [backView addSubview:title];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(title.frame)+10, 25, 25)];
    //icon.image = [UIImage imageNamed:@"cellHeadImageIcon"];
    icon.backgroundColor = BG_GRAY_COLOR;
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 13;
    [backView addSubview:icon];
    
    sign = [[UIImageView alloc] initWithFrame:CGRectMake(icon.center.x+3, icon.center.y, CGRectGetWidth(icon.frame)/2, CGRectGetHeight(icon.frame)/2)];
    //sign.backgroundColor = BG_GRAY_COLOR;
    //sign.image = [UIImage imageNamed:@"BigVRed"];
    sign.layer.masksToBounds = YES;
    sign.layer.cornerRadius = 7;
    [backView addSubview:sign];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(60, 162.5, 80, 15)];
    //name.text = @"James";
    name.textColor = [UIColor cyanColor];
    name.font = TEXT_FONT_LEVEL_3;
    [backView addSubview:name];
    
    tag = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(name.frame)+10, 162.5, 55, 15)];
    //tag.text = @"Yao·美丽";
    tag.textAlignment = NSTextAlignmentCenter;
    tag.textColor = [UIColor whiteColor];
    //tag.backgroundColor = COLOR_RED_LIGHT;
    tag.layer.masksToBounds = YES;
    tag.layer.cornerRadius = 2;
    tag.font = TEXT_FONT_LEVEL_4 ;
    [backView addSubview:tag];

    
}



@end
