//
//  LMhomePageCell.m
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMhomePageCell.h"
#import "UIImageView+WebCache.h"
#import "FitConsts.h"
#import "ImageHelpTool.h"

@interface LMhomePageCell ()

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *contentLabel;


@end

@implementation LMhomePageCell

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
    _imageV = [UIImageView new];
    _imageV.image = [UIImage imageNamed:@"112"];
    _imageV.backgroundColor = [UIColor lightGrayColor];
    
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    
    [self.contentView addSubview:_imageV];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:16.f];
    _titleLabel.textColor = TEXT_COLOR_LEVEL_1;
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines  = 2;
    _contentLabel.font = [UIFont systemFontOfSize:14.f];
    _contentLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_contentLabel];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:12.f];
    _nameLabel.textColor = LIVING_COLOR;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    _nameLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(articleNameClick)];
    
    [_nameLabel addGestureRecognizer:tap];
    
    
    
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12.f];
    _timeLabel.textColor = TEXT_COLOR_LEVEL_3;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 129.5, kScreenWidth-30, 0.5)];
    line.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:line];
    
    
}

-(void)setValue:(LMActicleList *)list
{
    LMActicleList *listData = list;
    
    _titleLabel.text = listData.articleTitle;
    _nameLabel.text = listData.articleName;
    _contentLabel.text = listData.articleContent;
    
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:listData.avatar] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    _timeLabel.text = [self getUTCFormateDate:listData.publishTime];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [_nameLabel sizeToFit];
    [_imageV sizeToFit];
    [_titleLabel sizeToFit];
    [_timeLabel sizeToFit];
    [_contentLabel sizeToFit];
    
    _imageV.frame = CGRectMake(15, 15, 120, 100);
    _titleLabel.frame = CGRectMake(145, 17, kScreenWidth-160, _titleLabel.bounds.size.height);
    
    _contentLabel.frame = CGRectMake(145, 20+_titleLabel.bounds.size.height, kScreenWidth-160, 50);
    
    
    _timeLabel.frame = CGRectMake(kScreenWidth-25-_timeLabel.bounds.size.width -_nameLabel.bounds.size.width, 95, _timeLabel.bounds.size.width, _timeLabel.bounds.size.height);
    
    _nameLabel.frame = CGRectMake(kScreenWidth-15-_nameLabel.bounds.size.width, 95, _nameLabel.bounds.size.width, _nameLabel.bounds.size.height);


    
}

-(void)articleNameClick
{
    NSLog(@"点击作者名字进入作者文章列表...");
    if ([_delegate respondsToSelector:@selector(cellWillClick:)]) {
        [_delegate cellWillClick:self];
    }
    
}




-(NSString *)getUTCFormateDate:(NSString *)newDate
{
    NSString *str=[newDate substringWithRange:NSMakeRange(0, 16)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *newsDateFormatted = [dateFormatter dateFromString:str];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"JST"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    int month=((int)time)/(3600*24*30);
    int day=((int)time)/(3600*24);
    int hour=((int)time)%(3600*24)/3600;
    int minute=((int)time)%(3600*24)/60;
    
    NSString *dateContent  = nil;
    
    if(month!=0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日"];
        
        NSString *str= [dateFormatter stringFromDate:newsDateFormatted];
        
        dateContent = str;
    }else if(day!=0){
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日"];
        
        NSString *str= [dateFormatter stringFromDate:newsDateFormatted];
        dateContent = str;
    }else if(hour!=0){
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",hour,@"小时前"];
    }else if(minute !=0){
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",minute,@"分钟前"];
        
    }else
    {
        dateContent =@"刚刚";
    }
    
    return dateContent;
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
