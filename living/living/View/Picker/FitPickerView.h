
//
//  FitPickerView.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/24.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitProtocols.h"

@interface FitPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property   (retain, nonatomic)     UIPickerView    *pickerView;
@property   (retain, nonatomic)     UIView          *viewMask;

@property   (weak,   nonatomic)     id<FitPickerViewDelegate>   delegate;

@property   (retain, nonatomic)     NSArray         *data;
@property   (retain, nonatomic)     NSArray         *offSets;

+ (void)showWithData:(NSArray *)data Delegate:(id<FitPickerViewDelegate>)delegate OffSets:(NSArray *)offSets;

- (void)dismissSelf;

@end
