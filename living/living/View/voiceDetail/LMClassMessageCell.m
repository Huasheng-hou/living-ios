//
//  LMClassMessageCell.m
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMClassMessageCell.h"
#import "FitConsts.h"

@interface LMClassMessageCell () {
    float _xScale;
    float _yScale;
}

@property (nonatomic, strong) UIImageView *phoneV;
@property (nonatomic, strong) UIImageView *timeV;
@property (nonatomic, strong) UIImageView *freeV;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *reportButton;

@end

@implementation LMClassMessageCell

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
    
    //号码
    _phoneV = [UIImageView new];
    _phoneV.image = [UIImage imageNamed:@"phoneV"];
    [self.contentView addSubview:_phoneV];
    
//    _reportButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
//    [_reportButton setTintColor:LIVING_COLOR];
//    _reportButton.showsTouchWhenHighlighted = YES;
//    _reportButton.frame = CGRectMake(kScreenWidth-70, 12, 60.f, 30.f);
//    [_reportButton addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_reportButton];
    
    
    _numberLabel = [UILabel new];
    _numberLabel.font = [UIFont systemFontOfSize:14.f];
    [_numberLabel setUserInteractionEnabled:YES];
    _numberLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_numberLabel];
    
    //价格
    
    _freeV = [UIImageView new];
    _freeV.image = [UIImage imageNamed:@"freeV"];
    [self.contentView addSubview:_freeV];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:14.f];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_priceLabel];
    
    //活动时间
    
    _timeV = [UIImageView new];
    _timeV.image = [UIImage imageNamed:@"timeV"];
    [self.contentView addSubview:_timeV];
    
    
    _timeLabel = [UILabel new];
    //    _timeLabel.text = @"2016-10-1 12:20 —— 2016-12-03 13:00";
    _timeLabel.font = [UIFont systemFontOfSize:14.f];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_timeLabel];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 170, kScreenWidth, 30)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:footView];
    
    //分割线
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 175, kScreenWidth, 5)];
    [view setBackgroundColor:BG_GRAY_COLOR];
    [self addSubview:view];

    
}

-(void)setValue:(LMVoiceDetailVO *)event
{

    if (event.startTime == nil) {
        _timeLabel.text = @"";
    }else{
        NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSString *start = [formatter stringFromDate:event.startTime];
        NSString *end = [formatter stringFromDate:event.endTime];
        
        _timeLabel.text = [NSString stringWithFormat:@"%@ —— %@",start,end];
    }
    if (event.contactPhone == nil) {
        _numberLabel.text = @"";
    }else{
        _numberLabel.text = [NSString stringWithFormat:@"%@(%@)",event.contactPhone,event.contactName];
    }
    if (event.perCost == nil) {
        _priceLabel.text = @"";
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"人均费用 %@ 元",event.perCost];
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
    [_phoneV sizeToFit];
    [_timeV sizeToFit];
    [_freeV sizeToFit];
    
    [_timeLabel sizeToFit];
    [_numberLabel sizeToFit];
    [_priceLabel sizeToFit];
    
    _phoneV.frame = CGRectMake(15, 15, 24, 24);
    _timeV.frame = CGRectMake(15, 54, 24, 24);
    _freeV.frame = CGRectMake(15, 93, 24, 24);
    
    
    _numberLabel.frame = CGRectMake(44, 12, _numberLabel.bounds.size.width, 30);
    _timeLabel.frame = CGRectMake(44, 49+0.5, _timeLabel.bounds.size.width, 30);
    
    _priceLabel.frame = CGRectMake(44, 90, _priceLabel.bounds.size.width, 30);
}


- (void)reportAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillreport:)]) {
        [_delegate cellWillreport:self];
    }
    
}

@end
