//
//  LMEventDetailMsgCell.h
//  living
//
//  Created by hxm on 2017/3/27.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMEventBodyVO.h"
#import <MapKit/MapKit.h>

@protocol  LMActivityMsgCellDelegate;

@interface LMEventDetailMsgCell : UITableViewCell
@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *addressLabel;//地址

@property(nonatomic,strong)MKMapView *mapView;

@property(nonatomic,strong) UIButton *mapButton;

@property(nonatomic)CGFloat  cellHight;

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;
@property (nonatomic, weak) id <LMActivityMsgCellDelegate> delegate;

-(void)setValue:(LMEventBodyVO *)event andLatitude:(NSString *)latitude andLongtitude:(NSString *)longtitude;

- (void)setXScale:(float)xScale yScale:(float)yScale;

@end


@protocol LMActivityMsgCellDelegate <NSObject>

@optional
- (void)cellWillreport:(LMEventDetailMsgCell *)cell;


@end
