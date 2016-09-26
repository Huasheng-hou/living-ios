
//
//  FitDatePickerView.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/24.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitProtocols.h"

@interface FitDatePickerView : UIView

@property   (retain, nonatomic)     UIDatePicker    *datePicker;
@property   (retain, nonatomic)     UIView          *viewMask;

@property   (weak,   nonatomic)     id<FitDatePickerDelegate>   delegate;

@property   (retain, nonatomic)     NSDate          *minimumDate;
@property   (retain, nonatomic)     NSDate          *maximumDate;
@property   (retain, nonatomic)     NSDate          *currentDate;
@property   (assign, nonatomic)     UIDatePickerMode    mode;

+ (void)showWithMinimumDate:(NSDate *)minimumDate
                MaximumDate:(NSDate *)maximumDate
                CurrentDate:(NSDate *)currentDate
                       Mode:(UIDatePickerMode)mode
                   Delegate:(id<FitDatePickerDelegate>)delegate;

@end
