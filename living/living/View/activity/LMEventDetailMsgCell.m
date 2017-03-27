//
//  LMEventDetailMsgCell.m
//  living
//
//  Created by hxm on 2017/3/27.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMEventDetailMsgCell.h"
#import "FitConsts.h"
@interface LMEventDetailMsgCell () {
    float _xScale;
    float _yScale;
}
@property (nonatomic, strong) UIImageView *phoneV;
//@property (nonatomic, strong) UIImageView *timeV;
@property (nonatomic, strong) UIImageView *addressV;
@property (nonatomic, strong) UIImageView *freeV;


//@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *reportButton;

@end

@implementation LMEventDetailMsgCell

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
    
    _reportButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
    [_reportButton setTintColor:LIVING_COLOR];
    _reportButton.showsTouchWhenHighlighted = YES;
    _reportButton.frame = CGRectMake(kScreenWidth-70, 12, 60.f, 30.f);
    [_reportButton addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_reportButton];
    
    
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
    
    //    _timeV = [UIImageView new];
    //    _timeV.image = [UIImage imageNamed:@"timeV"];
    //    [self.contentView addSubview:_timeV];
    
    
    //    _timeLabel = [UILabel new];
    ////    _timeLabel.text = @"2016-10-1 12:20 —— 2016-12-03 13:00";
    //    _timeLabel.font = [UIFont systemFontOfSize:14.f];
    //    _timeLabel.textAlignment = NSTextAlignmentCenter;
    //    _timeLabel.textColor = TEXT_COLOR_LEVEL_2;
    //    [self.contentView addSubview:_timeLabel];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 170, kScreenWidth, 30)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:footView];
    
    //活动地址
    _addressV = [UIImageView new];
    _addressV.image = [UIImage imageNamed:@"addressV"];
    [self.contentView addSubview:_addressV];
    
    
    _addressLabel = [UILabel new];
    _addressLabel.numberOfLines = 0;
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    _addressLabel.font = [UIFont systemFontOfSize:13.f];
    [_addressLabel setUserInteractionEnabled:YES];
    _addressLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_addressLabel];
    
    //分割线
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 175, kScreenWidth, 5)];
    [view setBackgroundColor:BG_GRAY_COLOR];
    [self addSubview:view];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(15, 185, kScreenWidth-30, 160)];
    _mapView.mapType = MKMapTypeStandard;
    [self.contentView addSubview:_mapView];
    
    _mapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight-30, 160)];
    [_mapView addSubview:_mapButton];
    
}

-(void)setValue:(LMEventBodyVO *)event andLatitude:(NSString *)latitude andLongtitude:(NSString *)longtitude
{
    _addressLabel.text = event.address;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    _cellHight = [_addressLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-59, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    
    
    //    if (event.startTime == nil) {
    //        _timeLabel.text = @"";
    //    }else{
    //        NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    //        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //
    //        NSString *start = [formatter stringFromDate:event.startTime];
    //        NSString *end = [formatter stringFromDate:event.endTime];
    //
    //      _timeLabel.text = [NSString stringWithFormat:@"%@ —— %@",start,end];
    //    }
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
    
    if (!event.latitude||[event.latitude isEqual:@""] ||[event.latitude intValue] ==0) {
        
        [self.mapView setHidden:YES];
    }else{
        
        //设置中心坐标点
        CLLocationCoordinate2D curLocation;
        curLocation.latitude = [latitude floatValue];
        curLocation.longitude = [longtitude floatValue];
        
        //设置地图跨度
        MKCoordinateSpan span;
        span.latitudeDelta = 0.008;
        span.longitudeDelta = 0.008;
        
        //显示地图
        MKCoordinateRegion region = {curLocation, span};
        [self.mapView setRegion:region animated:NO];
        
        //点
        MKPointAnnotation *annotation0 = [[MKPointAnnotation alloc] init];
        [annotation0 setCoordinate:CLLocationCoordinate2DMake(curLocation.latitude, curLocation.longitude)];
        [annotation0 setTitle:event.address];
        [_mapView addAnnotation:annotation0];
        
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(curLocation.latitude, curLocation.longitude)];
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
    //[_timeV sizeToFit];
    [_addressV sizeToFit];
    [_freeV sizeToFit];
    
    //[_timeLabel sizeToFit];
    [_numberLabel sizeToFit];
    [_priceLabel sizeToFit];
    [_addressLabel sizeToFit];
    
    _phoneV.frame = CGRectMake(15, 15, 24, 24); //y间距39
    //_timeV.frame = CGRectMake(15, 54, 24, 24);
    _freeV.frame = CGRectMake(15, 93-39, 24, 24);
    _addressV.frame = CGRectMake(15, 132-39, 24, 24);
    
    _numberLabel.frame = CGRectMake(44, 12, _numberLabel.bounds.size.width, 30);
    //_timeLabel.frame = CGRectMake(44, 49+0.5, _timeLabel.bounds.size.width, 30);
    _priceLabel.frame = CGRectMake(44, 49, _priceLabel.bounds.size.width, 30); //y 90
    _addressLabel.frame = CGRectMake(44, 97, kScreenWidth-59, _cellHight);  //y 136
}


- (void)reportAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillreport:)]) {
        [_delegate cellWillreport:self];
    }
    
}



@end
