//
//  LMMapViewCell.m
//  living
//
//  Created by JamHonyZ on 2016/11/1.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMapViewCell.h"
#import "FitConsts.h"

@implementation LMMapViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    [view setBackgroundColor:[UIColor greenColor]];
    [self addSubview:view];
    
//    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 150)];
//     _mapView.mapType = MKMapTypeStandard;
////    _mapView.showsUserLocation = YES;
//    [view addSubview:_mapView];
    
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 150, kScreenWidth-30, 30)];
    [label setText:@"这是地图显示地址"];
    [label setTextColor:TEXT_COLOR_LEVEL_3];
    [label setFont:TEXT_FONT_LEVEL_2];
    [view addSubview:label];
}
@end
