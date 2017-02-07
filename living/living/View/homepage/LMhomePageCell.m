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

@property (nonatomic, strong) UIView *typeView;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) UIImageView *VImage;
@property (nonatomic, assign) NSInteger VIndex;


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
    _imageV.backgroundColor = BG_GRAY_COLOR;
    
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    
    [self.contentView addSubview:_imageV];
    
    _titleLabel = [UILabel new];
    
    _titleLabel.font            = [UIFont systemFontOfSize:14.f];
    _titleLabel.numberOfLines   = 2;
    _titleLabel.textColor       = TEXT_COLOR_LEVEL_1;
    
    [self.contentView addSubview:_titleLabel];
    _titleLabel.userInteractionEnabled = YES;
    
    _typeView = [UIView new];
    _typeView.backgroundColor = [UIColor clearColor];
    [_titleLabel addSubview:_typeView];
    
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(articletitleClick)];
    
    [_typeView addGestureRecognizer:tap2];
    
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines  = 2;
    _contentLabel.font = [UIFont systemFontOfSize:12.f];
    _contentLabel.textColor = TEXT_COLOR_LEVEL_3;
    [self.contentView addSubview:_contentLabel];
    
    _nameLabel = [UILabel new];
    
    _nameLabel.font             = [UIFont systemFontOfSize:10.f];
    _nameLabel.textColor        = LIVING_COLOR;
    _nameLabel.textAlignment    = NSTextAlignmentCenter;
    _nameLabel.numberOfLines    = 1;
    
    [self.contentView addSubview:_nameLabel];
    
    _nameLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(articleNameClick)];
    
    [_nameLabel addGestureRecognizer:tap];
    
    _timeLabel = [UILabel new];
    _timeLabel.font             = [UIFont systemFontOfSize:10.f];
    _timeLabel.textColor        = TEXT_COLOR_LEVEL_3;
    _timeLabel.textAlignment    = NSTextAlignmentCenter;
    _timeLabel.numberOfLines    = 1;
    
    [self.contentView addSubview:_timeLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 129.5, kScreenWidth - 30, 0.5)];
    line.backgroundColor = LINE_COLOR;
    
    [self.contentView addSubview:line];
    
    _VImage = [UIImageView new];
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    [self.contentView addSubview:_VImage];
    
}

- (void)setValue:(LMActicleVO *)list
{
    _nameLabel.text = list.articleName;
    
    if ([list.group isEqualToString:@"voice"]) {
        NSString *contentString = list.articleContent;
        NSData *respData = [contentString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization
                                  JSONObjectWithData:respData
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        
        NSMutableArray *contentArray = [NSMutableArray new];
        NSMutableArray *contarray = [NSMutableArray new];
        contentArray = [respDict objectForKey:@"content"];
        for (NSDictionary *dic in contentArray) {
            NSString *role;
            
            if ([dic[@"role"] isEqualToString:@"teacher"]) {
                role = @"讲师";
            }
            if ([dic[@"role"] isEqualToString:@"host"]) {
                role = @"主持人";
            }
            
            NSString *content = dic[@"content"];
            if (role!= nil&&content!=nil) {
                NSString *con = [NSString stringWithFormat:@"%@：%@\n",role,content];
                [contarray addObject:con];
            }
        }
        NSString *conStr;
        for (int i = 0; i<contarray.count; i++) {
            if (i<1) {
                conStr = contarray[0];
            }else{
              conStr = [NSString stringWithFormat:@"%@%@",conStr,contarray[i]];
            }
        }
        
        _contentLabel.text = conStr;
        
        
    }else{
       _contentLabel.text = list.articleContent;
    }
    
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:list.avatar] placeholderImage:[UIImage imageNamed:@"BackImage"]];
    _timeLabel.text = [self getUTCFormateDate:list.publishTime];
    
    if (list.type&&![list.type isEqual:@""]) {
        
        _titleLabel.text = [NSString stringWithFormat:@"#%@#%@",list.type,list.articleTitle];
        
        NSInteger lenth = list.type.length;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0, lenth + 2)];
     
        _titleLabel.attributedText = str;
        _titleLabel.userInteractionEnabled  = YES;
        
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]};
        CGSize size=[[NSString stringWithFormat:@"#%@#",list.type] sizeWithAttributes:attrs];
        _width = size.width;
        
        
    } else {
        
        _titleLabel.text = list.articleTitle;
        _titleLabel.userInteractionEnabled = NO;
    }
    _VIndex = 2;
    
    if (list.franchisee&&[list.franchisee isEqualToString:@"yes"]) {
        _VIndex = 1;
        _VImage.image = [UIImage imageNamed:@"BigVRed"];

    }
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_nameLabel sizeToFit];
    [_imageV sizeToFit];
    [_titleLabel sizeToFit];
    [_timeLabel sizeToFit];
    [_contentLabel sizeToFit];
    [_typeView sizeToFit];
    [_VImage sizeToFit];
    
    _imageV.frame = CGRectMake(15, 15, 120, 100);
    _titleLabel.frame = CGRectMake(145, 17, kScreenWidth-160, _titleLabel.bounds.size.height);
    
    _contentLabel.frame = CGRectMake(145, 20 + _titleLabel.bounds.size.height, kScreenWidth-160, 50);
    
    
//    if (kScreenWidth - 30 - 10 - 10 - _timeLabel.frame.size.width - _nameLabel.frame.size.width < 0) {
//        
//        _nameLabel.frame = CGRectMake(_nameLabel.frame.origin.x, 95, kScreenWidth - 30 - 10 - 10 - _timeLabel.frame.size.width, _nameLabel.frame.size.height+20);
//    }else{
    _nameLabel.frame = CGRectMake(kScreenWidth-15-_nameLabel.bounds.size.width, 95, _nameLabel.bounds.size.width, _nameLabel.bounds.size.height+20);
//    }

    _typeView.frame = CGRectMake(-5, -5, _width+10, _titleLabel.bounds.size.height+10);
    
    if (_VIndex == 1) {
        _VImage.hidden = NO;
        _timeLabel.frame = CGRectMake(kScreenWidth-25-_timeLabel.bounds.size.width -_nameLabel.bounds.size.width-20, 105, _timeLabel.bounds.size.width, _timeLabel.bounds.size.height);
        _VImage.frame = CGRectMake(kScreenWidth-25-_nameLabel.bounds.size.width-10, 105+(_timeLabel.bounds.size.height-14)/2, 14, 14);

    }else{
        _timeLabel.frame = CGRectMake(kScreenWidth-25-_timeLabel.bounds.size.width -_nameLabel.bounds.size.width, 105, _timeLabel.bounds.size.width, _timeLabel.bounds.size.height);
        _VImage.hidden = YES;
    }
    



}

- (void)articleNameClick
{
    if ([_delegate respondsToSelector:@selector(cellWillClick:)]) {
     
        [_delegate cellWillClick:self];
    }
}

- (void)articletitleClick
{
    if ([_delegate respondsToSelector:@selector(TitlewillClick:)]) {
        [_delegate TitlewillClick:self];
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
