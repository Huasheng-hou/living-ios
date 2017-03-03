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

@property (nonatomic, strong) UIImageView *videoImage;

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
    
    _videoImage = [UIImageView new];
    _videoImage.backgroundColor = BG_GRAY_COLOR;
    _videoImage.contentMode = UIViewContentModeScaleAspectFill;
    [_videoImage setClipsToBounds:YES];
    _videoImage.userInteractionEnabled = YES;
    
    [self.contentView addSubview:_videoImage];
    UITapGestureRecognizer *tapVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickVideo:)];
    [_videoImage addGestureRecognizer:tapVideo];
    
    
    
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
    [_videoImage sd_setImageWithURL:[NSURL URLWithString:list.coverUrl]];

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

    
    if (list.coverWidth&&list.coverHeight) {
        _videoWidth = list.coverWidth;
        _videoHeight = list.coverHeight;
        UIImageView *playView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-21, (_videoHeight*(kScreenWidth-30)/_videoWidth)/2-21, 42, 42)];
        playView.image = [UIImage imageNamed:@"playIcon"];
        playView.userInteractionEnabled = YES;
        [_videoImage addSubview:playView];
    }else{
        _videoWidth = 0;
        _videoHeight = 0;
    }

    
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
    if (_videoWidth!=0) {
        _videoImage.frame = CGRectMake(15, 30+_conHigh+_headImage.bounds.size.height, kScreenWidth-30, _videoHeight*(kScreenWidth-30)/_videoWidth);
    }

    _contentLabel.frame = CGRectMake(15, 40+_headImage.bounds.size.height +_conHigh+_videoImage.bounds.size.height, kScreenWidth-30, _dspHigh);

}

-(void)clickImage:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellProjectImage:)]) {
        [_delegate cellProjectImage:self];
    }
}

-(void)clickVideo:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellProjectVideo:)]) {
        [_delegate cellProjectVideo:self];
    }
}


@end
