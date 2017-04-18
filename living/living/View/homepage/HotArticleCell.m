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
    //NSArray * typeList = @[@"幸福情商", @"美丽造型", @"营养养生", @"美食吃货", @"其他"]; //2.3分类
    NSArray * colorList = @[[UIColor colorWithRed:247/255.0 green:179/255.0 blue:155/255.0 alpha:1],
                            [UIColor colorWithRed:242/255.0 green:85/255.0 blue:120/255.0 alpha:1],
                            [UIColor colorWithRed:243/255.0 green:111/255.0 blue:102/255.0 alpha:1],
                            [UIColor colorWithRed:248/255.0 green:198/255.0 blue:41/255.0 alpha:1],
                            [UIColor colorWithRed:247/255.0 green:179/255.0 blue:155/255.0 alpha:1]];
    NSArray * typeList = @[@"happiness", @"beautiful", @"healthy", @"delicious", @"其他"];  //3.0
    NSInteger index = [typeList indexOfObject:list.category];

    if (index >= 4) {
        index = 3;
    }
    NSArray * newType = @[@"Yao·幸福", @"Yao·美丽", @"Yao·健康", @"Yao·美食",  @"Yao·幸福"];

    if (list.avatar) {
        [backImage sd_setImageWithURL:[NSURL URLWithString:list.avatar] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    }
   
    title.text = list.articleTitle;  //神奇卡顿崩溃bug iPhone 4S iOS 9.3.5
    
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
    
    [name sizeToFit];
    name.frame = CGRectMake(60, 162.5, name.frame.size.width+20, 15);
    tag.frame = CGRectMake(CGRectGetMaxX(name.frame)+10, 162.5, 55, 15);
    
    
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
        title.numberOfLines = 1;
        
        
        desp = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(title.frame), kScreenWidth-40, 40)];
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
    title.textColor = [UIColor whiteColor];
    title.font = TEXT_FONT_BOLD_18;
    [backView addSubview:title];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(title.frame)+10, 25, 25)];
    icon.backgroundColor = BG_GRAY_COLOR;
    icon.clipsToBounds = YES;
    icon.layer.cornerRadius = 13;
    [backView addSubview:icon];
    
    sign = [[UIImageView alloc] initWithFrame:CGRectMake(icon.center.x+3, icon.center.y, CGRectGetWidth(icon.frame)/2, CGRectGetHeight(icon.frame)/2)];
    sign.clipsToBounds = YES;
    sign.layer.cornerRadius = 7;
    [backView addSubview:sign];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(60, 162.5, 80, 15)];
    name.textColor = [UIColor cyanColor];
    name.font = TEXT_FONT_LEVEL_3;
    [backView addSubview:name];
    
    tag = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(name.frame)+10, 162.5, 55, 15)];
    tag.textAlignment = NSTextAlignmentCenter;
    tag.textColor = [UIColor whiteColor];
    tag.clipsToBounds = YES;
    tag.layer.cornerRadius = 2;
    tag.font = TEXT_FONT_LEVEL_4 ;
    [backView addSubview:tag];

    
}



@end
