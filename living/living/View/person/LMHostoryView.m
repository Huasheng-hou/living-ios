//
//  LMHostoryView.m
//  living
//
//  Created by Ding on 2017/2/12.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMHostoryView.h"
#import "FitConsts.h"

@implementation LMHostoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initViews];
    }
    
    return self;
}

- (void)initViews
{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(30, kScreenHeight/2-120, kScreenWidth-60, 180)];
    buttonView.backgroundColor = [UIColor whiteColor];
    buttonView.layer.cornerRadius = 5;
    [self addSubview:buttonView];
    
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-60, 40)];
    tipLabel.text = @"活动时间";
    tipLabel.textColor = LIVING_COLOR;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [buttonView addSubview:tipLabel];
    
    UILabel *stareLbael = [UILabel new];
    stareLbael.text = @"开始时间";
    stareLbael.font = TEXT_FONT_LEVEL_1;
    [stareLbael sizeToFit];
    stareLbael.frame = CGRectMake(15, 50, stareLbael.bounds.size.width, 30);
    [buttonView addSubview:stareLbael];
    
    UILabel *finishLbael = [UILabel new];
    finishLbael.text = @"结束时间";
    finishLbael.font = TEXT_FONT_LEVEL_1;
    [finishLbael sizeToFit];
    finishLbael.frame = CGRectMake(15, 90, finishLbael.bounds.size.width, 30);
    [buttonView addSubview:finishLbael];
    
    
    //开始时间
    _startButton = [LMTimeButton buttonWithType:UIButtonTypeSystem];
    _startButton.layer.cornerRadius = 5;
    _startButton.layer.borderColor = LINE_COLOR.CGColor;
    _startButton.layer.borderWidth = 0.5;
    _startButton.textLabel.text =  @"请选择开始时间          ";
    [_startButton.textLabel sizeToFit];
    _startButton.textLabel.frame = CGRectMake(5, 0, _startButton.textLabel.bounds.size.width+30, 30);
    [_startButton sizeToFit];
    _startButton.frame = CGRectMake(finishLbael.bounds.size.width+25, 50, kScreenWidth-100-finishLbael.bounds.size.width, 30);
    [buttonView addSubview:_startButton];
    
    
    //结束时间
    _finishButton = [LMTimeButton buttonWithType:UIButtonTypeSystem];
    _finishButton.layer.cornerRadius = 5;
    _finishButton.layer.borderColor = LINE_COLOR.CGColor;
    _finishButton.layer.borderWidth = 0.5;
    _finishButton.textLabel.text =  @"请选择结束时间         ";
    [_finishButton.textLabel sizeToFit];
    _finishButton.textLabel.frame = CGRectMake(5, 0, _finishButton.textLabel.bounds.size.width+30, 30);
    [_finishButton sizeToFit];
    _finishButton.frame = CGRectMake(finishLbael.bounds.size.width+25, 90, kScreenWidth-100-finishLbael.bounds.size.width, 30);
    [buttonView addSubview:_finishButton];
    
    
    _upstoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_upstoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_upstoreButton setTitle:@"上架" forState:UIControlStateNormal];
    _upstoreButton.backgroundColor = LIVING_COLOR;
    _upstoreButton.layer.cornerRadius = 5;
    _upstoreButton.frame = CGRectMake(kScreenWidth/2-70, 135, 80, 30);
    [buttonView addSubview:_upstoreButton];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_cancelButton setImage:[UIImage imageNamed:@"cancelIcon"] forState:UIControlStateNormal];
    _cancelButton.frame = CGRectMake(0, 0, 40, 40);
    [buttonView addSubview:_cancelButton];
    

    

}


@end
