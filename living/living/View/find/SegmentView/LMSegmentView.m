//
//  LMSegmentView.m
//  living
//
//  Created by JamHonyZ on 2016/12/7.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMSegmentView.h"
#import "FitConsts.h"

#define buttonW 65
#define  margin  (kScreenWidth-buttonW*2)/4

@implementation LMSegmentView
{
    UILabel *underLineView;
    CGFloat _height;
}
-(instancetype)initWithViewHeight:(CGFloat)height
{
    self=[super init];
    if (self) {
        _height=height;
        [self setFrame:CGRectMake(0, kNaviHeight+kStatuBarHeight, kScreenWidth, height)];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self contentViewHeight:height];
        
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, height-1, kScreenWidth, 1)];
        [line setBackgroundColor:LINE_COLOR];
        [self addSubview:line];
    }
    return self;
}

-(void)contentViewHeight:(CGFloat)height
{
    NSArray *titleArray=@[@"讲师/主持",@"全部消息"];
    for (int i=0; i<2; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(margin*(2*i+1)+buttonW*i, 0, buttonW, height)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:LIVING_COLOR forState:UIControlStateSelected];
        [button.titleLabel setFont:TEXT_FONT_LEVEL_2];
        [button setTag:i];
        [self addSubview:button];
        if (i==1) {
            [button setSelected:YES];
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //下划线
    underLineView=[[UILabel  alloc]initWithFrame:CGRectMake(margin*(2*1+1)+buttonW*1, height-2, buttonW, 2)];
    [underLineView setBackgroundColor:LIVING_COLOR];
    [self addSubview:underLineView];
}

-(void)buttonAction:(UIButton *)sender
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button=(UIButton *)view;
            [button setSelected:NO];
        }
    }
    [sender setSelected:YES];
    
    NSInteger index=sender.tag;
    
    [UIView animateWithDuration:0.3f animations:^{
        [underLineView setFrame:CGRectMake(margin*(2*index+1)+buttonW*index, _height-2, buttonW, 2)];
    }];
    
    [self.delegate selectedItem:index];
}

@end
