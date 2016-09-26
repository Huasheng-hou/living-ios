//
//  LMhomePageCell.m
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMhomePageCell.h"
#import "FitConsts.h"

@interface LMhomePageCell () {
    float _xScale;
    float _yScale;
}

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;


@end

@implementation LMhomePageCell

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
    _imageV = [UIImageView new];
    _imageV.image = [UIImage imageNamed:@"112"];
    [self.contentView addSubview:_imageV];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"果然我问问我吩咐我跟我玩嗡嗡图文无关的身份和她和热稳定";
    _titleLabel.numberOfLines  = 2;
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_titleLabel];
    
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"作者的名字";
    _nameLabel.font = [UIFont systemFontOfSize:12.f];
    _nameLabel.textColor = TEXT_COLOR_LEVEL_3;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"30分钟前";
    _timeLabel.font = [UIFont systemFontOfSize:12.f];
    _timeLabel.textColor = TEXT_COLOR_LEVEL_3;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    
    
}

-(void)setData:(NSString *)data
{
    
}


- (void)setXScale:(float)xScale yScale:(float)yScale
{
    _xScale = xScale;
    _yScale = yScale;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_nameLabel sizeToFit];
    [_imageV sizeToFit];
    [_titleLabel sizeToFit];
    [_timeLabel sizeToFit];
    
    _imageV.frame = CGRectMake(15, 15, 90, 70);
    _titleLabel.frame = CGRectMake(115, 18, kScreenWidth-130, _titleLabel.bounds.size.height*2);
    
    _nameLabel.frame = CGRectMake(kScreenWidth-150, 70, _nameLabel.bounds.size.width, _nameLabel.bounds.size.height);
    
    _timeLabel.frame = CGRectMake(kScreenWidth-60, 70, _timeLabel.bounds.size.width, _timeLabel.bounds.size.height);


    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
