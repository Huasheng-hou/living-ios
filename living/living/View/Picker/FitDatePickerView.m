//
//  FitDatePickerView.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/24.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitDatePickerView.h"
#import "FitConsts.h"



@implementation FitDatePickerView

+ (void)showWithMinimumDate:(NSDate *)minimumDate MaximumDate:(NSDate *)maximumDate CurrentDate:(NSDate *)currentDate Mode:(UIDatePickerMode)mode Delegate:(id<FitDatePickerDelegate>)delegate
{
    FitDatePickerView   *datePicker = [[FitDatePickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 260)];
    UIView              *viewMask   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    viewMask.backgroundColor    = [UIColor blackColor];
    viewMask.alpha              = 0;
    
    UITapGestureRecognizer  *tapGR  = [[UITapGestureRecognizer alloc] initWithTarget:datePicker action:@selector(dismissSelf)];
    [viewMask addGestureRecognizer:tapGR];
    
    datePicker.viewMask = viewMask;
    
    datePicker.minimumDate  = minimumDate;
    datePicker.maximumDate  = maximumDate;
    datePicker.currentDate  = currentDate;
    datePicker.mode         = mode;
    datePicker.delegate     = delegate;
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:viewMask];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:datePicker];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        viewMask.alpha      = 0.2;
        datePicker.frame    = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 260);
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _initSubviews];
        
        self.backgroundColor    = [UIColor whiteColor];
    }
    
    return self;
}

- (void)_initSubviews
{
    UIView   *toolBar       = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    toolBar.backgroundColor = BG_GRAY_COLOR;
    
    UIView  *line   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, .5)];
    line.backgroundColor    = LINE_COLOR;
    
    [toolBar addSubview:line];
    
    UIButton    *cancelBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:cancelBtn];
    
    UIButton    *confirmBtn     = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 70, 0, 70, 44)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmItemPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:confirmBtn];
    
    [self addSubview:toolBar];
    
    _datePicker     = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 216)];
    
    [self addSubview:_datePicker];
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    _datePicker.minimumDate = minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    _datePicker.maximumDate = maximumDate;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _datePicker.date        = currentDate;
}

- (void)setMode:(UIDatePickerMode)mode
{
    _datePicker.datePickerMode  = mode;
}

- (void)dismissSelf
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame  = CGRectMake(0, kScreenHeight, kScreenWidth, self.frame.size.height);
        self.viewMask.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.viewMask removeFromSuperview];
        [self removeFromSuperview];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewDidDisAppear)]) {
        [self.delegate pickerViewDidDisAppear];
    }
}

- (void)confirmItemPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedDate:)]) {
        
        [_delegate didSelectedDate:_datePicker.date];
    }
    
    [self dismissSelf];
}


@end
