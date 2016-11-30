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



@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIImageView *headV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *shareButton;


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
    _imageV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [_imageV addGestureRecognizer:tapImage];
    
    
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
    _headV.backgroundColor = BG_GRAY_COLOR;
    [self.contentView addSubview:_headV];
    
    //活动人名
    _nameLabel = [UILabel new];
    
    _nameLabel.font = [UIFont systemFontOfSize:13.f];
    _nameLabel.textColor = TEXT_COLOR_LEVEL_1;
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
    line.frame = CGRectMake(kScreenWidth-71, kScreenWidth*3/5+15, 1, 30);
    [self.contentView addSubview:line];
    
    
    _shareButton=[UIButton new];
    [_shareButton addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    _shareButton.layer.cornerRadius = 3;
//    _shareButton.layer.borderColor =LIVING_COLOR.CGColor;
//    _shareButton.layer.borderWidth = 0.5;
    [self.contentView addSubview:_shareButton];
    
    
    
}

-(void)setValue:(LMEventBodyVO *)event
{
    [_imageV sd_setImageWithURL:[NSURL URLWithString:event.eventImg]];

    if (event.publishName ==nil) {
        _nameLabel.text = @"";
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"发布者：%@",event.publishName];
    }
//    _titleLabel.text = event.eventName;
    [_headV sd_setImageWithURL:[NSURL URLWithString:event.publishAvatar]];
    _countLabel.text = [NSString stringWithFormat:@"活动人数：%d/%d人",event.totalNumber,event.totalNum];
    
    
    switch (event.status) {
        case 1:
            [_joinButton setTitle:@"报名" forState:UIControlStateNormal];
            break;
        case 2:
            [_joinButton setTitle:@"人满" forState:UIControlStateNormal];
            _joinButton.userInteractionEnabled = NO;
            break;
        case 3:
            [_joinButton setTitle:@"已开始" forState:UIControlStateNormal];
            _joinButton.userInteractionEnabled = NO;
            break;
        case 4:
            [_joinButton setTitle:@"已完结" forState:UIControlStateNormal];
            _joinButton.userInteractionEnabled = NO;
            break;
        case 5:
            [_joinButton setTitle:@"删除" forState:UIControlStateNormal];
            _joinButton.userInteractionEnabled = NO;
            break;
            
        default:
            break;
    }
    
    
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
    [_shareButton sizeToFit];
    
    
    _imageV.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5);
    
    _titleLabel.frame = CGRectMake(15, _imageV.bounds.size.height-_titleLabel.bounds.size.height*2, kScreenWidth-30, _titleLabel.bounds.size.height*2);
    
    _headV.frame = CGRectMake(15, 10+_imageV.bounds.size.height, 40, 40);
    
    _nameLabel.frame = CGRectMake(61, 14+_imageV.bounds.size.height, _nameLabel.bounds.size.width, _nameLabel.bounds.size.height);
    _countLabel.frame = CGRectMake(61, 17+_imageV.bounds.size.height+_nameLabel.bounds.size.height, _countLabel.bounds.size.width, _countLabel.bounds.size.height);
    
    _joinButton.frame = CGRectMake(kScreenWidth-70, kScreenWidth*3/5+5, 60, self.contentView.bounds.size.height-10-kScreenWidth*3/5);
    
    _shareButton.frame = CGRectMake(kScreenWidth-71-80, kScreenWidth*3/5+15, 80, 30);

}

- (void)onApply:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillApply:)]) {
        [_delegate cellWillApply:self];
    }
    
}

-(void)clickImage:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellClickImage:)]) {
        [_delegate cellClickImage:self];
    }
}

-(void)shareButton:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellShareImage:)]) {
        [_delegate cellShareImage:self];
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
