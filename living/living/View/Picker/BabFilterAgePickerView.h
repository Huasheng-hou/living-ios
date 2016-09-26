
//
//  BabFilterAgePickerView.h
//  Baby
//
//  Created by Huasheng on 16/2/2.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitProtocols.h"

@interface BabFilterAgePickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property   (retain, nonatomic)     UIPickerView    *pickerView;
@property   (retain, nonatomic)     UIView          *viewMask;

@property   (weak,   nonatomic)     id<FitPickerViewDelegate>   delegate;

@property   (retain, nonatomic)     NSArray         *data;
@property   (retain, nonatomic)     NSArray         *offSets;

+ (void)showWithData:(NSArray *)data Delegate:(id<FitPickerViewDelegate>)delegate OffSets:(NSArray *)offSets;

- (void)dismissSelf;

@end
