//
//  LMLiveRoomCell.h
//  living
//
//  Created by JamHonyZ on 2016/11/2.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "LMLivingInfoVO.h"

@interface LMLiveRoomCell : UITableViewCell

@property(nonatomic,strong)UILabel *roomName;

@property(nonatomic,strong)UILabel *roomIntro;

@property(nonatomic,strong)UILabel *balance;

@property(nonatomic,strong)UIButton *payButton;

@property(nonatomic,strong)UILabel *address;

@property(nonatomic,strong)MKMapView *mapView;

@property(nonatomic,strong)UIView *line;

@property(nonatomic)CGFloat dspHight;

-(void)setCellData:(LMLivingInfoVO *)info;


+ (CGFloat)cellHigth:(NSString *)titleString;

@end
