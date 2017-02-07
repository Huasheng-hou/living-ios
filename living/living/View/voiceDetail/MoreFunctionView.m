//
//  MoreFunctionView.m
//  living
//
//  Created by JamHonyZ on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "MoreFunctionView.h"
#import "FitConsts.h"

@implementation MoreFunctionView

-(instancetype)initWithContentArray:(NSArray *)contentArray andImageArray:(NSArray *)imageArray
{
    self=[super init];
    if (self) {
        [self contentView:contentArray andImageArray:imageArray];
    }
    return self;
}

-(void)contentView:(NSArray *)contentArray andImageArray:(NSArray *)imageArray
{
     if (contentArray.count<=0) {
            return ;
     }
    
    NSInteger rowHeight=40;
    NSInteger rowNum=contentArray.count;
    
    UIImageView *moreImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, rowNum*rowHeight+40)];
    [moreImageView setImage:[UIImage imageNamed:@"moreFunctionBackGround"]];
    moreImageView.alpha = 0.8;
    [self addSubview:moreImageView];
    
    [self setFrame:CGRectMake(kScreenWidth-125, 40, 120, rowNum*rowHeight+40)];
    
    for (int i=0; i<contentArray.count; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(20, i*rowHeight+20, self.frame.size.width, rowHeight)];
        [button setTitle:contentArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:TEXT_FONT_LEVEL_2];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        [self addSubview:button];
        
        UIImageView *iconImageV=[[UIImageView alloc]initWithFrame:CGRectMake(25, i*rowHeight+20+(rowHeight-20)/2, 20, 20)];
        [iconImageV setImage:[UIImage imageNamed:imageArray[i]]];
        [self addSubview:iconImageV];
    }
    
    
     for (int i=1; i<rowNum; i++) {
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(15, rowHeight*i+20, self.frame.size.width-30, 0.5)];
        [line setBackgroundColor:LINE_COLOR];
        [self addSubview:line];
    }
}

-(void)buttonAction:(UIButton *)sender
{
    [self.delegate moreViewSelectItem:sender.tag];
    [self setHidden:YES];
}

@end
