//
//  FitPickerThreeLevelView.h
//  apparel
//
//  Created by JamHonyZ on 16/9/20.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitProtocols.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface FitPickerThreeLevelView : UIView
<
UIPickerViewDataSource,
UIPickerViewDelegate
>
{
    UIPickerView *picker;
    
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
}
@property(nonatomic,strong) UIView   *viewMask;

@property   (weak,   nonatomic)     id<FitPickerViewDelegate>   delegate;

@end
