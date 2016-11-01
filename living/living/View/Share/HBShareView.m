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
    [whiteView setBackgroundColor:[UIColor whiteColor]];
//    [whiteView.layer setCornerRadius:5.0f];
//    [whiteView.layer setMasksToBounds:YES];
    [self addSubview:whiteView];
    
    [UIView animateWithDuration:0.3f animations:^{
        [whiteView setFrame:CGRectMake(0, kScreenHeight-240, kScreenWidth, 240)];
    }];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, 44)];
    [titleLabel setText:@"分享"];
    [titleLabel setFont:TEXT_FONT_LEVEL_2];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:titleLabel];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth, 0.5)];
    [line setBackgroundColor:BG_GRAY_COLOR];
    [whiteView addSubview:line];
    
    CGFloat startX=15;
    CGFloat sapce=20;
    CGFloat buttonW=(kScreenWidth-startX*2-sapce*3)/4;
    
//
    for (int i=0; i<4; i++) {
        HBShareButton *sharebutton=[[HBShareButton alloc]initWithFrame:CGRectMake(startX+(buttonW+sapce)*i, 80, buttonW, buttonW+50) andIndex:i+1];
        [sharebutton setTag:i+1];
        [sharebutton addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:sharebutton];
    }
}

-(void)dismissSelf
{
    [UIView animateWithDuration:0.3f animations:^{
        [whiteView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 220)];
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
