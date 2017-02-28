//
//  HotArticleCell.m
//  living
//
//  Created by Huasheng on 2017/2/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "HotArticleCell.h"
#import "FitConsts.h"
@implementation HotArticleCell
{
    UIImageView * backImage;
    UILabel * title;
    UIImageView * icon;
    UILabel * name;
    UILabel * tag;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
    }
    return self;
}

- (void)setCellType:(NSInteger)cellType{
    if (cellType == 1) {
        backImage.frame = CGRectMake(0, 0, kScreenWidth, 205);
    }
}
- (void)addSubViews{
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 215)];
    [self.contentView addSubview:backView];
    
    backImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 205)];
    backImage.image = [UIImage imageNamed:@"demo"];
    backImage.backgroundColor = BG_GRAY_COLOR;
    [backView addSubview:backImage];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, kScreenWidth-40, 60)];
    title.text = @"腰·美丽 丨 用一束光的时间与你相遇青春不负的冬日";
    title.textColor = [UIColor whiteColor];
    title.font = TEXT_FONT_BOLDOBLIQUE_16;
    title.numberOfLines = 2;
    [backView addSubview:title];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 160, 20, 20)];
    icon.image = [UIImage imageNamed:@"cellHeadImageIcon"];
    icon.backgroundColor = COLOR_RED_LIGHT;
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 10;
    [backView addSubview:icon];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(50, 165, 60, 10)];
    name.text = @"欧阳夏丹";
    name.textColor = TEXT_COLOR_LEVEL_4;
    name.font = TEXT_FONT_LEVEL_3;
    [backView addSubview:name];
    
    tag = [[UILabel alloc] initWithFrame:CGRectMake(110, 165, 45, 10)];
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
