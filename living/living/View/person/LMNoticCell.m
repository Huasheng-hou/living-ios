//
//  LMNoticCell.m
//  living
//
//  Created by Ding on 16/10/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMNoticCell.h"
#import "FitConsts.h"
#import "UIView+frame.h"

@interface LMNoticCell (){
    float _xScale;
    float _yScale;
}

@property(nonatomic,retain)UIImageView *headImage;

@property(nonatomic,retain)UILabel *timeLabel;

@property(nonatomic,retain)UILabel *typeLabel;

@property(nonatomic,retain)UILabel *contentLabel;

@property(nonatomic,retain)UILabel *titleLabel;

@property(nonatomic,retain)UIView *whiteView;

@end


@implementation LMNoticCell


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
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 50, 40, 40)];
    _headImage.layer.cornerRadius = 20;
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    _headImage.clipsToBounds = YES;
    
    [self.contentView addSubview:_headImage];
    
    _whiteView = [UIView new];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 3;
    _whiteView.contentMode = UIViewContentModeScaleAspectFill;
    _whiteView.clipsToBounds = YES;
    [self.contentView addSubview:_whiteView];
    
    _typeLabel = [UILabel new];
    _typeLabel.font = TEXT_FONT_LEVEL_2;
    _typeLabel.textColor = TEXT_COLOR_LEVEL_1;
    [_whiteView addSubview:_typeLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = TEXT_FONT_LEVEL_3;
    _timeLabel.textColor = TEXT_COLOR_LEVEL_3;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = TEXT_FONT_LEVEL_2;
    _titleLabel.textColor = TEXT_COLOR_LEVEL_1;
    [_whiteView addSubview:_titleLabel];
    
    
    _contentLabel = [UILabel new];
    _contentLabel.font = TEXT_FONT_LEVEL_2;
    _contentLabel.textColor = TEXT_COLOR_LEVEL_2;
    [_whiteView addSubview:_contentLabel];
    

}


-(void)setData:(LMNoticVO *)list
{
    
    if (list.sign &&[list.sign isEqual:@"article"]) {
        if (list.articleTitle&&![list.articleTitle isEqual:@""]) {
            _titleLabel.text = [NSString stringWithFormat:@"文章:%@",list.articleTitle];
        }else{
            _titleLabel.text = [NSString stringWithFormat:@"文章:"];
        }
    }
    if (list.sign &&[list.sign isEqual:@"event"]) {
        if (list.eventName&&![list.eventName isEqual:@""]) {
            _titleLabel.text = [NSString stringWithFormat:@"活动:%@",list.eventName];
        }else{
            _titleLabel.text = [NSString stringWithFormat:@"活动:"];
        }
    }
    
    if (list.sign &&[list.sign isEqual:@"voice"]) {
        if (list.voiceTitle&&![list.voiceTitle isEqual:@""]) {
            _titleLabel.text = [NSString stringWithFormat:@"课程:%@",list.voiceTitle];
        }else{
            _titleLabel.text = [NSString stringWithFormat:@"课程:"];
        }
    }

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0,3)];
    [str addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_LEVEL_1 range:NSMakeRange(3,str.length-3)];
    _titleLabel.attributedText = str;
    
    _contentLabel.text = list.content;
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yy-MM-dd HH:mm"];
    
    if (list.noticeTime && [list.noticeTime isKindOfClass:[NSDate class]]) {
        
        _timeLabel.text = [formatter stringFromDate:list.noticeTime];
    }
    
    if ([list.type isEqual:@"praise"]) {
        _headImage.image = [UIImage imageNamed:@"no-read"];
        if (list.userNick ==nil||[list.userNick isEqual:@""]) {
           _typeLabel.text =@"匿名访客觉得很赞";
        }else{
            _typeLabel.text =[NSString stringWithFormat:@"%@觉得很赞",list.userNick];
        }

    }
    if ([list.type isEqual:@"adopted"]) {
        _headImage.image = [UIImage imageNamed:@"no-read"];
        if (list.userNick ==nil||[list.userNick isEqual:@""]) {
            _typeLabel.text =@"匿名访客回复:";
        }else{
        _typeLabel.text =[NSString stringWithFormat:@"%@回复:",list.userNick];
        }
    }
    
    if ([list.type isEqual:@"comment"]) {
        if (list.userNick ==nil||[list.userNick isEqual:@""]) {
            _typeLabel.text =@"匿名访客评论:";
        }else{
            _typeLabel.text =[NSString stringWithFormat:@"%@评论:",list.userNick];
            _headImage.image = [UIImage imageNamed:@"no-read"];
        }
    }
    
    if ([list.type isEqual:@"system"]) {
        _typeLabel.text =[NSString stringWithFormat:@"系统消息"];
        _headImage.image = [UIImage imageNamed:@"settingIcon"];
    }
}

- (void)setXScale:(float)xScale yScale:(float)yScale
{
    _xScale = xScale;
    _yScale = yScale;
}


+ (CGFloat)cellHigth:(NSString *)titleString
{
    NSDictionary *attributes    = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    CGFloat conHigh = [titleString boundingRectWithSize:CGSizeMake(kScreenWidth-70, 100000)
                                                options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:attributes
                                                context:nil].size.height;
    
    return (75 + conHigh + 18 + 0.5);
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    [_typeLabel sizeToFit];
    [_timeLabel sizeToFit];
    [_contentLabel sizeToFit];
    [_titleLabel sizeToFit];
    [_whiteView sizeToFit];
    _whiteView.frame = CGRectMake(70, 50, kScreenWidth-140, 30 + _titleLabel.bounds.size.height+20);
    _timeLabel.frame = CGRectMake(0, 20, kScreenWidth, _timeLabel.bounds.size.height);
    _typeLabel.frame = CGRectMake(5, 5, _typeLabel.bounds.size.width,  30);
    
    if (_INDEX==1) {
        
        _titleLabel.frame = CGRectMake(5, 5, 35+_timeLabel.bounds.size.width, _titleLabel.bounds.size.height);
    }else{
       
        _titleLabel.frame = CGRectMake(5, 5, 85+_timeLabel.bounds.size.width, _titleLabel.bounds.size.height);
    }
    

    _typeLabel.frame = CGRectMake(5, 5+_titleLabel.bounds.size.height, _typeLabel.bounds.size.width,  30);
    _contentLabel.frame = CGRectMake(5+_typeLabel.bounds.size.width, 5+_titleLabel.bounds.size.height, kScreenWidth-140-_typeLabel.bounds.size.width, 30);

    
    
}


@end
