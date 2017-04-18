//
//  LMYGBOrderChooseCell.m
//  living
//
//  Created by hxm on 2017/3/9.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYGBOrderChooseCell.h"
#import "FitConsts.h"
@implementation LMYGBOrderChooseCell
{
    /******  数量   ******/
    UILabel * number;
    UIButton * sub;
    UILabel * numValue;
    UIButton * add;
    
    /******  分割线   ******/
    UILabel * topLine;
    UILabel * midLine;
    UILabel * botLine;
    
    /******  金额   ******/
    UILabel * money;
    UILabel * moneyValue;
    
    /******  支付方式   ******/
    UILabel * payType;
    UIImageView * alipay;
    UIImageView * wechat;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 123)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.userInteractionEnabled = YES;
    [self.contentView addSubview:backView];
    
    
    number = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
    number.text = @"数量";
    number.textColor = TEXT_COLOR_LEVEL_2;
    number.font = TEXT_FONT_LEVEL_1;
    [backView addSubview:number];
    
    sub = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-110, 10, 20, 20)];
    sub.backgroundColor = BG_GRAY_COLOR;
    [sub setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    sub.layer.masksToBounds = YES;
    sub.layer.cornerRadius = 10;
    [sub addTarget:self action:@selector(subNumber) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sub];
    
    
    numValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sub.frame), 12.5, 60, 15)];
    numValue.text = @"1";
    numValue.textAlignment = NSTextAlignmentCenter;
    numValue.textColor = TEXT_COLOR_LEVEL_1;
    numValue.font = TEXT_FONT_LEVEL_2;
    [backView addSubview:numValue];
    
    
    add = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numValue.frame), 10, 20, 20)];
    add.backgroundColor = BG_GRAY_COLOR;
    [add setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    add.layer.masksToBounds = YES;
    add.layer.cornerRadius = 10;
    [add addTarget:self action:@selector(addNumber) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:add];
    
    
    /*********************     分割线1     *******************/
    topLine = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, kScreenWidth-10, 1)];
    topLine.backgroundColor = BG_GRAY_COLOR;
    [backView addSubview:topLine];
    
    
    money = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topLine.frame)+10, 50, 20)];
    money.text = @"金额";
    money.textColor = TEXT_COLOR_LEVEL_2;
    money.font = TEXT_FONT_LEVEL_1;
    [backView addSubview:money];
    
    moneyValue = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-150, CGRectGetMinY(money.frame), 140, 20)];
    moneyValue.text = @"799腰果币+100元";
    moneyValue.textColor = ORANGE_COLOR;
    moneyValue.font = TEXT_FONT_LEVEL_1;
    moneyValue.textAlignment = NSTextAlignmentRight;
    [backView addSubview:moneyValue];
    
    
    /*********************     分割线2    *******************/
    midLine = [[UILabel alloc] initWithFrame:CGRectMake(10, 81, kScreenWidth-10, 1)];
    midLine.backgroundColor = BG_GRAY_COLOR;
    [backView addSubview:midLine];

    payType = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(midLine.frame)+10, 100, 20)];
    payType.text = @"选择支付方式";
    payType.textColor = TEXT_COLOR_LEVEL_2;
    payType.font = TEXT_FONT_LEVEL_1;
    [backView addSubview:payType];
    
    CGFloat w = 79;
    alipay = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-89*2, CGRectGetMaxY(midLine.frame)+5, w, 30)];
    alipay.image = [UIImage imageNamed:@""];
    alipay.backgroundColor = BG_GRAY_COLOR;
    alipay.tag = 30;
    alipay.userInteractionEnabled = YES;
    [alipay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pay:)]];
    [backView addSubview:alipay];
    
    
    wechat = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-89, CGRectGetMinY(alipay.frame), w, 30)];
    wechat.image = [UIImage imageNamed:@""];
    wechat.backgroundColor = BG_GRAY_COLOR;
    wechat.tag = 31;
    wechat.userInteractionEnabled = YES;
    [wechat addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pay:)]];
    [backView addSubview:wechat];
    
    /*********************     分割线3    *******************/
    botLine = [[UILabel alloc] initWithFrame:CGRectMake(10, 122, kScreenWidth-10, 1)];
    botLine.backgroundColor = BG_GRAY_COLOR;
    [backView addSubview:botLine];

}
- (void)subNumber{
    NSLog(@"减一");
    NSInteger num = [numValue.text integerValue];
    if (num <= 1) {
        return;
    }
    num--;
    numValue.text = [NSString stringWithFormat:@"%d", num];
    
    
}
- (void)addNumber{
    NSLog(@"加一");
    NSInteger num = [numValue.text integerValue];
    if (num >= 100) {
        return;
    }
    num++;
    numValue.text = [NSString stringWithFormat:@"%d", num];
    

}
- (void)pay:(UITapGestureRecognizer *)tap{
    
    if (tap.view.tag == 30) {
        NSLog(@"支付宝");
    }
    if (tap.view.tag == 31) {
        NSLog(@"微信");
    }
}


@end
