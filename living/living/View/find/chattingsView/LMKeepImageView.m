//
//  LMKeepImageView.m
//  living
//
//  Created by Ding on 2017/2/10.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMKeepImageView.h"

@implementation LMKeepImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [self contentWithView];
    }
    return self;
}

- (void)contentWithView
{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(50, kScreenHeight/2-60, kScreenWidth-100, 120)];
    buttonView.backgroundColor = [UIColor whiteColor];
    buttonView.layer.cornerRadius = 5;
    [self addSubview:buttonView];
    
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-100, 60)];
    tipLabel.text = @"是否保存到相册";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [buttonView addSubview:tipLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth-100, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [buttonView addSubview:lineView];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_leftButton setTitle:@"取 消" forState:UIControlStateNormal];
    _leftButton.titleLabel.font = TEXT_FONT_LEVEL_1;
    _leftButton.frame = CGRectMake(0, 60, kScreenWidth/2-50, 60);
    [buttonView addSubview:_leftButton];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-60, 60, 0.5, 60)];
    lineView2.backgroundColor = LINE_COLOR;
    [buttonView addSubview:lineView2];
    
    _rihgtButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_rihgtButton setTitle:@"确 定" forState:UIControlStateNormal];
    _rihgtButton.titleLabel.font = TEXT_FONT_LEVEL_1;
    _rihgtButton.frame = CGRectMake(kScreenWidth/2-50, 60, kScreenWidth/2-50, 60);
    [buttonView addSubview:_rihgtButton];

}


@end
