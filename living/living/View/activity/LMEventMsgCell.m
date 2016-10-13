//
//  LMEventMsgCell.m
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMEventMsgCell.h"
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
    _headImage.image = [UIImage imageNamed:@"112"];
//    headImage.frame = CGRectMake(15, 20+conHigh, kScreenWidth-30, 210);
    [_headImage setClipsToBounds:YES];
    _headImage.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_headImage];
    
    
    
    //标题
    
    _dspLabel = [UILabel new];
    _dspLabel.font = TEXT_FONT_LEVEL_2;
    _dspLabel.textColor = TEXT_COLOR_LEVEL_2;
    _dspLabel.numberOfLines=0;
    _dspLabel.text = @"这这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    CGFloat conHigh = [_dspLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    [_dspLabel sizeToFit];
    _dspLabel.frame = CGRectMake(15, 10, kScreenWidth-30, conHigh);
    [self.contentView addSubview:_dspLabel];
    
    
    
    //活动时间
    
    _contentLabel = [UILabel new];
    _contentLabel.font = TEXT_FONT_LEVEL_2;
    _contentLabel.textColor = TEXT_COLOR_LEVEL_3;
    _contentLabel.numberOfLines=0;
    _contentLabel.text = @"这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文这是正文";
    NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    CGFloat conHighs = [_contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height;
    [_contentLabel sizeToFit];
    _contentLabel.frame = CGRectMake(15, 30+_headImage.bounds.size.height +conHigh, kScreenWidth-30, conHighs);
    [self.contentView addSubview:_contentLabel];
    
    
    
}

-(void)setValue:(LMEventDetailLeavingMessages *)data
{
    
}

+ (CGFloat)cellHigth:(NSString *)titleString
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGFloat conHigh = [titleString boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    return (75+conHigh+20);
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

    

}


@end
