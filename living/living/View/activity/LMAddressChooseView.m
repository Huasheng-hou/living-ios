//
//  LMAddressChooseView.m
//  living
//
//  Created by Ding on 2016/11/28.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMAddressChooseView.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"

#define WhiteviewHeight   220

@implementation LMAddressChooseView

{
    UIView *whiteView;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self createUI];
    }
    return self;
}

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
    [titleLabel setText:@"选择地址输入类型"];
    [titleLabel setFont:TEXT_FONT_LEVEL_2];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:titleLabel];
    
    //上分割线
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, whiteView.frame.size.width, 0.5)];
    [line setBackgroundColor:LINE_COLOR];
    [whiteView addSubview:line];
    
//    //头像
//    UIImageView *headImageV=[[UIImageView alloc]initWithFrame:CGRectMake(whiteView.frame.size.width/2-30, 60, 60, 60)];
//    [headImageV sd_setImageWithURL:[NSURL URLWithString:_headImage]];
//    [headImageV.layer setCornerRadius:30.0f];
//    [headImageV.layer setMasksToBounds:YES];
//    headImageV.clipsToBounds = YES;
//    headImageV.contentMode = UIViewContentModeScaleAspectFill;
//    [whiteView addSubview:headImageV];
    

    _addressTF = [[UITextView alloc] initWithFrame:CGRectMake(10, 60, whiteView.frame.size.width-20, 60)];
    _addressTF.returnKeyType = UIReturnKeyDone;
    _addressTF.layer.cornerRadius = 5;
    _addressTF.layer.borderWidth = 0.5;
    _addressTF.layer.borderColor = LINE_COLOR.CGColor;
    _msgLabel = [UILabel new];
    _msgLabel.text = @"请输入地址内容";
    _msgLabel.font = TEXT_FONT_LEVEL_2;
    _msgLabel.textColor = TEXT_COLOR_LEVEL_2;
    [_msgLabel sizeToFit];
    _msgLabel.frame = CGRectMake(5, 0, _msgLabel.bounds.size.width, 25);
    [_addressTF addSubview:_msgLabel];
    
    [whiteView addSubview:_addressTF];
    
    //昵称
    _addressButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 130, whiteView.frame.size.width, 30)];
    [_addressButton.titleLabel setFont:TEXT_FONT_LEVEL_1];
    [_addressButton setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
    [_addressButton setTitle:@"选择地址" forState:UIControlStateNormal];
    [whiteView addSubview:_addressButton];
    
    
    
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
        [button setTag:i];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:TEXT_FONT_LEVEL_2];
        if (i==0) {
            [button setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
        }
        if (i==1) {
            [button setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
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
