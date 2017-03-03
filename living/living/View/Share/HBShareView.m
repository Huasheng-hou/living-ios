//
//  HBShareView.m
//  HBLive
//
//  Created by JamHonyZ on 2016/10/20.
//  Copyright © 2016年 Hou Huasheng. All rights reserved.
//

#import "HBShareView.h"
#import "HBShareButton.h"
#import "FitConsts.h"

@implementation HBShareView
{
    UIView *whiteView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self setBackgroundColor:[UIColor colorWithRed:38/255.0f green:38/255.0f blue:38/255.0f alpha:0.5f]];
    }
    return self;
}

-(void)createUI
{
    UITapGestureRecognizer  *tapGR  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [self addGestureRecognizer:tapGR];
    
    whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 240)];
    [whiteView setBackgroundColor:BG_GRAY_COLOR];
    [self addSubview:whiteView];
    
    [UIView animateWithDuration:0.3f animations:^{
        [whiteView setFrame:CGRectMake(0, kScreenHeight-240, kScreenWidth, 240)];
    }];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, 44)];

    [_titleLabel setText:@"分享文章"];
    
    
    [_titleLabel setFont:TEXT_FONT_LEVEL_1];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:_titleLabel];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth, 0.5)];
    [line setBackgroundColor:BG_GRAY_COLOR];
    [whiteView addSubview:line];
    
    CGFloat startX=15;
    CGFloat sapce=15;
    NSInteger buttonW=(NSInteger)(kScreenWidth-startX*2-sapce*3)/4;
    
//
    for (int i=0; i<4; i++) {
        HBShareButton *sharebutton=[[HBShareButton alloc]initWithFrame:CGRectMake(startX+(buttonW+sapce)*i, 40, buttonW, buttonW+50) andIndex:i+1];
        [sharebutton setTag:i+1];
        [sharebutton addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:sharebutton];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 195, kScreenWidth, 45)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"取消";
    label.font = TEXT_FONT_LEVEL_1;
    label.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.userInteractionEnabled = YES;
    [whiteView addSubview:label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [label addGestureRecognizer:tap];
    
}

-(void)dismissSelf
{
    [UIView animateWithDuration:0.3f animations:^{
        [whiteView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 220)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        for (UIView *view in whiteView.subviews) {
            [view removeFromSuperview];
        }
        
      [whiteView removeFromSuperview];
      [self removeFromSuperview];
    }];
}

-(void)buttonclick:(UIButton *)sender
{
    [self.delegate shareType:sender.tag];
    [self dismissSelf];
}

@end
