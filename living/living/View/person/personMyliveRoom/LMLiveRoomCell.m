//
//  LMLiveRoomCell.m
//  living
//
//  Created by JamHonyZ on 2016/11/2.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMLiveRoomCell.h"
#import "FitConsts.h"

@implementation LMLiveRoomCell


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
    //生活馆名称
    _roomName=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, kScreenWidth-30, 30)];
    [_roomName setText:@"我的生活馆"];
    [_roomName setFont:TEXT_FONT_LEVEL_2];
    [self addSubview:_roomName];
    
    //生活馆介绍
    _roomIntro=[[UITextView alloc]initWithFrame:CGRectMake(10, 30, kScreenWidth-20, 60)];
    [_roomIntro setText:@"他的借我号啥地方好速度发哈快速的防护见客户上的看法噶岁哦度奥是打飞机阿贾克斯的发哈可视电话发牢骚的拉伸地方还是爱上对方会拉丝的合法乐山大佛看我奥迪和说服力阿斯顿和覅拉伸到哈里斯的法海欧迪芬"];
    [_roomIntro setFont:TEXT_FONT_LEVEL_2];
   
    [_roomIntro setUserInteractionEnabled:NO];
    
    [self addSubview:_roomIntro];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_roomIntro.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _roomIntro.text.length)];
    _roomIntro.attributedText = attributedString;

     [_roomIntro setTextColor:TEXT_COLOR_LEVEL_3];
    
    //余额
    _balance=[[UILabel alloc]initWithFrame:CGRectMake(15, 100, 200, 30)];
    [_balance setText:@"余额￥1314"];
    [_balance setFont:[UIFont systemFontOfSize:20]];
    [_balance setTextColor:LIVING_REDCOLOR];
    [self addSubview:_balance];
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [label setText:@"立即充值"];
    [label setTextColor:[UIColor colorWithRed:0 green:142/255.0f blue:232/255.0f alpha:1.0f]];
    [label setFont:TEXT_FONT_LEVEL_2];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(60+3, 8, 14, 14)];
    [imageV setImage:[UIImage imageNamed:@"personRecharge"]];
    
    
    //充值按钮
    _payButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-100, 100, 80, 30)];
//    [_payButton setTitle:@"立即充值" forState:UIControlStateNormal];
    [_payButton setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
    [_payButton.layer setCornerRadius:5.0f];
    [_payButton.layer setBorderWidth:1.0f];
//    [_payButton.titleLabel setFont:TEXT_FONT_LEVEL_2];
    [_payButton.layer setBorderColor:[UIColor colorWithRed:0 green:142/255.0f blue:232/255.0f alpha:1.0f].CGColor];
    [_payButton.layer setMasksToBounds:YES];
    
    [_payButton addSubview:label];
    [_payButton addSubview:imageV];
    [self addSubview:_payButton];
    
    //分割线
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(15, 140, kScreenWidth-15, 0.5)];
    [line setBackgroundColor:LINE_COLOR];
    [self addSubview:line];
    
    //地图
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(15, 150, kScreenWidth-30, 160)];
    _mapView.mapType = MKMapTypeStandard;
    [_mapView setUserInteractionEnabled:NO];
    [self addSubview:_mapView];
    
    //设置中心坐标点
    CLLocationCoordinate2D curLocation;
    curLocation.latitude = 23.9098099;
    curLocation.longitude = 112.980980;
    
//    //设置地图跨度
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.008;
//    span.longitudeDelta = 0.008;
//    
//    //显示地图
//    MKCoordinateRegion region = {curLocation, span};
//    [self.mapView setRegion:region animated:NO];
//    
//    //点
//    MKPointAnnotation *annotation0 = [[MKPointAnnotation alloc] init];
//    [annotation0 setCoordinate:CLLocationCoordinate2DMake(23.9098099, 112.980980)];
//    [annotation0 setTitle:@"地址位置"];
//    //    [annotation0 setSubtitle:@"重庆市巴南区红光大道69号"];
//    [_mapView addAnnotation:annotation0];
    
    //地址显示
    _address=[[UILabel alloc]initWithFrame:CGRectMake(15, 310, kScreenWidth-30, 30)];
    [_address setText:@"这是地图显示地址安条路那个地区多少号"];
    [_address setTextColor:TEXT_COLOR_LEVEL_3];
    [_address setFont:TEXT_FONT_LEVEL_3];
    [self addSubview:_address];
}

-(void)setCellData:(LMLiveRoomLivingInfo *)info
{
//    名字
    _roomName.text=info.livingName;
//    描述
    _roomIntro.text=info.livingTitle;
//    余额
    _balance.text=[NSString stringWithFormat:@"余额%@",info.balance];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_balance.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
    
    [str addAttribute:NSFontAttributeName value:TEXT_FONT_LEVEL_2 range:NSMakeRange(0, 2)];
    _balance.attributedText = str;
    
//    地址
    _address.text=info.address;
}

@end
