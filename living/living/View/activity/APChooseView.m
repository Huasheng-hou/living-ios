//
//  APChooseView.m
//  apparel
//
//  Created by Ding on 16/7/26.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "APChooseView.h"
#import "FitConsts.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImageView+WebCache.h"

@implementation APChooseView
{
    NSInteger totalNumber;
    NSInteger totalNum;
    
    UILabel *sizeLabel;
    UILabel *colorLabel;
    UILabel *countLabel;
    UILabel *lineLabel2;
    
    NSInteger _sizeIndex;
    NSInteger _colorIndex;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:38/255.0f green:38/255.0f blue:38/255.0f alpha:0.6f]];
        //control 点击屏幕上方 View消失
        self.control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-280)];
        [self.control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.control];
        
        //白板位置
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight,self.bounds.size.width , 425)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        self.bottomView.tag = 1000;
        [self addSubview:self.bottomView];
        
        //退出按钮
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exitButton.frame = CGRectMake(self.bounds.size.width-40, 10, 30, 30);
        [exitButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [exitButton addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:exitButton];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(15, -25, 106, 106)];
        headView.backgroundColor = [UIColor whiteColor];
        headView.layer.cornerRadius = 5;
        headView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        headView.layer.borderWidth = 0.5;
        [self.bottomView addSubview:headView];
        
        //图片
        self.productImage = [[UIImageView alloc]initWithFrame:CGRectMake(3,3 , 100, 100)];
        self.productImage.layer.cornerRadius = 5;
        [self.productImage setContentMode:UIViewContentModeScaleAspectFill];
        [self.productImage setClipsToBounds:YES];
        [headView addSubview:self.productImage];

        
        //活动人数
        _inventory = [[UILabel alloc]initWithFrame:CGRectMake(145, 55, 150, 20)];
        _inventory.text = @"活动人数 ";
        _inventory.font = [UIFont systemFontOfSize:14];
        [self.bottomView addSubview:_inventory];
        
        //分界线
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,130, kScreenWidth, 0.5)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [self.bottomView addSubview:lineLabel];


        //报名须知
        sizeLabel = [UILabel new];
        sizeLabel.text = @"报名须知";
        sizeLabel.textColor = TEXT_COLOR_LEVEL_1;
        sizeLabel.font = [UIFont systemFontOfSize:15];
        [sizeLabel sizeToFit];
        sizeLabel.frame = CGRectMake(10, 150, sizeLabel.bounds.size.width, 20);
        [self.bottomView addSubview:sizeLabel];
        
        _dspLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, kScreenWidth-30,60)];
        _dspLabel.numberOfLines = 0;
        _dspLabel.text = @"报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知";
        _dspLabel.textColor = [UIColor lightGrayColor];
        
        _dspLabel.font = [UIFont systemFontOfSize:15];
        [self.bottomView addSubview:_dspLabel];
        
        
        //数量
        countLabel = [UILabel new];
        countLabel.text = @ "报名数量";
        countLabel.textColor = TEXT_COLOR_LEVEL_1;
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.font = [UIFont systemFontOfSize:15];
        [countLabel sizeToFit];
        countLabel.frame = CGRectMake(10, self.bottomView.frame.size.height-105, countLabel.bounds.size.width, 20);
        
        [self.bottomView addSubview:countLabel];
        //增加按钮
        _addButton = [CustomButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(kScreenWidth-50, self.bottomView.frame.size.height-105, 35, 30);
        _addButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _addButton.backgroundColor = LIVING_COLOR;
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton setTitle:@"+" forState:0];;
        [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_addButton];
        //减少
        _reduceButotn = [CustomButton buttonWithType:UIButtonTypeCustom];
        _reduceButotn.frame = CGRectMake(kScreenWidth-155, self.bottomView.frame.size.height-105, 35, 30);
        [_reduceButotn setTitle:@"-" forState:0];
        _reduceButotn.backgroundColor = LIVING_COLOR;
        [_reduceButotn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reduceButotn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_reduceButotn addTarget:self action:@selector(reduceButotnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_reduceButotn];
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-110, self.bottomView.frame.size.height-105, 50, 30)];
        _numLabel.text = @"1";
        _numLabel.backgroundColor = LIVING_COLOR;
        _numLabel.textColor = [UIColor whiteColor];
        
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.bottomView addSubview:_numLabel];
        //初始数量为1
        count = 1;
        UIButton *joinButton= [UIButton buttonWithType:UIButtonTypeCustom];
        joinButton.frame = CGRectMake(0, self.bottomView.frame.size.height-50,kScreenWidth, 50);
        [joinButton setBackgroundColor:LIVING_COLOR];
        [joinButton setTitleColor:[UIColor whiteColor] forState:0];
        joinButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [joinButton setTitle:@"确定" forState:0];
        [self.bottomView addSubview:joinButton];
        
        [joinButton addTarget:self action:@selector(exitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark 加入购物车按钮执行方法

- (void)exitButtonClick
{
    totalNumber = [[_orderInfo objectForKey:@"total_number"] intValue];
    totalNum = [[_orderInfo objectForKey:@"total_num"] intValue];
//    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:_numLabel.text,@"num", nil] ;
//
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"purchase" object:dic];
    
    [self.delegate APChooseViewSelectItem:[_numLabel.text intValue]];

    
    
    UIView *view = [self viewWithTag:1000];
    __weak APChooseView *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        view.frame = CGRectMake(0, self.bounds.size.height,self.bounds.size.width, 280);
        [weakSelf setAlpha:0.0f];
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark 关闭按钮

- (void)controlClick
{
    __weak APChooseView *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(0, self.bounds.size.height+280, self.bounds.size.width, 280);
        [weakSelf setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [weakSelf.delegate APChooseViewClose];
        [weakSelf removeFromSuperview];
    }];
}

- (void)addButtonClick:(CustomButton *)sender
{
    count+=1;
    
    if (_type != 1) {
        if (count > _event.totalNumber) {
            
            count -= 1;
            return;
        }

    }
    
    _numLabel.text = [NSString stringWithFormat:@"%@",@(count)];
 
    if (_reduceButotn.isRed == NO) {
        
        [_reduceButotn setBackgroundImage:[UIImage imageNamed:@"button_product_numbersub"] forState:UIControlStateNormal];
        _reduceButotn.isRed = YES;
    }
}

- (void)reduceButotnClick
{
    count   -= 1;

    if (count <=1) {
        
        [_reduceButotn setBackgroundImage:[UIImage imageNamed:@"button_product_numbersub_enable"] forState:UIControlStateNormal];
        count = 1;
        _numLabel.text = [NSString stringWithFormat:@"%@",@(count)];
        _recordButton.isRed = NO;
        return;
    }
    _numLabel.text = [NSString stringWithFormat:@"%@",@(count)];
}

@end
