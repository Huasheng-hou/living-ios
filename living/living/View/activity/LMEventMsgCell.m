//
//  LMEventMsgCell.m
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMEventMsgCell.h"
#import "UIImageView+WebCache.h"
#import "FitConsts.h"

@interface LMEventMsgCell () {
    float _xScale;
    float _yScale;
}

@property (nonatomic, strong) UIImageView *headImage;


@property (nonatomic, strong) UILabel *dspLabel;

@property (nonatomic, strong) UILabel *contentLabel;


@end

@implementation LMEventMsgCell

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
    
    //图片
    
    _headImage = [UIImageView new];
    [_headImage setClipsToBounds:YES];
    _headImage.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_headImage];
    
    
    
    //标题
    
    _dspLabel = [UILabel new];
    _dspLabel.font = TEXT_FONT_LEVEL_2;
    _dspLabel.textColor = TEXT_COLOR_LEVEL_2;
    _dspLabel.numberOfLines=0;

    [_dspLabel sizeToFit];
    
    [self.contentView addSubview:_dspLabel];
    
    
    
    //活动时间
    
    _contentLabel = [UILabel new];
    _contentLabel.font = TEXT_FONT_LEVEL_2;
    _contentLabel.textColor = TEXT_COLOR_LEVEL_3;
    _contentLabel.numberOfLines=0;

    [self.contentView addSubview:_contentLabel];
    
    
    
}

-(void)setValue:(LMEventDetailEventProjectsBody *)data
{
    LMEventDetailEventProjectsBody *list = data;
    _dspLabel.text = list.projectTitle;
    _contentLabel.text = list.projectDsp;

    [_headImage sd_setImageWithURL:[NSURL URLWithString:list.projectImgs]];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
     _conHigh = [_dspLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    
    _dspHigh = [_contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    
}



- (void)setXScale:(float)xScale yScale:(float)yScale
{
    _xScale = xScale;
    _yScale = yScale;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_headImage sizeToFit];
    [_dspLabel sizeToFit];
    [_contentLabel sizeToFit];

    _dspLabel.frame = CGRectMake(15, 10, kScreenWidth-30, _conHigh);
    _headImage.frame = CGRectMake(15, 20+_conHigh, kScreenWidth-30, 210);
    _contentLabel.frame = CGRectMake(15, 30+_headImage.bounds.size.height +_conHigh, kScreenWidth-30, _dspHigh);

}


@end
