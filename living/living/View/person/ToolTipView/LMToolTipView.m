
//
//  LMToolTipView.m
//  living
//
//  Created by JamHonyZ on 2016/11/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMToolTipView.h"
#import "FitConsts.h"

#define WhiteviewHeight   220

@implementation LMToolTipView

{
    UIView *whiteView;
    
    UIImage *_headImage;
    NSString *_nickName;
    
}

- (instancetype)initWithHeadImage:(UIImage *)image andNickName:(NSString *)nickName
{
    self = [super init];
    if (self) {
        _headImage=image;
        _nickName=nickName;
        
        [self createUI];
    }
    return self;
}

//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self=[super initWithFrame:frame];
//    if (self) {
//        [self createUI];
//        [self setBackgroundColor:[UIColor clearColor]];
//    }
//    return self;
//}

-(void)createUI
{
    [self setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    [self setBackgroundColor:[UIColor colorWithRed:38/255.0f green:38/255.0f blue:38/255.0f alpha:0.7f]];
    
    UITapGestureRecognizer  *tapGR  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [self addGestureRecognizer:tapGR];
    
    whiteView=[[UIView alloc]initWithFrame:CGRectMake(30, kScreenHeight/2-WhiteviewHeight/2, kScreenWidth-60, WhiteviewHeight)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [whiteView.layer setCornerRadius:5.0f];
    [whiteView.layer setMasksToBounds:YES];
    [self addSubview:whiteView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, 44)];
    [titleLabel setText:@"确认添加好友"];
    [titleLabel setFont:TEXT_FONT_LEVEL_2];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:titleLabel];
    
    //上分割线
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, whiteView.frame.size.width, 0.5)];
    [line setBackgroundColor:LINE_COLOR];
    [whiteView addSubview:line];
    
    //头像
    UIImageView *headImageV=[[UIImageView alloc]initWithFrame:CGRectMake(whiteView.frame.size.width/2-30, 60, 60, 60)];
    [headImageV setImage:_headImage];
    [headImageV.layer setCornerRadius:30.0f];
    [headImageV.layer setMasksToBounds:YES];
    [whiteView addSubview:headImageV];
    
    //昵称
    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(0, 130, whiteView.frame.size.width, 30)];
    [name setText:_nickName];
    [name setFont:TEXT_FONT_LEVEL_2];
    [name setTextColor:TEXT_COLOR_LEVEL_3];
    [whiteView addSubview:name];
    
    
    
    //下分割线
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(0, whiteView.frame.size.height-45, whiteView.frame.size.width, 0.5)];
    [line1 setBackgroundColor:LINE_COLOR];
    [whiteView addSubview:line1];
    //竖直分割线
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(whiteView.frame.size.width/2, whiteView.frame.size.height-45, 0.5, 45)];
    [line2 setBackgroundColor:LINE_COLOR];
    [whiteView addSubview:line2];
    
    
    
    //按钮
    CGFloat buttonW=whiteView.frame.size.width/2;
    NSArray *titleArray=@[@"取消",@"确认"];
    
    for (int i=0; i<2; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(buttonW*i, whiteView.frame.size.height-44, buttonW, 44)];
        [button setTag:i+1];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:TEXT_FONT_LEVEL_2];
        if (i==0) {
            [button setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
        }
        if (i==1) {
            [button setTitleColor:LIVING_REDCOLOR forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
    }
}

-(void)dismissSelf
{
     for (UIView *view in whiteView.subviews) {
            [view removeFromSuperview];
        }
     [whiteView removeFromSuperview];
     [self removeFromSuperview];
    
}

-(void)buttonclick:(UIButton *)sender
{
    [self.delegate buttonType:sender.tag];
    [self dismissSelf];
}

@end
