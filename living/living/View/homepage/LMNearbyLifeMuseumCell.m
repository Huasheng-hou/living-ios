//
//  LMNearbyLifeMuseumCell.m
//  living
//
//  Created by Huasheng on 2017/2/25.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMNearbyLifeMuseumCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"
@implementation LMNearbyLifeMuseumCell
{
    UIImageView * _icon;
    UILabel * _name;
    UILabel * _arrow;
    UILabel * _botLine;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 25, 25)];
    //_icon.image = [UIImage imageNamed:@"cellHeadImageIcon"];
    _icon.backgroundColor = BG_GRAY_COLOR;
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = 3;
    [self.contentView addSubview:_icon];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+10, 15, kScreenWidth-70, 15)];
    //_name.text = @"成都生活馆";
    _name.textColor = TEXT_COLOR_LEVEL_4;
    _name.font = TEXT_FONT_BOLD_14;
    [self.contentView addSubview:_name];
    
    _arrow = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-25, 15, 15, 15)];
    _arrow.text = @"＞";
    _arrow.textColor = TEXT_COLOR_LEVEL_4;
    _arrow.font = TEXT_FONT_BOLD_14;
    [self.contentView addSubview:_arrow];
    
    _botLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_icon.frame), CGRectGetMaxY(_icon.frame)+9, kScreenWidth-CGRectGetMinX(_icon.frame), 1)];
    _botLine.backgroundColor = BG_GRAY_COLOR;
    [self.contentView addSubview:_botLine];
    
}

- (void)setVO:(LMLivingVenueVO *)vo{
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:vo.livingImage] placeholderImage:[UIImage imageNamed:@"cellHeadImageIcon"]];
    
    _name.text = vo.livingName;
    
}

@end
