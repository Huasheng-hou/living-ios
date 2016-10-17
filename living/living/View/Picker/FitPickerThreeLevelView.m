//
//  FitPickerThreeLevelView.m
//  apparel
//
//  Created by JamHonyZ on 16/9/20.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FitPickerThreeLevelView.h"
#import "FitConsts.h"

@implementation FitPickerThreeLevelView
{
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor    = [UIColor whiteColor];
        [self _initSubviews];
    }
    return self;
}

- (void)_initSubviews
{
    _viewMask   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    _viewMask.backgroundColor    = [UIColor blackColor];
    _viewMask.alpha              = 0;
    
    UITapGestureRecognizer  *tapGR  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [_viewMask addGestureRecognizer:tapGR];

    [[[[UIApplication sharedApplication] delegate] window] addSubview:_viewMask];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _viewMask.alpha      = 0.2;
        self.frame    = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 260);
    }];
    
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
    
/*************************************************************/
    
    [self getAreaData];
}

-(void)getAreaData
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    
    
    picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 44, kScreenWidth, 216)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow: 0 inComponent: 0 animated: YES];
    [self addSubview: picker];
    
    selectedProvince = [province objectAtIndex: 0];
}

#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [province objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:14];
        
        myView.backgroundColor = [UIColor clearColor];
        
        return myView;
    }
   else if (component==1) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.text = [city objectAtIndex: row];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.font = [UIFont systemFontOfSize:14];
        
        myView.backgroundColor = [UIColor clearColor];
       
        return myView;
    }
    
    else {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.text = [district objectAtIndex: row];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.font = [UIFont systemFontOfSize:14];
        
        myView.backgroundColor = [UIColor clearColor];
        
        return myView;
    }
    
    return nil;
    
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        selectedProvince = [province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        city = [[NSArray alloc] initWithArray: array];
        
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
        [picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: CITY_COMPONENT];
        [picker reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[province indexOfObject: selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: DISTRICT_COMPONENT];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 100;
    }
    else if (component == 1) {
        return 100;
    }
    else {
        return 100;
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
    NSInteger provinceIndex = [picker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [picker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [picker selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    NSString *districtStr = [district objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
        cityStr = @"";
        districtStr = @"";
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }
    
    NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@", provinceStr, cityStr, districtStr];
    
    NSMutableArray      *items  = [NSMutableArray new];
    
    [items addObject:showMsg];
//
//    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedItems:)]) {
//        
//        [_delegate didSelectedItems:items];
//    }
    [_delegate didSelectedItems:items andDistrict:districtStr];
    
    
    
    [self dismissSelf];
}

@end
