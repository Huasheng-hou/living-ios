//
//  FitPickerView.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/24.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitPickerView.h"
#import "FitConsts.h"

@implementation FitPickerView

+ (void)showWithData:(NSArray *)data Delegate:(id<FitPickerViewDelegate>)delegate OffSets:(NSArray *)offSets
{
    FitPickerView   *pickerView = [[FitPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 260)];
    UIView          *viewMask   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    viewMask.backgroundColor    = [UIColor blackColor];
    viewMask.alpha              = 0;
    
    UITapGestureRecognizer  *tapGR  = [[UITapGestureRecognizer alloc] initWithTarget:pickerView action:@selector(dismissSelf)];
    [viewMask addGestureRecognizer:tapGR];
    
    pickerView.viewMask = viewMask;
    
    pickerView.data     = data;
    pickerView.delegate = delegate;
    pickerView.offSets  = offSets;
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:viewMask];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:pickerView];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        viewMask.alpha      = 0.2;
        pickerView.frame    = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 260);
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
    
    _pickerView     = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 216)];
    _pickerView.delegate    = self;
    _pickerView.dataSource  = self;
    
    [self addSubview:_pickerView];
}

- (void)setData:(NSArray *)data
{
    if (!data) {
        return;
    }
    
    _data   = data;
    [self.pickerView reloadAllComponents];
}

- (void)setOffSets:(NSArray *)offSets
{
    if (!offSets) {
        return;
    }
    
    for (int i = 0; i < offSets.count; i ++) {
        
        if (![[offSets objectAtIndex:i] isKindOfClass:[NSString class]]) {
            
            continue;
        }
        NSInteger   offSet  = [[offSets objectAtIndex:i] integerValue];
        
        if ([_pickerView numberOfComponents] > i) {
            
            if ([_pickerView numberOfRowsInComponent:i] > offSet && offSet >= 0) {
                
                [_pickerView selectRow:offSet inComponent:i animated:NO];
            }
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _data.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([[_data objectAtIndex:component] isKindOfClass:[NSArray class]]) {
        
        return [(NSArray *)[_data objectAtIndex:component] count];
    }
     
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if ([[_data objectAtIndex:component] isKindOfClass:[NSArray class]]) {
        
        NSArray *rowList    = [_data objectAtIndex:component];
        
        if (rowList.count == 1 && [rowList objectAtIndex:0] && [[rowList objectAtIndex:0] isKindOfClass:[NSString class]]) {
            
            NSString    *unit   = [rowList objectAtIndex:0];
            NSLog(@"%@",unit);
            
        }
    }
    return self.frame.size.width / _data.count * 1.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
{
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([[_data objectAtIndex:component] isKindOfClass:[NSArray class]]) {
        
        NSArray *rowList    = [_data objectAtIndex:component];
        
        if (rowList.count > row && [rowList objectAtIndex:row] && [[rowList objectAtIndex:row] isKindOfClass:[NSString class]]) {
            
            return [rowList objectAtIndex:row];
        }
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *provinceArr = self.data[0];
    if ([provinceArr[0] isEqualToString:@"北京"] && self.data.count == 2) {
        //城市地区
        if (component == 0) {
            NSString *plistPath     = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
            NSArray  *dataArr        = [NSArray arrayWithContentsOfFile:plistPath];
            NSArray *provinceArr = self.data[0];
            NSDictionary *provinceInfo = dataArr[row];
            NSArray *cityInfoArr = [provinceInfo objectForKey:@"county"];
            NSMutableArray *cityArr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic in cityInfoArr) {
                [cityArr addObject:[dic objectForKey:@"AddressName"]];
            }
            _data = @[provinceArr, cityArr];
            [self.pickerView reloadAllComponents];
        }
    }
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
}

- (void)confirmItemPressed
{
    NSInteger           count   = [_pickerView numberOfComponents];
    NSMutableArray      *items  = [NSMutableArray new];
    NSInteger  row = 0;

    for (int i = 0; i < count; i ++) {
        
        row = [_pickerView selectedRowInComponent:i];
        NSString    *item   = [self pickerView:_pickerView titleForRow:row forComponent:i];
        
        [items addObject:item];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedItems: Row:)]) {
        
        [_delegate didSelectedItems:items Row:row];
    }
    
    [self dismissSelf];
}

@end
