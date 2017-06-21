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
    CGFloat headImgH;
}

@property (nonatomic, strong) UIView * shadow;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIImageView *headV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *shareButton;

//@property (nonatomic, strong) UILabel *joinLabel;

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
    
    
    _shadow = [UIView new];
    _shadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [_imageV addSubview:_shadow];
    
    
    
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
    
    
    //报名
    _joinButton = [UIButton buttonWithType:UIButtonTypeSystem];
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
//    _joinLabel = [UILabel new];
//    _joinLabel.textColor = TEXT_COLOR_LEVEL_2;
//    _joinLabel.font = [UIFont systemFontOfSize:14.f];
    //[self.contentView addSubview:_joinLabel];
    
    _imageArrayView = [UIView new];
    [self.contentView addSubview:_imageArrayView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(memberList)];
    [_imageArrayView addGestureRecognizer:tap];
    
    _shareButton=[UIButton new];
    [_shareButton addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    _shareButton.layer.cornerRadius = 3;
    [self.contentView addSubview:_shareButton];
    
    
}

-(void)setValue:(LMVoiceDetailVO *)event
{
    if (event&&event!=nil) {
        _voiceVO = event;
        [_imageV sd_setImageWithURL:[NSURL URLWithString:_voiceVO.image]];
        
        if (event.publishName ==nil) {
            _nameLabel.text = @"";
        }else{
            _nameLabel.text = [NSString stringWithFormat:@"本期讲师：%@",_voiceVO.publishName];
        }

        [_headV sd_setImageWithURL:[NSURL URLWithString:_voiceVO.avatar]];
        //_countLabel.text = [NSString stringWithFormat:@"人数：%@/%@人",_voiceVO.number,_voiceVO.limitNum];
        
        
        int currentNum = [_voiceVO.number intValue];
        int limitNum = [_voiceVO.limitNum intValue];
        
        if (_voiceVO.status && [_voiceVO.status isEqualToString:@"ready"] && currentNum < limitNum) {
            if (currentNum / (float)limitNum < 0.75) {
                _countLabel.text = [NSString stringWithFormat:@"%@人   报名中",_voiceVO.limitNum];
            }else{
                _countLabel.text = [NSString stringWithFormat:@"%@人   名额不多",_voiceVO.limitNum];
            }
        }else{
            _countLabel.text = [NSString stringWithFormat:@"%@人",_voiceVO.limitNum];
        }
        
        
        
        
        if ([_role isEqualToString:@"student"]) {
            if (_voiceVO.isBuy == YES) {
                [_joinButton setTitle:@"已报名" forState:UIControlStateNormal];
                _joinButton.userInteractionEnabled = NO;
            }else{
                if (_voiceVO.status&&[_voiceVO.status isEqualToString:@"open"]) {
                    [_joinButton setTitle:@"已开始" forState:UIControlStateNormal];
                    _joinButton.userInteractionEnabled = NO;
                }
                if (_voiceVO.status&&[_voiceVO.status isEqualToString:@"ready"]) {
                    if (currentNum == limitNum) {
                        [_joinButton setTitle:@"已售罄" forState:UIControlStateNormal];
                        _joinButton.userInteractionEnabled = NO;
                    }
                    if (currentNum < limitNum) {
                        [_joinButton setTitle:@"报名" forState:UIControlStateNormal];
                    }
                }
                if (_voiceVO.status&&[_voiceVO.status isEqualToString:@"closed"]) {
                    [_joinButton setTitle:@"已结束" forState:UIControlStateNormal];
                    _joinButton.userInteractionEnabled = NO;
                }
            }
        }else{
            if (_voiceVO.status&&[_voiceVO.status isEqualToString:@"open"]) {
                [_joinButton setTitle:@"已开始" forState:UIControlStateNormal];
                _joinButton.userInteractionEnabled = NO;
            }
            if (_voiceVO.status&&[_voiceVO.status isEqualToString:@"ready"]) {
                [_joinButton setTitle:@"未开始" forState:UIControlStateNormal];
                _joinButton.userInteractionEnabled = NO;
            }
            if (_voiceVO.status&&[_voiceVO.status isEqualToString:@"closed"]) {
                [_joinButton setTitle:@"已结束" forState:UIControlStateNormal];
                _joinButton.userInteractionEnabled = NO;
            }
        }
        

        
        
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        conHigh = [_voiceVO.voiceTitle boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        _titleLabel.text = _voiceVO.voiceTitle;
        
        //_joinLabel.text = [NSString stringWithFormat:@"共%@人参与课堂",_voiceVO.number];
        
        if (_voiceVO.list&&_voiceVO.list.count>0) {
            NSInteger num = _voiceVO.list.count;
        CGFloat imgW = (kScreenWidth - 100)/9;
        headImgH = imgW;
        
        if (num>9) {
            for (int i = 0; i<9; i++) {
                if (i ==8) {
                    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*(i+1)+i*imgW, 0, imgW, imgW)];
                    [headImage sd_setImageWithURL:[NSURL URLWithString:[_voiceVO.list[i] objectForKey:@"userAvatar"]] placeholderImage:[UIImage imageNamed:@"headIcon"]];
                    headImage.image = [UIImage imageNamed:@"headMore"];
                    
                    [_imageArrayView addSubview:headImage];
                }else{
                UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*(i+1)+i*imgW, 0, imgW, imgW)];
                headImage.backgroundColor = BG_GRAY_COLOR;
                [headImage sd_setImageWithURL:[NSURL URLWithString:[_voiceVO.list[i] objectForKey:@"userAvatar"]] placeholderImage:[UIImage imageNamed:@"headIcon"]];
                headImage.layer.cornerRadius = 2;
                headImage.contentMode = UIViewContentModeScaleAspectFill;
                headImage.clipsToBounds = YES;
                
                [_imageArrayView addSubview:headImage];
                }
            }
        

        }else{
        
            for (int i = 0; i<num; i++) {
                UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*(i+1)+i*imgW, 0, imgW, imgW)];
                [headImage sd_setImageWithURL:[NSURL URLWithString:[_voiceVO.list[i] objectForKey:@"userAvatar"]] placeholderImage:[UIImage imageNamed:@"headIcon"]];
                headImage.layer.cornerRadius = 2;
                headImage.contentMode = UIViewContentModeScaleAspectFill;
                headImage.clipsToBounds = YES;
                [_imageArrayView addSubview:headImage];
                
            }
        }
    }
    
 
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
    [_titleLabel sizeToFit];
    [_countLabel sizeToFit];
    [_headV sizeToFit];
    //[_joinLabel sizeToFit];
    [_imageArrayView sizeToFit];
    [_shareButton sizeToFit];
    
    _imageV.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5);
    
    _shadow.frame = _imageV.bounds;
    
    _headV.frame = CGRectMake(15, 10+_imageV.bounds.size.height, 40, 40);
    
    _nameLabel.frame = CGRectMake(61, 14+_imageV.bounds.size.height, kScreenWidth-65-80-61, _nameLabel.bounds.size.height);
    _countLabel.frame = CGRectMake(61, 17+_imageV.bounds.size.height+_nameLabel.bounds.size.height, _countLabel.bounds.size.width, _countLabel.bounds.size.height);
    
    _joinButton.frame = CGRectMake(kScreenWidth-70, kScreenWidth*3/5+5, 60, 50);
    
    
    _titleLabel.frame = CGRectMake(15, _imageV.bounds.size.height +65, kScreenWidth-30, conHigh);
    
    //_joinLabel.frame = CGRectMake(15, _imageV.bounds.size.height +70+conHigh, kScreenWidth-30, 30);
    _imageArrayView.frame = CGRectMake(0, _imageV.bounds.size.height +75+conHigh, kScreenWidth, headImgH+10);
    
    _shareButton.frame = CGRectMake(kScreenWidth-71-80, kScreenWidth*3/5+15, 80, 30);
}

+ (CGFloat)cellHigth:(NSString *)titleString imageArray:(NSArray *)array
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGFloat conHigh = [titleString boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    
    if (array&&array.count>0) {
        CGFloat imgW = (kScreenWidth - 100)/9;
      return (60+conHigh+kScreenWidth*3/5 +80-30+imgW+10-35);
    }else{
        return (60+conHigh+kScreenWidth*3/5 +80-30-35);
    }
    
    
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

- (void)memberList
{
    if ([_delegate respondsToSelector:@selector(cellwillClickImageView:)]) {
        [_delegate cellwillClickImageView:self];
    }
}

-(void)shareButton:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellShareImage:)]) {
        [_delegate cellShareImage:self];
    }
}


@end
