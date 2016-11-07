//
//  OSTextField.m
//  KeyBoard
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 筒子家族. All rights reserved.
//

#import "OSTextField.h"

#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width

@implementation OSTextField
{
    int    _limitLength;
}

#pragma mark - methods

- (void)initTopView
{
    self.inputAccessoryView = [self topView];
}

- (UIView *)topView
{
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    topview.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat buttonWidth = 50;
    CGFloat buttonHeight = 30;
    CGFloat leftDistance = 20;
    
    NSArray *btnTitles = @[@"取消", @"完成"];
    for (int i=0; i<2; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftDistance+(ScreenWidth-leftDistance*2-buttonWidth*2 + buttonWidth)*i, (CGRectGetHeight(topview.frame)-buttonHeight)/2.0, buttonWidth, buttonHeight);
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10+i;
        [topview addSubview:btn];
    }
    
    // 标记
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance+buttonWidth+10, 0, ScreenWidth-leftDistance*2-buttonWidth*2-20, CGRectGetHeight(topview.frame))];
    label.text = self.prompts;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    [topview addSubview:label];
    
    return topview;
}

- (void)limitTextLength:(int)length
{
    _limitLength = length;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitEvent) name:UITextFieldTextDidChangeNotification object:self];
}

- (void)limitEvent
{
    if ([self.text length] > _limitLength) {
        self.text = [self.text substringToIndex:_limitLength];
    }
}

#pragma mark - buttonEvent

- (void)btnEvent:(UIButton *)button
{
    [self resignFirstResponder];
    
    if (button.tag == 11)
    {
        if (_block) {
            _block();
        }
    }
}

#pragma mark - removeNotification

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
