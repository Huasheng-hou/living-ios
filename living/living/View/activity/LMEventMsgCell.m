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
    _headImage.backgroundColor = BG_GRAY_COLOR;
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    [_headImage setClipsToBounds:YES];
    _headImage.userInteractionEnabled = YES;
    
    [self.contentView addSubview:_headImage];
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [_headImage addGestureRecognizer:tapImage];
    
    
    
    //标题
    
    _dspLabel = [UILabel new];
    _dspLabel.font = TEXT_FONT_LEVEL_2;
    _dspLabel.textColor = LIVING_COLOR;
    _dspLabel.numberOfLines=0;
    [self.contentView addSubview:_dspLabel];
    
    
    
    //活动内容
    _contentLabel = [UILabel new];
    _contentLabel.font = TEXT_FONT_LEVEL_2;
    _contentLabel.textColor = TEXT_COLOR_LEVEL_3;
    _contentLabel.numberOfLines=0;
    [self.contentView addSubview:_contentLabel];
}

-(void)setValue:(LMProjectBodyVO *)list
{

    _dspLabel.text = list.projectTitle;
    _contentLabel.text = list.projectDsp;

    [_headImage sd_setImageWithURL:[NSURL URLWithString:list.projectImgs]];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    if (_contentLabel.text!=nil) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_contentLabel.text];
        
        [paragraphStyle setLineSpacing:7];
        [paragraphStyle setParagraphSpacing:10];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _contentLabel.text.length)];
        _contentLabel.attributedText = attributedString;
    }

    
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paragraphStyle};
    NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
     _conHigh = [_dspLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height;
    
    _dspHigh = [_contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    
    _imageWidth = list.width;
    _imageHeight = list.height;
    
}

+ (CGFloat)cellHigth:(NSString *)titleString
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    if (titleString!=nil) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:titleString];
        
        [paragraphStyle setLineSpacing:7];
        [paragraphStyle setParagraphSpacing:10];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, titleString.length)];
    }
    
    
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paragraphStyle};
    CGFloat  dspHigh = [titleString boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;

    return dspHigh;
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
 
    _headImage.frame = CGRectMake(15, 20+_conHigh, kScreenWidth-30, 0);
    if (_index==1) {
        _headImage.frame = CGRectMake(15, 20+_conHigh, kScreenWidth-30, 0);
    }else{
       _headImage.frame = CGRectMake(15, 20+_conHigh, kScreenWidth-30, _imageHeight*(kScreenWidth-30)/_imageWidth);
    }

    _contentLabel.frame = CGRectMake(15, 30+_headImage.bounds.size.height +_conHigh, kScreenWidth-30, _dspHigh);

}

-(void)clickImage:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellProjectImage:)]) {
        [_delegate cellProjectImage:self];
    }
}


@end
