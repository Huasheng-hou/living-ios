//
//  CustomToolbar.m
//  chatting
//
//  Created by JamHonyZ on 2016/12/12.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import "CustomToolbar.h"

#import "FitConsts.h"

@interface CustomToolbar()<AVAudioRecorderDelegate>
{
    NSDate *startdate;
    NSDate *enddate;
    CGPoint _tempPoint;
    
}


@end


@implementation CustomToolbar

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self contentWithView];
    }
    return self;
}

#pragma mark 视图
-(void)contentWithView
{
    //语音
    _imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8.5, 28, 28)];
    [_imageV setImage:[UIImage imageNamed:@"sayImageIcon"]];
    [self addSubview:_imageV];
    
    _saybutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
//    [_saybutton setBackgroundImage:[UIImage imageNamed:@"sayImage"] forState:UIControlStateNormal];
    [_saybutton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_saybutton setTag:0];
    [_saybutton setSelected:NO];
    [self addSubview:_saybutton];
    
    //输入框
    _inputTextView=[[UITextView alloc]initWithFrame:CGRectMake(45, 5, kScreenWidth-45-45, 35)];
    [_inputTextView setBackgroundColor:[UIColor whiteColor]];
    [_inputTextView.layer setCornerRadius:3.0f];
    [_inputTextView.layer setMasksToBounds:YES];
    [_inputTextView setKeyboardType:UIKeyboardTypeDefault];
    [_inputTextView setReturnKeyType:UIReturnKeySend];
    [_inputTextView setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_inputTextView];
    
    //按住说话

    _sayLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _sayLabel=[[UIButton alloc]initWithFrame:CGRectMake(45, 0, kScreenWidth-45-45, 45)];
    [_sayLabel.layer setCornerRadius:3.0f];
    [_sayLabel.layer setMasksToBounds:YES];
    _sayLabel.hidden = YES;
    [_sayLabel setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_sayLabel setTitle:@"松开 结束" forState:UIControlStateSelected];
    [_sayLabel setBackgroundImage:[[UIImage imageNamed:@"btn_chatbar_press_normal" ] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [_sayLabel setBackgroundImage:[[UIImage imageNamed:@"touch"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
    _sayLabel.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_sayLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sayLabel addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
    [_sayLabel addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
    [_sayLabel addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
    [_sayLabel addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
    [_sayLabel addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
    
    [self addSubview:_sayLabel];
    
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-28-10, 8.5, 28, 28)];
    [imageView setImage:[UIImage imageNamed:@"addImageCircle"]];
    [self addSubview:imageView];
    //
    _addButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-45, 0, 45, 45)];
    [_addButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addButton setTag:1];
    [self addSubview:_addButton];
}


- (void)startRecordVoice
{
    [self.delegate startRecord];
    _sayLabel.backgroundColor = LINE_COLOR;
    [_sayLabel setTitle:@"松开 结束" forState:UIControlStateSelected];
}

-(void)cancelRecordVoice
{
    [self.delegate cancelRecord];
    _sayLabel.backgroundColor = [UIColor whiteColor];
    [_sayLabel setTitle:@"按住 说话" forState:UIControlStateNormal];
}

- (void)confirmRecordVoice
{
    [self.delegate confirmRecord];
    _sayLabel.backgroundColor = [UIColor whiteColor];
    [_sayLabel setTitle:@"按住 说话" forState:UIControlStateNormal];
}

- (void)updateCancelRecordVoice
{
    [self.delegate updateCancelRecord];
    _sayLabel.backgroundColor = [UIColor whiteColor];
    [_sayLabel setTitle:@"按住 说话" forState:UIControlStateNormal];
}

- (void)updateContinueRecordVoice
{
    [self.delegate updateContinueRecord];
    _sayLabel.backgroundColor = [UIColor whiteColor];
    [_sayLabel setTitle:@"按住 说话" forState:UIControlStateNormal];
}


#pragma mark 按钮执行动作
-(void)buttonAction:(UIButton *)sender
{
    [self.delegate selectItem:sender.tag];
    if (sender.tag==0) {
        sender.selected=!sender.selected;
        if (sender.selected) {
            [_imageV setImage:[UIImage imageNamed:@"sayImage"]];
            [_sayLabel setHidden:NO];
            [_inputTextView setUserInteractionEnabled:NO];
            
        }else{
            [_inputTextView resignFirstResponder];
            [_imageV setImage:[UIImage imageNamed:@"sayImageIcon"]];
            [_sayLabel setHidden:YES];
            [_inputTextView setUserInteractionEnabled:YES];
            
        }
        
    }else{
         [_imageV setImage:[UIImage imageNamed:@"sayImageIcon"]];
        [_saybutton setSelected:NO];
        [_sayLabel setHidden:YES];
        [_inputTextView setUserInteractionEnabled:YES];
    }
    
}


@end
