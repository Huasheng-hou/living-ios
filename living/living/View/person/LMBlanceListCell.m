//
//  LMBlanceListCell.m
//  living
//
//  Created by Ding on 2016/10/30.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBlanceListCell.h"
#import "FitConsts.h"

@interface LMBlanceListCell ()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *detailLable;
@property(nonatomic,strong)UILabel *balanceLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@end

@implementation LMBlanceListCell


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
    _titleLabel = [UILabel new];
    _titleLabel.text = @"这是什么什么活动名称呢？";
    _titleLabel.font = TEXT_FONT_LEVEL_1;
    _titleLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_titleLabel];
    
    _detailLable = [UILabel new];
    _detailLable.text = @"报名成功";
    _detailLable.font = TEXT_FONT_LEVEL_2;
    _detailLable.textColor = TEXT_COLOR_LEVEL_3;
    [self.contentView addSubview:_detailLable];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"10月30日 12:12:12";
    _timeLabel.font = TEXT_FONT_LEVEL_3;
    _timeLabel.textColor = TEXT_COLOR_LEVEL_3;
    [self.contentView addSubview:_timeLabel];
    
    _balanceLabel = [UILabel new];
    _balanceLabel.text = @"￥ 400";
    _balanceLabel.font = TEXT_FONT_LEVEL_1;
    [self.contentView addSubview:_balanceLabel];
    
    
}

-(void)setModel:(LMBalanceList *)list
{
    _titleLabel.text = list.name;
    _detailLable.text = list.title;
    _timeLabel.text = list.datetime;
    if (list.amount==nil) {
        _balanceLabel.text = @"";
    }else{
        _balanceLabel.text = [NSString stringWithFormat:@"￥ %@",list.amount];
    }
    
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    [_detailLable sizeToFit];
    [_timeLabel sizeToFit];
    [_balanceLabel sizeToFit];
    
    
    _titleLabel.frame = CGRectMake(15, 5, _titleLabel.bounds.size.width, 25);
    _detailLable.frame = CGRectMake(15, 32, _detailLable.bounds.size.width, _detailLable.bounds.size.height);
    _timeLabel.frame = CGRectMake(15, 70-_timeLabel.bounds.size.height, _timeLabel.bounds.size.width, _timeLabel.bounds.size.height);
    _balanceLabel.frame = CGRectMake(kScreenWidth-15-_balanceLabel.bounds.size.width, 0, _balanceLabel.bounds.size.width, 75);
    
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