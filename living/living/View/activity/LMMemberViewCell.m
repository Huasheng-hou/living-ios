//
//  LMMemberViewCell.m
//  living
//
//  Created by Ding on 2016/11/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMemberViewCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"

@implementation LMMemberViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews
{
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 85, 85)];
    _headImage.layer.cornerRadius = 5;
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    _headImage.backgroundColor = BG_GRAY_COLOR;
    _headImage.clipsToBounds = YES;
    [self.contentView addSubview:_headImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 150, 20)];
    _nameLabel.font = TEXT_FONT_LEVEL_2;
    _nameLabel.textColor = TEXT_COLOR_LEVEL_1;
    _nameLabel.text = @"高琛";
    [self.contentView addSubview:_nameLabel];
    
    _IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 150, 60)];
    _IDLabel.font = TEXT_FONT_LEVEL_2;
    _IDLabel.textColor = TEXT_COLOR_LEVEL_2;
    _IDLabel.textAlignment = NSTextAlignmentRight;
    _IDLabel.text = @"(ID:45654654)";
    [self.contentView addSubview:_IDLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-90, 30, 80, 23)];
    _priceLabel.font = TEXT_FONT_LEVEL_1;
    _priceLabel.textColor = LIVING_REDCOLOR;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.text = @"￥365";
    [self.contentView addSubview:_priceLabel];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 35, 150, 13)];
    _numLabel.font = TEXT_FONT_LEVEL_2;
    _numLabel.textColor = TEXT_COLOR_LEVEL_2;
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.text = @"x3";
    [self.contentView addSubview:_numLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 59.5, kScreenWidth-10, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView];
    
    
    
}

-(void)setData:(LMMemberVO *)list
{
    [_headImage sd_setImageWithURL:[NSURL URLWithString:list.Avatar]];
    _nameLabel.text = list.nickName;
    _IDLabel.text = [NSString stringWithFormat:@"(ID:%d)",list.userId];
    _numLabel.text = [NSString stringWithFormat:@"x%d",list.number];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",list.orderAmount];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [_nameLabel sizeToFit];
    [_numLabel sizeToFit];
    [_IDLabel sizeToFit];
    [_priceLabel sizeToFit];
    
    _nameLabel.frame = CGRectMake(65, 10, _nameLabel.bounds.size.width, 20);
    _numLabel.frame = CGRectMake(65, 35, _numLabel.bounds.size.width, 13);
    _IDLabel.frame = CGRectMake(65+5+_nameLabel.bounds.size.width, 10, _IDLabel.bounds.size.width, 20);
    _priceLabel.frame = CGRectMake(kScreenWidth-_priceLabel.bounds.size.width-10, 30, _priceLabel.bounds.size.width, 20);
    
    
    
    
    
}



@end
