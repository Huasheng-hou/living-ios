//
//  LMBottomView.m
//  living
//
//  Created by JamHonyZ on 2016/11/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBottomView.h"
#import "FitConsts.h"

@implementation LMBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self createUI];
        
    }
    return self;
}

-(void)createUI
{
   //地名
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 20 , kScreenWidth-30, 30)];
    [_nameLabel setText:@"地名"];
    [_nameLabel setFont:TEXT_FONT_LEVEL_2];
    [self addSubview:_nameLabel];
    
    _navButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-120, 50, 100, 40)];
    [_navButton.layer setCornerRadius:5.0f];
    [_navButton.layer setMasksToBounds:YES];
    [_navButton setBackgroundColor:[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f]];
    [_navButton.layer setBorderWidth:1.0f];
    [_navButton.layer setBorderColor:LINE_COLOR.CGColor];
    
    [_navButton setTitle:@"本地地图" forState:UIControlStateNormal];
    [_navButton.titleLabel setFont:TEXT_FONT_LEVEL_3];
    [_navButton setTitleColor:TEXT_COLOR_LEVEL_2 forState:UIControlStateNormal];
    [self addSubview:_navButton];
}

@end
