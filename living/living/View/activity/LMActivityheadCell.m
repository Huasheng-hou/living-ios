//
//  LMActivityheadCell.m
//  living
//
//  Created by Ding on 16/9/30.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMActivityheadCell.h"
#import "FitConsts.h"

@interface LMActivityheadCell () {
    float _xScale;
    float _yScale;
}

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIImageView *headV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong)UIButton *joinButton;

@end

@implementation LMActivityheadCell

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
    _imageV.backgroundColor = BG_GRAY_COLOR;
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    [self.contentView addSubview:_imageV];
    
    //标题
    _titleLabel = [UILabel new];

    _titleLabel.numberOfLines  = 2;
    _titleLabel.font = [UIFont systemFontOfSize:16.f];
    _titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_titleLabel];
    
    //活动人数
    _countLabel = [UILabel new];
    
    _countLabel.textColor = TEXT_COLOR_LEVEL_2;
    _countLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:_countLabel];
    
    
    //活动人头像
    _headV = [UIImageView new];
    _headV.layer.cornerRadius = 5.f;
    _headV.contentMode = UIViewContentModeScaleAspectFill;
    _headV.clipsToBounds = YES;
    _headV.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_headV];
    
    //活动人名
    _nameLabel = [UILabel new];
    
    _nameLabel.font = [UIFont systemFontOfSize:13.f];
    _nameLabel.textColor = TEXT_COLOR_LEVEL_2;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    _joinButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //        _topBtn.backgroundColor = _COLOR_N(red);
    [_joinButton setTitle:@"报名" forState:UIControlStateNormal];
    [_joinButton setTintColor:LIVING_COLOR];
    _joinButton.showsTouchWhenHighlighted = YES;
    _joinButton.frame = CGRectMake(0, 0, 48.f, 48.f);
    [_joinButton addTarget:self action:@selector(onApply:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_joinButton];
    
    UIView *line = [UIView new];
    line.backgroundColor = LINE_COLOR;
    [line sizeToFit];
    line.frame = CGRectMake(kScreenWidth-71, 185, 1, 30);
    [self.contentView addSubview:line];
    
    
    
}

-(void)setValue:(LMEventDetailEventBody *)event
{
    [_imageV sd_setImageWithURL:[NSURL URLWithString:event.eventImg]];

    if (event.publishName ==nil) {
        _nameLabel.text = @"";
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"发布者：%@",event.publishName];
    }
//    _titleLabel.text = event.eventName;
    [_headV sd_setImageWithURL:[NSURL URLWithString:event.publishAvatar]];
    _countLabel.text = [NSString stringWithFormat:@"活动人数：%.0f/%.0f人",event.totalNumber,event.totalNum];
    
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
    [_countLabel sizeToFit];
    [_headV sizeToFit];
    
    
    _imageV.frame = CGRectMake(0, 0, kScreenWidth, 170);
    
    _titleLabel.frame = CGRectMake(15, _imageV.bounds.size.height-_titleLabel.bounds.size.height*2, kScreenWidth-30, _titleLabel.bounds.size.height*2);
    
    _headV.frame = CGRectMake(15, 10+_imageV.bounds.size.height, 40, 40);
    
    _nameLabel.frame = CGRectMake(60, 10+_imageV.bounds.size.height, _nameLabel.bounds.size.width, _nameLabel.bounds.size.height);
    _countLabel.frame = CGRectMake(60, 15+_imageV.bounds.size.height+_nameLabel.bounds.size.height, _countLabel.bounds.size.width, _countLabel.bounds.size.height);
    
    _joinButton.frame = CGRectMake(kScreenWidth-70, 170+5, 60, self.contentView.bounds.size.height-180);
    

}

- (void)onApply:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillApply:)]) {
        [_delegate cellWillApply:self];
    }
    
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
