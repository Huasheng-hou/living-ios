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
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    _headImage.image = [UIImage imageNamed:@"settingIcon"];
    _headImage.clipsToBounds = YES;
    [self.contentView addSubview:_headImage];
    
    _typeLabel = [UILabel new];
    _typeLabel.font = TEXT_FONT_LEVEL_2;
    _typeLabel.textColor = TEXT_COLOR_LEVEL_2;
    _typeLabel.text = @"系统通知";
    [self.contentView addSubview:_typeLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = TEXT_FONT_LEVEL_3;
    _timeLabel.textColor = TEXT_COLOR_LEVEL_3;
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = TEXT_FONT_LEVEL_2;
    _titleLabel.textColor = TEXT_COLOR_LEVEL_1;
    [self.contentView addSubview:_titleLabel];
    
    
    _contentLabel = [UILabel new];
    _contentLabel.font = TEXT_FONT_LEVEL_2;
    _contentLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_contentLabel];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-4, 0, 4, 70)];
    leftView.backgroundColor = LIVING_COLOR;
    [self.contentView addSubview:leftView];
    
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
        if (list.articleTitle&&![list.articleTitle isEqual:@""]) {
            _titleLabel.text = [NSString stringWithFormat:@"活动:%@",list.eventName];
        }else{
            _titleLabel.text = [NSString stringWithFormat:@"活动:"];
        }
    }
    
    _contentLabel.text = list.content;
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    if (list.noticeTime && [list.noticeTime isKindOfClass:[NSDate class]]) {
        
        _timeLabel.text = [formatter stringFromDate:list.noticeTime];
    }
    
    if ([list.type isEqual:@"praise"]) {
        if (list.userNick ==nil||[list.userNick isEqual:@""]) {
           _typeLabel.text =@"匿名访客赞了你:";
        }else{
            _typeLabel.text =[NSString stringWithFormat:@"%@赞了你:",list.userNick];
            _headImage.image = [UIImage imageNamed:@"no-read"];
        }

    }
    if ([list.type isEqual:@"adopted"]) {
        if (list.userNick ==nil||[list.userNick isEqual:@""]) {
            _typeLabel.text =@"匿名访客回复你:";
        }else{
        _typeLabel.text =[NSString stringWithFormat:@"%@回复你:",list.userNick];
        _headImage.image = [UIImage imageNamed:@"no-read"];
        }
    }
    if ([list.type isEqual:@"system"]) {
        _typeLabel.text =[NSString stringWithFormat:@"系统消息:"];
        _headImage.image = [UIImage imageNamed:@"settingIcon"];
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
    [_typeLabel sizeToFit];
    [_timeLabel sizeToFit];
    [_contentLabel sizeToFit];
    [_titleLabel sizeToFit];
    
    _typeLabel.frame = CGRectMake(70, _timeLabel.bounds.size.height+15, _typeLabel.bounds.size.width,  30);
    
    if (_INDEX==1) {
       _timeLabel.frame = CGRectMake(kScreenWidth-65-_timeLabel.bounds.size.width, 12, _timeLabel.bounds.size.width, _timeLabel.bounds.size.height);
        _titleLabel.frame = CGRectMake(70, 12, 35+_timeLabel.bounds.size.width, _titleLabel.bounds.size.height);
    }else{
       _timeLabel.frame = CGRectMake(kScreenWidth-15-_timeLabel.bounds.size.width, 12, _timeLabel.bounds.size.width, _timeLabel.bounds.size.height);
        _titleLabel.frame = CGRectMake(70, 12, 85+_timeLabel.bounds.size.width, _titleLabel.bounds.size.height);
    }
    

    _contentLabel.frame = CGRectMake(70+_typeLabel.bounds.size.width, _timeLabel.bounds.size.height+15, kScreenWidth-85-_typeLabel.bounds.size.width, 30);

    
    
}


@end
