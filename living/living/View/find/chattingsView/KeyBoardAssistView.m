//
//  KeyBoardAssistView.m
//  chatting
//
//  Created by JamHonyZ on 2016/12/13.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import "KeyBoardAssistView.h"
#import "FitConsts.h"

@implementation KeyBoardAssistView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:237/255.0f alpha:1.0f]];
        [self contentWithView];
    }
    return self;
}

-(void)contentWithView
{
    NSInteger buttonW=60;
    NSInteger offset=30;
    NSArray *titleArray=@[@"照片",@"提问"];
    
    for (int i=1; i<=2; i++) {
        UIButton *button=[[UIButton alloc]init];
        UILabel *label=[[UILabel alloc]init];
        if (i==1) {
            [button setFrame:CGRectMake(kScreenWidth/2-offset-buttonW, 50, buttonW, buttonW)];
            [label setFrame:CGRectMake(kScreenWidth/2-offset-buttonW, 50+buttonW, buttonW, 50)];
            [button setBackgroundImage:[UIImage imageNamed:@"photoIcon"] forState:UIControlStateNormal];
        }
        if (i==2) {
            [button setFrame:CGRectMake(kScreenWidth/2+offset, 50, buttonW, buttonW)];
            [label setFrame:CGRectMake(kScreenWidth/2+offset, 50+buttonW, buttonW, 50)];
            [button setBackgroundImage:[UIImage imageNamed:@"questionIcon"] forState:UIControlStateNormal];
        }
        [button.layer setCornerRadius:10.0f];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:0.5f];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        [button.layer setBorderColor:LINE_COLOR.CGColor];
        [self addSubview:button];
        
        [label setText:titleArray[i-1]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13]];
        [label setTextColor:[UIColor grayColor]];
        [self addSubview:label];
    }
}

-(void)buttonAction:(UIButton *)sender
{
    [self.delegate assistViewSelectItem:sender.tag];
}

@end
