//
//  LMVoiceHeaderCell.m
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMVoiceHeaderCell.h"
#import "FitConsts.h"

@interface LMVoiceHeaderCell () {
    float _xScale;
    float _yScale;
    CGFloat conHigh;
}



@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIImageView *headV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UILabel *joinLabel;

@property (nonatomic, strong) UIView *imageArrayView;


@end

@implementation LMVoiceHeaderCell

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
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5+kScreenWidth*3/5, kScreenWidth, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineView];
    
    //标题
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines  = 0;
    _titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:_titleLabel];
    
    //活动参与者
    _joinLabel = [UILabel new];
    _joinLabel.textColor = TEXT_COLOR_LEVEL_2;
    _joinLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_joinLabel];
    
    _imageArrayView = [UIView new];
    _imageArrayView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_imageArrayView];
    
    
}

-(void)setValue:(LMVoiceDetailVO *)event
{
    if (event&&event!=nil) {
        _voiceVO = event;
        NSLog(@"%@",_voiceVO.image);
        [_imageV sd_setImageWithURL:[NSURL URLWithString:_voiceVO.image]];
        
        if (event.publishName ==nil) {
            _nameLabel.text = @"";
        }else{
            _nameLabel.text = [NSString stringWithFormat:@"本期讲师：%@",_voiceVO.publishName];
        }
        
        
        
        [_headV sd_setImageWithURL:[NSURL URLWithString:_voiceVO.avatar]];
        _countLabel.text = [NSString stringWithFormat:@"人数：%@/%@人",_voiceVO.number,_voiceVO.limitNum];
        
        
        //    switch (event.status) {
        //        case 1:
        [_joinButton setTitle:@"报名" forState:UIControlStateNormal];
        //            break;
        //        case 2:
        //            [_joinButton setTitle:@"人满" forState:UIControlStateNormal];
        //            _joinButton.userInteractionEnabled = NO;
        //            break;
        //        case 3:
        //            [_joinButton setTitle:@"已开始" forState:UIControlStateNormal];
        //            _joinButton.userInteractionEnabled = NO;
        //            break;
        //        case 4:
        //            [_joinButton setTitle:@"已完结" forState:UIControlStateNormal];
        //            _joinButton.userInteractionEnabled = NO;
        //            break;
        //        case 5:
        //            [_joinButton setTitle:@"删除" forState:UIControlStateNormal];
        //            _joinButton.userInteractionEnabled = NO;
        //            break;
        //
        //        default:
        //            break;
        //    }
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        conHigh = [_voiceVO.voiceTitle boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        _titleLabel.text = _voiceVO.voiceTitle;
        
        _joinLabel.text = [NSString stringWithFormat:@"共%@人参与课堂",_voiceVO.number];
        
 
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
    [_joinLabel sizeToFit];
    [_imageArrayView sizeToFit];
    
    _imageV.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5);
    _headV.frame = CGRectMake(15, 10+_imageV.bounds.size.height, 40, 40);
    
    _nameLabel.frame = CGRectMake(61, 14+_imageV.bounds.size.height, kScreenWidth-65-80-61, _nameLabel.bounds.size.height);
    _countLabel.frame = CGRectMake(61, 17+_imageV.bounds.size.height+_nameLabel.bounds.size.height, _countLabel.bounds.size.width, _countLabel.bounds.size.height);
    
    _joinButton.frame = CGRectMake(kScreenWidth-70, kScreenWidth*3/5+5, 60, 60);
    
    
    _titleLabel.frame = CGRectMake(15, _imageV.bounds.size.height +65, kScreenWidth-30, conHigh);
    
    _joinLabel.frame = CGRectMake(15, _imageV.bounds.size.height +70+conHigh, kScreenWidth-30, 30);
    _imageArrayView.frame = CGRectMake(0, _imageV.bounds.size.height +110+conHigh, kScreenWidth, 30);
    
}

+ (CGFloat)cellHigth:(NSString *)titleString
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGFloat conHigh = [titleString boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    return (60+conHigh+kScreenWidth*3/5 +80+10);
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

@end
