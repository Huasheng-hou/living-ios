//
//  LMActivityCell.m
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMActivityCell.h"
#import "UIImageView+WebCache.h"
#import "FitConsts.h"

@interface LMActivityCell () {
    float _xScale;
    float _yScale;
}

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *headV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation LMActivityCell

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
    //活动图片
    _imageV = [UIImageView new];
    _imageV.backgroundColor = [UIColor lightGrayColor];
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    
    [self.contentView addSubview:_imageV];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    backView.frame = CGRectMake(0, 0, kScreenWidth, 170);
    [_imageV addSubview:backView];
    
    
    //标题
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines  = 2;
    _titleLabel.font = [UIFont systemFontOfSize:16.f];
    _titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_titleLabel];
    
    //参加人数
    _countLabel = [UILabel new];
    _countLabel.font = [UIFont systemFontOfSize:13.f];
    _countLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_countLabel];
    
    
    //价格
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:13.f];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_priceLabel];

    
    
    //活动时间
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13.f];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_timeLabel];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 170, kScreenWidth, 30)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:footView];
    
    //活动人头像
    _headV = [UIImageView new];
    _headV.backgroundColor = [UIColor lightGrayColor];
    _headV.clipsToBounds = YES;
    _headV.layer.cornerRadius = 10.f;
    [footView addSubview:_headV];
    
    //活动人名
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:13.f];
    _nameLabel.textColor = TEXT_COLOR_LEVEL_2;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:_nameLabel];
    
    //活动地址
    _addressLabel = [UILabel new];
    _addressLabel.textAlignment = NSTextAlignmentRight;
    _addressLabel.font = [UIFont systemFontOfSize:13.f];
    _addressLabel.textColor = TEXT_COLOR_LEVEL_2;
    [footView addSubview:_addressLabel];
    
    
    
}

-(void)setValue:(LMActivityList *)list
{
    LMActivityList *listData = list;
    if (listData.nickNname==nil) {
        _nameLabel.text = @"匿名商户";
    }else{
        _nameLabel.text = listData.nickNname;
    }
    
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:listData.eventImg]];
    _addressLabel.text = listData.address;
    [_headV sd_setImageWithURL:[NSURL URLWithString:listData.avatar] placeholderImage:[UIImage imageNamed:@"headIcon"]];
    _titleLabel.text = listData.eventName;
    
   NSString *string = [listData.startTime substringToIndex:16];
    
    _timeLabel.text = string;
    
    _countLabel.text = [NSString stringWithFormat:@"%.0f/%.0f人已报名参加",listData.currentNum,listData.totalnum];
    _priceLabel.text =[NSString stringWithFormat:@"￥%@/人",listData.perCost];
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
    [_countLabel sizeToFit];
    [_priceLabel sizeToFit];
    [_addressLabel sizeToFit];
    [_headV sizeToFit];
    
    
    _imageV.frame = CGRectMake(0, 0, kScreenWidth, 170);
    
    _titleLabel.frame = CGRectMake(15, 18, kScreenWidth-30, _titleLabel.bounds.size.height*2);
    
    _countLabel.frame = CGRectMake(15, 90, _countLabel.bounds.size.width, _countLabel.bounds.size.height);
    
    _priceLabel.frame = CGRectMake(15, 115, _priceLabel.bounds.size.width, _priceLabel.bounds.size.height);
    _timeLabel.frame = CGRectMake(15, 140, _timeLabel.bounds.size.width, _timeLabel.bounds.size.height);
    
    _headV.frame = CGRectMake(15, 5, 20, 20);
    
    _nameLabel.frame = CGRectMake(40, 0, _nameLabel.bounds.size.width, 30);
    
    _addressLabel.frame = CGRectMake(70+_nameLabel.bounds.size.width, 0, kScreenWidth-85-_nameLabel.bounds.size.width, 30);
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
