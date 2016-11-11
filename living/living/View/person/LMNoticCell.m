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
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    _headImage.image = [UIImage imageNamed:@"settingIcon"];
    _headImage.clipsToBounds = YES;
    [self.contentView addSubview:_headImage];
    
    _typeLabel = [UILabel new];
    _typeLabel.font = TEXT_FONT_LEVEL_3;
    _typeLabel.textColor = TEXT_COLOR_LEVEL_3;
    _typeLabel.text = @"系统通知";
    [self.contentView addSubview:_typeLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = TEXT_FONT_LEVEL_3;
    _timeLabel.textColor = TEXT_COLOR_LEVEL_3;
    _timeLabel.text = @"2016.11.11 12:30:33";
    [self.contentView addSubview:_timeLabel];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = TEXT_FONT_LEVEL_2;
    _contentLabel.textColor = TEXT_COLOR_LEVEL_2;
    _contentLabel.text = @"这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容";
    [self.contentView addSubview:_contentLabel];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-4, 0, 4, 60)];
    leftView.backgroundColor = LIVING_COLOR;
    [self.contentView addSubview:leftView];
    
}


-(void)setData:(LMNoticVO *)list
{
    _contentLabel.text = list.content;
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    if (list.noticeTime && [list.noticeTime isKindOfClass:[NSDate class]]) {
        
        _timeLabel.text = [formatter stringFromDate:list.noticeTime];
    }
    
    NSLog(@"%@",list.userNick);
    
    if ([list.type isEqual:@"praise"]) {
        _typeLabel.text =[NSString stringWithFormat:@"%@赞了你",list.userNick];
        _headImage.image = [UIImage imageNamed:@"no-read"];
    }
    if ([list.type isEqual:@"adopted"]) {
        _typeLabel.text =[NSString stringWithFormat:@"%@回复你",list.userNick];
        _headImage.image = [UIImage imageNamed:@"no-read"];
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

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_typeLabel sizeToFit];
    [_timeLabel sizeToFit];
    [_contentLabel sizeToFit];
    
    _typeLabel.frame = CGRectMake(60, 12, _typeLabel.bounds.size.width,  _typeLabel.bounds.size.height);
    
    if (_INDEX==1) {
       _timeLabel.frame = CGRectMake(kScreenWidth-65-_timeLabel.bounds.size.width, 12, _timeLabel.bounds.size.width, _timeLabel.bounds.size.height);
    }else{
    _timeLabel.frame = CGRectMake(kScreenWidth-15-_timeLabel.bounds.size.width, 12, _timeLabel.bounds.size.width, _timeLabel.bounds.size.height);
    }

    _contentLabel.frame = CGRectMake(60, _timeLabel.bounds.size.height+12, kScreenWidth-75, 30);

    
    
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
