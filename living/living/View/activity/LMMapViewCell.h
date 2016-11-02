//
//  LMMapViewCell.h
//  living
//
//  Created by JamHonyZ on 2016/11/1.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LMMapViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *tipLabel;

@property(nonatomic,strong)MKMapView *mapView;

@end
